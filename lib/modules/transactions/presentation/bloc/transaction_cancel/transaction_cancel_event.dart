import '../../../domain/models/transaction.dart';

abstract class TransactionCancelEvent {
  const TransactionCancelEvent();
}

class TransactionCancelFetchEvent extends TransactionCancelEvent {
  final String endToEndId;
  const TransactionCancelFetchEvent(this.endToEndId);
}

class TransactionCancelAcceptEvent extends TransactionCancelEvent {
  final String endToEndId;
  final Transaction transaction;

  const TransactionCancelAcceptEvent(this.endToEndId, this.transaction);
}

class TransactionCancelAcceptResponseEvent extends TransactionCancelEvent {
  final Transaction transaction;
  const TransactionCancelAcceptResponseEvent(this.transaction);
}

class TransactionCancelRejectEvent extends TransactionCancelEvent {
  final Transaction transaction;

  const TransactionCancelRejectEvent(this.transaction);
}
