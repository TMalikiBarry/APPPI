import 'package:flutter_contacts/flutter_contacts.dart';

import '../../../domain/models/participant/participant.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_liste.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';

class TransactionSendState {
  /// Liste des dernières transactions affichées
  final TransactionListe? transactions;

  /// Liste des participants
  final List<Participant>? participants;

  const TransactionSendState({
    this.transactions,
    this.participants,
  });
}

final class TransactionSendInitialState extends TransactionSendState {
  /// Liste des dernières transactions affichées
  final List<Contact>? contacts;
  const TransactionSendInitialState({super.transactions, this.contacts});
}

final class TransactionSendSearchState extends TransactionSendState {
  /// Liste des dernières transactions affichées
  final List<Contact>? contacts;
  const TransactionSendSearchState({super.transactions, this.contacts});
}

/// Affiche le formulaire d'envoie d'une transaction
final class TransactionSendFormInputState extends TransactionSendState {
  const TransactionSendFormInputState(this.command, {super.participants});
  final TransactionSendCommand command;
}

/// Pendant que l'on recherche les données à vérifier
final class TransactionSendFormVerificationLoadingState
    extends TransactionSendState {
  TransactionSendFormVerificationLoadingState(this.command,
      {super.participants});
  final TransactionSendCommand command;
}
final class TransactionSendFormInitLoadingState
    extends TransactionSendState {
  TransactionSendFormInitLoadingState(this.command);
  final TransactionSendCommand command;
}

/// Affiche les données de vérification
final class TransactionSendFormVerificationAskingState
    extends TransactionSendState {
  TransactionSendFormVerificationAskingState(this.command, this.transaction,
      {super.participants});
  final TransactionSendCommand command;
  final Transaction transaction;
}

/// Affiche le formulaire de programmation d'une transaction
final class TransactionSendFormScheduleState extends TransactionSendState {
  const TransactionSendFormScheduleState(
    this.command,
    this.transaction, {
    super.participants,
  });
  final TransactionSendCommand command;
  final Transaction transaction;
}

/// Pendant que l'on confirme la transaction
final class TransactionSendFormSendingState extends TransactionSendState {
  TransactionSendFormSendingState(
    this.command,
    this.transaction, {
    super.participants,
  });
  final TransactionSendCommand command;
  final Transaction transaction;
}

/// Transaction réussie
final class TransactionSendFormSuccessState extends TransactionSendState {
  TransactionSendFormSuccessState(
    this.command,
    this.transaction, {
    super.participants,
  });
  final TransactionSendCommand command;
  final Transaction transaction;
}

/// Transaction échouée
final class TransactionSendFormErrorState extends TransactionSendState {
  TransactionSendFormErrorState(
    this.command,
    this.error, {
    super.participants,
  });
  final TransactionSendCommand command;
  final String error;
}

final class TransactionSendLoadingState
    extends TransactionSendState {
  TransactionSendLoadingState(this.command);
  final TransactionSendCommand command;
}