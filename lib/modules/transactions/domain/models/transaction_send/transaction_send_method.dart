enum TransactionSendMethod {
  // alias
  alias("ALIAS"),
  //  bank
  iban("IBAN"),
  // autre
  othr("OTHR"),
  // QR Code
  qrcode("QRCODE"),
  // autre
  contact("CONTACT");

  // Codification du paramètre
  final String code;

  const TransactionSendMethod(this.code);
}
