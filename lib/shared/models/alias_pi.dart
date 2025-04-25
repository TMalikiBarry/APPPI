/// Modeles et regles de validation du champ alias
class AliasPI {
  //
  static String label = "@PI";
  //
  AliasPI({required this.value, error});
  String? value;
  AliasPIError? error;

  /// Format de numéro de téléphone des 8 pays de l'union
  static const patternMBNO =
      r'^(?:\+225\d{10}|\+221(77|76|70)\d{7}|\+223\d{8}|\+226\d{8}|\+229\d{8}|\+228\d{8}|\+227\d{8}|\+245\d{6})$';

  static const patternSHID =
      r'^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$';

  bool isValid() {
    // lorsque l'identifiant n'est pas renseigné
    if (value == null || value!.isEmpty) {
      error = AliasPIError.empty;
    }
    // L'alias est un numéro de téléphone ou SHID
    else if (!(RegExp(patternMBNO).hasMatch(value!)) &&
        !(RegExp(patternSHID).hasMatch(value!))) {
      error = AliasPIError.invalid;
    }
    // lorsque l'identifiant est valide
    else {
      error = null;
    }
    return error == null;
  }
}

/// Types d'erreurs possibles sur le champ alias
enum AliasPIError {
  //
  empty("AliasPIErrorEmpty"),
  invalid("AliasPIErrorInvalid"),
  notFound("AliasPIErrorNotFound");

  // Codification du paramètre
  final String code;

  const AliasPIError(this.code);
}
