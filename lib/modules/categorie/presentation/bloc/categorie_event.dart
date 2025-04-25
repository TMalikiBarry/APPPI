import '../../domain/models/categorie.dart';
import '../../domain/models/categorie_create_command.dart';
import '../../domain/models/categorie_update_command.dart';

class CategorieEvent {
  const CategorieEvent();
}

class CategorieListEvent extends CategorieEvent {}

class CategorieListUpdatedEvent extends CategorieEvent {
  final List<Categorie> categories;
  CategorieListUpdatedEvent(this.categories);
}

/// Demande d'ajout d'une catégorie
class CategorieAddEvent extends CategorieEvent {
  CategorieAddEvent();
}

/// Demande de validation d'une catégorie
class CategorieAddValidationEvent extends CategorieEvent {
  final CategorieCreateCommand command;
  CategorieAddValidationEvent(this.command);
}

/// Demande d'enregistrement d'une catégorie créée
class CategorieCreateEvent extends CategorieEvent {
  final CategorieCreateCommand command;
  const CategorieCreateEvent(this.command);
}

/// Demande d'edition d'une catégorie
class CategorieEditEvent extends CategorieEvent {
  final Categorie categorie;
  const CategorieEditEvent(this.categorie);
}

/// Demande de validation d'une catégorie
class CategorieEditValidationEvent extends CategorieEvent {
  final CategorieUpdateCommand command;
  final Categorie categorie;
  CategorieEditValidationEvent(this.command, this.categorie);
}

/// Demande d'enregistrement d'une catégorie créée
class CategorieUpdateEvent extends CategorieEvent {
  final CategorieUpdateCommand command;
  final Categorie categorie;
  const CategorieUpdateEvent(this.command, this.categorie);
}
