import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../../shared/models/liste_meta.dart';
import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../../config/domain/models/config_keys.dart';
import '../../../domain/models/transaction_liste.dart';
import '../../../ports/input/transaction_input_port.dart';
import 'transaction_recents_event.dart';
import 'transaction_recents_state.dart';

class TransactionRecentsBloc
    extends Bloc<TransactionRecentsEvent, TransactionRecentsState> {
  //
  final logger = Logger();

  final intdefaultSize = 3;

  // Bloc de gestion de la config
  final ConfigBloc configBloc;

  /// Service
  final TransactionInputPort transactionsInputPort;

  TransactionRecentsBloc(this.configBloc, this.transactionsInputPort)
      : super(
          TransactionRecentsInitialState(
            TransactionListe(
              data: [],
              meta: ListeMeta(total: 0, limit: 3),
            ),
          ),
        ) {
    // Pour recuperer la liste
    on<TransactionRecentsListEvent>(_onTransactionRecentsListEvent);
  }

  /// Quand on demande la liste des transactions
  Future<void> _onTransactionRecentsListEvent(
    TransactionRecentsListEvent event,
    Emitter<TransactionRecentsState> emit,
  ) async {
    // Appeler le service pour obtenir la liste
    // Pendant TransactionRecentsInitialState un skeleton devrait être affiché
    // Paramètre Nombre de transactions récentes à afficher
    String? nbItemsParam =
        configBloc.getParamValue(ConfigKey.transactionsRecentNbItems);
    int nbItems = nbItemsParam != null ? int.parse(nbItemsParam) : 3;

    // Récuperer la liste des derniers elements enregistrés
    TransactionListe liste = await transactionsInputPort.list(
      compte: event.compte,
      limit: nbItems,
    );
    emit(TransactionRecentsListState(liste));

    // Cherche des nouvelles transactions à afficher
    TransactionListe recents = await transactionsInputPort.search(
      compte: event.compte,
      limit: nbItems,
    );
    emit(TransactionRecentsListState(recents));
  }
}
