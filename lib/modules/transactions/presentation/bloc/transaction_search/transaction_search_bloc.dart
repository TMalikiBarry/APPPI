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
    TransactionSearchCommand command = event.command;
    emit(TransactionSearchLoadingState(command: command));

    if (command.canLoadMore()) {
      try {
        /*TransactionListe liste = await _rechercherTransactions(command);
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
      }*/
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
    }
  }

}
