import 'package:logger/logger.dart';


import '../domain/models/transaction.dart';
import '../domain/models/transaction_cancel_reason.dart';
import '../domain/models/transaction_liste.dart';
import '../domain/models/transaction_send/transaction_confirm_command.dart';
import '../domain/models/transaction_send/transaction_send_command.dart';
import '../domain/models/transaction_send/transaction_send_command_schedule.dart';
import '../ports/output/transaction_output_port.dart';
import 'transaction_output_hive.dart';
import 'transaction_output_remote.dart';

/// Online repository
class TransactionOutputRepository implements TransactionOutputPort {
  ///
  TransactionOutputRepository();

  ///
  final logger = Logger();

  final TransactionOutputRemote repoRemote = TransactionOutputRemote();

  /// Pour enregistrer les données localement
  /// Si c'était une base firestore qui est utilisée et non une API simple
  /// On n'aurait pas besoin de gérer le mode Offline nous même
  final TransactionLocalHive repoLocal = const TransactionLocalHive();

  @override
  Future<TransactionListe> search({
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
  }) async {
    // Fetch remote and update local
    TransactionListe liste = await repoRemote.list(
      compte: compte,
      alias: alias,
      page: page,
      limit: limit,
      sens: sens,
      dateOperationDebut: dateOperationDebut,
      dateOperationFin: dateOperationFin,
      keyword: keyword,
      sortBy: sortBy,
      fields: fields,
    );
    try {
      for (var tx in liste.data) {
        repoLocal.patch(tx);
      }
    } catch(e){

    }
    // Trier les transactions par dateOperation dans l'ordre descendant
    liste.data.sort((a, b) => b.dateOperation!.compareTo(a.dateOperation!));
    return liste;
  }

  @override
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
  }) async {

    /*return await repoLocal.list(
      compte: compte,
      alias: alias,
      page: page,
      limit: limit,
      sortBy: sortBy,
      fields: fields,
      sens: sens,
      dateOperationDebut: dateOperationDebut,
      dateOperationFin: dateOperationFin,
      categories: categories,
      keyword: keyword,
    );*/

    return await repoRemote.list(
      compte: compte,
      alias: alias,
      page: page,
      limit: limit,
      sortBy: sortBy,
      fields: fields,
      sens: sens,
      dateOperationDebut: dateOperationDebut,
      dateOperationFin: dateOperationFin,
      keyword: keyword,
    );
  }

  @override
  Future<Transaction> initiate(TransactionSendCommand command) async {
    // Send transfer
    return await repoRemote.initiate(
      command,
    );
  }

  @override
  Future<Stream<Transaction>> confirm(
    TransactionConfirmCommand command,
  ) async {
    // Confirm transfer
    Stream<Transaction> result = await repoRemote.confirm(
      command.endToendId,
      command,
    );
    return result.map((event) {
      if (event.statut == TransactionStatut.irrevocable) {
        repoLocal.save(event);
      }
      return event;
    });
  }

  @override
  Future<Transaction> schedule(
    String endToEndId,
    TransactionSendCommandSchedule command,
  ) async {
    Transaction transaction = await repoRemote.schedule(endToEndId, command);
    repoLocal.schedule(transaction);
    return transaction;
  }

  @override
  Future<void> update(Transaction transaction) async {
    // Local Update
    await repoLocal.save(transaction);
  }

  /// Retourner les fonds après une transaction reçue
  @override
  Future<Stream<Transaction>> returnFunds(
    Transaction transaction,
  ) async {
    // Envoyer le retour de fonds
    return await repoRemote.returnFunds(
      transaction,
    );
  }

  @override
  Future<Transaction> cancel(
    Transaction transaction,
    TransactionCancelReason reason,
  ) async {
    transaction = await repoRemote.cancel(transaction, reason);
    await repoLocal.save(transaction);
    return transaction;
  }

  @override
  Future<Transaction> get(String reference) async {
    return await repoRemote.get(reference);
  }

  @override
  Future<Transaction> reject(Transaction transaction, String reason) async {
    transaction = await repoRemote.reject(transaction, reason);
    await repoLocal.save(transaction);
    return transaction;
  }

  @override
  Future<TransactionListe> fetchHistory({
    required DateTime startDate,
    required DateTime endDate,
    required int size,
    required int page,
  }) async {
    return await repoRemote.history(
      startDate: startDate,
      endDate: endDate,
      size: size,
      page: page,
    );
    // mappe MovementDetailsDTO → Transaction
    /*final txs = dto.data.map((md) => md.toTransaction()).toList();
    // reconstruis la meta
    final meta = ListeMeta(total: dto.total, limit: dto.size);
    return TransactionListe(data: txs, meta: meta);*/
  }
}
