import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/qrcode/domain/models/qrcode_data.dart';

void main() {
  group('QrcodeModel - toJson', () {
    test("toJson ", () async {
      final json = {
        'alias': '111c3e1b-4312-49ec-b75e-4c8c74c10fd7',
        'txId': null,
        'montant': null,
        'channel': '000'
      };
      expect(
          QrcodeData("111c3e1b-4312-49ec-b75e-4c8c74c10fd7", null, null, '000')
              .toJson(),
          json);
    });
  });
}
