enum TransactionSendMethod {
  // alias
  alias("ALIAS"),
  aliasRtb("ALIAS_RTB"),
  //  bank
  iban("IBAN"),
  // autre
  othr("OTHR"),
  // QR Code
  qrcode("QRCODE"),
  // autre
  contact("CONTACT"),
  
  rtpAcceptPay("rtpAcceptPay");

  // Codification du paramètre
  final String code;

  const TransactionSendMethod(this.code);
}
