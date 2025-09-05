import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di.dart';
import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/notification_dialog.dart';
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
            return Column(

              children: [
                // Titre et bouton paramètres
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      traductions.homeTransactions,
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(color: Themer.primaryColor, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => showModalBottomSheet<int?>(
                        context: context,
                        builder: (_) => const TransactionRecentsNombreWidget(),
                        isScrollControlled: true,
                      ),
                      icon: const Icon(Icons.more_horiz),
                    ),
                  ],
                ),

                // Contenu principal
                _buildContent(context, state, traductions),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TransactionRecentsState state, AppLocalizations trad) {
    if (state is TransactionRecentsLoadingState) {
      return const TransactionListLoadingWidget();
    }

    if (state is TransactionRecentsListState) {
      return _buildTransactionList(state.transactions.data, trad);
    }

    if (state is TransactionRecentsEmptyState) {
      return _buildEmptyState(trad);
    }

    if (state is TransactionRecentsErrorState) {
      return _buildErrorState(state, trad);
    }

    return const TransactionListLoadingWidget();
  }

  Widget _buildTransactionList(List<Transaction> transactions, AppLocalizations trad) {
    return Column(
      children: [
        ...transactions.map((transaction) => TransactionListItemWidget(
          transaction: transaction,
          detailsBackRoute: AppRouter.home,
        )),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => AppRouter.push(context, AppRouter.transactionSearch),
          child: Text(trad.transactionsSeeAll),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppLocalizations trad) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.receipt_long, size: 48, color: Themer.neural03Color),
          const SizedBox(height: 16),
          Text(
            trad.transactionsNoRecent,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            trad.transactionsNoRecentSubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Themer.neural03Color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(TransactionRecentsErrorState state, AppLocalizations trad) {
    return NotificationDialog(
      type: NotificationType.error,
      message: trad.transactionsErrorLoading, // ou state.error
      //description: trad.serverErrorSubtitle, // optionnel
      description: "Problème lors de la récupération des transactions récentes",
      btnText: trad.retry,
      btnColor: Themer.error,
      btnAction: () {
        Navigator.of(context).pop();  // ferme le dialog
        transactionsBloc.add(TransactionRecentsListEvent(compte)); // retry
      },
    );
    /*return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            trad.transactionsErrorLoading,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            state.error,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => transactionsBloc.add(TransactionRecentsListEvent(compte)),
            icon: const Icon(Icons.refresh),
            label: Text(trad.retry),
          ),
        ],
      ),
    );*/
  }

}
