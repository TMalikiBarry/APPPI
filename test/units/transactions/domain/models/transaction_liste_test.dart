import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_liste.dart';
import 'package:pi_mobile_app/shared/models/liste_meta.dart';

void main() {
  group('Valid', () {
    test('Valid other', () async {
      // Arrange
      final json = {
        "data": [
          {
            "montant": 100.00,
            "sens": "debit",
            "motif": "Achat en ligne",
            "clientNom": "Christian Pouye",
            "clientPays": "SN",
            "clientPhoto":
                "https://sm.ign.com/ign_fr/cover/a/avatar-gen/avatar-generations_bssq.jpg",
            "clientPSP": "SNB000",
            "clientCompte": "Compte123",
            "endToEndId": "E2E123",
            "compte": "C2345454",
            "dateOperation": "2019-08-24T14:15:22.999Z"
          },
          {
            "montant": 55500.00,
            "sens": "credit",
            "clientNom": "Fougnigue Marc Arnauld Soro",
            "clientPays": "CI",
            "compte": "C2345454",
            "endToEndId": "ESNB00120230221153554KXvozkpNvhUk9e",
            "dateOperation": "2019-08-20T14:15:22.999Z"
          },
          {
            "montant": 100000.00,
            "sens": "debit",
            "clientNom": "Mariam Traore",
            "clientPays": "TG",
            "compte": "C2345454",
            "clientAlias": "e35bf776-a2d3-4693-9461-df5bfab95472",
            "endToEndId": "ESNB00120230219153554KXvozkpNvhUk7a",
            "dateOperation": "2019-08-18T14:15:22.999Z"
          },
          {
            "montant": 100.00,
            "sens": "debit",
            "motif": "Achat en ligne",
            "clientNom": "Mamadou Doucouré",
            "clientPays": "SN",
            "compte": "C2345454",
            "clientPSP": "SNB000",
            "clientCompte": "Compte123",
            "endToEndId": "E2E123",
            "dateOperation": "2019-08-24T14:15:22.999Z"
          },
          {
            "montant": 55500.00,
            "sens": "credit",
            "clientNom": "Drissa Sanou",
            "compte": "C2345454",
            "clientPays": "CI",
            "clientCompte": "e35bf776-a2d3-4693-9461-df5bfab95472",
            "endToEndId": "ESNB00120230221153554KXvozkpNvhUk9e",
            "dateOperation": "2019-08-20T14:15:22.999Z"
          },
          {
            "montant": 100000.00,
            "sens": "credit",
            "clientNom": "Khadidja Ndiaye",
            "compte": "C2345454",
            "clientPays": "TG",
            "clientCompte": "e35bf776-a2d3-4693-9461-df5bfab95472",
            "endToEndId": "ESNB00120230219153554KXvozkpNvhUk7a",
            "dateOperation": "2019-08-18T14:15:22.999Z"
          },
          {
            "montant": 100000.00,
            "sens": "credit",
            "clientNom": "Mboré Seye",
            "compte": "C2345454",
            "clientPays": "TG",
            "clientCompte": "e35bf776-a2d3-4693-9461-df5bfab95472",
            "endToEndId": "ESNB00120230219153554KXvozkpNvhUk7a",
            "dateOperation": "2019-08-18T14:15:22.999Z"
          },
          {
            "montant": 100.00,
            "sens": "debit",
            "motif": "Achat en ligne",
            "compte": "C2345454",
            "clientNom": "Amadou Ndiaye Dioum",
            "clientPays": "SN",
            "clientPSP": "SNB000",
            "clientCompte": "Compte123",
            "endToEndId": "E2E123",
            "dateOperation": "2019-08-24T14:15:22.999Z"
          }
        ],
        "meta": {"total": 10, "limit": 8}
      };

      final transactionListe = TransactionListe.fromJson(json);
      // Accept
      expect(transactionListe, transactionListe);
    });

    test('isNotEmpty', () {
      // Arrange
      final json = {
        "data": [
          {
            "montant": 100.00,
            "sens": "debit",
            "motif": "Achat en ligne",
            "clientNom": "Christian Pouye",
            "clientPays": "SN",
            "clientPhoto":
                "https://sm.ign.com/ign_fr/cover/a/avatar-gen/avatar-generations_bssq.jpg",
            "clientPSP": "SNB000",
            "clientCompte": "Compte123",
            "endToEndId": "E2E123",
            "compte": "C2345454",
            "dateOperation": "2019-08-24T14:15:22.999Z",
            "statut": "irrevocable"
          },
          {
            "montant": 55500.00,
            "sens": "credit",
            "clientNom": "Fougnigue Marc Arnauld Soro",
            "clientPays": "CI",
            "endToEndId": "ESNB00120230221153554KXvozkpNvhUk9e",
            "dateOperation": "2019-08-20T14:15:22.999Z",
            "compte": "C2345454",
            "statut": "rejete"
          },
          {
            "montant": 100000.00,
            "sens": "debit",
            "clientNom": "Mariam Traore",
            "clientPays": "TG",
            "clientAlias": "e35bf776-a2d3-4693-9461-df5bfab95472",
            "endToEndId": "ESNB00120230219153554KXvozkpNvhUk7a",
            "dateOperation": "2019-08-18T14:15:22.999Z",
            "compte": "C2345454",
            "statut": "initie"
          },
          {
            "montant": 100.00,
            "sens": "debit",
            "motif": "Achat en ligne",
            "clientNom": "Mamadou Doucouré",
            "clientPays": "SN",
            "clientPSP": "SNB000",
            "clientCompte": "Compte123",
            "compte": "C2345454",
            "endToEndId": "E2E123",
            "dateOperation": "2019-08-24T14:15:22.999Z"
          },
          {
            "montant": 55500.00,
            "sens": "credit",
            "clientNom": "Drissa Sanou",
            "compte": "C2345454",
            "clientPays": "CI",
            "clientCompte": "e35bf776-a2d3-4693-9461-df5bfab95472",
            "endToEndId": "ESNB00120230221153554KXvozkpNvhUk9e",
            "dateOperation": "2019-08-20T14:15:22.999Z"
          },
          {
            "montant": 100000.00,
            "sens": "credit",
            "clientNom": "Khadidja Ndiaye",
            "compte": "C2345454",
            "clientPays": "TG",
            "clientCompte": "e35bf776-a2d3-4693-9461-df5bfab95472",
            "endToEndId": "ESNB00120230219153554KXvozkpNvhUk7a",
            "dateOperation": "2019-08-18T14:15:22.999Z"
          },
          {
            "montant": 100000.00,
            "sens": "credit",
            "clientNom": "Mboré Seye",
            "compte": "C2345454",
            "clientPays": "TG",
            "clientCompte": "e35bf776-a2d3-4693-9461-df5bfab95472",
            "endToEndId": "ESNB00120230219153554KXvozkpNvhUk7a",
            "dateOperation": "2019-08-18T14:15:22.999Z",
            'annulationDate': '2023-12-04T14:30:00.000'
          },
          {
            "montant": 100.00,
            "sens": "debit",
            "motif": "Achat en ligne",
            "compte": "C2345454",
            "clientNom": "Amadou Ndiaye Dioum",
            "clientPays": "SN",
            "clientPSP": "SNB000",
            "clientCompte": "Compte123",
            "endToEndId": "E2E123",
            "dateOperation": "2019-08-24T14:15:22.999Z",
            "retourDate": "2019-08-24T14:15:22.999Z"
          }
        ],
        "meta": {"total": 10, "limit": 8}
      };

      final transactionListe = TransactionListe.fromJson(json);

      // Accept
      expect(transactionListe.data.isNotEmpty, isTrue);
    });

    test('addTransactions test', () {
      // Arrange
      final json = {
        "data": [
          {
            "montant": 100.00,
            "sens": "debit",
            "motif": "Achat en ligne",
            "clientNom": "Christian Pouye",
            "clientPays": "SN",
            "clientPhoto":
                "https://sm.ign.com/ign_fr/cover/a/avatar-gen/avatar-generations_bssq.jpg",
            "clientPSP": "SNB000",
            "clientCompte": "Compte123",
            "endToEndId": "E2E123",
            "compte": "C2345454",
            "dateOperation": "2019-08-24T14:15:22.999Z",
            "statut": "irrevocable"
          },
        ],
        "meta": {"total": 1, "limit": 8}
      };

      final transactionListe = TransactionListe.fromJson(json);

      transactionListe.addTransactions([
        Transaction(
            montant: 100.00,
            sens: TransactionSens.debit,
            motif: "Achat en ligne",
            clientNom: "Amadou Ndiaye Dioum",
            clientPSPNom: "SBANK",
            clientCompte: "FMASORO123",
            clientPays: "SN",
            clientPSP: "SNB000",
            clientAlias: "539335b7-ed13-408a-995e-83cb0f3ce0a5",
            endToEndId: "E2E123000000000",
            compte: 'C2345454',
            dateOperation: DateTime(2023, 12, 4, 14, 30))
      ]);
      // Accept
      expect(transactionListe.data[1].endToEndId, "E2E123000000000");
    });

    test('toJson test', () {
      // Arrange
      final transactionJson = {
        "data": [
          {
            "montant": 100.00,
            "sens": "debit",
            "motif": "Achat en ligne",
            "clientNom": "Christian Pouye",
            "clientPays": "SN",
            "clientPSP": "SNB000",
            "clientCompte": "Compte123",
            "endToEndId": "E2E123",
            "compte": "C2345454",
            "dateOperation": "2019-08-24T14:15:22.999Z"
          }
        ],
        "meta": {"total": 1, "limit": 8}
      };

      final transactionList = TransactionListe.fromJson(transactionJson);
      // Accept
      final expectedJson = {
        "meta": {
          "total": "1",
          "limit": "8",
          "previous": null,
          "current": null,
          "next": null
        },
        "data": [
          {
            "compte": "C2345454",
            "alias": null,
            "montant": "100.0",
            "sens": "debit",
            "motif": "Achat en ligne",
            "clientNom": "Christian Pouye",
            "clientPays": "SN",
            "clientPSP": "SNB000",
            "clientPSPNom": null,
            "clientCompte": "Compte123",
            "clientAlias": null,
            "endToEndId": "E2E123",
            "canal": null,
            "dateOperation": "2019-08-24T14:15:22.999Z",
            "statut": null,
            "categorie": null,
            "facture": null,
            "txId": null,
            "subscriptionId": null,
            "dateExpiration": null,
            "dateDebut": null,
            "dateFin": null,
            "frequence": null,
            "periodicite": null,
            "retourDate": null,
            "retourStatut": null,
            "retourStatutRaison": null,
            "annulationRaison": null,
            "annulationDate": null,
            "annulationStatut": null,
            "annulationStatutRaison": null,
            "dateReponse": null,
            "remise": null,
            "retraitAchat": null,
            "montantFrais": null,
            "retraitMontant": null,
            "retraitFrais": null,
            "differe": null,
            "differeFrequence": null,
            "differeOccurence": null,
            "differeMontant": null
          }
        ]
      };
      expect(transactionList.toJson(), expectedJson);
    });
  });
  group('Errors', () {
    test('Empty', () {
      // Arrange
      final transactionListe =
          TransactionListe(data: [], meta: ListeMeta(total: 0, limit: 0));

      // Accept
      expect(transactionListe.data.isEmpty, isTrue);
    });
  });
}

Future<dynamic> retrieveData(String resourcePath) async {
  final String data = await rootBundle.loadString("assets/json/$resourcePath");
  final map = jsonDecode(data);
  return map;
}
