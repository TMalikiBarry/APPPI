/// Modeles et regles de validation du champ othr
class TransactionSendCommandOthr {
  //
  TransactionSendCommandOthr({required this.value, error});
  String? value;
  TransactionSendCommandOthrError? error;

  bool isValid() {
    // lorsque l'identifiant n'est pas renseigné
    if (value == null || value!.isEmpty) {
      error = TransactionSendCommandOthrError.empty;
    }
    // lorsque l'identifiant est valide
    else {
      error = null;
    }
    return error == null;
  }
}

/// Types d'erreurs possibles sur le champ alias
enum TransactionSendCommandOthrError {
  //
  empty("TransactionSendCommandOthrErrorEmpty"),
  invalid("TransactionSendCommandOthrErrorInvalid");

  // Codification du paramètre
  final String code;

  const TransactionSendCommandOthrError(this.code);
}
