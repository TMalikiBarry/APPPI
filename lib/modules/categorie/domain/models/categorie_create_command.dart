import 'categorie.dart';

/// Modele de données pour la création d'une categorie
class CategorieCreateCommand {
  //
  CategorieCreateCommand({
    required this.liste,
    this.label,
    this.icon,
    this.color,
  });

  List<Categorie> liste;
  String? label;
  String? icon;
  CategorieIconType? iconType;
  int? color;
  CategorieCreateCommandError? error;

  /// Méthode qui effectue la validation
  bool isValid() {
    // lorsque c'est trop long
    if (label == null) {
      error = CategorieCreateCommandError.empty;
    }
    // lorsque c'est trop long
    else if (label != null && label!.length > 25) {
      error = CategorieCreateCommandError.invalid;
    }
    // Si la categorie existe deja
    else if (label != null &&
        liste
            .where((element) =>
                element.label.toLowerCase() == label!.toLowerCase())
            .isNotEmpty) {
      error = CategorieCreateCommandError.alreadyExist;
    }
    //
    else if (label != null) {
      error = null;
    }
    return error == null;
  }
}

enum CategorieCreateCommandError { empty, invalid, alreadyExist }
