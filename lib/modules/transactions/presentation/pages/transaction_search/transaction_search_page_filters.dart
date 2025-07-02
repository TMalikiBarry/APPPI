import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

import '../../../../../core/router.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../categorie/domain/models/categorie.dart';
import '../../../../categorie/presentation/pages/categorie_select_widget.dart';
import '../../../domain/models/transaction_search/transaction_search_command.dart';
import '../../bloc/transaction_search/transaction_search_bloc.dart';
import '../../bloc/transaction_search/transaction_search_state.dart';
import 'transaction_search_page_filters_dates.dart';
import 'transaction_search_page_filters_sens.dart';

class TransactionSearchPageFilters extends StatelessWidget {
  ///
  const TransactionSearchPageFilters({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    TransactionSearchBloc transactionSearchBloc =
        context.read<TransactionSearchBloc>();

    //
    return BlocBuilder<TransactionSearchBloc, TransactionSearchState>(
      bloc: transactionSearchBloc,
      builder: (context, state) {
        TransactionSearchCommand command;
        if (state is TransactionSearchInitialState) {
          command = state.command;
        }
        else if (state is TransactionSearchListState) {
          command = state.command;
        }
        else if (state is TransactionSearchPaginateState) {
          command = state.command;
        }
        else if (state is TransactionSearchFilterState) {
          command = state.command;
        }
        else if (state is TransactionSearchEmptyState) {
          command = state.command;
        }
        else if (state is TransactionSearchErrorState) {
          command = state.command;
        }
        else {
          // Fallback pour les états non gérés
          return const Center(child: CircularProgressIndicator());
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height - 48,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: MyPageContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AppBar
                  const SizedBox(height: 10),
                  // Page Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Bouton retour
                      BackButton(onPressed: () => AppRouter.pop(context)),
                      // Bouton pour appliquer les filtres
                      TextButton(
                        onPressed: () {
                          AppRouter.pop(context, value: command);
                        },
                        child: Text(
                          traductions.transactionSearchInputFilterBtnAppliquer,
                        ),
                      ),
                    ],
                  ),

                  //
                  const SizedBox(height: 10),

                  // Titre de la page des filtres
                  Text(
                    traductions.transactionSearchInputFilterTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  //
                  const SizedBox(height: 20),

                  // Options de filtrage
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Plage de dates
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Titre de la section
                              Text(
                                traductions
                                    .transactionSearchInputFilterDateTitle,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              //
                              const SizedBox(height: 14),

                              // Selectionner plage de dates
                              const TransactionSearchPageFiltersDates(),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Catégories
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Titre de la section
                              Text(
                                traductions
                                    .transactionSearchInputFilterCategoriesTitle,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              //
                              const SizedBox(height: 14),

                              // Selon le sens de l'opération
                              const TransactionSearchPageFiltersSens(),
                              const SizedBox(height: 20),
                              // Selon les catégories de transactions
                              CategorieSelectWidget(
                                selectedCategories: command.filters.categories,
                                onSelectionChanged:
                                    (Categorie categorie, bool? checked) {
                                  debugPrint("${categorie.toJson()}");
                                  // add to selected
                                  if (checked != null && checked) {
                                    command.filters.categories
                                        .add(categorie.id);
                                  } // remove to selected
                                  else {
                                    command.filters.categories.removeWhere(
                                        (element) => element == categorie.id);
                                  }
                                },
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
