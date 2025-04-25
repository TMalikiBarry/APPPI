import '../../../../../l10n/app_localizations.dart';
import '../../../domain/models/transaction_cancel_reason.dart';

class TransactionCancelReasonText {
  /// Textes des raisons de la demande d'annulation
  static String label(
    TransactionCancelReason motif,
    AppLocalizations traductions,
  ) {
    switch (motif) {
      case TransactionCancelReason.erreurDestinataire:
        return traductions.transactionDetailsCancelRsnDestinataire;
      case TransactionCancelReason.erreurMontant:
        return traductions.transactionDetailsCancelRsnMontant;
      case TransactionCancelReason.serviceNonRendu:
        return traductions.transactionDetailsCancelRsnService;
      case TransactionCancelReason.fraude:
        return traductions.transactionDetailsCancelRsnFraud;
      case TransactionCancelReason.dejaPaye:
        return traductions.transactionDetailsCancelRsnDuplicate;
    }
  }
}
