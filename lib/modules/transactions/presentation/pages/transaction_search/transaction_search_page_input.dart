import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../domain/models/transaction_search/transaction_search_command.dart';
import '../../bloc/transaction_search/transaction_search_bloc.dart';
import '../../bloc/transaction_search/transaction_search_event.dart';
import '../../bloc/transaction_search/transaction_search_state.dart';

class TransactionSearchPageInput extends StatelessWidget {
  //
  const TransactionSearchPageInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    // BLOC
    final transactionSearchBloc = context.read<TransactionSearchBloc>();

    //
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Champ de recherche
        Expanded(
          child: Card(
            child: SizedBox(
              height: 40,
              child: TextField(
                keyboardType: TextInputType.text,
                style: Theme.of(context).textTheme.displayLarge,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.search, color: Themer.neural03Color),
                  filled: true,
                  border: InputBorder.none,
                  hintText: traductions.transactionSearchInputSearchHint,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .displayLarge! //
                      .copyWith(color: Themer.neural03Color),
                ),
                onChanged: (value) {

                  /*TransactionSearchCommand command =
                      transactionSearchBloc.state.command;
                  // nouveau mot cle
                  command.keyWord = value;
                  // rechercher
                  transactionSearchBloc.add(TransactionSearchFilterEvent(
                    command: command,
                  ));*/

                  // Méthode sécurisée pour obtenir la commande
                  final command = _getCurrentCommand(transactionSearchBloc.state);

                  if (command != null) {
                    // Créer une nouvelle commande plutôt que de muter l'existante
                    final newCommand = command.copyWith(keyWord: value);

                    transactionSearchBloc.add(TransactionSearchFilterEvent(
                      command: newCommand,
                    ));
                  }
                },
              ),
            ),
          ),
        ),

        //
        const SizedBox(width: 12),

        // Option de filtrage
        FloatingActionButton.small(
          onPressed: () async {
            TransactionSearchCommand? filters = await AppRouter.push(
              context,
              AppRouter.transactionSearchFilters,
              params: transactionSearchBloc,
            );
            //
            if (filters != null) {
              transactionSearchBloc.add(
                TransactionSearchFilterEvent(command: filters),
              );
            }
          },
          elevation: 0,
          heroTag: 'filter',
          child: const Icon(
            Icons.filter_list_outlined,
            color: Themer.whiteColor,
            size: 22,
          ),
        ),
      ],
    );
  }

  TransactionSearchCommand? _getCurrentCommand(TransactionSearchState state) {
    if (state is TransactionSearchInitialState) return state.command;
    if (state is TransactionSearchListState) return state.command;
    if (state is TransactionSearchPaginateState) return state.command;
    if (state is TransactionSearchFilterState) return state.command;
    if (state is TransactionSearchEmptyState) return state.command;
    if (state is TransactionSearchErrorState) return state.command;
    return null;
  }
}
