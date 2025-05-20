import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme.dart';
import '../../../../../shared/widgets/amount_widget.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_search/transaction_search_command.dart';
import '../../bloc/transaction_search/transaction_search_bloc.dart';
import '../../bloc/transaction_search/transaction_search_event.dart';
import '../../bloc/transaction_search/transaction_search_state.dart';
import '../transaction_list_item_widget.dart';
import '../transaction_list_loading_widget.dart';

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
  late int index;
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
}
