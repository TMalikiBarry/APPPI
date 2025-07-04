import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../../shared/models/liste_meta.dart';
import '../../../domain/models/transaction_liste.dart';
import '../../../domain/models/transaction_search/transaction_search_command.dart';
import '../../../domain/models/transaction_search/transaction_search_filter.dart';
import '../../../ports/input/transaction_input_port.dart';
import 'transaction_search_event.dart';
import 'transaction_search_state.dart';


class TransactionSearchBloc
    extends Bloc<TransactionSearchEvent, TransactionSearchState> {
  final Logger logger = Logger();
  final TransactionInputPort transactionsInputPort;

  TransactionSearchBloc(this.transactionsInputPort)
      : super(TransactionSearchInitialState(
    transactions: TransactionListe(
      data: [],
      meta: ListeMeta(total: 0, limit: TransactionSearchCommand.defaultLimit),
    ),
    command: TransactionSearchCommand(
      filters: TransactionSearchFilter(categories: []),
      limit: TransactionSearchCommand.defaultLimit,
    ),
    hasMorePages: true,
  )) {
    on<TransactionSearchListEvent>(_onTransactionSearchListEvent);
    on<TransactionSearchPaginateEvent>(_onTransactionSearchPaginateEvent);
    on<TransactionSearchFilterEvent>(_onTransactionSearchFilterEvent);
  }

  /// Chargement initial de la liste
  Future<void> _onTransactionSearchListEvent(
      TransactionSearchListEvent event,
      Emitter<TransactionSearchState> emit,
      ) async {
    try {
      // État de chargement initial
      emit(TransactionSearchLoadingState(
        transactions: TransactionListe(
          data: [],
          meta: ListeMeta(total: 0, limit: event.command.limit),
        ),
        command: event.command,
        hasMorePages: true,
      ));

      // Appeler le service
      final liste = await _rechercherTransactions(event.command);
      final hasMore = liste.data.length >= event.command.limit;

      if (liste.data.isEmpty) {
        emit(TransactionSearchEmptyState(
          transactions: liste,
          command: event.command,
          hasMorePages: hasMore,
        ));
      } else {
        emit(TransactionSearchListState(
          transactions: liste,
          command: event.command.copyWith(total: liste.meta.total),
          hasMorePages: hasMore,
        ));
      }
    } catch (e, stackTrace) {
      emit(TransactionSearchErrorState(
        error: e.toString(),
        stackTrace: stackTrace.toString(),
        transactions: state.transactions,
        command: event.command,
        hasMorePages: state.hasMorePages,
      ));
    }
  }

  /// Filtrage des transactions
  Future<void> _onTransactionSearchFilterEvent(
      TransactionSearchFilterEvent event,
      Emitter<TransactionSearchState> emit,
      ) async {
    try {
      // Réinitialiser l'index
      final newCommand = event.command.copyWith(index: 0);

      // État de chargement avec données existantes
      emit(TransactionSearchLoadingState(
        transactions: state.transactions,
        command: newCommand,
        hasMorePages: state.hasMorePages,
      ));

      // Appeler le service
      final liste = await _rechercherTransactions(newCommand);
      final hasMore = liste.data.length >= newCommand.limit;

      emit(TransactionSearchListState(
        transactions: liste,
        command: newCommand.copyWith(total: liste.meta.total),
        hasMorePages: hasMore,
      ));
    } catch (e, stackTrace) {
      emit(TransactionSearchErrorState(
        error: e.toString(),
        stackTrace: stackTrace.toString(),
        transactions: state.transactions,
        command: event.command,
        hasMorePages: state.hasMorePages,
      ));
    }
  }

  /// Pagination
  Future<void> _onTransactionSearchPaginateEvent(
      TransactionSearchPaginateEvent event,
      Emitter<TransactionSearchState> emit,
      ) async {
    try {
      // État de chargement avec données existantes
      emit(TransactionSearchLoadingState(
        transactions: state.transactions,
        command: event.command,
        hasMorePages: state.hasMorePages,
      ));

      // Appeler le service
      final newTransactions = await _rechercherTransactions(event.command);

      // Fusionner les transactions
      final allTransactions = [
        ...state.transactions.data,
        ...newTransactions.data
      ];

      // Calculer s'il reste des pages
      final totalItems = newTransactions.meta.total;
      final loadedItems = allTransactions.length;
      final hasMorePages = loadedItems < totalItems;

      emit(TransactionSearchListState(
        transactions: TransactionListe(
          data: allTransactions,
          meta: ListeMeta(
            total: totalItems,
            limit: newTransactions.meta.limit,
          ),
        ),
        command: event.command.copyWith(total: totalItems),
        hasMorePages: hasMorePages,
      ));
    } catch (e, stackTrace) {
      emit(TransactionSearchErrorState(
        error: e.toString(),
        stackTrace: stackTrace.toString(),
        transactions: state.transactions,
        command: event.command,
        hasMorePages: state.hasMorePages,
      ));
    }
  }

  /// Appeler le service pour filtrer les transactions
  Future<TransactionListe> _rechercherTransactions(
      TransactionSearchCommand searchCommand,
      ) async {
    return await transactionsInputPort.search(
      compte: searchCommand.compte!,
      limit: searchCommand.limit,
      page: searchCommand.index,
      sens: searchCommand.filters.sens?.name,
      categories: searchCommand.filters.categories,
      dateOperationDebut: searchCommand.filters.dateDebut,
      dateOperationFin: searchCommand.filters.dateFin,
      keyword: searchCommand.keyWord,
    );
  }
}
/*class TransactionSearchBloc
    extends Bloc<TransactionSearchEvent, TransactionSearchState> {
  //
  final logger = Logger();

  /// Service
  final TransactionInputPort transactionsInputPort;

  TransactionSearchBloc(this.transactionsInputPort)
      : super(
    TransactionSearchInitialState(
      transactions: TransactionListe(
        data: [],
        meta: ListeMeta(
          total: 0,
          limit: TransactionSearchCommand.defaultLimit,
        ),
      ),
      command: TransactionSearchCommand(
        filters: TransactionSearchFilter(categories: []),
        limit: TransactionSearchCommand.defaultLimit,
      ),
    ),
  ) {
    // Pour recuperer la liste
    on<TransactionSearchListEvent>(_onTransactionSearchListEvent);
    // Pour paginer la liste
    on<TransactionSearchPaginateEvent>(_onTransactionSearchPaginateEvent);
    // Pour Filtrer la liste
    on<TransactionSearchFilterEvent>(_onTransactionSearchFilterEvent);
  }

  /// Quand on demande la liste des transactions
  Future<void> _onTransactionSearchListEvent(TransactionSearchListEvent event,
      Emitter<TransactionSearchState> emit,) async {
    // En cours de rechargement
    TransactionSearchCommand command = event.command;

    emit(TransactionSearchLoadingState(command: command));

    // Appeler le service pour obtenir la liste
    TransactionListe liste = await _rechercherTransactions(command);
    command.total = liste.meta.total;
    command.index = 0;

    emit(TransactionSearchListState(
      transactions: liste,
      command: command,
    ));
  }

  /// Filtrer la liste en fonction des critères
  Future<void> _onTransactionSearchFilterEvent(
      TransactionSearchFilterEvent event,
      Emitter<TransactionSearchState> emit,) async {
    // Réinitialiser l'index
    event.command.index = 0;

    // Filtrer la liste
    TransactionSearchCommand filters = event.command;

    TransactionListe liste = await _rechercherTransactions(filters);
    filters.total = liste.meta.total;

    emit(TransactionSearchListState(
      transactions: liste,
      command: filters,
    ));
  }

  /// Appeler le service pour filtrer les transactions
  Future<TransactionListe> _rechercherTransactions(
      TransactionSearchCommand searchCommand,) async {
    return await transactionsInputPort.search(
      compte: searchCommand.compte!,
      limit: searchCommand.limit,
      page: searchCommand.index,
      sens: searchCommand.filters.sens?.name,
      categories: searchCommand.filters.categories,
      dateOperationDebut: searchCommand.filters.dateDebut,
      dateOperationFin: searchCommand.filters.dateFin,
      keyword: searchCommand.keyWord,
    );
  }

  /// Pagination
  Future<void> _onTransactionSearchPaginateEvent(
      TransactionSearchPaginateEvent event,
      Emitter<TransactionSearchState> emit,) async {
    // Copier l'état actuel
    final currentTransactions = state.transactions.data;

    // Émettre un état de chargement avec les données existantes
    emit(TransactionSearchLoadingState(
      transactions: TransactionListe(
        data: currentTransactions,
        meta: state.transactions.meta,
      ),
      command: event.command,
      hasMorePages: state.hasMorePages,
    ));

    try {
      final newTransactions = await _rechercherTransactions(event.command);
      final allTransactions = [...currentTransactions, ...newTransactions.data];

      // Calculer s'il reste des pages
      final totalItems = newTransactions.meta.total;
      final loadedItems = allTransactions.length;
      final hasMorePages = loadedItems < totalItems;

      emit(TransactionSearchListState(
        transactions: TransactionListe(
          data: allTransactions,
          meta: ListeMeta(
            total: totalItems,
            limit: newTransactions.meta.limit,
          ),
        ),
        command: event.command,
        hasMorePages: hasMorePages,
      ));
    } catch (e, stackTrace) {
      // Réémettre l'état précédent en cas d'erreur
      emit(TransactionSearchListState(
        transactions: state.transactions,
        command: state.command,
        hasMorePages: state.hasMorePages,
      ));
        // 4) Gestion des erreurs
        logger.e(
            "Error searching transactions", error: e, stackTrace: stackTrace);
        emit(TransactionSearchErrorState(
          error: e.toString(),
          stackTrace: stackTrace.toString(),
          command: event.command,
        ));
      }
    }

    /// Pagination
 *//* Future<void> _onTransactionSearchPaginateEvent(
      TransactionSearchPaginateEvent event,
      Emitter<TransactionSearchState> emit,) async {
    TransactionSearchCommand command = event.command;
    emit(TransactionSearchLoadingState(command: command));

    if (command.canLoadMore()) {
      try {
        *//**//*TransactionListe liste = await _rechercherTransactions(command);
        command.total = liste.meta.total;
        List<Transaction> newTransactions = liste.data;
        if (newTransactions.isNotEmpty) {
          // List<Transaction> oldTransactions = state.transactions.data;
          List<Transaction> allTransactions = [
            // ...oldTransactions,
            ...newTransactions,
          ];
          emit(TransactionSearchListState(
            transactions: TransactionListe(
              data: allTransactions,
              meta: liste.meta,
            ),
            command: command,
          ));
        }
      } catch (e) {
        logger.e("Error on pagination", error: e);
      }*//**//*
        // 2) Appel serveur
        final history = await _rechercherTransactions(command);

        // 3) Gestion des résultats
        if (history.data.isEmpty) {
          emit(TransactionSearchEmptyState(event.command));
        } else {
          emit(TransactionSearchListState(
              transactions: history, command: event.command));
        }
      } catch (e, stackTrace) {
        // 4) Gestion des erreurs
        logger.e(
            "Error searching transactions", error: e, stackTrace: stackTrace);
        emit(TransactionSearchErrorState(
          error: e.toString(),
          stackTrace: stackTrace.toString(),
          command: event.command,
        ));
      }

  }*//*

}*/
