abstract class QrcodeScanEvent {
  const QrcodeScanEvent();
}

// Permert de decoder un qrcode selon la norme emv
class QrcodeScanDecodeEvent extends QrcodeScanEvent {
  final String contenu;
  QrcodeScanDecodeEvent(this.contenu);
}

// Permet de recuperer une image de qrcode dans la galerie
// du téléphone,
class QrcodeScanSelectEvent extends QrcodeScanEvent {
  const QrcodeScanSelectEvent();
}
