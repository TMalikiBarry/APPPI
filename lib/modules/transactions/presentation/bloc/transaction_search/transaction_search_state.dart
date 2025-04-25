import '../../../domain/models/transaction_liste.dart';
import '../../../domain/models/transaction_search/transaction_search_command.dart';

class TransactionSearchState {
  ///
  TransactionSearchState({
    required this.transactions,
    required this.command,
  });

  TransactionListe transactions;
  TransactionSearchCommand command;
}

final class TransactionSearchInitialState extends TransactionSearchState {
  TransactionSearchInitialState({
    required super.transactions,
    required super.command,
  });
}

final class TransactionSearchLoadingState extends TransactionSearchState {
  TransactionSearchLoadingState({
    required super.transactions,
    required super.command,
  });
}

final class TransactionSearchListState extends TransactionSearchState {
  TransactionSearchListState({
    required super.transactions,
    required super.command,
  });
}
