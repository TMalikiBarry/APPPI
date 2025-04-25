import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_canal.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_alias.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_amount.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_contact.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_iban.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_motif.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_othr.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_schedule.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_method.dart';
import 'package:pi_mobile_app/shared/models/frequence_command.dart';

void main() {
  group('Valid', () {
    test('Valid alias', () {
      // Arrange
      final transaction = TransactionSendCommand(
          action: TransactionSendCommand.actionSendNow,
          method: TransactionSendMethod.alias,
          solde: 123.0,
          alias: TransactionSendCommandAlias(value: "+221773242452"),
          amount: TransactionSendCommandAmount(value: 1000, solde: 2000),
          motif: TransactionSendCommandMotif(value: "aide famille"),
          compte: '2344');

      // Act
      bool isValid = transaction.isValid();

      // Accept
      expect(isValid, isTrue);
    });

    test('Valid other', () {
      // Arrange
      final transaction = TransactionSendCommand(
          action: TransactionSendCommand.actionSendNow,
          method: TransactionSendMethod.alias,
          solde: 123.0,
          othr: TransactionSendCommandOthr(value: "221773242452"),
          amount: TransactionSendCommandAmount(value: 1000, solde: 2000),
          motif: TransactionSendCommandMotif(value: "aide famille"),
          compte: '2344',
          txId: "365214");

      // Act
      bool isValid = transaction.isValid();

      // Accept
      expect(isValid, isTrue);
    });

    test('Valid iban', () {
      // Arrange
      final transaction = TransactionSendCommand(
          action: "envoie",
          method: TransactionSendMethod.alias,
          solde: 123.0,
          iban:
              TransactionSendCommandIban(value: "SN08SN0120120103520465350169"),
          contact: TransactionSendCommandContact(value: "+221773242452"),
          amount: TransactionSendCommandAmount(value: 1000, solde: 2000),
          motif: TransactionSendCommandMotif(value: "aide famille"),
          compte: '1234');

      // Act
      bool isValid = transaction.isValid();

      // Accept
      expect(isValid, isTrue);
    });

    test('Transaction par qr code', () {
      // Arrange

      final transaction = TransactionSendCommand(
        compte: '1234',
        action: TransactionSendCommand.actionSendNow,
        method: TransactionSendMethod.qrcode,
        alias: TransactionSendCommandAlias(
          value: "539335b7-ed13-408a-995e-83cb0f3ce0a5",
        ),
        canal: "731",
        amount: TransactionSendCommandAmount(value: 1000, solde: 2000),
      );

      // Act
      bool isValid = transaction.isValid();

      // Accept
      expect(isValid, isTrue);
    });

    test('Valid transaction iban to json', () {
      final json = {
        'compte': '1234',
        'canal': null,
        'montant': 1000.0,
        'payePSP': null,
        'latitude': null,
        'longitude': null,
        'txId': '365214',
        'motif': 'aide famille',
        'iban': 'SN08SN0120120103520465350169'
      };
      // Arrange
      final transaction = TransactionSendCommand(
          action: "envoie",
          method: TransactionSendMethod.iban,
          solde: 123.0,
          iban:
              TransactionSendCommandIban(value: "SN08SN0120120103520465350169"),
          contact: TransactionSendCommandContact(value: "+221773242452"),
          amount: TransactionSendCommandAmount(value: 1000, solde: 2000),
          motif: TransactionSendCommandMotif(value: "aide famille"),
          compte: '1234',
          txId: "365214");

      // Accept
      expect(transaction.toJson(), json);
    });
    test('Valid transaction alias to json', () {
      final json = {
        'compte': '1234',
        'canal': null,
        'montant': 1000.0,
        'payePSP': null,
        'latitude': null,
        'longitude': null,
        'motif': 'aide famille',
        'alias': '+221773242452'
      };
      // Arrange
      final transaction = TransactionSendCommand(
          action: "envoie",
          method: TransactionSendMethod.alias,
          solde: 123.0,
          alias: TransactionSendCommandAlias(value: "+221773242452"),
          contact: TransactionSendCommandContact(value: "+221773242452"),
          amount: TransactionSendCommandAmount(value: 1000, solde: 2000),
          motif: TransactionSendCommandMotif(value: "aide famille"),
          compte: '1234');

      // Accept
      expect(transaction.toJson(), json);
    });

    test('Valid transaction qrcode to json', () {
      final json = {
        'compte': '1234',
        'canal': null,
        'montant': 1000.0,
        'payePSP': null,
        'latitude': null,
        'longitude': null,
        'txId': '365214',
        'motif': 'aide famille',
        'alias': null
      };
      // Arrange
      final transaction = TransactionSendCommand(
          action: "envoie",
          method: TransactionSendMethod.qrcode,
          solde: 123.0,
          iban:
              TransactionSendCommandIban(value: "SN08SN0120120103520465350169"),
          contact: TransactionSendCommandContact(value: "+221773242452"),
          amount: TransactionSendCommandAmount(value: 1000, solde: 2000),
          motif: TransactionSendCommandMotif(value: "aide famille"),
          compte: '1234',
          txId: "365214");

      // Accept
      expect(transaction.toJson(), json);
    });

    test('Valid transaction othr to json', () {
      final json = {
        'compte': '1234',
        'canal': '333',
        'montant': 1000.0,
        'payePSP': null,
        'latitude': null,
        'longitude': null,
        'motif': 'aide famille',
        'othr': '221773242452'
      };
      // Arrange
      final transaction = TransactionSendCommand(
          action: "envoie",
          method: TransactionSendMethod.othr,
          canal: "333",
          solde: 123.0,
          othr: TransactionSendCommandOthr(value: "221773242452"),
          contact: TransactionSendCommandContact(value: "+221773242452"),
          amount: TransactionSendCommandAmount(value: 1000, solde: 2000),
          motif: TransactionSendCommandMotif(value: "aide famille"),
          compte: '1234');

      // Accept
      expect(transaction.toJson(), json);
    });
    test('Valid transaction contact to json', () {
      final json = {
        'compte': '1234',
        'canal': null,
        'montant': 1000.0,
        'payePSP': null,
        'latitude': null,
        'longitude': null,
        'motif': 'aide famille',
        'alias': '+221773242452'
      };
      // Arrange
      final transaction = TransactionSendCommand(
          action: "envoie",
          method: TransactionSendMethod.contact,
          solde: 123.0,
          alias: TransactionSendCommandAlias(value: "+221773242452"),
          contact: TransactionSendCommandContact(value: "+221773242452"),
          amount: TransactionSendCommandAmount(value: 1000, solde: 2000),
          motif: TransactionSendCommandMotif(value: "aide famille"),
          compte: '1234');

      // Accept
      expect(transaction.toJson(), json);
    });

    test(' to json with schedule', () {
      final transacationSchedule = TransactionSendCommandSchedule(
          dateDebut: DateTime(2023, 12, 4, 14, 30),
          dateFin: DateTime(2023, 12, 4, 14, 30),
          frequence:
              FrequenceCommand(value: Frequence.annuelle, periodicite: 1),
          error: TransactionSendCommandScheduleError.debutEmpty);

      final json = {
        'compte': '1234',
        'canal': null,
        'montant': 1000.0,
        'payePSP': null,
        'latitude': null,
        'longitude': null,
        'motif': 'aide famille',
        'alias': '+221773242452',
        'dateDebut': DateTime(2023, 12, 4, 14, 30),
        'frequence': Frequence.annuelle.code,
        'periodicite': 1,
        'dateFin': DateTime(2023, 12, 4, 14, 30)
      };
      // Arrange
      final transaction = TransactionSendCommand(
          action: "envoie",
          method: TransactionSendMethod.contact,
          solde: 123.0,
          alias: TransactionSendCommandAlias(value: "+221773242452"),
          contact: TransactionSendCommandContact(value: "+221773242452"),
          amount: TransactionSendCommandAmount(value: 1000, solde: 2000),
          motif: TransactionSendCommandMotif(value: "aide famille"),
          schedule: transacationSchedule,
          compte: '1234');

      // Accept
      expect(transaction.toJson(), json);
    });

    test('fromTransaction test with alias', () {
      final transaction = Transaction(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientAlias: "+221773242452",
          endToEndId: "E12345555",
          dateOperation: DateTime.now(),
          compte: 'C2345454');

      expect(TransactionSendCommand.fromTransaction(transaction).alias!.value,
          TransactionSendCommandAlias(value: transaction.clientAlias).value);

      expect(TransactionSendCommand.fromTransaction(transaction).othr, null);
    });

    test('fromTransaction test with othr', () {
      final transaction = Transaction(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientCompte: "+221773242452",
          endToEndId: "E12345555",
          dateOperation: DateTime.now(),
          compte: 'C2345454');

      expect(TransactionSendCommand.fromTransaction(transaction).alias, null);

      expect(TransactionSendCommand.fromTransaction(transaction).othr!.value,
          TransactionSendCommandOthr(value: transaction.clientCompte).value);
    });
  });
}
