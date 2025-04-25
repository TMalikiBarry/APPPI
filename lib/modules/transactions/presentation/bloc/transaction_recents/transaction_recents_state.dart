import '../../../domain/models/transaction_liste.dart';

class TransactionRecentsState {
  //
  final TransactionListe transactions;
  const TransactionRecentsState(this.transactions);
}

final class TransactionRecentsInitialState extends TransactionRecentsState {
  TransactionRecentsInitialState(super.transactions);
}

final class TransactionRecentsLoadingState extends TransactionRecentsState {
  TransactionRecentsLoadingState(super.transactions);
}

final class TransactionRecentsListState extends TransactionRecentsState {
  TransactionRecentsListState(super.transactions);
}
