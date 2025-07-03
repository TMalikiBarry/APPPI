import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/amount_widget.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_search/transaction_search_command.dart';
import '../../bloc/transaction_search/transaction_search_bloc.dart';
import '../../bloc/transaction_search/transaction_search_event.dart';
import '../../bloc/transaction_search/transaction_search_state.dart';
import '../transaction_list_item_widget.dart';


class TransactionSearchPageListe extends StatefulWidget {
  const TransactionSearchPageListe({
    super.key,
    this.select,
    this.selectedItems,
  });

  final Function? select;
  final List<Transaction>? selectedItems;

  @override
  State<TransactionSearchPageListe> createState() =>
      _TransactionSearchPageListeState();
}

class _TransactionSearchPageListeState
    extends State<TransactionSearchPageListe> {
  late ScrollController scrollController;
  final double scrollThreshold = 100.0; // Seuil de déclenchement

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_shouldLoadNextPage()) {
      final bloc = context.read<TransactionSearchBloc>();
      final state = bloc.state;
      final nextPage = state.command.index + 1;
      final newCommand = state.command.copyWith(index: nextPage);

      bloc.add(TransactionSearchPaginateEvent(command: newCommand));
    }
  }

  bool _shouldLoadNextPage() {
    if (!scrollController.hasClients) return false;

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    final isNearBottom = (maxScroll - currentScroll) <= scrollThreshold;

    final bloc = context.read<TransactionSearchBloc>();
    final state = bloc.state;

    return isNearBottom &&
        state.hasMorePages &&
        state is! TransactionSearchLoadingState;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trad = AppLocalizations.of(context)!;

    return BlocConsumer<TransactionSearchBloc, TransactionSearchState>(
      listener: (context, state) {
        // Logique de mise à jour si nécessaire
      },
      builder: (context, state) {
        // Gestion de l'état de chargement initial
        if (state is TransactionSearchLoadingState && state.transactions.data.isEmpty) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // Gestion de l'état vide
        if (state is TransactionSearchEmptyState) {
          return _buildEmptyState(trad);
        }

        // Gestion des erreurs
        if (state is TransactionSearchErrorState) {
          return _buildErrorState(state, trad);
        }

        // Extraire les transactions de l'état
        final transactions = state.transactions.data;

        // Si aucune transaction après chargement
        if (transactions.isEmpty) {
          return _buildEmptyState(trad);
        }

        return _buildTransactionList(state);
      },
    );
  }

  Widget _buildTransactionList(TransactionSearchState state) {
    final transactions = state.transactions.data;
    final transactionsGroupList = groupTransactions(transactions);

    return ListView.builder(
      controller: scrollController,
      itemCount: transactionsGroupList.length + (state.hasMorePages ? 1 : 0),
      itemBuilder: (context, index) {
        // Si c'est le dernier élément et qu'il reste des pages
        if (index >= transactionsGroupList.length) {
          return _buildLoaderFooter(state);
        }

        return _buildTransactionGroupSection(
          context,
          transactionsGroupList[index],
        );
      },
    );
  }

  Widget _buildLoaderFooter(TransactionSearchState state) {
    if (state is TransactionSearchLoadingState) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (state.hasMorePages) {
      return TextButton(
        onPressed: () {
          final nextPage = state.command.index + 1;
          final newCommand = state.command.copyWith(index: nextPage);
          context.read<TransactionSearchBloc>().add(
            TransactionSearchPaginateEvent(command: newCommand),
          );
        },
        child: Text(AppLocalizations.of(context)!.loadMore),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildEmptyState(AppLocalizations trad) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 48, color: Themer.neural03Color),
            const SizedBox(height: 16),
            Text(
              trad.transactionSearchEmptyTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              trad.transactionSearchEmptySubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(TransactionSearchErrorState state, AppLocalizations trad) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                context.read<TransactionSearchBloc>().add(
                  TransactionSearchListEvent(command: state.command),
                );
              },
              icon: const Icon(Icons.refresh),
              label: Text(trad.retry),
            ),
          ],
        ),
      ),
    );
  }

  // Regrouper les transactions par jour
  Widget _buildTransactionGroupSection(
      BuildContext context,
      TransactionGroup transactionGroup,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Jours
            Text(
              DateFormat('d MMMM').format(DateTime.parse(transactionGroup.jour)),
              style: Theme.of(context).textTheme.displayLarge!
                  .copyWith(color: Themer.neural03Color),
            ),
            // Montant total
            AmountWidget(
              montant: transactionGroup.bilanOperation.toDouble(),
              style: Theme.of(context).textTheme.displayLarge!
                  .copyWith(color: Themer.neural03Color),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Liste de transaction par jour
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactionGroup.transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactionGroup.transactions[index];
                final isSelected = widget.selectedItems
                    ?.any((t) => t.endToEndId == transaction.endToEndId) ?? false;

                return TransactionListItemWidget(
                  transaction: transaction,
                  onSelect: widget.select != null
                      ? (bool? value) => widget.select!(transaction, value)
                      : null,
                  isSelected: isSelected,
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}

// Ce model represente une sous groupe de transaction
class TransactionGroup {
  TransactionGroup({
    // Jour
    required this.jour,
    // Bilan des opétations
    required this.bilanOperation,
    // Liste des transactions
    required this.transactions,
  });

  final String jour;
  final int bilanOperation;
  final List<Transaction> transactions;
}

// Fonction utilitaire pour grouper les transactions par jour
List<TransactionGroup> groupTransactions(List<Transaction> transactions) {
  final grouped = <String, List<Transaction>>{};

  for (final transaction in transactions) {
    if (transaction.dateOperation == null) continue;

    final day = transaction.dateOperation!.toIso8601String().split('T')[0];
    grouped.putIfAbsent(day, () => []).add(transaction);
  }

  return grouped.entries.map((entry) {
    final total = entry.value.fold<int>(0, (sum, t) => sum + t.montant.toInt());

    return TransactionGroup(
      jour: entry.key,
      bilanOperation: total,
      transactions: entry.value,
    );
  }).toList();
}
/*
class TransactionSearchPageListe extends StatefulWidget {
  ///
  const TransactionSearchPageListe({
    super.key,
    this.select,
    this.selectedItems,
  });

  final Function? select;
  final List<Transaction>? selectedItems;

  @override
  State<TransactionSearchPageListe> createState() =>
      _TransactionSearchPageListeState();
}

class _TransactionSearchPageListeState
    extends State<TransactionSearchPageListe> {
  late ScrollController scrollController;
  late int currentPage;
  TransactionSearchCommand? currentCommand;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    currentPage = 0;

    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (currentCommand != null) {
        // Créez une nouvelle commande avec l'index mis à jour
        final newCommand = currentCommand!.copyWith(index: currentPage + 1);

        // Envoyez l'événement avec la nouvelle commande
        context.read<TransactionSearchBloc>().add(
          TransactionSearchPaginateEvent(command: newCommand),
        );

        // Mettez à jour la page courante
        currentPage++;
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trad = AppLocalizations.of(context)!;

    return BlocConsumer<TransactionSearchBloc, TransactionSearchState>(
      listener: (context, state) {
        if (state is TransactionSearchListState ||
            state is TransactionSearchPaginateState) {
          // Utiliser un cast explicite
          final commandState = state as dynamic;
          currentCommand = commandState.command;
          currentPage = commandState.command.index;
        }
      },
      builder: (context, state) {
        // Gestion de l'état de chargement
        if (state is TransactionSearchLoadingState) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // Gestion des états avec données
        if (state is TransactionSearchListState ||
            state is TransactionSearchPaginateState) {

          final commandState = state as dynamic;
          final transactions = commandState.transactions.data;
          currentCommand = commandState.command;

          if (transactions.isEmpty) {
            return _buildEmptyState(trad);
          }

          return _buildTransactionList(transactions, commandState.command);
        }

        // Gestion de l'état vide
        if (state is TransactionSearchEmptyState) {
          return _buildEmptyState(trad);
        }

        // Gestion des erreurs
        if (state is TransactionSearchErrorState) {
          return _buildErrorState(state, trad);
        }

        // État initial - afficher un chargement
        return const Expanded(
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildTransactionList(
      List<Transaction> transactions,
      TransactionSearchCommand command,
      ) {
    // Grouper les transactions par jour
    final transactionsGroupList = groupTransactions(transactions);

    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: transactionsGroupList.length,
        itemBuilder: (context, index) {
          return _buildTransactionGroupSection(
            context,
            transactionsGroupList[index],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations trad) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 48, color: Themer.neural03Color),
            const SizedBox(height: 16),
            Text(
              trad.transactionSearchEmptyTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              trad.transactionSearchEmptySubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(TransactionSearchErrorState state, AppLocalizations trad) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                context.read<TransactionSearchBloc>().add(
                  TransactionSearchListEvent(command: state.command),
                );
              },
              icon: const Icon(Icons.refresh),
              label: Text(trad.retry),
            ),
          ],
        ),
      ),
    );
  }

  // Regrouper les transactions par jour
  Widget _buildTransactionGroupSection(
      BuildContext context,
      TransactionGroup transactionGroup,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Jours
            Text(
              DateFormat('d MMMM').format(DateTime.parse(transactionGroup.jour)),
              style: Theme.of(context).textTheme.displayLarge!
                  .copyWith(color: Themer.neural03Color),
            ),
            // Montant total
            AmountWidget(
              montant: transactionGroup.bilanOperation.toDouble(),
              style: Theme.of(context).textTheme.displayLarge!
                  .copyWith(color: Themer.neural03Color),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Liste de transaction par jour
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactionGroup.transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactionGroup.transactions[index];
                final isSelected = widget.selectedItems
                    ?.any((t) => t.endToEndId == transaction.endToEndId) ?? false;

                return TransactionListItemWidget(
                  transaction: transaction,
                  onSelect: widget.select != null
                      ? (bool? value) => widget.select!(transaction, value)
                      : null,
                  isSelected: isSelected,
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}

// Ce model represente une sous groupe de transaction
class TransactionGroup {
  TransactionGroup({
    // Jour
    required this.jour,
    // Bilan des opétations
    required this.bilanOperation,
    // Liste des transactions
    required this.transactions,
  });

  final String jour;
  final int bilanOperation;
  final List<Transaction> transactions;
}

// Fonction utilitaire pour grouper les transactions par jour
List<TransactionGroup> groupTransactions(List<Transaction> transactions) {
  final grouped = <String, List<Transaction>>{};

  for (final transaction in transactions) {
    if (transaction.dateOperation == null) continue;

    final day = transaction.dateOperation!.toIso8601String().split('T')[0];
    grouped.putIfAbsent(day, () => []).add(transaction);
  }

  return grouped.entries.map((entry) {
    final total = entry.value.fold<int>(0, (sum, t) => sum + t.montant.toInt());

    return TransactionGroup(
      jour: entry.key,
      bilanOperation: total,
      transactions: entry.value,
    );
  }).toList();
}*/


  /*late int index;
  late TransactionSearchCommand filters;

  @override
  void initState() {
    super.initState();
    // Pour la pagination
    scrollController = ScrollController();
    index = 0;
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        index++;
        filters.index = index;
        context
            .read<TransactionSearchBloc>()
            .add(TransactionSearchPaginateEvent(index, command: filters));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    return BlocBuilder<TransactionSearchBloc, TransactionSearchState>(
      builder: (context, state) {
        List<Transaction> transactions = state.transactions.data;
        filters = state.command;

        // Liste groupé par jour
        if (state is TransactionSearchListState) {
          if (state.transactions.data.isNotEmpty) {
            List<TransactionGroup> transactionsGroupList =
                groupTransactions(transactions);
            return Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: transactionsGroupList.length,
                itemBuilder: (context, index) {
                  final transactionsGroup = transactionsGroupList[index];
                  return _buildTransactionGroupSection(
                    context,
                    transactionsGroup,
                  );
                },
              ),
            );
          }
          // Empty
          else {
            return Expanded(
              child: Container(),
            );
          }
        } //
        else {
          return const TransactionListLoadingWidget();
        }
      },
    );
  }

  // Regrouper les transactions par jour
  Widget _buildTransactionGroupSection(
    BuildContext context,
    TransactionGroup transactionGroup,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Jours
            Text(
              DateFormat('d MMMM')
                  .format(DateTime.parse(transactionGroup.jour)),
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Themer.neural03Color),
            ),
            // Montant total
            AmountWidget(
              montant: transactionGroup.bilanOperation.toDouble(),
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Themer.neural03Color),
            ),
          ],
        ),

        //
        const SizedBox(height: 8),

        // Liste de transaction par jour
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactionGroup.transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactionGroup.transactions[index];
                final isSelected = widget.selectedItems
                        ?.any((t) => t.endToEndId == transaction.endToEndId) ??
                    false;

                return TransactionListItemWidget(
                  transaction: transaction,
                  onSelect: widget.select != null
                      ? (bool? value) => {
                            widget.select!(transaction, value),
                          }
                      : null,
                  isSelected: isSelected,
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}

// Ce model represente une sous groupe de transaction
class TransactionGroup {
  TransactionGroup({
    // Jour
    required this.jour,
    // Bilan des opétations
    required this.bilanOperation,
    // Liste des transactions
    required this.transactions,
  });

  final String jour;
  final int bilanOperation;
  final List<Transaction> transactions;
}

// Cette  fonction convertie une liste de transaction
// en liste en liste de sous groupe de transaction
// Les transactions sont donc regroupées  poar jour
// avec le bilan (somme de credits - somme des débits)
List<TransactionGroup> groupTransactions(List<Transaction> transactions) {
  Map<String, List<Transaction>> groupedTransactions = {};

  // Regrouper les transaction par jour
  for (var transaction in transactions) {
    String jour = transaction.dateOperation!.toIso8601String().split('T')[0];
    groupedTransactions[jour] = groupedTransactions[jour] ?? [];
    groupedTransactions[jour]!.add(transaction);
  }

  // Regrouper les transaction par jour avec le bilan des operation
  List<TransactionGroup> result = [];
  for (var entry in groupedTransactions.entries) {
    int bilanOperation = 0;
    for (var transaction in entry.value) {
      bilanOperation += transaction.montant.toInt();
    }
    result.add(TransactionGroup(
      jour: entry.key,
      bilanOperation: bilanOperation,
      transactions: entry.value,
    ));
  }
  return result;
}*/
