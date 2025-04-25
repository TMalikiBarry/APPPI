import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_motif.dart';

void main() {
  group('Valid alias', () {
    test('Valid MBNO alias', () {
      // Arrange
      final motif = TransactionSendCommandMotif(value: "aide famille");

      // Act
      bool isValid = motif.isValid();

      // Accept
      expect(isValid, isTrue);
    });
  });
  group('Tests erreurs', () {
    test('valeur null ', () {
      // Arrange

      // Accept
      expect(
          TransactionSendCommandMotif(
                  value:
                      'xyynlphhkotrjzsqcgcnmuuzububzcstmticcbastqofsdhpebmnkxny'
                      'lkeuezklfzaisafjupdgbcqtsqdykjkajsrdtnluhslcarhxi'
                      'yedleejd')
              .isValid(),
          false);
    });
  });
}
