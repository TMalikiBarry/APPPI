import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_amount.dart';

void main() {
  group('Valid amount', () {
    test('Valid amount not null and less than balance', () {
      // Arrange
      final amount = TransactionSendCommandAmount(value: 1000, solde: 2000);

      // Act
      bool isValid = amount.isValid();

      // Accept
      expect(isValid, isTrue);
      expect(amount.error, isNull);
    });
  });

  group('Invalid amount', () {
    test('Invalid amount - null', () {
      // Arrange
      final amount = TransactionSendCommandAmount();

      // Act
      bool isValid = amount.isValid();

      // Accept
      expect(isValid, isFalse);
      expect(amount.error, equals(TransactionSendCommandAmountError.empty));
    });

    test('Invalid amount - greater than solde', () {
      // Arrange
      final amount = TransactionSendCommandAmount(value: 3000, solde: 2000);

      // Act
      bool isValid = amount.isValid();

      // Accept
      expect(isValid, isFalse);
      expect(amount.error, equals(TransactionSendCommandAmountError.invalid));
    });

    test('Invalid amount - less than minimum', () {
      // Arrange
      final amount = TransactionSendCommandAmount(value: 3, solde: 2000);

      // Act
      bool isValid = amount.isValid();

      // Accept
      expect(isValid, isFalse);
      expect(amount.error, equals(TransactionSendCommandAmountError.low));
    });
  });
}
