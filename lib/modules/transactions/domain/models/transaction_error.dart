/// Types d'erreurs possibles dans la gestion des transactions
enum TransactionError {
  //
  unknow,
  connection,
  timeOut,
  // Transferts
  destinataireIndisponible,
  soldeInsuffisant,
  // Annulations
  dejaRetourne,
  delaiDepasse,
  //RTP
  dejaPaye;
}
