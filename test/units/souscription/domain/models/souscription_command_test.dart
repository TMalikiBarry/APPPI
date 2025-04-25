import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/subscription/domain/models/subscription_command.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_motif.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_schedule.dart';
import 'package:pi_mobile_app/shared/models/frequence_command.dart';

void main() {
  group('SubscriptionCommand', () {
    test('isValid test', () {

      final transacationSchedule = TransactionSendCommandSchedule(
        dateDebut: DateTime(2023, 12, 4, 14, 30),
        dateFin: DateTime(2023, 12, 4, 14, 30),
        frequence: FrequenceCommand( value: Frequence.annuelle, periodicite: 1),
        error: TransactionSendCommandScheduleError.debutEmpty
      );

      final souscriptionCommand = SubscriptionCommand(
        schedule: transacationSchedule,
        motif: TransactionSendCommandMotif(value: "error"),
        categorie: 'C'
      );
      
      expect(souscriptionCommand.isValid(), isTrue);
    });

    test('isValid test with null attribute', () {

      expect(SubscriptionCommand().isValid(), isFalse);
    });

    test('isValid test with null motif', () {

      final transacationSchedule = TransactionSendCommandSchedule(
        dateDebut: DateTime(2023, 12, 4, 14, 30),
        dateFin: DateTime(2023, 12, 4, 14, 30),
        frequence: FrequenceCommand( value: Frequence.annuelle, periodicite: 1),
        error: TransactionSendCommandScheduleError.debutEmpty
      );

      final souscriptionCommand = SubscriptionCommand(
        schedule: transacationSchedule,
        categorie: 'C'
      );

      expect(souscriptionCommand.isValid(), isTrue);
    });

    test('isValid test with null schedule', () {

      final souscriptionCommand = SubscriptionCommand(
        motif: TransactionSendCommandMotif(value: "error"),
        categorie: 'C'
      );

      expect(souscriptionCommand.isValid(), isTrue);
    });

    test('toJson test with motif', () {

     final transacationSchedule = TransactionSendCommandSchedule(
        dateDebut: DateTime(2023, 12, 4, 14, 30),
        dateFin: DateTime(2023, 12, 4, 14, 30),
        frequence: FrequenceCommand( value: Frequence.annuelle, periodicite: 1),
        error: TransactionSendCommandScheduleError.debutEmpty
      );

      final souscriptionCommand = SubscriptionCommand(
        schedule: transacationSchedule,
        motif: TransactionSendCommandMotif(value: "error"),
        categorie: 'C'
      );

      expect(souscriptionCommand.toJson(), {'motif': 'error'});
    });

    test('toJson test without motif', () {

     final transacationSchedule = TransactionSendCommandSchedule(
        dateDebut: DateTime(2023, 12, 4, 14, 30),
        dateFin: DateTime(2023, 12, 4, 14, 30),
        frequence: FrequenceCommand( value: Frequence.annuelle, periodicite: 1),
        error: TransactionSendCommandScheduleError.debutEmpty
      );

      final souscriptionCommand = SubscriptionCommand(
        schedule: transacationSchedule,
        categorie: 'C'
      );

      expect(souscriptionCommand.toJson(), {'categorie': 'C'});
    });

    test('toJson test without motif and categorie', () {

     final transacationSchedule = TransactionSendCommandSchedule(
        dateDebut: DateTime(2023, 12, 4, 14, 30),
        dateFin: DateTime(2023, 12, 4, 14, 30),
        frequence: FrequenceCommand( value: Frequence.annuelle, periodicite: 1),
        error: TransactionSendCommandScheduleError.debutEmpty
      );

      final souscriptionCommand = SubscriptionCommand(
        schedule: transacationSchedule
      );

      expect(souscriptionCommand.toJson(), {
            'dateDebut': '2023-12-04T14:30:00.000',
            'frequence': 'A',
            'periodicite': 1,
            'dateFin': '2023-12-04T14:30:00.000'
          });
    });
  });
}
