import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_othr.dart';

void main() {
  group('Valid', () {
    test('Valid other', () {
      // Arrange
      final other = TransactionSendCommandOthr(value: "221773242452");

      // Act
      bool isValid = other.isValid();

      // Accept
      expect(isValid, isTrue);
    });
  });
  group('Tests erreurs', () {
    test('valeur null ', () {
      // Arrange
      final other = TransactionSendCommandOthr(value: null);

      // Act
      bool isValid = other.isValid();

      // Accept
      expect(isValid, isFalse);
      expect(other.error, equals(TransactionSendCommandOthrError.empty));
    });
  });
}
