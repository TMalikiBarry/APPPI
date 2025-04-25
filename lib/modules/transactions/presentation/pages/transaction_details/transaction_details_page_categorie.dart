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
    // Determiner la categorie
    Categorie categorie = transaction.categorie != null
        ? categories
            .where((element) => element.id == transaction.categorie)
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
}
