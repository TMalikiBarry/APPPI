/// Modeles et regles de validation du champ montant
class TransactionSendCommandAmount {
  //
  TransactionSendCommandAmount({this.value, this.solde, error});
  double? value;
  double? solde;
  TransactionSendCommandAmountError? error;

  bool isValid() {
    // lorsque il n'est pas renseigné
    if (value == null) {
      error = TransactionSendCommandAmountError.empty;
    }
    // Si le solde est insuffisant
    else if (solde != null && value! > solde!) {
      error = TransactionSendCommandAmountError.invalid;
    } else if (value! < 1) {
      // min transfert 1 frcs
      error = TransactionSendCommandAmountError.low;
    }
    // lorsque l'identifiant est valide
    else {
      error = null;
    }
    return error == null;
  }
}

/// Types d'erreurs possibles sur le champ alias
enum TransactionSendCommandAmountError {
  //
  empty("TransactionSendCommandAmountErrorEmpty"),
  invalid("TransactionSendCommandAmountErrorInvalid"),
  low("TransactionSendCommandAmountErrorLow");

  // Codification du paramètre
  final String code;

  const TransactionSendCommandAmountError(this.code);
}
