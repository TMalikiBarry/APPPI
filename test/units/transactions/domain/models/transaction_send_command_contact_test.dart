import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_contact.dart';

void main() {
  group('Valid contact', () {
    test('Valid contact', () {
      // Arrange
      final contact = TransactionSendCommandContact(value: "+221773242452");

      // Act
      bool isValid = contact.isValid();

      // Accept
      expect(isValid, isTrue);
    });
  });
  group(' errors tests', () {
    test('valeur null ', () {
      // Arrange
      final alias = TransactionSendCommandContact(value: null);

      // Act
      bool isValid = alias.isValid();

      // Accept
      expect(isValid, isFalse);
      expect(alias.error, equals(TransactionSendCommandContactError.empty));
    });
  });
}
