import '../../domain/models/transaction.dart';
import '../../domain/models/transaction_cancel_reason.dart';
import '../../domain/models/transaction_liste.dart';
import '../../domain/models/transaction_reject_reason.dart';
import '../../domain/models/transaction_send/transaction_confirm_command.dart';
import '../../domain/models/transaction_send/transaction_send_command.dart';
import '../../domain/models/transaction_send/transaction_send_command_schedule.dart';

/// Expose les services offerts dans la gestion des transactions
abstract class TransactionInputPort {
  //

  /// Récupère l’historique depuis le serveur
  Future<TransactionListe> fetchHistory({
    required DateTime startDate,
    required DateTime endDate,
    required int size,
    required int page,
  });

  /// Lister les transactions (local)
  Future<TransactionListe> list({
    required String compte,
    String? alias,
    int? page,
    int? limit,
    String? sortBy,
    String? fields,
    String? sens,
    DateTime? dateOperationDebut,
    DateTime? dateOperationFin,
    List<String>? categories,
    String? keyword,
  });

  /// Rechercher
  Future<TransactionListe> search({
    required String compte,
    String? alias,
    int? page,
    int? limit,
    String? sortBy,
    String? fields,
    String? sens,
    List<String>? categories,
    DateTime? dateOperationDebut,
    DateTime? dateOperationFin,
    String? keyword,
  });

  /// Initier une transaction
  Future<Transaction> initiate(
    TransactionSendCommand command,
  );

  /// Confirmer une transaction
  Future<Stream<Transaction>> confirm(
    TransactionConfirmCommand command
  );

  /// Programmer une transaction
  Future<Transaction> schedule(
    String endToEndId,
    TransactionConfirmCommand confirmCommand,
    TransactionSendCommandSchedule command,
  );

  /// Mettre à jour les details d'une transaction
  Future<void> update(Transaction transaction);

  /// Retourner les fonds après une transaction reçue
  Future<Stream<Transaction>> returnFunds(Transaction transaction);

  /// Demander l'annulation d'une transaction
  Future<Transaction> cancel(
    Transaction transaction,
    TransactionCancelReason reason,
  );

  /// Recuperer une transaction à partir de la référence
  Future<Transaction> get(String reference);

  /// Rejeter une transaction: annulation ou paiement
  Future<Transaction> reject(
    Transaction transaction,
    TransactionRejectReason reason,
    bool isRtp,
  );
}
