import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/subscription/domain/models/subscription.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction.dart';
import 'package:pi_mobile_app/shared/models/frequence_command.dart';

void main() {
  group('Subscription', () {
    test('hasStarted ', () {
      final souscription = Subscription(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPSPNom: "SBANK",
          clientCompte: "FMASORO123",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientAlias: "539335b7-ed13-408a-995e-83cb0f3ce0a5",
          endToEndId: "E2E123",
          dateDebut: DateTime(2023, 12, 4, 14, 30),
          dateFin: DateTime(2023, 12, 4, 14, 30),
          frequence: Frequence.quotidienne,
          periodicite: 2,
          compte: 'C2345454');

      expect(souscription.hasStarted(), isTrue);
    });

    test('isFinished with frequence', () {
      final souscription = Subscription(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPSPNom: "SBANK",
          clientCompte: "FMASORO123",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientAlias: "539335b7-ed13-408a-995e-83cb0f3ce0a5",
          endToEndId: "E2E123",
          dateDebut: DateTime.now(),
          dateFin: DateTime.now(),
          frequence: Frequence.quotidienne,
          periodicite: 2,
          compte: 'C2345454');

      expect(souscription.isFinished(), isTrue);
    });

    test('isFinished with frequence null', () {
      final souscription = Subscription(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPSPNom: "SBANK",
          clientCompte: "FMASORO123",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientAlias: "539335b7-ed13-408a-995e-83cb0f3ce0a5",
          endToEndId: "E2E123",
          dateDebut: DateTime(2023, 12, 4, 14, 30),
          dateFin: DateTime(2023, 12, 4, 14, 30),
          periodicite: 2,
          compte: 'C2345454');

      expect(souscription.isFinished(), isTrue);
    });

    test('fromTransaction with null frequence', () {
      final transaction = Transaction(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPSPNom: "SBANK",
          clientCompte: "FMASORO123",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientAlias: "539335b7-ed13-408a-995e-83cb0f3ce0a5",
          endToEndId: "E2E123",
          dateFin: DateTime(2023, 12, 4, 14, 30),
          periodicite: 2,
          compte: 'C2345454');

      expect(Subscription.fromTransaction(transaction).nextPaymentDate,
          transaction.dateDebut);
    });

    test('fromTransaction with now is before dateDebut', () {
      final transaction = Transaction(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPSPNom: "SBANK",
          clientCompte: "FMASORO123",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientAlias: "539335b7-ed13-408a-995e-83cb0f3ce0a5",
          endToEndId: "E2E123",
          dateDebut: DateTime.now(),
          dateFin: DateTime(2023, 12, 4, 14, 30),
          periodicite: 2,
          compte: 'C2345454');

      expect(Subscription.fromTransaction(transaction).nextPaymentDate,
          transaction.dateDebut);
    });

    test('fromTransaction with now is after dateFin', () {
      final transaction = Transaction(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPSPNom: "SBANK",
          clientCompte: "FMASORO123",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientAlias: "539335b7-ed13-408a-995e-83cb0f3ce0a5",
          endToEndId: "E2E123",
          dateDebut: DateTime(2023, 12, 4, 14, 30),
          dateFin: DateTime(2023, 12, 4, 14, 30),
          frequence: Frequence.quotidienne,
          periodicite: 2,
          compte: 'C2345454');

      expect(Subscription.fromTransaction(transaction).nextPaymentDate, null);
    });

    test('fromTransaction without dateFin and Frequence.quotidienne', () {
      final transaction = Transaction(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPSPNom: "SBANK",
          clientCompte: "FMASORO123",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientAlias: "539335b7-ed13-408a-995e-83cb0f3ce0a5",
          endToEndId: "E2E123",
          dateDebut: DateTime(2023, 12, 4, 14, 30),
          frequence: Frequence.quotidienne,
          periodicite: 2,
          compte: 'C2345454');

      expect(Subscription.fromTransaction(transaction).nextPaymentDate!.day,
          DateTime.now().day + transaction.periodicite!);
    });

    test('fromTransaction without dateFin and Frequence.hebdomadaire', () {
      final transaction = Transaction(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPSPNom: "SBANK",
          clientCompte: "FMASORO123",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientAlias: "539335b7-ed13-408a-995e-83cb0f3ce0a5",
          endToEndId: "E2E123",
          dateDebut: DateTime(2023, 12, 4, 14, 30),
          frequence: Frequence.hebdomadaire,
          periodicite: 2,
          compte: 'C2345454');

      expect(Subscription.fromTransaction(transaction).nextPaymentDate!.day,
          DateTime.now().day + transaction.periodicite! * 7);
    });

    test('fromTransaction without dateFin and Frequence.mensuelle', () {
      final transaction = Transaction(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPSPNom: "SBANK",
          clientCompte: "FMASORO123",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientAlias: "539335b7-ed13-408a-995e-83cb0f3ce0a5",
          endToEndId: "E2E123",
          dateDebut: DateTime.now(),
          frequence: Frequence.mensuelle,
          periodicite: 2,
          compte: 'C2345454');

      final debutDate = transaction.dateDebut!;
      expect(
          Subscription.fromTransaction(transaction).nextPaymentDate,
          DateTime(
            debutDate.year,
            debutDate.month + transaction.periodicite!,
            min(
                debutDate.day,
                DateTime(debutDate.year,
                        debutDate.month + transaction.periodicite! + 1, 0)
                    .day),
          ));
    });

    test(
        'fromTransaction without dateFin, month != 2, day != 29 and Frequence.annuelle',
        () {
      final transaction = Transaction(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPSPNom: "SBANK",
          clientCompte: "FMASORO123",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientAlias: "539335b7-ed13-408a-995e-83cb0f3ce0a5",
          endToEndId: "E2E123",
          dateDebut: DateTime.now(),
          frequence: Frequence.annuelle,
          periodicite: 2,
          compte: 'C2345454');

      final debutDate = transaction.dateDebut!;
      expect(
          Subscription.fromTransaction(transaction).nextPaymentDate,
          DateTime(debutDate.year + transaction.periodicite!, debutDate.month,
              debutDate.day));
    });

    test('fromTransaction: Frequence.annuelle with leap year', () {
      final transaction = Transaction(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPSPNom: "SBANK",
          clientCompte: "FMASORO123",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientAlias: "539335b7-ed13-408a-995e-83cb0f3ce0a5",
          endToEndId: "E2E123",
          dateDebut: DateTime(2020, 2, 29),
          frequence: Frequence.annuelle,
          periodicite: 4,
          compte: 'C2345454');

      expect(
          Subscription.fromTransaction(transaction).nextPaymentDate!.day, 29);
      expect(
          Subscription.fromTransaction(transaction).nextPaymentDate!.month, 2);
    });

    test('fromTransaction: Frequence.annuelle without leap year', () {
      final transaction = Transaction(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPSPNom: "SBANK",
          clientCompte: "FMASORO123",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientAlias: "539335b7-ed13-408a-995e-83cb0f3ce0a5",
          endToEndId: "E2E123",
          dateDebut: DateTime(2020, 2, 29),
          frequence: Frequence.annuelle,
          periodicite: 2,
          compte: 'C2345454');

      expect(
          Subscription.fromTransaction(transaction).nextPaymentDate!.day, 28);
      expect(
          Subscription.fromTransaction(transaction).nextPaymentDate!.month, 2);
    });

    test('fromJson test', () {
      final transaction = Transaction(
          montant: 100.0,
          sens: TransactionSens.debit,
          motif: 'Achat en ligne',
          clientNom: 'Amadou Ndiaye Dioum',
          clientPays: 'SN',
          clientPSP: 'SNB000',
          clientCompte: 'FMASORO123',
          clientAlias: '539335b7-ed13-408a-995e-83cb0f3ce0a5',
          endToEndId: 'E2E123',
          dateOperation: DateTime(2023, 12, 4, 14, 30),
          dateDebut: DateTime(2023, 12, 4, 14, 30),
          dateFin: DateTime(2023, 12, 4, 14, 30),
          frequence: Frequence.quotidienne,
          periodicite: 2,
          dateExpiration: DateTime(2023, 12, 4, 14, 30),
          dateReponse: DateTime(2023, 12, 4, 14, 30),
          dateDemande: DateTime(2023, 12, 4, 14, 30),
          remise: 1.0,
          retraitAchat: 25.0,
          retraitMontant: 100.0,
          retraitFrais: 10.0,
          differe: true,
          differeFrequence: Frequence.hebdomadaire,
          differeOccurence: 1,
          differeMontant: 100.0,
          compte: 'C2345454');

      // Accept
      final json = {
        'montant': '100.0',
        'sens': 'debit',
        'motif': 'Achat en ligne',
        'clientNom': 'Amadou Ndiaye Dioum',
        'clientPays': 'SN',
        'clientPSP': 'SNB000',
        'clientPSPNom': 'SBANK',
        'clientCompte': 'FMASORO123',
        'clientAlias': '539335b7-ed13-408a-995e-83cb0f3ce0a5',
        'endToEndId': 'E2E123',
        'dateOperation': '2023-12-04T14:30:00.000',
        'dateExpiration': '2023-12-04T14:30:00.000',
        'dateDebut': '2023-12-04T14:30:00.000',
        'dateFin': '2023-12-04T14:30:00.000',
        'dateDemande': '2023-12-04T14:30:00.000',
        'frequence': 'J',
        'dateReponse': '2023-12-04T14:30:00.000',
        'remise': '1.0',
        'retraitAchat': '25.0',
        'retraitMontant': '100.0',
        'retraitFrais': '10.0',
        'differe': true,
        'differeFrequence': 'S',
        'differeOccurence': 1,
        'differeMontant': "100.0",
        'periodicite': 2,
        'compte': 'C2345454'
      };
      expect(Subscription.fromJson(json).nextPaymentDate,
          Subscription.fromTransaction(transaction).nextPaymentDate);
    });
  });
}
