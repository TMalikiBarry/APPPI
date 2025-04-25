import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_cancel_reason.dart';
import 'package:pi_mobile_app/shared/models/frequence_command.dart';

void main() {
  group('Valid', () {
    test('toJson test ', () {
      // Arrange
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
          dateExpiration: DateTime(2023, 12, 4, 14, 30),
          dateDebut: DateTime(2023, 12, 4, 14, 30),
          dateFin: DateTime(2023, 12, 4, 14, 30),
          dateOperation: DateTime(2023, 12, 4, 14, 30),
          dateDemande: DateTime(2023, 12, 4, 14, 30),
          dateReponse: DateTime(2023, 12, 4, 14, 30),
          frequence: Frequence.quotidienne,
          annulationRaison: TransactionCancelReason.erreurDestinataire,
          remise: 1,
          retraitAchat: 25,
          retraitMontant: 100,
          retraitFrais: 10,
          differe: true,
          differeFrequence: Frequence.hebdomadaire,
          differeOccurence: 1,
          differeMontant: 100,
          periodicite: 2,
          compte: 'C2345454');

      // Accept
      final json = {
        "compte": "C2345454",
        "alias": null,
        "montant": "100.0",
        "sens": "debit",
        "motif": "Achat en ligne",
        "clientNom": "Amadou Ndiaye Dioum",
        "clientPays": "SN",
        "clientPSP": "SNB000",
        "clientPSPNom": "SBANK",
        "clientCompte": "FMASORO123",
        "clientAlias": "539335b7-ed13-408a-995e-83cb0f3ce0a5",
        "endToEndId": "E2E123",
        "canal": null,
        "dateOperation": "2023-12-04T14:30:00.000",
        "statut": null,
        "categorie": null,
        "facture": null,
        "txId": null,
        "subscriptionId": null,
        "dateExpiration": "2023-12-04T14:30:00.000",
        "dateDebut": "2023-12-04T14:30:00.000",
        "dateFin": "2023-12-04T14:30:00.000",
        "frequence": "J",
        "periodicite": "2",
        "retourDate": null,
        "retourStatut": null,
        "retourStatutRaison": null,
        "annulationRaison": "AC03",
        "annulationDate": null,
        "annulationStatut": null,
        "annulationStatutRaison": null,
        "dateReponse": "2023-12-04T14:30:00.000",
        "remise": "1.0",
        "retraitAchat": "25.0",
        "retraitMontant": "100.0",
        "retraitFrais": "10.0",
        "montantFrais": null,
        "differe": true,
        "differeFrequence": "S",
        "differeOccurence": "1",
        "differeMontant": "100.0"
      };
      expect(transaction.toJson(), json);
    });

    test('fromJson test ', () {
      // Accept
      final json = {
        "compte": "C2345454",
        "alias": null,
        "montant": "100.0",
        "sens": "debit",
        "motif": "Achat en ligne",
        "clientNom": "Amadou Ndiaye Dioum",
        "clientPays": "SN",
        "clientPSP": "SNB000",
        "clientCompte": "FMASORO123",
        "clientAlias": "539335b7-ed13-408a-995e-83cb0f3ce0a5",
        "endToEndId": "E2E123",
        "canal": null,
        "dateOperation": "2023-12-04T14:30:00.000",
        "statut": 'desactive',
        "categorie": null,
        "facture": null,
        "dateExpiration": "2023-12-04T14:30:00.000",
        "dateDebut": "2023-12-04T14:30:00.000",
        "dateFin": "2023-12-04T14:30:00.000",
        "frequence": "J",
        "periodicite": "2",
        "retourDate": null,
        "retourStatut": 'desactive',
        "retourStatutRaison": null,
        "annulationRaison": "AC03",
        "annulationDate": null,
        "annulationStatut": 'desactive',
        "annulationStatutRaison": null,
        "dateReponse": "2023-12-04T14:30:00.000",
        "remise": "1.0",
        "retraitAchat": "25.0",
        "retraitMontant": "100.0",
        "retraitFrais": "10.0",
        "montantFrais": 100.0,
        "differe": true,
        "differeFrequence": "S",
        "differeOccurence": "1",
        "differeMontant": "100.0"
      };

      expect(Transaction.fromJson(json).differe, json["differe"]);
    });

    test('Valid String', () {
      // Arrange
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
          compte: 'C2345454',
          dateOperation: DateTime(2023, 12, 4, 14, 30));

      // Accept
      final stringTransaction =
          'Transaction { compte: C2345454, alias: null, montant: 100.0, sens: TransactionSens.debit, motif: Achat en ligne, canal: null, clientNom: Amadou Ndiaye Dioum, clientPays: SN, clientPSP: SNB000, clientPSPNom: SBANK, clientPhoto: null, clientCompte: FMASORO123, clientAlias: 539335b7-ed13-408a-995e-83cb0f3ce0a5, endToEndId: E2E123, dateOperation: 2023-12-04 14:30:00.000, statut: null, statutRaison: null, categorie: null, facture: null, dateDebut: null, dateFin: null, frequence: null, periodicite: null, retourDate: null, retourStatut: null, retourStatutRaison: null annulationDate: null, annulationRaison: null, annulationStatut: null, annulationStatutRaison: null, dateExpiration: null, dateReponse: null, remise: null, retraitAchat: null, retraitMontant: null, retraitFrais: null, differe: null, differeFrequence: null, differeOccurence: null, differeMontant: null }';
      expect(transaction.toString(), stringTransaction);
    });
  });

  group('RTP TEST', () {
    test('isRTP test ', () {
      // Arrange
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
          canal: "631",
          compte: 'C2345454',
          dateOperation: DateTime(2023, 12, 4, 14, 30));

      expect(transaction.isRTP(), true);
    });

    test('canSchedule test ', () {
      // Arrange
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
          canal: "520",
          compte: 'C2345454',
          dateOperation: DateTime(2023, 12, 4, 14, 30));

      expect(transaction.canSchedule(), true);
    });

    test('isPICO test ', () {
      // Arrange
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
          canal: "520",
          retraitAchat: 1,
          compte: 'C2345454',
          dateOperation: DateTime(2023, 12, 4, 14, 30));

      expect(transaction.isPICO(), true);
    });

    test('isPICASH avec retraitAchat==0 test ', () {
      // Arrange
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
          retraitAchat: 0,
          retraitMontant: 100.0,
          txId: "Tx123",
          subscriptionId: "1ZEE",
          compte: 'C2345454',
          dateOperation: DateTime(2023, 12, 4, 14, 30));

      expect(transaction.isPICASH(), true);
    });

    test('isPICASH avec retraitAchat==null test ', () {
      // Arrange
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
          compte: 'C2345454',
          dateOperation: DateTime(2023, 12, 4, 14, 30));

      expect(transaction.isPICASH(), true);
    });
  });
}
