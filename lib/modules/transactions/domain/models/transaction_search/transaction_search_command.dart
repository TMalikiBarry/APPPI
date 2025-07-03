import 'transaction_search_filter.dart';

class TransactionSearchCommand {
  final String? compte;
  final TransactionSearchFilter filters;
  final String? keyWord;
  final int index;
  final int limit;
  final int? total; // Nouvelle propriété
  final bool hasMorePages;

  TransactionSearchCommand({
    this.compte,
    required this.filters,
    this.keyWord,
    this.index = 0,
    this.limit = 10,
    this.total,
    this.hasMorePages = true,
  });

  TransactionSearchCommand copyWith({
    String? compte,
    TransactionSearchFilter? filters,
    String? keyWord,
    int? index,
    int? limit,
    int? total,
    bool? hasMorePages,
  }) {
    return TransactionSearchCommand(
      compte: compte ?? this.compte,
      filters: filters ?? this.filters,
      keyWord: keyWord ?? this.keyWord,
      index: index ?? this.index,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      hasMorePages: hasMorePages ?? this.hasMorePages,
    );
  }

  bool canLoadMore() {
    if (total == null) return true;
    final loadedItems = index * limit;
    return loadedItems < total!;
  }

  static const int defaultLimit = 10;
}
/*class TransactionSearchCommand {
  static const int defaultLimit = 5;
  //
  TransactionSearchCommand({
    required this.filters,
    this.compte,
    this.keyWord,
    this.limit = defaultLimit,
    this.index = 0,
    this.total = 0,
  });

  TransactionSearchFilter filters;
  String? compte;
  String? keyWord;
  int limit;
  int index;
  int total;

  /// Méthode pour déterminer si plus de notifications peuvent être chargées
  bool canLoadMore() {
    return (index * limit) < total;
  }

  TransactionSearchCommand copyWith({
    String? compte,
    int? index,
    int? limit,
    TransactionSearchFilter? filters,
    String? keyWord,
    int? total,
  }) {
    return TransactionSearchCommand(
      compte: compte ?? this.compte,
      index: index ?? this.index,
      limit: limit ?? this.limit,
      filters: filters ?? this.filters,
      keyWord: keyWord ?? this.keyWord,
      total: total ?? this.total
    );
  }
}*/
