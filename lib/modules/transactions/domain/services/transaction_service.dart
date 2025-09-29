import '../../../../shared/models/liste_meta.dart';
import '../../ports/input/transaction_input_port.dart';
import '../../ports/output/transaction_output_port.dart';
import '../models/transaction.dart';
import '../models/transaction_canal.dart';
import '../models/transaction_cancel_reason.dart';
import '../models/transaction_liste.dart';
import '../models/transaction_reject_reason.dart';
import '../models/transaction_send/transaction_confirm_command.dart';
import '../models/transaction_send/transaction_send_command.dart';
import '../models/transaction_send/transaction_send_command_schedule.dart';

class TransactionService implements TransactionInputPort {
  //
  final TransactionOutputPort transactionOutputPort;

  ///
  TransactionService(this.transactionOutputPort);

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
  }) {
    return transactionOutputPort.list(
      compte: compte,
      alias: alias,
      limit: limit,
      sortBy: sortBy,
      fields: fields,
      sens: sens,
      dateOperationDebut: dateOperationDebut,
      dateOperationFin: dateOperationFin,
      categories: categories,
      keyword: keyword,
    );
  }

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
  }) {
    return transactionOutputPort.search(
      compte: compte,
      alias: alias,
      limit: limit,
      page: page,
      sortBy: sortBy,
      fields: fields,
      sens: sens,
      dateOperationDebut: dateOperationDebut,
      dateOperationFin: dateOperationFin,
      categories: categories,
      keyword: keyword,
    );
  }

  @override
  Future<Transaction> initiate(
    TransactionSendCommand command,
  ) async {
    // Définir le canal par défaut s'il n'est pas renseigné
    command.canal ??= TransactionCanal.defaultCanal.code;
    return await transactionOutputPort.initiate(command);
  }

  @override
  Future<Transaction> schedule(
    String endToEndId,
    TransactionConfirmCommand confirmCommand,
    TransactionSendCommandSchedule command,
  ) async {
    return await transactionOutputPort.schedule(endToEndId, confirmCommand, command);
  }

  @override
  Future<void> update(Transaction transaction) async {
    // Local Update
    await transactionOutputPort.update(transaction);
  }

  @override
  Future<Stream<Transaction>> confirm(TransactionConfirmCommand command) async {
    return await transactionOutputPort.confirm(command);
  }

  @override
  Future<Stream<Transaction>> returnFunds(Transaction transaction) async {
    return await transactionOutputPort.returnFunds(transaction);
  }

  @override
  Future<Transaction> cancel(
    Transaction transaction,
    TransactionCancelReason reason,
  ) async {
    return await transactionOutputPort.cancel(transaction, reason);
  }

  @override
  Future<Transaction> get(String reference) async {
    return await transactionOutputPort.get(reference);
  }

  @override
  Future<Transaction> reject(
    Transaction transaction,
    TransactionRejectReason reason,
    isRtp
  ) async {
    return await transactionOutputPort.reject(transaction, reason.code, isRtp: isRtp);
  }

  @override
  Future<TransactionListe> fetchHistory({
    required DateTime startDate,
    required DateTime endDate,
    required int size,
    required int page,
  }) {
    return transactionOutputPort.fetchHistory(
      startDate: startDate,
      endDate: endDate,
      size: size,
      page: page,
    );
  }
}
