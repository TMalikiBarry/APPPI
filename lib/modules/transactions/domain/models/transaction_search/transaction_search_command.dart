import 'transaction_search_filter.dart';

class TransactionSearchCommand {
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
  }) {
    return TransactionSearchCommand(
      compte: compte ?? this.compte,
      index: index ?? this.index,
      limit: limit ?? this.limit,
      filters: filters ?? this.filters,
      keyWord: keyWord ?? this.keyWord,
    );
  }
}
