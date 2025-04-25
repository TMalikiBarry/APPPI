import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../categorie/domain/models/categorie.dart';
import '../../../../categorie/presentation/bloc/categorie_bloc.dart';
import '../../../../categorie/presentation/bloc/categorie_event.dart';
import '../../../../transactions/presentation/pages/transaction_details/transaction_details_page_detail.dart';
import '../../../domain/models/subscription.dart';
import '../../bloc/subscription_details/subscription_details_bloc.dart';
import '../../bloc/subscription_details/subscription_details_event.dart';

class SubscriptionDetailsPageCategorie extends StatelessWidget {
  final SubscriptionDetailsBloc detailsBloc;
  final AppLocalizations traductions;
  final Subscription subscription;

  const SubscriptionDetailsPageCategorie({
    super.key,
    required this.traductions,
    required this.subscription,
    required this.detailsBloc,
  });

  @override
  Widget build(BuildContext context) {
    //
    final categorieBloc = context.read<CategorieBloc>();

    List<Categorie> categories = [
      ...Categorie.defaultListe,
      ...categorieBloc.state.categories,
    ];
    // Determiner la categorie
    Categorie categorie = subscription.categorie != null
        ? categories
            .where((element) => element.id == subscription.categorie)
            .first
        : Categorie.defaultCategorie;

    return TransactionDetailsPageDetail(
      label: traductions.transactionDetailsCategorie,
      actionIcon: categorie.icon.startsWith("assets")
          ? Image.asset(
              categorie.icon,
              width: 24,
              color: Theme.of(context).primaryColorDark,
            )
          : Text(
              categorie.icon,
              style: const TextStyle(fontSize: 20),
            ),
      actionText: categorie.label,
      actionFunction: () async {
        categorieBloc.add(CategorieListEvent());
        Categorie? selectedCategorie = await AppRouter.push(
          context,
          AppRouter.categoriesSelect,
        );
        //
        if (selectedCategorie != null) {
          // save this new categorie
          detailsBloc.add(
            SubscriptionDetailsCategorieUpdateEvent(
              subscription,
              selectedCategorie,
            ),
          );
        }
      },
    );
  }
}
