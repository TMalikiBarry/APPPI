import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_confirm_command.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_amount.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_motif.dart';

void main() {
  group('TransactionConfirmCommand', () {
    test('Valid TransactionConfirmCommand', () {
      // Arrange
      final transaction = TransactionConfirmCommand(
          confirmationDate: "2019-08-24T14:15:22.999Z",
          endToendId: "E2E123",
          confirmationMethode: "ok",
          motif: TransactionSendCommandMotif(value: "aide famille"),
          amount: TransactionSendCommandAmount(value: 90, solde: 2000));

      // Act
      bool isValid = transaction.isValid();

      // Accept
      expect(isValid, isTrue);
    });
    test('Valid TransactionConfirmCommand toJson', () {
      // Arrange
      final transaction = TransactionConfirmCommand(
          confirmationDate: "2019-08-24T14:15:22.999Z",
          endToendId: "E2E123",
          confirmationMethode: "ok",
          motif: TransactionSendCommandMotif(value: "aide famille"),
          amount: TransactionSendCommandAmount(value: 90, solde: 2000));

      // Accept
      expect(transaction.toJson(), {
        'montant': 90.0,
        'confirmationDate': '2019-08-24T14:15:22.999Z',
        'confirmationMethode': 'ok',
        'motif': 'aide famille'
      });
    });
  });
}
