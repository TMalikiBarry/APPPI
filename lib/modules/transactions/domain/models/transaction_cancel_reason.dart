/// Raisons d'une demande d'annulation
enum TransactionCancelReason {
  //
  erreurDestinataire("AC03"),
  erreurMontant("AM09"),
  serviceNonRendu("SVNR"),
  dejaPaye("DUPL"),
  fraude("FRAD");

  // Codification du paramètre
  final String code;

  const TransactionCancelReason(this.code);
}
