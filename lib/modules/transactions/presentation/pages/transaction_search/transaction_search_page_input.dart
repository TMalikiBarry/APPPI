import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../domain/models/transaction_search/transaction_search_command.dart';
import '../../bloc/transaction_search/transaction_search_bloc.dart';
import '../../bloc/transaction_search/transaction_search_event.dart';

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
                  TransactionSearchCommand command =
                      transactionSearchBloc.state.command;
                  // nouveau mot cle
                  command.keyWord = value;
                  // rechercher
                  transactionSearchBloc.add(TransactionSearchFilterEvent(
                    command: command,
                  ));
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
}
