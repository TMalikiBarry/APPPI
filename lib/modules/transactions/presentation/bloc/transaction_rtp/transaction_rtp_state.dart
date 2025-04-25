import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_error.dart';

abstract class TransactionRtpState {
  final String endToEndId;
  const TransactionRtpState(this.endToEndId);
}

class TransactionRtpInitialState extends TransactionRtpState {
  const TransactionRtpInitialState(super.endToEndId);
}

class TransactionRtpDetailsState extends TransactionRtpState {
  final Transaction transaction;
  const TransactionRtpDetailsState(super.endToEndId, this.transaction);
}

class TransactionRtpLoadingState extends TransactionRtpState {
  final Transaction transaction;
  const TransactionRtpLoadingState(super.endToEndId, this.transaction);
}

class TransactionRtpReponseState extends TransactionRtpState {
  final Transaction transaction;
  final TransactionError? error;
  const TransactionRtpReponseState(
    super.endToEndId,
    this.transaction, [
    this.error,
  ]);
}
