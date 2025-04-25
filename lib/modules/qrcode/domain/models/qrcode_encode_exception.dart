import 'qrcode_encode_error.dart';

class QrcodeEncodeException implements Exception {
  ///
  final Object? cause;

  final QrCodeEncodeError error;

  QrcodeEncodeException(this.error, {this.cause});

  @override
  String toString() => '$cause';
}
