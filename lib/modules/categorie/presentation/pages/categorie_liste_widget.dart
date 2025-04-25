import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/models/categorie.dart';
import '../bloc/categorie_bloc.dart';
import '../bloc/categorie_event.dart';

class CategorieListeWidget extends StatefulWidget {
  ///
  const CategorieListeWidget({
    super.key,
    required this.liste,
    required this.defaultSelectedCategories,
    required this.onSelectionChanged,
    this.editable,
  });

  final Function(Categorie, bool?) onSelectionChanged;
  final List<Categorie> liste;
  final List<String> defaultSelectedCategories;
  final bool? editable;

  @override
  CategorieListeWidgetState createState() => CategorieListeWidgetState();
}

class CategorieListeWidgetState extends State<CategorieListeWidget> {
  /// Categories selectionnées
  List<Categorie> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedCategories.addAll(widget.liste
          .where((element) =>
              widget.defaultSelectedCategories.contains(element.id))
          .toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.liste.map<Widget>((categorie) {
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Row(
                children: [
                  // Icon
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(categorie.bgColor!)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: categorie.icon.startsWith("assets")
                          ? Image(
                              image: AssetImage(categorie.icon),
                              width: 30,
                              height: 30,
                            )
                          : Text(
                              categorie.icon,
                              style: const TextStyle(fontSize: 20),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // label
                  Text(
                    " ${categorie.label}",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  // Edit btn
                  if (widget.editable != null && widget.editable!)
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context
                                .read<CategorieBloc>()
                                .add(CategorieEditEvent(categorie));
                          },
                          child: Text(traductions.categorieEditBtn),
                        ),
                      ),
                    ),
                ],
              ),
              value: selectedCategories
                  .where((element) => element.id == categorie.id)
                  .isNotEmpty,
              onChanged: (bool? value) {
                setState(() {
                  // add to selected
                  if (value != null && value) {
                    selectedCategories.add(categorie);
                  } // remove to selected
                  else {
                    selectedCategories
                        .removeWhere((element) => element.id == categorie.id);
                  }
                  widget.onSelectionChanged(categorie, value);
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
