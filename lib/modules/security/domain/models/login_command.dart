/// Login Input Command
class LoginCommand {
  //
  LoginCommand({this.username, this.password});

  LoginCommandUsername? username;
  LoginCommandPassword? password;

  bool isValid() {
    return username != null &&
        username!.isValid() //
        &&
        password != null &&
        password!.isValid();
  }
}

/// Modelise les regles de gestion du username
class LoginCommandUsername {
  //
  LoginCommandUsername({required this.value, error});
  String? value;
  LoginCommandUsernameError? error;

  bool isValid() {
    // lorsque l'identifiant n'est pas renseigné
    if (value == null || value!.isEmpty) {
      error = LoginCommandUsernameError.empty;
    }
    // Si le nom d'utilisateur est inférieur à 3 caractères
    else if (value!.length < 3) {
      error = LoginCommandUsernameError.invalid;
    }
    // lorsque l'identifiant est valide
    else {
      error = null;
    }
    return error == null;
  }
}

/// Types d'erreurs possibles sur le champ username
enum LoginCommandUsernameError {
  //
  empty("loginUsernameErrorEmpty"),
  invalid("loginUsernameErrorInvalid");

  // Codification du paramètre
  final String code;

  const LoginCommandUsernameError(this.code);
}

/// Modelise les regles de gestion du mot de passe
class LoginCommandPassword {
  //
  LoginCommandPassword({required this.value});
  String? value;
  LoginCommandPasswordError? error;

  final RegExp passwordRegex =
      RegExp(r"^(?=.*[A-Za-z0-9])(?=.*[@-])([A-Za-z0-9@-]{8,})$");

  bool isValid() {
    // Ajoutez votre logique de validation du username ici
    // Par exemple, vérifiez la longueur minimale, les caractères autorisés.
    // regex qui sera appliqué au mot de passe pour assurer sa complexité
    // Explication de l'expression régulière :
    // ^ : Début de la chaîne.
    // (?=.*[A-Za-z0-9]) : Requiert au moins un chiffre ou une lettre.
    // (?=.*[@-]) : Requiert la présence d'un caractère spécial, qui peut
    // être un tiret (-) ou un @.
    // ([A-Za-z0-9@-]{8,}) : Accepte n'importe quel caractère alphanumérique
    //  ou l'un des caractères spéciaux (tiret ou @) répété au moins 8 fois.
    // $ : Fin de la chaîne.
    // lorsque le mot de passe n'est pas renseigné
    if (value == null || value!.isEmpty) {
      error = LoginCommandPasswordError.empty;
    }
    // lorsque le mot de passe est valide
    else if (!passwordRegex.hasMatch(value!)) {
      error = LoginCommandPasswordError.invalid;
    }
    // lorsque que le mot de passe est ne respecte pas le regex
    else {
      error = null;
    }
    return error == null;
  }
}

/// Types d'erreurs possibles sur le champ mot de passe
enum LoginCommandPasswordError { empty, invalid }
