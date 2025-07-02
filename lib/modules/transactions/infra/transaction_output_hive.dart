import '../../../core/storage.dart';
import '../../../shared/models/liste_meta.dart';
import '../domain/models/transaction.dart';
import '../domain/models/transaction_liste.dart';

class TransactionLocalHive {
  ///
  const TransactionLocalHive();

  ///
  static const String collectionId = "transactions";
  static const String collectionSchedule = "subscriptions";

  /// Lister les transactions à partir des données en local
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
    //
    // Retrieve collection
    List<Transaction> transactions = await AppStorage.list<Transaction>(
      collectionId,
      (json) => Transaction.fromJson(json),
    );

    // Filter by alias
    if (alias != null) {
      transactions = transactions.where((tx) => tx.alias == alias).toList();
    }

    // Filter by sens
    if (sens != null) {
      transactions = transactions.where((tx) => tx.sens?.name == sens).toList();
    }

    // Filter by categorie
    if (categories != null && categories.isNotEmpty) {
      transactions = transactions
          .where((tx) =>
              tx.categorie != null && categories.contains(tx.categorie!))
          //tx.categorie!.toLowerCase().indexOf(categories[0].toLowerCase()) >
          //0)
          .toList();
    }

    // Filter by date
    if (dateOperationDebut != null) {
      transactions = transactions
          .where((tx) => tx.dateOperation!.compareTo(dateOperationDebut) >= 0)
          .toList();
    }
    if (dateOperationFin != null) {
      transactions = transactions
          .where((tx) => tx.dateOperation!.compareTo(dateOperationFin) <= 0)
          .toList();
    }

    // Filter by keyword
    if (keyword != null && keyword.trim().isNotEmpty) {
      transactions = transactions
          .where((tx) =>
              tx.toString().toLowerCase().indexOf(keyword.toLowerCase()) > 0)
          .toList();
    }

    // Sort by the most recents
    transactions.sort((a, b) => b.dateOperation!.compareTo(a.dateOperation!));

    // Return nb items requested
    if (limit != null && limit < transactions.length) {
      List<Transaction> donnees = transactions.take(limit).toList();
      return TransactionListe(
        data: donnees,
        meta: ListeMeta(total: transactions.length, limit: limit),
      );
    } //
    else {
      return TransactionListe(
        data: transactions,
        meta: ListeMeta(
          total: transactions.length,
          limit: transactions.length,
        ),
      );
    }
  }

  /// Recuperer une transaction
  Future<Transaction> get(String reference) async {
    return await AppStorage.get(collectionId, reference, Transaction.fromJson);
  }

  /// Enregistre une transaction dans la base locale
  Future<void> save(Transaction transaction) async {
    await AppStorage.save(
      collectionId,
      transaction.endToEndId,
      transaction.toJson(),
    );
  }

  /// MAJ une transaction dans la base locale
  Future<void> patch(Transaction transaction) async {
    await AppStorage.patch(
      collectionId,
      transaction.endToEndId,
      transaction.toJson(),
    );
  }

  /// Ecoute sur les changements de la liste des transactions
  Future<Stream<List<Transaction>>> stream() async {
    return await AppStorage.streamList(
      collectionId,
      Transaction.fromJson,
    );
  }

  /// Enregistre une subscription dans la base locale
  Future<void> schedule(Transaction transaction) async {
    await AppStorage.save(
      collectionSchedule,
      transaction.endToEndId,
      transaction.toJson(),
    );
  }
}
