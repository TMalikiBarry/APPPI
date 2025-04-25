class TransactionRecentsEvent {
  final String compte;
  const TransactionRecentsEvent(this.compte);
}

class TransactionRecentsListEvent extends TransactionRecentsEvent {
  const TransactionRecentsListEvent(super.compte);
}
