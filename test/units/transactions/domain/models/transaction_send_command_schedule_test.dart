import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_schedule.dart';
import 'package:pi_mobile_app/shared/models/frequence_command.dart';

void main() {
  group('ok test', () {
    test(' isValid test', () {
      // Arrange
      final frequence = FrequenceCommand(
          value: Frequence.annuelle,
          periodicite: 1
        );

      final transacationSchedule = TransactionSendCommandSchedule(
        dateDebut: DateTime(2023, 12, 4, 14, 30),
        dateFin: DateTime(2023, 12, 4, 14, 30),
        frequence: frequence,
        error: TransactionSendCommandScheduleError.debutEmpty
      );
      // Accept
      expect(transacationSchedule.isValid(), isTrue);
    });

     test(' toJson test', () {
      // Arrange
      final frequence = FrequenceCommand(
          value: Frequence.quotidienne,
          periodicite: 1
        );

      final transacationSchedule = TransactionSendCommandSchedule(
        dateDebut: DateTime(2023, 12, 4, 14, 30),
        dateFin: DateTime(2023, 12, 4, 14, 30),
        frequence: frequence,
        error: TransactionSendCommandScheduleError.debutEmpty
      );

      final json = {
            'dateDebut': '2023-12-04T14:30:00.000',
            'frequence': 'J',
            'periodicite': 1,
            'dateFin': '2023-12-04T14:30:00.000'
          };
      // Accept
      expect(transacationSchedule.toJson(), json);
    });

  });

  group('error test', () {
    test(' isValid with dateDebut null', () {
      // Arrange
      final frequence = FrequenceCommand(
          value: Frequence.annuelle,
          periodicite: 1
        );

      final transacationSchedule = TransactionSendCommandSchedule(
        dateFin: DateTime(2023, 12, 4, 14, 30),
        frequence: frequence,
        error: TransactionSendCommandScheduleError.debutEmpty
      );
      // Accept
      expect(transacationSchedule.isValid(), isFalse);
    });
  });
}
