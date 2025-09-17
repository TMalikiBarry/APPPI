import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:pi_mobile_app/modules/security/domain/models/connected_user.dart';

import '../../../../core/api.dart';
import '../../domain/exceptions/alias_retrieve_exception.dart';
import '../../domain/exceptions/invalid_otp_exception.dart';
import '../../domain/exceptions/not_available_exception.dart';
import '../../domain/models/alias.dart';
import '../../domain/models/alias_create_command.dart';
import '../../domain/models/alias_error.dart';
import '../../domain/models/alias_mbno_otp_command.dart';
import '../../domain/models/alias_revendication.dart';
import '../../domain/models/alias_type.dart';
import '../../ports/input/alias_input_port.dart';
import 'alias_event.dart';
import 'alias_state.dart';

class AliasBloc extends Bloc<AliasEvent, AliasState> {
  //
  final logger = Logger();

  //
  final AliasInputPort aliasInputPort;
  StreamSubscription? aliasStreamSubscription;

  /// ConfigLoadingState est l'état initial de l'app en cours de chargement
  AliasBloc(this.aliasInputPort) : super(const AliasInitialState()) {
    //
    /// Quand on demande la recupération de l'alias
    on<FetchAliasEvent>(_onFetchAliasEvent);

    /// Quand on demande la création d'un alias de type SHID
    on<CreateAliasSHIDEvent>(_onCreateAliasSHIDEvent);

    /// Quand on demande la création d'un alias de type SHID
    on<CreateAliasMBNOEvent>(_onCreateAliasMBNOEvent);

    /// Quand on demande la suppression d'un
    on<AliasDeleteEvent>(_onAliasDeleteEvent);

    /// Quand l'utilisateur saisit son numéro de téléphone
    /// et que le système tente de valider le format
    on<CreateAliasMBNOValidationEvent>(_onCreateAliasMBNOValidationEvent);

    /// Quand on envoi une de vérification à un numéro de téléphone
    on<AskPhoneNumberVerificationEvent>(_onAskPhoneNumberVerificationEvent);

    /// Quand on verifie le code de vérification envoyé à un numéro de téléphone
    on<CheckPhoneNumberVerificationEvent>(_onCheckPhoneNumberVerificationEvent);

    // Reclamation
    /// Quand on Reclame un numéro de téléphone
    on<AliasClaimAskEvent>(_onAliasClaimAskEvent);

    // Pour recuperer une revendication
    on<AliasClaimFetchEvent>(_onAliasClaimFetchEvent);

    // Pour accepter une revendication
    on<AliasClaimRespondEvent>(_onAliasClaimRespondEvent);
  }

  /// Quand on demande l'alias de l'utilisateur connecte
  void _onFetchAliasEvent(
    FetchAliasEvent event,
    Emitter<AliasState> emit,
  ) async {
    try {
      emit(AliasLoadingState());
      Alias? alias = await aliasInputPort.recuperer(event.compte);
      emit(alias != null && alias.participant != null && alias.participant == "SNC004"
          ? AliasExistState(alias)
          : AliasNotExistState());
    } on AliasRetrieveException catch (e) {
      logger.i("Exception : AliasRetrieveException ${e.error}");
      if (e.error == ApiError.notFound) {
        emit(AliasNotExistState());
      } else {
        emit(AliasFetchErrorState(event.compte, AliasError.unknow));
      }
    }
  }

  // Suppression d'un alias
  void _onAliasDeleteEvent(
    AliasDeleteEvent event,
    Emitter<AliasState> emit,
  ) async {
    try {
      emit(AliasDeletingState());
      await aliasInputPort.supprimer(event.cle);
      emit(AliasNotExistState());
    } catch (e) {
      emit(AliasDeleteErrorState("Error"));
    }
  }

  /// Quand on demande la création d'un alias de type SHID
  void _onCreateAliasSHIDEvent(
    CreateAliasSHIDEvent event,
    Emitter<AliasState> emit,
  ) async {
    AliasCreateCommand aliasC = AliasCreateCommand(
      type: AliasType.shid,
      compte: event.compte,
    );
    emit(AliasCreatingState(aliasC));
    try {
      Alias alias = await aliasInputPort.creer(aliasC);
      logger.i("User initial : alias : ${ConnectedUser.current?.alias}, shid: ${ConnectedUser.current?.shid}");

      ConnectedUser.current = ConnectedUser.current?.copyWith(
        alias: alias.cle,
        shid: alias.shid,
      );
      logger.i("User modifié : shid: ${ConnectedUser.current?.shid}, alias: ${ConnectedUser.current?.alias}");

      emit(AliasExistState(alias));
    } //
    on ApiException catch (e) {
      if (e.error == ApiError.noInternetConnection) {
        emit(AliasCreationErrorState(AliasError.connection, aliasC));
      } //
      else if (e.error == ApiError.forbidden) {
        if (e.problem != null && e.problem!.object != null) {
          emit(AliasCreationErrorState(AliasError.aliasAlreadyExist, aliasC));
        } else {
          emit(AliasCreationErrorState(AliasError.limitError, aliasC));
        }
      } //
      else {
        logger.e('Erreur création SHID', error: e);
        emit(AliasCreationErrorState(AliasError.unknow, aliasC));
      }
    }
  }

  /// Quand on demande la création d'un alias de type MBNO
  void _onCreateAliasMBNOEvent(
    CreateAliasMBNOEvent event,
    Emitter<AliasState> emit,
  ) async {
    emit(AliasMBNOCreationState(AliasCreateCommand(
      type: AliasType.mbno,
      compte: event.compte,
    )));
  }

  /// Quand on fait la validation du numéro de téléphone utilisé
  void _onCreateAliasMBNOValidationEvent(
    CreateAliasMBNOValidationEvent event,
    Emitter<AliasState> emit,
  ) async {
    //
    AliasCreateCommand form = event.values;
    form.isValid();
    emit(AliasMBNOCreationState(form));
  }

  /// Quand le client finit d'entrez son numéro de téléphone
  /// et qu'il doit passer à l'étape de vérification
  void _onAskPhoneNumberVerificationEvent(
    AskPhoneNumberVerificationEvent event,
    Emitter<AliasState> emit,
  ) async {
    //
    try {
      emit(AliasCreatingState(event.values));
      await aliasInputPort.envoyerOtp("${event.values.phoneNumber!.indicatif}${event.values.phoneNumber!.phone}", event.channel ?? null);
      emit(AliasMBNOVerificationState(event.values, [], null));
    } on ApiException catch (e) {
        // Erreur non gérée
        emit(AliasFetchErrorState(event.values.compte, AliasError.unknow));
    }
  }

  /// Quand on verifie le code de vérification envoyé à un numéro de téléphone
  void _onCheckPhoneNumberVerificationEvent(
    CheckPhoneNumberVerificationEvent event,
    Emitter<AliasState> emit,
  ) async {
    // Valeur du code PIN
    AliasMbnoOtpCommand otpCode = event.otpCode;
    String? channel = event.channel;
    if (otpCode.isValid()) {
      emit(AliasCreatingState(event.values));
      try {
        Alias alias = await aliasInputPort.confirmer(otpCode, event.values, channel);
        emit(AliasExistState(alias));
      }
      // Alias déja pris réclamer?
      on AliasNotAvailableException {
        emit(AliasCreationErrorState(
          AliasError.aliasAlreadyExist,
          event.values,
        ));
      }
      // Code OTP invalid
      on AliasInvalidOtpException {
        emit(AliasMBNOVerificationState(
            event.values, otpCode.value, AliasError.invalidOtpCode));
      } on ApiException catch (e) {
        // Erreur non gérée
        emit(AliasCreationErrorState(AliasError.unknow, event.values));
      }
    }
    // Code invalid => user n'a pas fini de saisir
    else {
      emit(AliasMBNOVerificationState(event.values, otpCode.value, null));
    }
  }

  /// Quand on veut revendiquer un alias
  void _onAliasClaimAskEvent(
    AliasClaimAskEvent event,
    Emitter<AliasState> emit,
  ) async {
    emit(AliasClaimAskingState());
    try {
      await aliasInputPort.revendiquer(
        event.compte,
        event.phoneNumber,
      );
      emit(AliasClaimAskingSuccessState());
    } //
    on ApiException catch (e) {
      if (e.error == ApiError.forbidden) {
        // Alias en cours de revendication
        emit(AliasClaimAskingErrorState(
          AliasError.aliasLocked,
          event.phoneNumber,
        ));
      } //
      else if (e.error == ApiError.notFound) {
        // Alias n'existe pas
        // L'alias est deja supprimé dans PI
        emit(AliasClaimAskingErrorState(
          AliasError.aliasNotExist,
          event.phoneNumber,
        ));
      } //
      else {
        logger.e('Erreur revendication alias', error: e);
        emit(AliasClaimAskingErrorState(
          AliasError.unknow,
          event.phoneNumber,
        ));
      }
    }
  }

  /// Quand on veut récupérer une revendication
  void _onAliasClaimFetchEvent(
    AliasClaimFetchEvent event,
    Emitter<AliasState> emit,
  ) async {
    // Loading
    emit(AliasClaimFetchingState(event.id, event.alias));

    // Fetch revendication
    AliasRevendication? revendication =
        await aliasInputPort.recupererRevendication(event.id);

    // Return revendication
    if (revendication != null) {
      emit(AliasClaimHandlingState(
        event.id,
        event.alias,
        revendication,
        false,
      ));
    } //
    else {
      emit(AliasClaimNotFoundState(event.id, event.alias));
      emit(AliasExistState(event.alias, null));
    }
  }

  /// Quand on veut accepter une revendication
  void _onAliasClaimRespondEvent(
    AliasClaimRespondEvent event,
    Emitter<AliasState> emit,
  ) async {
    try {
      AliasRevendication claim = await aliasInputPort.repondreRevendication(
        event.id,
        event.decision,
        event.otpCode?.join(),
      );
      if (event.decision) {
        // Il a acepté
        emit(AliasClaimHandlingSuccessState(event.id, event.alias, claim));
        // Apres acceptation l'alias shid est le seul qu'il a
        emit(AliasExistState(claim.shid!, claim));
      } //
      else {
        // Il a refusé
        if (event.otpCode == null) {
          // demande un code OTP
          emit(AliasClaimHandlingState(
            event.id,
            event.alias,
            claim,
            true,
          ));
        } else {
          emit(AliasClaimHandlingSuccessState(event.id, event.alias, claim));
          // Confirmer qu'il a conserve son alias MBNO
          emit(AliasExistState(event.alias, claim));
        }
      }
    } //
    // Code OTP invalid
    on AliasInvalidOtpException {
      emit(AliasClaimHandlingState(
        event.id,
        event.alias,
        event.claim,
        true,
      ));
    } //
    on ApiException catch (e) {
      if (e.error == ApiError.forbidden) {
        // revendication terminée ou cloturee
        emit(AliasClaimHandlingErrorState(
          event.id,
          event.alias,
          event.claim,
          event.otpCode != null,
          AliasError.claimClosed,
        ));
      } //
      else {
        logger.e('Erreur acceptation revendication alias', error: e);
        emit(AliasClaimHandlingErrorState(
          event.id,
          event.alias,
          event.claim,
          event.otpCode != null,
          AliasError.unknow,
        ));
      }
    }
  }
}
