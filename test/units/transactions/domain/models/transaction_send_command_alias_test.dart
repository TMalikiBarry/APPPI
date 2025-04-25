import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_alias.dart';

void main() {
  group('Valid alias', () {
    test('Valid MBNO alias', () {
      // Arrange
      final alias = TransactionSendCommandAlias(value: "+221773242452");

      // Act
      bool isValid = alias.isValid();

      // Accept
      expect(isValid, isTrue);
    });

    test('Valid SHID alias', () {
      // Arrange
      final alias = TransactionSendCommandAlias(
          value: "539335b7-ed13-408a-995e-83cb0f3ce0a5");

      // Act
      bool isValid = alias.isValid();

      // Accept
      expect(isValid, isTrue);
    });
  });

  group('Invalid alias', () {
    test('Invalid SHID alias', () {
      // Arrange
      final alias = TransactionSendCommandAlias(
          value: "39335b7-ed13-408a-995e-83cb0f3ce0a5");

      // Act
      bool isValid = alias.isValid();

      // Accept
      expect(isValid, isFalse);
    });

    test('Invalid MBNO alias', () {
      // Arrange
      final alias = TransactionSendCommandAlias(value: "221773242452");

      // Act
      bool isValid = alias.isValid();

      // Accept
      expect(isValid, isFalse);
    });

    test('Empty alias', () {
      // Arrange
      final alias = TransactionSendCommandAlias(value: "");

      // Act
      bool isValid = alias.isValid();

      // Accept
      expect(isValid, isFalse);
      expect(alias.error, equals(TransactionSendCommandAliasError.empty));
    });

    test('Null alias', () {
      // Arrange
      final alias = TransactionSendCommandAlias(value: null);

      // Act
      bool isValid = alias.isValid();

      // Accept
      expect(isValid, isFalse);
      expect(alias.error, equals(TransactionSendCommandAliasError.empty));
    });
  });
}
