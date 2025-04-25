import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_iban.dart';

void main() {
  group('Valid alias', () {
    test('Valid MBNO alias', () {
      // Arrange
      final contact =
          TransactionSendCommandIban(value: "SN08SN0120120103520465350169");

      // Act
      bool isValid = contact.isValid();

      // Accept
      expect(isValid, isTrue);
    });
  });
  group('Tests erreurs', () {
    test('valeur null ', () {
      // Arrange
      final alias = TransactionSendCommandIban(value: null);

      // Act
      bool isValid = alias.isValid();

      // Accept
      expect(isValid, isFalse);
      expect(alias.error, equals(TransactionSendCommandIbanError.empty));
    });
    test('valeur moins de 3 ', () {
      // Arrange
      final alias = TransactionSendCommandIban(value: "12");

      // Act
      bool isValid = alias.isValid();

      // Accept
      expect(isValid, isFalse);
      expect(alias.error, equals(TransactionSendCommandIbanError.invalid));
    });
  });
}
