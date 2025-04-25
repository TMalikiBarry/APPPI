import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

import '../../../../../core/di.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../alias/domain/models/alias.dart';
import '../../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../../alias/presentation/bloc/alias_state.dart';
import '../../../domain/models/transaction_search/transaction_search_command.dart';
import '../../../domain/models/transaction_search/transaction_search_filter.dart';
import '../../bloc/transaction_search/transaction_search_bloc.dart';
import '../../bloc/transaction_search/transaction_search_event.dart';
import 'transaction_search_page_input.dart';
import 'transaction_search_page_liste.dart';

class TransactionSearchPage extends StatelessWidget {
  ///
  const TransactionSearchPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;

    // Compte - Alias
    Alias alias = (context.read<AliasBloc>().state as AliasExistState).alias;

    // Bloc de recherche des transactions
    TransactionSearchBloc transactionsBloc = TransactionSearchBloc(
      Di.getTransactionInputPort(),
    )..add(TransactionSearchListEvent(
        command: TransactionSearchCommand(
          compte: alias.compte,
          filters: TransactionSearchFilter(categories: []),
        ),
      ));

    return Scaffold(
      // Pour avoir le bouton de retour
      appBar: AppBar(),
      //
      body: BlocProvider<TransactionSearchBloc>(
        create: (_) => transactionsBloc,
        child: MyPageContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                traductions.transactionSearchTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),

              //
              const SizedBox(height: 16),

              // barre de filtre: input et button
              const TransactionSearchPageInput(),

              //
              const SizedBox(height: 32),

              // Liste des transactions
              const TransactionSearchPageListe(),
            ],
          ),
        ),
      ),
    );
  }
}
