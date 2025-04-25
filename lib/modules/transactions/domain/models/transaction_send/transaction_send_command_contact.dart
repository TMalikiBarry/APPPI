/// Modeles et regles de validation du champ nom du contact
class TransactionSendCommandContact {
  //
  TransactionSendCommandContact({required this.value, error});
  String? value;
  TransactionSendCommandContactError? error;

  bool isValid() {
    // lorsque l'identifiant n'est pas renseigné
    if (value == null || value!.isEmpty) {
      error = TransactionSendCommandContactError.empty;
    }
    // lorsque l'identifiant est valide
    else {
      error = null;
    }
    return error == null;
  }
}

/// Types d'erreurs possibles sur le champ alias
enum TransactionSendCommandContactError {
  //
  empty("TransactionSendCommandContactErrorEmpty"),
  invalid("TransactionSendCommandContactErrorInvalid");

  // Codification du paramètre
  final String code;

  const TransactionSendCommandContactError(this.code);
}
