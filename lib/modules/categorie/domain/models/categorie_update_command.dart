import 'categorie.dart';

/// Modele de données pour la modification d'une categorie
class CategorieUpdateCommand {
  //
  CategorieUpdateCommand({
    required this.id,
    this.label,
    this.icon,
    this.color,
  });

  String id;
  String? label;
  String? icon;
  CategorieIconType? iconType;
  int? color;
  CategorieUpdateCommandError? error;

  /// Méthode qui effectue la validation
  bool isValid() {
    // lorsque c'est trop long
    if (label == null) {
      error = CategorieUpdateCommandError.empty;
    }
    // lorsque c'est trop long
    else if (label != null && label!.length > 25) {
      error = CategorieUpdateCommandError.invalid;
    }
    //
    else if (label != null) {
      error = null;
    }
    return error == null;
  }
}

enum CategorieUpdateCommandError { empty, invalid }
