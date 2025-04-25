import '../../domain/models/categorie.dart';
import '../../domain/models/categorie_create_command.dart';
import '../../domain/models/categorie_update_command.dart';

abstract class CategorieState {
  const CategorieState(this.categories);
  final List<Categorie> categories;
}

final class CategorieInitialState extends CategorieState {
  CategorieInitialState(super.categories);
}

/// Etat quand on est entrain de créer une categorie
class CategorieCreationState extends CategorieState {
  final CategorieCreateCommand command;
  CategorieCreationState(super.categories, this.command);
}

/// Etat quand on est entrain de modifier une categorie
class CategorieEditState extends CategorieState {
  final Categorie categorie;
  final CategorieUpdateCommand command;
  CategorieEditState(super.categories, this.categorie, this.command);
}
