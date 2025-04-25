/// Modeles et regles de validation du champ iban
class TransactionSendCommandIban {
  //
  TransactionSendCommandIban({required this.value, error});
  String? value;
  TransactionSendCommandIbanError? error;

  static const patternIBAN = r'^[A-Z]{2}[0-9]{2}[A-Z0-9]{11,27}$';

  bool isValid() {
    // lorsque l'identifiant n'est pas renseigné
    if (value == null || value!.isEmpty) {
      error = TransactionSendCommandIbanError.empty;
    }
    // Si le nom d'utilisateur est inférieur à 3 caractères
    // SN08SN0120120103520465350169
    // CI93CI0080111301134291200589
    // TG53TG0090604310346500400070
    else if (!verifierCodeIban(value!)) {
      error = TransactionSendCommandIbanError.invalid;
    }
    // lorsque l'identifiant est valide
    else {
      error = null;
    }
    return error == null;
  }

  static bool verifierCodeIban(String codeIban) {
    if (codeIban.isNotEmpty && codeIban.replaceAll(' ', '').length == 28) {
      // Conversion en majuscule
      codeIban = codeIban.toUpperCase();
      String codeIbanFinal = '';
      // Reconstitution de l'IBAN selon le regex alphanumérique
      for (int i = 0; i < codeIban.length; i++) {
        String car = codeIban[i];
        if (RegExp(r'[a-zA-Z0-9]').hasMatch(car)) {
          codeIbanFinal += car;
        }
      }

      // Concaténation du RIB et des 4 premiers caractères
      codeIbanFinal =
          codeIbanFinal.substring(4) + codeIbanFinal.substring(0, 4);

      String codeIbanATester = '';
      for (int i = 0; i < codeIbanFinal.length; i++) {
        String car = codeIbanFinal[i];
        if (RegExp(r'[A-Z]').hasMatch(car)) {
          car = (car.codeUnitAt(0) - 55).toString();
        }
        codeIbanATester += car;
      }
      return modulo97(codeIbanATester) == 1;
    } else {
      return false;
    }
  }

  static int modulo97(String valeur) {
    int reste = 0;
    for (int i = -1; i < valeur.length - 1; i++) {
      reste = ((reste * 10) + int.parse((valeur[i + 1]))) % 97;
    }
    return reste;
  }
}

/// Types d'erreurs possibles sur le champ alias
enum TransactionSendCommandIbanError {
  //
  empty("TransactionSendCommandIbanErrorEmpty"),
  invalid("TransactionSendCommandIbanErrorInvalid");

  // Codification du paramètre
  final String code;

  const TransactionSendCommandIbanError(this.code);
}
