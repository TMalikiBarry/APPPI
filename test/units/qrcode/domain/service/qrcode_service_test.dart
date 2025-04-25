import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/alias/domain/models/alias.dart';
import 'package:pi_mobile_app/modules/alias/domain/models/alias_type.dart';
import 'package:pi_mobile_app/modules/qrcode/domain/models/qrcode_data.dart';
import 'package:pi_mobile_app/modules/qrcode/domain/models/qrcode_decode_error.dart';
import 'package:pi_mobile_app/modules/qrcode/domain/models/qrcode_decode_exception.dart';
import 'package:pi_mobile_app/modules/qrcode/ports/input/qrcode_input_port.dart';
import 'package:pi_mobile_app/modules/qrcode/domain/services/qrcode_service.dart';

void main() {
  group('QrcodeInputPort - cas succès', () {
    QrcodeInputPort service = QrcodeService();

    test("Decode - Paiement marchand par QR Code de paiement statique ",
        () async {
      await service
          .decode(
              '00020136560012int.bceao.pi0136539335b7-ed13-408a-995e-83cb0f3ce0'
              'a553039525802SN6207110373164100101X0201X63046E69')
          .then((value) => () {
                expect(
                    value,
                    QrcodeData("111c3e1b-4312-49ec-b75e-4c8c74c10fd7", null,
                        null, '000'));
              });
    });

    test("Decode - QR Code avec montant ", () async {
      await service
          .decode('00020136560012int.bceao.pi0136539335b7-ed13-408a'
              '-995e-83cb0f3ce0a55303952540410005802CI6207'
              '110373164100101X0201X630483E5')
          .then((QrcodeData value) => () {
                expect(value.montant, 1000.0);
              });
    });

    test("encode - Paiement marchand par QR Code de paiement statique cas OK",
        () async {
      await service
          .encode(Alias(
              cle: "539335b7-ed13-408a-995e-83cb0f3ce0a5",
              compte: "123456789",
              type: AliasType.shid,
              pays: 'CI'))
          .then((value) => () {
                expect(
                    value,
                    QrcodeData("111c3e1b-4312-49ec-b75e-4c8c74c10fd7", null,
                        null, '000'));
              });
    });
  });
  group('QrcodeInputPort - cas erreurs', () {
    QrcodeInputPort service = QrcodeService();

    test("Decode - mauvais payload ", () async {
      try {
        await service.decode("");
      } catch (e) {
        expect(
            e.toString(),
            QrcodeDecodeException(QrCodeDecodeError.notInteroperable, cause: e)
                .toString());
      }
    });

    test("Decode - sans channel ", () async {
      try {
        await service.decode('00020136560012int.bceao.pi0136539335b7-ed13-408a-'
            '995e-83cb0f3ce0a553039525802CI64100101X0201X630405D9');
      } catch (e) {
        expect(
            e.toString(),
            QrcodeDecodeException(QrCodeDecodeError.invalidChannel, cause: e)
                .toString());
      }
    });

    test("Decode - data null ", () async {
      try {
        await service.decode(null.toString());
      } catch (e) {
        expect(
            e.toString(),
            QrcodeDecodeException(QrCodeDecodeError.invalidFormat, cause: e)
                .toString());
      }
    });

    test("Decode - currency null ", () async {
      //QrcodeService.currency = "953";
      try {
        await service.decode(
            '00020136560012int.bceao.pi0136539335b7-ed13-408a-995e-83cb0f3ce0'
            'a553039535802SN6207110373164100101X0201X63044728');
      } catch (e) {
        expect(
            e.toString(),
            QrcodeDecodeException(QrCodeDecodeError.notInteroperable, cause: e)
                .toString());
      }
    });

    test("Decode - Country null ", () async {
      //QrcodeService.currency = "953";
      try {
        await service.decode(
            '00020136560012int.bceao.pi0136539335b7-ed13-408a-995e-83cb0f3ce0a'
            '553039526207110373164100101X0201X6304CA1F');
      } catch (e) {
        expect(
            e.toString(),
            QrcodeDecodeException(QrCodeDecodeError.notInteroperable, cause: e)
                .toString());
      }
    });
    test("Decode - alias null ", () async {
      //QrcodeService.currency = "953";
      try {
        await service
            .decode('00020136200012int.bceao.pi010053039525802CI62071103'
                '73164100101X0201X6304AAE8');
      } catch (e) {
        expect(
            e.toString(),
            QrcodeDecodeException(QrCodeDecodeError.invalidAlias, cause: e)
                .toString());
      }
    });
    test("Decode - channel null ", () async {
      //QrcodeService.currency = "953";
      try {
        await service
            .decode('00020136200012int.bceao.pi010053039525802CI62071103'
                '73164100101X0201X6304AAE8');
      } catch (e) {
        expect(
            e.toString(),
            QrcodeDecodeException(QrCodeDecodeError.invalidAlias, cause: e)
                .toString());
      }
    });
  });
}
