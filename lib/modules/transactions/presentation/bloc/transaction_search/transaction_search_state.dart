import '../../../domain/models/transaction_liste.dart';
import '../../../domain/models/transaction_search/transaction_search_command.dart';


abstract class TransactionSearchState {
  TransactionListe get transactions;
  TransactionSearchCommand get command;
  bool get hasMorePages;
}

class TransactionSearchInitialState extends TransactionSearchState {
  @override
  final TransactionListe transactions;
  @override
  final TransactionSearchCommand command;
  @override
  final bool hasMorePages;

  TransactionSearchInitialState({
    required this.transactions,
    required this.command,
    this.hasMorePages = true,
  });
}

class TransactionSearchLoadingState extends TransactionSearchState {
  @override
  final TransactionListe transactions;
  @override
  final TransactionSearchCommand command;
  @override
  final bool hasMorePages;

  TransactionSearchLoadingState({
    required this.transactions,
    required this.command,
    required this.hasMorePages,
  });
}

class TransactionSearchFilterState extends TransactionSearchState {
  @override
  TransactionListe transactions;

  @override
  final TransactionSearchCommand command;

  @override
  final bool hasMorePages;

  TransactionSearchFilterState({
    required this.transactions,
    required this.command,
    required this.hasMorePages,
  });
}

class TransactionSearchListState extends TransactionSearchState {
  @override
  final TransactionListe transactions;
  @override
  final TransactionSearchCommand command;
  @override
  final bool hasMorePages;

  TransactionSearchListState({
    required this.transactions,
    required this.command,
    required this.hasMorePages,
  });
}

class TransactionSearchPaginateState extends TransactionSearchState {
  @override
  final TransactionListe transactions;
  @override
  final TransactionSearchCommand command;
  @override
  final bool hasMorePages;

  TransactionSearchPaginateState({
    required this.transactions,
    required this.command,
    required this.hasMorePages,
  });
}

class TransactionSearchEmptyState extends TransactionSearchState {
  @override
  final TransactionListe transactions;
  @override
  final TransactionSearchCommand command;
  @override
  final bool hasMorePages;

  TransactionSearchEmptyState({
    required this.transactions,
    required this.command,
    this.hasMorePages = false,
  });
}

class TransactionSearchErrorState extends TransactionSearchState {
  final String error;
  final String? stackTrace;

  @override
  final TransactionListe transactions;
  @override
  final TransactionSearchCommand command;
  @override
  final bool hasMorePages;

  TransactionSearchErrorState({
    required this.error,
    this.stackTrace,
    required this.transactions,
    required this.command,
    required this.hasMorePages,
  });
}

/*class TransactionSearchState {
  ///
  TransactionSearchState();

}

abstract class TransactionSearchState {
  TransactionListe get transactions;
  TransactionSearchCommand get command;
  bool get hasMorePages;
}

final class TransactionSearchInitialState extends TransactionSearchState {

  @override
  TransactionListe transactions;

  @override
  final TransactionSearchCommand command;

  @override
  final bool hasMorePages;

  TransactionSearchInitialState({
    required this.transactions,
    required this.command,
    this.hasMorePages = true,
  });

}

class TransactionSearchFilterState extends TransactionSearchState {
  @override
  TransactionListe transactions;

  @override
  final TransactionSearchCommand command;

  @override
  final bool hasMorePages;

  TransactionSearchFilterState(this.transactions, this.command, true);
}

/*final class TransactionSearchLoadingState extends TransactionSearchState {
  TransactionSearchLoadingState();
}*/

class TransactionSearchPaginateState extends TransactionSearchState {
  final TransactionListe transactions;
  @override
  final TransactionSearchCommand command;

  TransactionSearchPaginateState(this.transactions, this.command);
}

class TransactionSearchLoadingState extends TransactionSearchState {
  @override
  final TransactionListe? currentTransactions;
  @override
  final TransactionSearchCommand command;

  @override
  final bool hasMorePages;

  TransactionSearchLoadingState({
    required this.command,
    this.currentTransactions,
    this.hasMorePages = true,
  });
}

final class TransactionSearchListState extends TransactionSearchState {

  TransactionListe transactions;
  TransactionSearchCommand command;

  final bool hasMorePages;

  TransactionSearchListState({
    required this.transactions,
    required this.command,
    this.hasMorePages = true,
  });
}


class TransactionSearchEmptyState extends TransactionSearchState {
  final TransactionSearchCommand command;

  TransactionSearchEmptyState(this.command);
}

class TransactionSearchErrorState extends TransactionSearchState {
  final String error;
  final String? stackTrace;
  final TransactionSearchCommand command;

  TransactionSearchErrorState({
    required this.error,
    this.stackTrace,
    required this.command,
  });
}*/
