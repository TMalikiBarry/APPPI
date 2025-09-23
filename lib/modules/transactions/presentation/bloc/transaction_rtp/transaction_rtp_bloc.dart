import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

import '../../../../../core/api.dart';
import '../../../../security/domain/models/permission_type.dart';
import '../../../../security/ports/input/permission_input_port.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_error.dart';
import '../../../domain/models/transaction_send/transaction_confirm_command.dart';
import '../../../domain/models/transaction_send/transaction_send_command_amount.dart';
import '../../../ports/input/transaction_input_port.dart';
import 'transaction_rtp_event.dart';
import 'transaction_rtp_state.dart';

class TransactionRtpBloc
    extends Bloc<TransactionRtpEvent, TransactionRtpState> {
  //
  final logger = Logger();

  //
  final TransactionInputPort transactionInputPort;
  final PermissionInputPort permissionInputPort;
  final String endToEndId;

  TransactionRtpBloc(
    this.transactionInputPort,
    this.permissionInputPort,
    this.endToEndId,
  ) : super(TransactionRtpInitialState(endToEndId)) {
    // Pour recuperer une demande de paiement
    on<TransactionRtpFetchEvent>(_onTransactionRtpFetchEvent);

    // Pour accepter une demande de paiement
    on<TransactionRtpFrequenceEvent>(_onTransactionRtpFrequenceEvent);
    on<TransactionRtpAcceptPayEvent>(_onTransactionRtpAcceptPayEvent);
    on<TransactionRtpAcceptResponseEvent>(_onTransactionRtpAcceptResponseEvent);

    // Pour rejeter une demande de paiement
    on<TransactionRtpRejectEvent>(_onTransactionRtpRejectEvent);
  }

  /// Pour Recuperer les infos sur la demande de paiement
  Future<void> _onTransactionRtpFetchEvent(
    TransactionRtpFetchEvent event,
    Emitter<TransactionRtpState> emit,
  ) async {
    //Transaction tx = await transactionInputPort.get(endToEndId);
    emit(TransactionRtpDetailsState(endToEndId, event.transaction));
  }

  /// Pour dire si on accepte le débit différé payé en plusieurs fois
  Future<void> _onTransactionRtpFrequenceEvent(
    TransactionRtpFrequenceEvent event,
    Emitter<TransactionRtpState> emit,
  ) async {
    Transaction tx = event.transaction;
    if (event.frequence) {
      // Definit la frequence de paiement
      tx.frequence = tx.differeFrequence;
      tx.periodicite = tx.differeOccurence;
    } else {
      tx.frequence = null;
      tx.periodicite = null;
    }
    emit(TransactionRtpDetailsState(endToEndId, tx));
  }

  /// Pour Accepter et Payer Toute Suite la demande de paiement
  Future<void> _onTransactionRtpAcceptPayEvent(
    TransactionRtpAcceptPayEvent event,
    Emitter<TransactionRtpState> emit,
  ) async {
    Transaction tx = event.transaction;
    emit(TransactionRtpLoadingState(event.transaction.endToEndId, tx));
    // Récuperer position GPS
    Position? position;
    try {
      position = await _askPosition();
    } //
    catch (e) {
      PermissionType permission = PermissionType.localisationGPS;
      bool granted = await permissionInputPort.grantPermission(permission);
      if (granted) {
        position = await _askPosition();
      }
    }
    // S'il ne donne pas sa position on fait rien
    if (position == null) {
      // Il reste sur le formulaire - pas de confirmation
      emit(TransactionRtpDetailsState(endToEndId, tx));
      return;
    }
    // On effectue le transfert
    try {
      TransactionConfirmCommand command = TransactionConfirmCommand(
        endToendId: tx.endToEndId,
        confirmationDate: DateTime.now().toIso8601String(),
        confirmationMethode: event.method,
        latitude: position.latitude,
        longitude: position.longitude,
        clientAlias: tx.clientAlias,
        amount: TransactionSendCommandAmount(value: tx.montant),
        guID: tx.guID,
        codeMembreParticipantPayer: tx.codeMembreParticipantPayer,
        clientName: tx.clientNom,
        country: tx.clientPays
      );
      Stream<Transaction> stream = await transactionInputPort.confirm(command);

      stream.listen(
        (trans) {
          add(TransactionRtpAcceptResponseEvent(trans));
        },
      );
    } on ApiException catch (e) {
      if (e.error == ApiError.forbidden &&
          e.problem != null &&
          e.problem!.invalidParams != null) {
        var badParam = e.problem!.invalidParams!["name"];
        if (badParam == "solde") {
          emit(TransactionRtpReponseState(
            tx.endToEndId,
            tx,
            TransactionError.soldeInsuffisant,
          ));
        } //
        else if (badParam == "date") {
          emit(TransactionRtpReponseState(
            tx.endToEndId,
            tx,
            TransactionError.delaiDepasse,
          ));
        } //
        else if (badParam == "statut") {
          emit(TransactionRtpReponseState(
            tx.endToEndId,
            tx,
            TransactionError.dejaPaye,
          ));
        } else {
          emit(TransactionRtpReponseState(
            tx.endToEndId,
            tx,
            TransactionError.unknow,
          ));
        }
      } else {
        emit(TransactionRtpReponseState(
          tx.endToEndId,
          tx,
          TransactionError.unknow,
        ));
      }
    }
  }

  /// Quand on recoit la réponse au paiement
  _onTransactionRtpAcceptResponseEvent(
    TransactionRtpAcceptResponseEvent event,
    Emitter<TransactionRtpState> emit,
  ) {
    Transaction tx = event.transaction;
    if (tx.statut == TransactionStatut.irrevocable ||
        tx.statut == TransactionStatut.initie ||
        tx.statut == TransactionStatut.rejete
    ) {
      emit(TransactionRtpReponseState(tx.endToEndId, tx));
    }
    // Transaction rejetée
    else {
      // C'est rejeté => "Le participant payeur (destinataire) n'est pas actif"
      if (tx.retourStatutRaison == "AG10") {
        emit(TransactionRtpReponseState(
          tx.endToEndId,
          tx,
          TransactionError.destinataireIndisponible,
        ));
      }
      //
      else {
        emit(TransactionRtpReponseState(
          tx.endToEndId,
          tx,
          TransactionError.unknow,
        ));
      }
    }
  }

  // Demander position GPS
  Future<Position> _askPosition() async {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }

  /// Pour rejeter la demande
  Future<void> _onTransactionRtpRejectEvent(
    TransactionRtpRejectEvent event,
    Emitter<TransactionRtpState> emit,
  ) async {
    Transaction tx = event.transaction;
    emit(TransactionRtpLoadingState(tx.endToEndId, tx));
    try {
      tx = await transactionInputPort.reject(tx, event.raison, event.isRtp);
      emit(TransactionRtpReponseState(tx.endToEndId, tx));
    }
    // Erreurs
    on ApiException catch (e) {
      if (e.error == ApiError.forbidden &&
          e.problem != null &&
          e.problem!.invalidParams != null) {
        var badParam = e.problem!.invalidParams!["name"];
        if (badParam == "date") {
          emit(TransactionRtpReponseState(
            tx.endToEndId,
            tx,
            TransactionError.delaiDepasse,
          ));
        } else {
          emit(TransactionRtpReponseState(
            tx.endToEndId,
            tx,
            TransactionError.unknow,
          ));
        }
      } else {
        emit(TransactionRtpReponseState(
          tx.endToEndId,
          tx,
          TransactionError.unknow,
        ));
      }
    }
  }
}
