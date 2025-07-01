import '../../../domain/models/transaction_liste.dart';

class TransactionRecentsState {
  //
  const TransactionRecentsState();
}

final class TransactionRecentsInitialState extends TransactionRecentsState {
  final TransactionListe transactions;
  TransactionRecentsInitialState(this.transactions);
}

final class TransactionRecentsLoadingState extends TransactionRecentsState {
  TransactionRecentsLoadingState();
}

final class TransactionRecentsListState extends TransactionRecentsState {
  final TransactionListe transactions;
  TransactionRecentsListState(this.transactions);
}

class TransactionRecentsEmptyState extends TransactionRecentsState {
  const TransactionRecentsEmptyState();
}

// État pour erreur de chargement
class TransactionRecentsErrorState extends TransactionRecentsState {
  final String error;
  final String stackTrace;

  const TransactionRecentsErrorState({
    required this.error,
    required this.stackTrace,
  });
}