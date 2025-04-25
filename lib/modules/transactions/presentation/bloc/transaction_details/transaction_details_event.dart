import '../../../../categorie/domain/models/categorie.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_cancel_reason.dart';

abstract class TransactionDetailsEvent {
  const TransactionDetailsEvent();
}

class TransactionDetailsFetchEvent extends TransactionDetailsEvent {
  final Transaction transaction;
  const TransactionDetailsFetchEvent(this.transaction);
}

class TransactionCategorieUpdateEvent extends TransactionDetailsEvent {
  final Transaction transaction;
  final Categorie categorie;
  const TransactionCategorieUpdateEvent(this.transaction, this.categorie);
}

class TransactionReturnSendEvent extends TransactionDetailsEvent {
  final Transaction transaction;
  const TransactionReturnSendEvent(this.transaction);
}

class TransactionReturnResponseEvent extends TransactionDetailsEvent {
  final Transaction transaction;
  const TransactionReturnResponseEvent(this.transaction);
}

/// Demande d'annulation
class TransactionCancelSendEvent extends TransactionDetailsEvent {
  final Transaction transaction;
  final TransactionCancelReason reason;
  const TransactionCancelSendEvent(this.transaction, this.reason);
}

// class TransactionDetailsInitial extends TransactionDetailsEvent {}

// class RecuperationTransactionDetailsEvent extends TransactionDetailsEvent {
//   final String transactionId;
//   RecuperationTransactionDetailsEvent(this.transactionId);
// }

// class ChargerTicketDeCaisseEvent extends TransactionDetailsEvent {
//   final String transactionId;
//   final String filePath;
//   ChargerTicketDeCaisseEvent(this.transactionId, this.filePath);
// }

// class ChangerCategorieEvent extends TransactionDetailsEvent {
//   final String transactionId;
//   final String categorie;
//   ChangerCategorieEvent(this.transactionId, this.categorie);
// }

// class SupprimerTicketDeCaisseEvent extends TransactionDetailsEvent {
//   final String transactionId;
//   final String filePath;
//   SupprimerTicketDeCaisseEvent(this.transactionId, this.filePath);
// }
