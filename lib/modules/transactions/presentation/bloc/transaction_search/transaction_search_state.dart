import '../../../domain/models/transaction_liste.dart';
import '../../../domain/models/transaction_search/transaction_search_command.dart';

/*class TransactionSearchState {
  ///
  TransactionSearchState();

}*/

abstract class TransactionSearchState {
  TransactionSearchCommand get command;
}

final class TransactionSearchInitialState extends TransactionSearchState {

  TransactionListe transactions;

  @override
  final TransactionSearchCommand command;

  TransactionSearchInitialState({
    required this.transactions,
    required this.command,
  });
}

class TransactionSearchFilterState extends TransactionSearchState {
  final TransactionListe transactions;
  @override
  final TransactionSearchCommand command;

  TransactionSearchFilterState(this.transactions, this.command);
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
  final TransactionListe? currentTransactions;
  @override
  final TransactionSearchCommand command;

  TransactionSearchLoadingState({
    required this.command,
    this.currentTransactions,
  });
}

final class TransactionSearchListState extends TransactionSearchState {

  TransactionListe transactions;
  TransactionSearchCommand command;

  TransactionSearchListState({
    required this.transactions,
    required this.command,
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
}
