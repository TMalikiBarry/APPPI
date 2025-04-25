/// Raisons d'un rejet
enum TransactionRejectReason {
  //
  erreurDestinataire("BE05"),
  erreurMontant("AM09"),
  dejaPaye("APAR"),
  facture("RR07"),
  fraude("FR01"),
  autre("CUST");

  // Codification du paramètre
  final String code;

  const TransactionRejectReason(this.code);
}
