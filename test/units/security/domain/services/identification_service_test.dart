import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/security/domain/models/biometric_method.dart';
import 'package:pi_mobile_app/modules/security/domain/models/identification_response.dart';
import 'package:pi_mobile_app/modules/security/domain/models/pin_command.dart';
import 'package:pi_mobile_app/modules/security/domain/services/identification_service.dart';

import '../infra/identification_biometric_output_mock.dart';
import '../infra/identification_pin_output_mock.dart';

void main() {
  group('IdentificationService - cas succès', () {
    IdentificationService service = IdentificationService(
        MockIdentificationBiometricOutputPort(),
        MockIdentificationPinOutputPort());

    test("isPinCreated - true ", () async {
      expect((await service.isPinCreated()), true);
    });

    test("setupCodePin - true ", () async {
      expect(service.setupCodePin(PinCommand([123, 125])), isA<void>());
    });

    test("identifyUsingCodePin - true ", () async {
      final result = await service.identifyUsingCodePin(PinCommand([123, 125]));
      expect(result.passed, true);
    });

    test("isBiometryPossible - true ", () async {
      expect(await service.isBiometryPossible(), true);
    });

    test("isBiometryAutorized - true ", () async {
      expect(await service.isBiometryAutorized(), true);
    });

    test("setupBiometry - true ", () async {
      expect(
          service.setupBiometry(
              true, [BiometricMethod.face, BiometricMethod.fingerprint]),
          isA<void>());
    });

    test("listMethods - true ", () async {
      expect(await service.listMethods(), [
        BiometricMethod.face,
        BiometricMethod.fingerprint,
        BiometricMethod.iris
      ]);
    });

    test("identifyUsingBiometric - true ", () async {
      await service.identifyUsingBiometric().then((value) => () {
            expect(value, IdentificationResponse(passed: true, methods: []));
          });
    });
  });

  group('IdentificationService - cas erreurs', () {
    IdentificationService service = IdentificationService(
        MockIdentificationBiometricOutputPortErrors(),
        MockIdentificationPinOutputPortErrors());

    test("identifyUsingBiometric - true ", () async {
      try {
        await service.identifyUsingBiometric();
      } catch (e) {
        expect(
            e.toString(),
            'Biometric identification error <- Biometric'
            ' identification error <- null');
      }
    });

    test("identifyUsingBiometric - true ", () async {
      try {
        await service.identifyUsingCodePin(PinCommand([123, 125]));
      } catch (e) {
        expect(
            e.toString(),
            'Error connexion par un code pin <- Error connexion'
            ' par un code pin <- null');
      }
    });

    test("setupCodePin - true ", () async {
      try {
        await service.setupCodePin(PinCommand([123, 125]));
      } catch (e) {
        expect(
            e.toString(),
            Exception('Error rencontrée pendant la configuration du code pin '
                    'Exception: Error')
                .toString());
      }
    });
  });
}
