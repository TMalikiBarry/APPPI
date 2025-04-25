import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router.dart';
import '../../../../core/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/my_page_container.dart';
import '../../domain/models/categorie.dart';
import '../bloc/categorie_bloc.dart';
import '../bloc/categorie_event.dart';
import '../bloc/categorie_state.dart';
import 'categorie_liste_widget.dart';

class CategorieSelectPage extends StatelessWidget {
  ///
  const CategorieSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    //
    return BlocConsumer<CategorieBloc, CategorieState>(
      listenWhen: (previous, current) {
        return previous is CategorieInitialState &&
            (current is CategorieCreationState ||
                current is CategorieEditState);
      },
      listener: (context, state) async {
        if (state is CategorieCreationState) {
          await AppRouter.push(context, AppRouter.categoriesAdd);
        } //
        else if (state is CategorieEditState) {
          await AppRouter.push(context, AppRouter.categoriesEdit);
        }
      },
      builder: (context, state) {
        List<Categorie> categories = state.categories;
        return MyPageContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButton(
                    onPressed: () {
                      context.read<CategorieBloc>().add(CategorieListEvent());
                      AppRouter.pop(context);
                    },
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Catégories personnalisées
                        Text(
                          traductions.categorieCustomTitle,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 14),
                        //
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Add button
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(
                                    traductions.categorieCustomAdd,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  leading: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(14.0)),
                                    ),
                                    child: const Icon(Icons.add),
                                  ),
                                  onTap: () {
                                    context
                                        .read<CategorieBloc>()
                                        .add(CategorieAddEvent());
                                  },
                                ),
                              ),
                              // Custom categories list
                              if (categories.isNotEmpty) ...[
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Divider(color: Themer.neural01Color),
                                ),
                                CategorieListeWidget(
                                  liste: categories,
                                  editable: true,
                                  defaultSelectedCategories: const [],
                                  onSelectionChanged: (categorie, checked) =>
                                      onSelectedCategorie(
                                          context, categorie, checked),
                                ),
                              ]
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Catégories par défaut
                        Text(
                          traductions.categorieDefaultTitle,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 14),
                        //
                        CategorieListeWidget(
                          liste: Categorie.defaultListe,
                          defaultSelectedCategories: const [],
                          onSelectionChanged: (categorie, checked) =>
                              onSelectedCategorie(context, categorie, checked),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Lorsqu'une catégorie est selectionnée, retourner
  void onSelectedCategorie(
    BuildContext context,
    Categorie categorie,
    bool? checked,
  ) {
    if (checked != null && checked) {
      AppRouter.pop(
        context,
        value: categorie,
      );
    }
  }
}
