import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/security/domain/models/login_command.dart';

void main() {
  group('LoginCommandUsername', () {
    test('LoginCommandUsername isValid', () {
      expect(LoginCommandUsername(value: "fma").isValid(), true);
    });

    test('LoginCommandUsername error moins de 3 characts', () {
      expect(LoginCommandUsername(value: "fm").isValid(), isFalse);
    });

    test('LoginCommandUsername error', () {
      expect(LoginCommandUsername(value: null).isValid(), false);
    });
  });

  group('LoginCommand', () {
    test('LoginCommand error bad password', () {
      expect(
          LoginCommand(
                  username: LoginCommandUsername(value: "fma"),
                  password: LoginCommandPassword(value: "123ABCd"))
              .isValid(),
          false);
    });

    test('LoginCommand is valid', () {
      expect(
          LoginCommand(
                  username: LoginCommandUsername(value: "fma"),
                  password: LoginCommandPassword(value: "P@sser1234"))
              .isValid(),
          isTrue);
    });

    test('LoginCommand sans mot de passe', () {
      expect(
          LoginCommand(
                  username: LoginCommandUsername(value: "fma"),
                  password: LoginCommandPassword(value: null))
              .isValid(),
          false);
    });
  });
}
