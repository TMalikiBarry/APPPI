/// ChangePassword Input Command
class ChangePasswordCommand {
  //
  ChangePasswordCommand({
    required this.username,
    this.password,
    this.passwordConfirmation,
  });

  String username;
  ChangePasswordCommandPassword? password;
  ChangePasswordCommandPassword? passwordConfirmation;
  ChangePasswordCommandError? error;

  bool isValid() {
    if (password != null &&
        password!.isValid() && //
        passwordConfirmation != null && //
        password!.value == passwordConfirmation!.value) {
      error = null;
      return true;
    }
    // Si les deux mot de passe sont différents
    else if (password != null &&
        passwordConfirmation != null &&
        password!.value != passwordConfirmation!.value) {
      error = ChangePasswordCommandError.passwordDifferent;
    }
    return false;
  }
}

/// Modelise les regles de gestion du nouveau mot de passe
class ChangePasswordCommandPassword {
  //
  ChangePasswordCommandPassword({required this.value});
  String? value;
  ChangePasswordCommandPasswordError? error;

  final RegExp passwordRegex =
      RegExp(r"^(?=.*[A-Za-z0-9])(?=.*[@-])([A-Za-z0-9@-]{8,})$");

  bool isValid() {
    // Ajoutez votre logique de validation du username ici
    // Par exemple, vérifiez la longueur minimale, les caractères autorisés.
    // regex qui sera appliqué au mot de passe pour assurer sa complexité
    // Explication de l'expression régulière :
    // ^ : Début de la chaîne.
    // (?=.*[A-Za-z0-9]) : Requiert au moins un chiffre ou une lettre.
    // (?=.*[@-]) : Requiert la présence d'un caractère spécial,
    // qui peut être un tiret (-) ou un @.
    // ([A-Za-z0-9@-]{8,}) : Accepte n'importe quel caractère alphanumérique
    // ou l'un des caractères spéciaux (tiret ou @) répété au moins 8 fois.
    // $ : Fin de la chaîne.
    // lorsque le mot de passe n'est pas renseigné
    if (value == null || value!.isEmpty) {
      error = ChangePasswordCommandPasswordError.empty;
    }
    // lorsque le mot de passe est valide
    else if (!passwordRegex.hasMatch(value!)) {
      error = ChangePasswordCommandPasswordError.invalid;
    }
    // lorsque que le mot de passe est ne respecte pas le regex
    else {
      error = null;
    }
    return error == null;
  }
}

/// Types d'erreurs possibles sur le champ mot de passe
enum ChangePasswordCommandPasswordError { empty, invalid }

/// Types d'erreurs possibles globalement
enum ChangePasswordCommandError { passwordDifferent }
