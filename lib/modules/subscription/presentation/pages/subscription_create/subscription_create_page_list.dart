import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../alias/domain/models/alias.dart';
import '../../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../../alias/presentation/bloc/alias_state.dart';
import '../../../../transactions/domain/models/transaction.dart';
import '../../../../transactions/domain/models/transaction_search/transaction_search_command.dart';
import '../../../../transactions/domain/models/transaction_search/transaction_search_filter.dart';
import '../../../../transactions/presentation/bloc/transaction_search/transaction_search_bloc.dart';
import '../../../../transactions/presentation/bloc/transaction_search/transaction_search_event.dart';
import '../../../../transactions/presentation/pages/transaction_search/transaction_search_page_liste.dart';

class SubscriptionCreatePageList extends StatefulWidget {
  ///
  const SubscriptionCreatePageList({
    super.key,
    required this.selectTransaction,
  });

  final Function selectTransaction;

  ///
  @override
  State<SubscriptionCreatePageList> createState() =>
      _SubscriptionCreatePageListState();
}

class _SubscriptionCreatePageListState
    extends State<SubscriptionCreatePageList> {
  //
  late TransactionSearchBloc searchBloc;
  Transaction? seletedTransaction;

  @override
  void initState() {
    super.initState();
    Alias alias = (context.read<AliasBloc>().state as AliasExistState).alias;
    searchBloc = TransactionSearchBloc(Di.getTransactionInputPort())
      ..add(TransactionSearchListEvent(
        command: TransactionSearchCommand(
          compte: alias.compte,
          filters: TransactionSearchFilter(
            sens: TransactionSens.debit,
            categories: [],
          ),
        ),
      ));
  }

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return BlocProvider<TransactionSearchBloc>(
      create: (_) => searchBloc,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            traductions.subscriptionMenuSubscribeTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),

          // Séparateur
          const SizedBox(height: 8.0),

          // Sous titre de la page
          Text(
            traductions.subscriptionMenuSubscribeSubtitle2,
            style: Theme.of(context).textTheme.displaySmall,
          ),

          //
          const SizedBox(height: 16),

          // Liste des transactions
          TransactionSearchPageListe(
            select: _selectTransaction,
            selectedItems:
                seletedTransaction != null ? [seletedTransaction!] : [],
          ),
        ],
      ),
    );
  }

  _selectTransaction(Transaction transaction, bool value) {
    setState(() {
      seletedTransaction = value ? transaction : null;
      widget.selectTransaction(transaction);
    });
  }
}
