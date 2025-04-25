import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/security/domain/models/pin_command.dart';

void main() {
  group('PinCommand - cas succès', () {
    test('PinCommand is valid', () {
      expect(PinCommand([1233, 4, 4, 5]).isValid(), isTrue);
    });
  });
}
