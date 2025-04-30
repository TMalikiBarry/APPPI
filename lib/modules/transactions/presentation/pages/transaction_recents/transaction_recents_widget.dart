import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di.dart';
import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../../alias/presentation/bloc/alias_state.dart';
import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../../config/adapters/ui/bloc/config_state.dart';
import '../../../../config/domain/models/config_keys.dart';
import '../../../domain/models/transaction.dart';
import '../../bloc/transaction_recents/transaction_recents_bloc.dart';
import '../../bloc/transaction_recents/transaction_recents_event.dart';
import '../../bloc/transaction_recents/transaction_recents_state.dart';
import '../transaction_list_item_widget.dart';
import '../transaction_list_loading_widget.dart';
import 'transaction_recents_nombre_widget.dart';

class TransactionRecentsWidget extends StatefulWidget {
  ///
  const TransactionRecentsWidget({super.key});
  @override
  State<TransactionRecentsWidget> createState() =>
      _TransactionRecentsWidgetState();
}

class _TransactionRecentsWidgetState extends State<TransactionRecentsWidget> {
  late TransactionRecentsBloc transactionsBloc;
  late String compte;

  @override
  void initState() {
    super.initState();
    // Compte numéro
    compte = (context.read<AliasBloc>().state as AliasExistState).alias.compte;
    // Recents transactions bloc
    transactionsBloc = TransactionRecentsBloc(
      context.read<ConfigBloc>(),
      Di.getTransactionInputPort(),
    )..add(TransactionRecentsListEvent(compte));
  }

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return BlocProvider<TransactionRecentsBloc>(
      create: (_) => transactionsBloc,
      child: BlocListener<ConfigBloc, ConfigState>(
        listenWhen: (previous, current) =>
            current is ConfigLoadedState &&
            current.updatedKey == ConfigKey.transactionsRecentNbItems,
        listener: (context, state) {
          transactionsBloc.add(TransactionRecentsListEvent(compte));
        },
        child: BlocBuilder<TransactionRecentsBloc, TransactionRecentsState>(
          bloc: transactionsBloc,
          builder: (context, state) {

            if(state is TransactionRecentsLoadingState) {
              // return Container();
              return const TransactionListLoadingWidget();
            }
            // Liste des transactions récupérée
            if (state is TransactionRecentsListState) {
              List<Transaction> transactions = state.transactions.data;
              // Si la liste est vide, n'affiche rien
              if (transactions.isEmpty) {
                return Container();
              } else {
                return Column(
                  children: [
                    // En tête : titre et icon button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Titre
                        Text(
                          traductions.homeTransactions,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(color: Themer.neural04Color),
                        ),
                        // Parametrer nombre d'éléments à afficher
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => showModalBottomSheet<int?>(
                            context: context,
                            builder: (BuildContext context) {
                              return const TransactionRecentsNombreWidget();
                            },
                            isScrollControlled: true,
                          ),
                          icon: const Icon(Icons.more_horiz),
                        ),
                      ],
                    ),
                    // Liste
                    Column(
                      children: [
                        for (var transaction in transactions)
                          TransactionListItemWidget(
                            transaction: transaction,
                            detailsBackRoute: AppRouter.home,
                          ),
                      ],
                    ),
                    // Tout afficher Btn s'il reste d'autres éléments à afficher
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        AppRouter.push(context, AppRouter.transactionSearch);
                      },
                      child: Text(traductions.transactionsSeeAll),
                    ),
                  ],
                );
              }
            }
            // TransactionRecentsInitial => Liste pas encore chargée
            else {
              return const TransactionListLoadingWidget();
            }
          },
        ),
      ),
    );
  }
}
