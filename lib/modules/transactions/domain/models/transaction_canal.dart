/// Canal de communication
/// Correspond au champ localInstrument des messages pacs.008 et pain.013
enum TransactionCanal {
  //
  /// Transfert par QR Code 731
  transfertParQrcode("731"),

  /// Transfert par Telephone 633
  transfertParTelephone("633"),

  /// Transfert par adresse de paiement 633
  transfertParSHID("633"),

  /// Transfert par compte 633
  transfertParCompte("633"),

  /// Ordre de transfert bancaire 999
  ordreDeTransfertBancaire("999"),

  /// Paiement par QR Code Statique 000
  paiementParQrcodeStatique("000"),

  /// Paiement par QR Code Dynamique 400
  paiementParQrcodeDynamique("400"),

  /// Transfert par request to pay 631
  transfertParRequestToPay("631"),

  /// Paiement par Request To Pay sur site 500
  paiementParRequestToPaySite("500"),

  /// Demande de Paiement e-commerce immédiat
  paiementParRequestToPayEcommerceImmediat("521"),

  /// Demande de Paiement e-commerce à la livraison
  paiementParRequestToPayEcommerceLivraison("520"),

  /// Autres Demande de Paiement
  paiementParRequestToPayAutresFactures("401"),

  /// Tout autre type de canal
  defaultCanal("633");

  // Codification du paramètre
  final String code;

  const TransactionCanal(this.code);
}
