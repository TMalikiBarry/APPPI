import 'alias_type.dart';

/// Modele de données pour la création d'un alias
class AliasCreateCommand {
  //
  AliasCreateCommand({
    required this.type,
    required this.compte,
    this.phoneNumber,
  });

  String compte;
  AliasType type;
  AliasCreateCommandPhoneNumber? phoneNumber;

  bool isValid() {
    return (type == AliasType.shid && phoneNumber == null) ||
        (type == AliasType.mbno &&
            phoneNumber != null &&
            phoneNumber!.isValid());
  }

  /// Convertit un objet Alias en JSON
  Map<String, dynamic> toJson() {
    return {
      'clientPhoneNumber': phoneNumber != null && phoneNumber!.value() != null
          ? phoneNumber!.value()
          : null,
      'aliasType': type.code,
      'compte': compte,
    };
  }
}

/// Modelise les regles du numéro de téléphone
class AliasCreateCommandPhoneNumber {
  //
  AliasCreateCommandPhoneNumber(
      {required this.indicatif, required this.phone, error});
  String? indicatif;
  String? phone;
  AliasCreateCommandPhoneNumberError? error;

  /// Format de numéro de téléphone des 8 pays de l'union
  static const pattern =
      r'^(?:\+225\d{10}|\+221(77|76|70)\d{7}|\+223\d{8}|\+226\d{8}|\+229\d{8}|\+228\d{8}|\+227\d{8}|\+245\d{6})$';

  /// Méthode qui retourne le numéro de téléphone entier
  String? value() => "$indicatif${phone!}";

  /// Méthode qui effectue la validation
  bool isValid() {
    // lorsque l'identifiant n'est pas renseigné
    if (phone == null || phone!.isEmpty) {
      error = AliasCreateCommandPhoneNumberError.empty;
    }
    // Si le numéro est valide
    else if (!(RegExp(pattern).hasMatch(value()!))) {
      error = AliasCreateCommandPhoneNumberError.invalid;
    }
    //
    else {
      error = null;
    }
    return error == null;
  }
}

enum AliasCreateCommandPhoneNumberError { empty, invalid }
