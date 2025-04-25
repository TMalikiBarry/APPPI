/// Modeles et regles de validation du champ motif
class TransactionSendCommandMotif {
  //
  TransactionSendCommandMotif({required this.value, error});
  String? value;
  TransactionSendCommandMotifError? error;

  bool isValid() {
    // lorsque l'identifiant n'est pas renseigné
    if (value != null && value!.length > 104) {
      error = TransactionSendCommandMotifError.invalid;
    }
    // lorsque l'identifiant est valide
    else {
      error = null;
    }
    return error == null;
  }
}

/// Types d'erreurs possibles sur le champ alias
enum TransactionSendCommandMotifError {
  //
  empty("TransactionSendCommandMotifErrorEmpty"),
  invalid("TransactionSendCommandMotifErrorInvalid");

  // Codification du paramètre
  final String code;

  const TransactionSendCommandMotifError(this.code);
}
