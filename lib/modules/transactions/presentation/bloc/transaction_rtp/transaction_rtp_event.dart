import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_reject_reason.dart';
import '../../../domain/models/transaction_send/transaction_send_method.dart';

abstract class TransactionRtpEvent {
  const TransactionRtpEvent();
}

class TransactionRtpFetchEvent extends TransactionRtpEvent {
  //final String endToEndId;
  final Transaction transaction;
  const TransactionRtpFetchEvent(this.transaction);
}

class TransactionRtpFrequenceEvent extends TransactionRtpEvent {
  final Transaction transaction;
  final bool frequence;
  const TransactionRtpFrequenceEvent(this.transaction, this.frequence);
}

class TransactionRtpAcceptPayEvent extends TransactionRtpEvent {
  final Transaction transaction;
  // Methode d'authentification
  final TransactionSendMethod method;
  const TransactionRtpAcceptPayEvent(this.transaction, this.method);
}

class TransactionRtpScheduleEvent extends TransactionRtpEvent {
  final Transaction transaction;
  const TransactionRtpScheduleEvent(this.transaction);
}

class TransactionRtpAcceptResponseEvent extends TransactionRtpEvent {
  final Transaction transaction;
  const TransactionRtpAcceptResponseEvent(this.transaction);
}

class TransactionRtpRejectEvent extends TransactionRtpEvent {
  final Transaction transaction;
  final TransactionRejectReason raison;
  final bool isRtp;
  const TransactionRtpRejectEvent(this.transaction, this.raison, this.isRtp);
}
