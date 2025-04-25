import 'qrcode_decode_error.dart';

class QrcodeDecodeException implements Exception {
  ///
  final Object? cause;

  final QrCodeDecodeError error;

  QrcodeDecodeException(this.error, {this.cause});

  @override
  String toString() => '$cause';
}
