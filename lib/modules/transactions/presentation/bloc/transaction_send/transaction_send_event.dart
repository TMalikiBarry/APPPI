import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../../domain/models/transaction_send/transaction_send_method.dart';

class TransactionSendEvent {
  const TransactionSendEvent();
}

/// Lister les 3 dernières transactions à afficher
class TransactionSendListRecentsEvent extends TransactionSendEvent {
  const TransactionSendListRecentsEvent(this.compte);
  final String compte;
}

/// Rechercher les contacts
class TransactionSendSearchContactsEvent extends TransactionSendEvent {
  const TransactionSendSearchContactsEvent(this.contact);
  final String? contact;
}

/// Recherche par le nom ou l'alias ou dans les contacts
class TransactionSendSearchEvent extends TransactionSendEvent {
  const TransactionSendSearchEvent();
}

/// Pour afficher le formulaire de transaction
class TransactionSendDisplayFormEvent extends TransactionSendEvent {
  final TransactionSendCommand command;
  const TransactionSendDisplayFormEvent(this.command);
}

/// Pour demander le solde du client pour vérification du montant
/// quand c'est un transfert
class TransactionSendCheckSoldeEvent extends TransactionSendEvent {
  const TransactionSendCheckSoldeEvent(this.command);
  final TransactionSendCommand command;
}

/// Pour valider le formulaire
class TransactionSendFormChangedEvent extends TransactionSendEvent {
  const TransactionSendFormChangedEvent(this.command);
  final TransactionSendCommand command;
}

/// Événement pour récupérer la liste des participants selon le pays sélectionné
class TransactionSendGetParticipantsByCountryEvent extends TransactionSendEvent {
  TransactionSendGetParticipantsByCountryEvent(this.countryCode, this.command);
  final String countryCode;
  final TransactionSendCommand command;
}

/// Quand l'utilisateur veut continuer (initier le transfert)
class TransactionSendInitiateEvent extends TransactionSendEvent {
  //
  const TransactionSendInitiateEvent(this.command);
  final TransactionSendCommand command;
}

/// Quand l'utilisateur veut programmer le transfert
class TransactionSendScheduleEvent extends TransactionSendEvent {
  //
  const TransactionSendScheduleEvent(this.command, this.transaction);
  final TransactionSendCommand command;
  final Transaction transaction;
}

/// Quand l'utilisateur veut rejeter le transfert
class TransactionSendRejectEvent extends TransactionSendEvent {
  //
  const TransactionSendRejectEvent(this.command);
  final TransactionSendCommand command;
}

/// Quand l'utilisateur veut confirmer le transfert
class TransactionSendConfirmEvent extends TransactionSendEvent {
  //
  const TransactionSendConfirmEvent(
    this.command,
    this.transaction,
    this.method,
  );
  final TransactionSendCommand command;
  final Transaction transaction;
  final TransactionSendMethod method;
}

/// Quand une réponse à un transfert est reçue
class TransactionSendResponseEvent extends TransactionSendEvent {
  //
  const TransactionSendResponseEvent(this.command, this.transaction);
  final TransactionSendCommand command;
  final Transaction transaction;
}

class TransactionSendErrorEvent extends TransactionSendEvent {
  //
  const TransactionSendErrorEvent(this.command, this.transaction, this.error);
  final TransactionSendCommand command;
  final Transaction transaction;
  final String error;
}

class TransactionSendSplitSendEvent extends TransactionSendEvent {
  final List<TransactionSendCommand> commands;
  final String method;
  TransactionSendSplitSendEvent(this.commands, this.method);
}

/// Événement pour récupérer un des participants selon le pays sélectionné et son code participant
class TransactionGetNameParticipant extends TransactionSendEvent {
  TransactionGetNameParticipant(this.countryCode, this.participantCode);
  final String countryCode;
  final String participantCode;
}