import '../../../domain/models/transaction_search/transaction_search_command.dart';

class TransactionSearchEvent {
  ///
  TransactionSearchEvent({
    required this.command,
  });

  TransactionSearchCommand command;
}

/// Lister les transactions à l'ouverture de la page
class TransactionSearchListEvent extends TransactionSearchEvent {
  TransactionSearchListEvent({
    required super.command,
  });
}

/// Affichage de la page suivante , précédente des transactions
class TransactionSearchPaginateEvent extends TransactionSearchEvent {
  TransactionSearchPaginateEvent({required super.command});

  /// Index où on s'est arrete
  // final int index;
}

/// Filtrer les transactions en fonction des paramètres de recherche
class TransactionSearchFilterEvent extends TransactionSearchEvent {
  TransactionSearchFilterEvent({
    required super.command,
  });
}
