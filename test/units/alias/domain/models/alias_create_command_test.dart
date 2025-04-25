import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/alias/domain/models/alias_create_command.dart';
import 'package:pi_mobile_app/modules/alias/domain/models/alias_mbno_otp_command.dart';
import 'package:pi_mobile_app/modules/alias/domain/models/alias_type.dart';
import 'package:pi_mobile_app/shared/models/uemoa_countries.dart';

void main() {
  group('AliasCreateCommand', () {
    test('isValid should return true for +223773242452', () {
      UEMOACountry benin = UEMOACountry.liste[0];
      final phoneNumber = AliasCreateCommandPhoneNumber(
        indicatif: benin.phoneCode,
        phone: '73242452',
      );

      final aliasCreateCommand = AliasCreateCommand(
        type: AliasType.mbno,
        phoneNumber: phoneNumber,
        compte: 'CI123456789',
      );

      expect(aliasCreateCommand.isValid(), isTrue);
    });

    test('isValid should return true for +221773242452', () {
      final phoneNumber = AliasCreateCommandPhoneNumber(
        indicatif: '+221',
        phone: '773242452',
      );

      final aliasCreateCommand = AliasCreateCommand(
        compte: "CI123456789",
        type: AliasType.mbno,
        phoneNumber: phoneNumber,
      );

      expect(aliasCreateCommand.isValid(), isTrue);
    });

    test('isValid should return false for invalid +2217732', () {
      final phoneNumber = AliasCreateCommandPhoneNumber(
        indicatif: '+221',
        phone: '7732', // Invalid phone number, too short
      );

      final aliasCreateCommand = AliasCreateCommand(
        compte: "CI123456789",
        type: AliasType.mbno,
        phoneNumber: phoneNumber,
      );

      expect(aliasCreateCommand.isValid(), isFalse);
    });

    test('toJson should return a valid JSON representation', () {
      final phoneNumber = AliasCreateCommandPhoneNumber(
        indicatif: '+221',
        phone: '773242452',
      );

      final aliasCreateCommand = AliasCreateCommand(
        compte: "CI123456789",
        type: AliasType.mbno,
        phoneNumber: phoneNumber,
      );

      final expectedJson = {
        'cle': '+221773242452',
        'type': 'MBNO',
        'compte': 'CI123456789'
      };

      expect(aliasCreateCommand.toJson(), expectedJson);
    });
  });

  group('AliasCreateCommandPhoneNumber', () {
    test('isValid should return true for valid phone number', () {
      final phoneNumber = AliasCreateCommandPhoneNumber(
        indicatif: '+221',
        phone: '773242452',
      );

      expect(phoneNumber.isValid(), isTrue);
      expect(phoneNumber.error, isNull);
    });

    test('isValid should return false for empty phone number', () {
      final phoneNumber = AliasCreateCommandPhoneNumber(
        indicatif: '+221',
        phone: '',
      );

      expect(phoneNumber.isValid(), isFalse);
      expect(phoneNumber.error, AliasCreateCommandPhoneNumberError.empty);
    });

    test('isValid should return false for an invalid phone number', () {
      final phoneNumber = AliasCreateCommandPhoneNumber(
        indicatif: '+221',
        phone: '12345', // Invalid phone number, too short
      );

      expect(phoneNumber.isValid(), isFalse);
      expect(phoneNumber.error, AliasCreateCommandPhoneNumberError.invalid);
    });

    test('isValid should return true for an valid otp', () {
      final otp = AliasMbnoOtpCommand([0, 1, 2, 3, 4, 5]);

      expect(otp.isValid(), isTrue);
    });

    test('isValid should return false for an invalid otp', () {
      final otp = AliasMbnoOtpCommand([0, 1, 2, 3, 4]);

      expect(otp.isValid(), isFalse);
    });
  });
}
