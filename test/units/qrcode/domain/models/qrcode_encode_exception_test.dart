import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/qrcode/domain/models/qrcode_encode_error.dart';
import 'package:pi_mobile_app/modules/qrcode/domain/models/qrcode_encode_exception.dart';

void main() {
  group('QrcodeModel - toJson', () {
    test("toJson ", () async {
      expect(QrcodeEncodeException(QrCodeEncodeError.unknown).cause.toString(),
          "null");
    });
    test("toJson ", () async {
      expect(
          QrcodeEncodeException(QrCodeEncodeError.unknown).toString(), "null");
    });
  });
}
