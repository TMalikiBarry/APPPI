import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/categorie.dart';
import '../bloc/categorie_bloc.dart';
import 'categorie_liste_widget.dart';

class CategorieSelectWidget extends StatelessWidget {
  ///
  const CategorieSelectWidget({
    super.key,
    required this.onSelectionChanged,
    required this.selectedCategories,
  });

  final Function(Categorie, bool?) onSelectionChanged;
  final List<String> selectedCategories;

  @override
  Widget build(BuildContext context) {
    final categorieBloc = context.read<CategorieBloc>();
    return Column(
      children: [
        // Catégories personnalisées
        CategorieListeWidget(
          liste: categorieBloc.state.categories,
          editable: false,
          defaultSelectedCategories: selectedCategories,
          onSelectionChanged: onSelectionChanged,
        ),
        const SizedBox(height: 20),
        // Catégories par défaut
        CategorieListeWidget(
          liste: Categorie.defaultListe,
          defaultSelectedCategories: selectedCategories,
          onSelectionChanged: onSelectionChanged,
        )
      ],
    );
  }
}
