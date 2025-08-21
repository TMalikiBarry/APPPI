import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';
import 'package:pi_mobile_app/modules/home/presentation/pages/home_bottom_widget.dart';

import '../../../../../core/di.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../../alias/presentation/bloc/alias_state.dart';
import '../../../domain/models/transaction_search/transaction_search_command.dart';
import '../../../domain/models/transaction_search/transaction_search_filter.dart';
import '../../bloc/transaction_search/transaction_search_bloc.dart';
import '../../bloc/transaction_search/transaction_search_event.dart';
import 'transaction_search_page_input.dart';
import 'transaction_search_page_liste.dart';

class TransactionSearchPage extends StatefulWidget {
  ///
  const TransactionSearchPage({
    super.key,
  });

  @override
  State<TransactionSearchPage> createState() => _TransactionSearchPageState();
}

class _TransactionSearchPageState extends State<TransactionSearchPage> {
  @override
  Widget build(BuildContext context) {
    final trad = AppLocalizations.of(context)!;
    int selectedIndex = 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(trad.transactionSearchTitle),
      ),
      body: BlocProvider(
        create: (context) {
          final alias = (context.read<AliasBloc>().state as AliasExistState).alias;
          final bloc = TransactionSearchBloc(
            Di.getTransactionInputPort(),
          )..add(TransactionSearchListEvent(
            command: TransactionSearchCommand(
              compte: alias.compte,
              filters: TransactionSearchFilter(categories: []),
            ),
          ));
          return bloc;
        },
        child: const MyPageContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barre de filtre: input et button
              //TransactionSearchPageInput(),

              SizedBox(height: 32),

              // Liste des transactions
              Expanded(child: TransactionSearchPageListe()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() => selectedIndex = index);
        },
      ),
    );
  }
}
