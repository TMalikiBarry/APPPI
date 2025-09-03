import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

import '../../../../../core/api.dart';
import '../../../../compte/ports/input/compte_input_port.dart';
import '../../../../security/domain/models/permission_type.dart';
import '../../../../security/ports/input/permission_input_port.dart';
import '../../../domain/models/participant/participant.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_error.dart';
import '../../../domain/models/transaction_liste.dart';
import '../../../domain/models/transaction_send/transaction_confirm_command.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../../domain/models/transaction_send/transaction_send_command_alias.dart';
import '../../../ports/input/participant_input_port.dart';
import '../../../ports/input/transaction_input_port.dart';
import 'transaction_send_event.dart';
import 'transaction_send_state.dart';

class TransactionSendBloc extends Bloc<TransactionSendEvent, TransactionSendState> {
  ///
  final logger = Logger();

  /// Service transaction
  final TransactionInputPort transactionsInputPort;

  /// Info compte solde
  final CompteInputPort compteInputPort;

  /// Pour obtenir la liste des participants
  final ParticipantInputPort participantInputPort;

  /// Pour demander des permissions
  final PermissionInputPort permissionInputPort;

  ///
  TransactionSendBloc(
    this.transactionsInputPort,
    this.compteInputPort,
    this.participantInputPort,
    this.permissionInputPort,
  ) : super(const TransactionSendInitialState()) {
    // Pour obtenir la liste des transferts récents
    on<TransactionSendListRecentsEvent>(_onTransactionSendListRecentsEvent);

    // Pour cacher ou afficher les options de transferts
    on<TransactionSendSearchContactsEvent>(_onTransactionSendSearchContactsEvent);

    // Pour afficher le formulaire de transaction
    on<TransactionSendDisplayFormEvent>(_onTransactionSendDisplayFormEvent);

    // Pour vérifier l'état de validation du formulaire
    on<TransactionSendFormChangedEvent>(_onTransactionSendFormChangedEvent);

    // Pour initier la transaction
    on<TransactionSendInitiateEvent>(_onTransactionSendInitiateEvent);
    // Pour confirmer la transaction
    on<TransactionSendConfirmEvent>(_onTransactionSendConfirmEvent);

    // Pour rejeter la transaction
    on<TransactionSendRejectEvent>(_onTransactionSendRejectEvent);

    // A la reception d'une réponse
    on<TransactionSendResponseEvent>(_onTransactionSendResponseEvent);
    on<TransactionSendErrorEvent>(_onTransactionSendErrorEvent);

    // Pour programmer une transaction
    on<TransactionSendScheduleEvent>(_onTransactionSendScheduleEvent);

    //Pour partager un paiement
    on<TransactionSendSplitSendEvent>(_onTransactionSendSplitSendEvent);

    // Pour récupérer les participants selon le pays
    on<TransactionSendGetParticipantsByCountryEvent>(_onTransactionSendGetParticipantsByCountryEvent);

    on<TransactionGetNameParticipant>(_onTransactionGetNameParticipant);
  }

  /// Pour obtenir la liste des transferts récents
  void _onTransactionSendListRecentsEvent(
    TransactionSendListRecentsEvent event,
    Emitter<TransactionSendState> emit,
  ) async {
    // Récuperer la liste
    TransactionListe transactions = await transactionsInputPort.list(
      compte: event.compte,
      limit: 3,
    );
    // Retourner la liste
    emit(TransactionSendInitialState(transactions: transactions));
  }

  /// Pour obtenir la liste des transferts récents
  void _onTransactionSendSearchContactsEvent(
    TransactionSendSearchContactsEvent event,
    Emitter<TransactionSendState> emit,
  ) async {
    if (event.contact != "") {
      emit(TransactionSendSearchState(transactions: state.transactions));
    } else {
      emit(TransactionSendInitialState(transactions: state.transactions));
    }
  }

  /// Récupère les données de référence permettant d'effectuer des transferts
  void _onTransactionSendDisplayFormEvent(
    TransactionSendDisplayFormEvent event,
    Emitter<TransactionSendState> emit,
  ) async {
    emit(TransactionSendFormInputState(event.command));

    // Récupérer le solde
    TransactionSendCommand form = event.command;
    double? solde = await compteInputPort.getSolde(form.compte);
    form.solde = solde ?? 0.0;
    emit(TransactionSendFormInputState(form));

    // Recuperer liste des PSPs
    List<Participant> psps = await participantInputPort.list(form.pspPays);
    if (event.command.pspCode != null) {
      try {
        Participant psp = psps.where((el) => el.codeMembre == event.command.pspCode).first;
        event.command.pspNom = psp.nomMembre;
      } catch (e) {
        // TODO handle psp not in list
      }
    }
    emit(TransactionSendFormInputState(form, participants: psps));
  }

  /// A chaque fois que les données entrées changent, reactive form
  void _onTransactionSendFormChangedEvent(
    TransactionSendFormChangedEvent event,
    Emitter<TransactionSendState> emit,
  ) async {
    TransactionSendCommand form = event.command;
    form.isValid();
    // Si IBAN, determine participant
    if (form.iban != null && form.iban!.isValid() && state.participants != null) {
      Iterable<Participant> matches = state.participants!.where((element) => element.codeBanque == form.iban!.value!.substring(4, 9));
      //
      if (matches.length == 1) {
        Participant psp = matches.first;
        form.pspCode = psp.codeMembre;
        form.pspPays = form.pspCode!.substring(0, 2);
        form.pspNom = psp.nomMembre;
      }
    }
    // Si Other e
    if (form.othr != null && form.othr!.isValid() && form.pspCode != null && state.participants != null) {
      Iterable<Participant> matches = state.participants!.where((element) => element.codeMembre == form.pspCode);
      //
      if (matches.length == 1) {
        Participant psp = matches.first;
        form.pspNom = psp.nomMembre;
      }
    }
    emit(TransactionSendFormInputState(form, participants: state.participants));
  }

  /// Initier la transaction (Alias recherche, QR Code transfer, Verification)
  void _onTransactionSendInitiateEvent(
    TransactionSendInitiateEvent event,
    Emitter<TransactionSendState> emit,
  ) async {
    // Loading
    //emit(TransactionSendFormVerificationLoadingState(event.command,
    //    participants: state.participants));
    emit(TransactionSendLoadingState(event.command));
    logger.i("### DANS TransactionSendLoadingState CONFIRM pressed for");

    // Récuperer position GPS
    Position? position = await _getPosition();
    if (position != null) {

      // Ajouter la position dans les données du transfert
      event.command.latitude = position.latitude; // 14.7508962
      event.command.longitude = position.longitude; // -17.464383

      logger.w("### DANS TransactionSendLoadingState POsition Pas null");
      // Initier
      TransactionSendCommand form = event.command;
      //form.isValid();
      try {
        logger.i("### DANS TransactionSendLoadingState INITIER 1");
        Transaction transaction = await transactionsInputPort.initiate(
          event.command,
        );
        /* if (event.command.action == TransactionSendCommand.actionReceiveNow) {
          // La demande est envoyée
          emit(TransactionSendFormSuccessState(
            event.command,
            transaction,
            participants: state.participants,
          ));
        } // Transferts
        else {*/
        // Afficher la page de demande de vérification
        logger.i("### DANS TransactionSendLoadingState "
            "INITIER 2 tx = ${transaction.transactionVerificationResultAlias?.toJson()}");
        emit(TransactionSendFormVerificationAskingState(
          form,
          transaction,
        ));
        //}
      } on ApiException catch (e) {
        logger.e("### DANS TransactionSendLoadingState Erreur est ", error: e);
        // Erreur de vérification : alias invalide ou autre
        if (e.error == ApiError.notFound) {
          emit(TransactionSendFormErrorState(
            event.command,
            TransactionSendCommandAliasError.notFound.code,
            participants: state.participants,
          ));
        }
        // Inconnu
        else {
          emit(TransactionSendFormErrorState(
            event.command,
            TransactionError.unknow.toString(),
            participants: state.participants,
          ));
        }
      }
    } else {
      logger.w("### DANS TransactionSendLoadingState pas de confirmation et PAS DE POSITION");
      // Il reste sur le formulaire - pas de confirmation
      emit(TransactionSendFormInputState(
        event.command,
        participants: state.participants,
      ));
    }
  }

  // Confirmer le transfert
  void _onTransactionSendConfirmEvent(
    TransactionSendConfirmEvent event,
    Emitter<TransactionSendState> emit,
  ) async {
    Transaction transaction = event.transaction;

    // Loading
    /*emit(TransactionSendFormSendingState(
      event.command,
      transaction,
      participants: state.participants,
    ));*/
    emit(TransactionSendLoadingState(event.command));

    // Initier
    /*if (event.command.schedule != null) {
    // Just schedule
    try {
      transaction = await transactionsInputPort.schedule(
        transaction.endToEndId,
        event.command.schedule!,
      );
      emit(TransactionSendFormSuccessState(
        event.command,
        transaction,
        participants: state.participants,
      ));
    } catch (e) {
      logger.e("Erreur de création de la souscription", error: e);
      emit(TransactionSendFormErrorState(
        event.command,
        TransactionError.unknow.name,
        participants: state.participants,
      ));
    }
    //}
    // Send Now
    else {*/
    try {
      Stream<Transaction> stream = await transactionsInputPort.confirm(TransactionConfirmCommand(
        endToendId: transaction.endToEndId,
        confirmationDate: DateTime.now().toIso8601String(),
        confirmationMethode: event.method,
        latitude: event.command.latitude,
        longitude: event.command.longitude,
        amount: event.command.amount,
        transactionVerificationResultAlias: event.transaction.transactionVerificationResultAlias,
        transactionVerificationResultIban: event.transaction.transactionVerificationResultIban,
        transactionVerificationResultOthr: event.transaction.transactionVerificationResultOthr,
      ));

      stream.listen(
        (trans) {
          add(TransactionSendResponseEvent(event.command, trans));
        },
        onError: (error) {
          if (error is TimeoutException) {
            add(TransactionSendErrorEvent(
              event.command,
              transaction,
              TransactionError.timeOut.toString(),
            ));
          } else {
            add(TransactionSendErrorEvent(event.command, transaction, error));
          }
        },
      );
    } catch (e) {
      logger.e("Erreur de création de la souscription", error: e);
      emit(TransactionSendFormErrorState(
        event.command,
        TransactionError.unknow.name,
        participants: state.participants,
      ));
    }
    //}
  }

  /// Losq'une réponse est reçue aprés envoie d'une transaction
  void _onTransactionSendResponseEvent(
    TransactionSendResponseEvent event,
    Emitter<TransactionSendState> emit,
  ) {
    Transaction transaction = event.transaction;
    if (transaction.statut == TransactionStatut.irrevocable) {
      emit(TransactionSendFormSuccessState(
        event.command,
        event.transaction,
        participants: state.participants,
      ));
    } else {
      emit(TransactionSendFormErrorState(
        event.command,
        "REJETEE",
        participants: state.participants,
      ));
    }
  }

  /// Lorsqu'une réponse n'est pas reçue à cause d'une erreur
  void _onTransactionSendErrorEvent(
    TransactionSendErrorEvent event,
    Emitter<TransactionSendState> emit,
  ) {
    emit(TransactionSendFormErrorState(
      event.command,
      event.error,
      participants: state.participants,
    ));
  }

  /// Losque l'utilisateur demande à annuler le transfert
  void _onTransactionSendRejectEvent(
    TransactionSendRejectEvent event,
    Emitter<TransactionSendState> emit,
  ) async {
    // Retourner la liste
    emit(TransactionSendInitialState(transactions: state.transactions));
  }

  void _onTransactionSendScheduleEvent(
    TransactionSendScheduleEvent event,
    Emitter<TransactionSendState> emit,
  ) async {
    TransactionSendCommand form = event.command;
    form.isValid();
    emit(TransactionSendFormScheduleState(
      form,
      event.transaction,
      participants: state.participants,
    ));
  }

  void _onTransactionSendSplitSendEvent(
    TransactionSendSplitSendEvent event,
    Emitter<TransactionSendState> emit,
  ) async {
    // Loading
    emit(TransactionSendFormVerificationLoadingState(
      event.commands[0],
      participants: state.participants,
    ));

    // Récuperer position GPS
    Position? position = await _getPosition();
    if (position == null) {
      emit(TransactionSendInitialState(transactions: state.transactions));
    } else {
      List<Transaction> transactions = [];
      List<String> errors = [];
      for (TransactionSendCommand command in event.commands) {
        command.latitude = position.latitude;
        command.longitude = position.longitude;
        try {
          Transaction transaction = await transactionsInputPort.initiate(
            command,
          );
          transaction.motif = command.motif?.value;
          transactions.add(transaction);
        } catch (e) {
          logger.e(
              "Erreur d'envoie du paiement partagé"
              " à ${command.alias!.value}",
              error: e);
          errors.add(e.toString());
        }
      }
      if (errors.isEmpty) {
        emit(TransactionSendFormSuccessState(
          event.commands[0],
          transactions[0],
        ));
      } else {
        emit(TransactionSendFormErrorState(
          event.commands[0],
          errors.join(", "),
        ));
      }
    }
  }

  Future<Position?> _getPosition() async {
    Position? position;
    try {
      logger.i("_getPosition");

      // Vérifier et demander l'autorisation avant d'obtenir la position
      bool hasPermission = await _checkAndRequestLocationPermission();
      logger.i("hasPermission $hasPermission");

      if (!hasPermission) {
        logger.i("_getPosition : Permission de localisation refusée");
        return null;
      }

      position = await _askPosition();
      logger.i("_getPosition : '${position.longitude}' '${position.latitude}'");
    } catch (e) {
      logger.i("_getPosition : '${e.toString()}'");

      // Fallback avec votre système de permissions personnalisé
      PermissionType permission = PermissionType.localisationGPS;
      bool granted = await permissionInputPort.grantPermission(permission);
      logger.i("_getPosition : granted $granted");

      if (granted) {
        // Réessayer la vérification après avoir accordé la permission
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          position = await _askPosition();
        } else {
          logger.i("_getPosition : Service de localisation toujours désactivé");
        }
      }
    }
    return position;
  }

// Vérifier et demander l'autorisation de localisation
  Future<bool> _checkAndRequestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifier l'autorisation actuelle d'abord
    permission = await Geolocator.checkPermission();
    logger.i("_checkAndRequestLocationPermission : Permission actuelle: $permission");

    if (permission == LocationPermission.denied) {
      // Demander l'autorisation - ceci affichera le pop-up système
      // Même si le GPS est désactivé, le pop-up peut permettre d'activer le GPS
      logger.i("_checkAndRequestLocationPermission : Demande d'autorisation en cours...");
      permission = await Geolocator.requestPermission();
      logger.i("_checkAndRequestLocationPermission : Réponse de l'utilisateur: $permission");

      if (permission == LocationPermission.denied) {
        logger.i("_checkAndRequestLocationPermission : Autorisation refusée par l'utilisateur");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      logger.i("_checkAndRequestLocationPermission : Autorisation refusée définitivement");

      // Ouvrir les paramètres de l'application pour activation manuelle
      await Geolocator.openAppSettings();
      return false;
    }

    // Maintenant vérifier si le service de localisation est activé
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      logger.i("_checkAndRequestLocationPermission : Service de localisation désactivé");

      // Si on a la permission mais le service est désactivé,
      // ouvrir les paramètres système pour activer le GPS
      await Geolocator.openLocationSettings();

      // Attendre un peu que l'utilisateur puisse activer le service
      await Future.delayed(Duration(seconds: 2));

      // Vérifier à nouveau si le service est maintenant activé
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        logger.i("_checkAndRequestLocationPermission : Service de localisation toujours désactivé");
        return false;
      }
      logger.i("_checkAndRequestLocationPermission : Service de localisation activé");
    }

    // Vérifier si on a au moins une permission partielle
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      logger.i("_checkAndRequestLocationPermission : Autorisation accordée ($permission)");
      return true;
    }

    logger.i("_checkAndRequestLocationPermission : Permission non accordée: $permission");
    return false;
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

  /// Récupère les participants selon le pays sélectionné
  void _onTransactionSendGetParticipantsByCountryEvent(
    TransactionSendGetParticipantsByCountryEvent event,
    Emitter<TransactionSendState> emit,
  ) async {
    try {
      logger.i("CountryCode ${event.countryCode}");
      logger.i("CountryCode ${event.command.toJson()}");
      // Récupérer la liste des participants pour le pays sélectionné
      List<Participant> participants = await participantInputPort.list(event.countryCode);

      // Mettre à jour le command avec le nouveau pays
      TransactionSendCommand updatedCommand = event.command;
      updatedCommand.pspPays = event.countryCode;

      // Réinitialiser le participant sélectionné si il n'existe pas dans la nouvelle liste
      if (updatedCommand.pspCode != null) {
        bool participantExists = participants.any((p) => p.codeMembre == updatedCommand.pspCode);
        if (!participantExists) {
          updatedCommand.pspCode = null;
          updatedCommand.pspNom = null;
        }
      }

      // Valider le formulaire
      updatedCommand.isValid();

      // Émettre le nouvel état avec la liste des participants mise à jour
      emit(TransactionSendFormInputState(updatedCommand, participants: participants));
    } catch (e) {
      logger.e("Erreur lors de la récupération des participants: $e");
      // Émettre un état d'erreur ou maintenir l'état actuel
      emit(TransactionSendFormInputState(event.command, participants: []));
    }
  }


  /// Récupère les participants selon le pays sélectionné
  void _onTransactionGetNameParticipant(
      TransactionGetNameParticipant event,
      Emitter<TransactionSendState> emit,
      ) async {
    try {
      logger.i("CountryCode ${event.countryCode}");
      logger.i("participantCode ${event.participantCode}");

      // Récupérer la liste des participants pour le pays sélectionné
      List<Participant> participants =
      await participantInputPort.list(event.countryCode);
      String? participantName;

      // Vérifier si le participant sélectionné existe toujours
      Participant? selected = participants.firstWhere(
            (p) => p.codeMembre == event.participantCode,
        orElse: null, // à adapter selon ton modèle
      );

      if (selected.codeMembre == null || selected.codeMembre!.isEmpty) {
        // le participant n'existe plus -> on réinitialise
        participantName = null;
      } else {
        participantName = selected.nomMembre;
      }

      // Émettre le nouvel état avec la liste des participants mise à jour
      emit(TransactionSearchParticipant(participantName: participantName));
    } catch (e) {
      logger.i("Erreur lors de la récupération des participants: $e");
      // Émettre un état d'erreur ou état avec liste vide
      emit(TransactionSearchParticipant(participantName: null));
    }
  }
}
