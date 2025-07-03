import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../categorie/domain/models/categorie.dart';
import '../../../../categorie/presentation/bloc/categorie_bloc.dart';
import '../../../../categorie/presentation/bloc/categorie_event.dart';
import '../../../domain/models/transaction.dart';
import '../../bloc/transaction_details/transaction_details_bloc.dart';
import '../../bloc/transaction_details/transaction_details_event.dart';
import 'transaction_details_page_detail.dart';

class TransactionDetailsPageCategorie extends StatelessWidget {
  final TransactionDetailsBloc transactionDetailsBloc;
  final AppLocalizations traductions;
  final Transaction transaction;

  const TransactionDetailsPageCategorie({
    super.key,
    required this.traductions,
    required this.transaction,
    required this.transactionDetailsBloc,
  });

  @override
  Widget build(BuildContext context) {
    //
    final categorieBloc = context.read<CategorieBloc>();

    List<Categorie> categories = [
      ...Categorie.defaultListe,
      ...categorieBloc.state.categories,
    ];

    /*Categorie theCategorie = transaction.categorie != null ? categories
        .where((element) => (transaction.categorie!.contains(element.id) ||
        transaction.canal!.contains(element.id)))
        .first : Categorie.defaultCategorie;

    // Determiner la categorie
    Categorie categorie = theCategorie != null
        ? theCategorie
        : Categorie.defaultCategorie;

    categorie = categorie == null ? Categorie.defaultCategorie: categorie;*/

    Categorie categorie = getCategorieForTransaction(transaction, categories);

    return TransactionDetailsPageDetail(
      label: traductions.transactionDetailsCategorie,
      actionIcon: categorie.icon.startsWith("assets")
          ? Image.asset(
              categorie.icon,
              width: 24,
              color: Theme.of(context).primaryColorDark,
              package: 'common_dependencies'
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
          transactionDetailsBloc.add(
            TransactionCategorieUpdateEvent(
              transaction,
              selectedCategorie,
            ),
          );
        }
      },
    );
  }

  Categorie getCategorieForTransaction(
      Transaction transaction,
      List<Categorie> categories
      ) {
    // 1. Chercher par catégorie
    if (transaction.categorie != null) {
      for (final categorie in categories) {
        if (transaction.categorie!.contains(categorie.id)) {
          return categorie;
        }
      }
    }

    // 2. Chercher par canal
    if (transaction.canal != null) {
      for (final categorie in categories) {
        if (transaction.canal!.contains(categorie.id)) {
          return categorie;
        }
      }
    }

    // 3. Retour par défaut
    return Categorie.defaultCategorie;
  }
}
