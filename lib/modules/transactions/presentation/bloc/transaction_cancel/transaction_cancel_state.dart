import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_error.dart';

abstract class TransactionCancelState {
  final String endToEndId;
  const TransactionCancelState(this.endToEndId);
}

class TransactionCancelInitialState extends TransactionCancelState {
  const TransactionCancelInitialState(super.endToEndId);
}

class TransactionCancelDetailsState extends TransactionCancelState {
  final Transaction transaction;
  const TransactionCancelDetailsState(super.endToEndId, this.transaction);
}

class TransactionCancelLoadingState extends TransactionCancelState {
  final Transaction transaction;
  const TransactionCancelLoadingState(super.endToEndId, this.transaction);
}

class TransactionCancelReponseState extends TransactionCancelState {
  final Transaction transaction;
  final TransactionError? error;
  const TransactionCancelReponseState(
    super.endToEndId,
    this.transaction, [
    this.error,
  ]);
}

class TransactionInitCancelState extends TransactionCancelState {
  const TransactionInitCancelState(super.endToEndId);
}