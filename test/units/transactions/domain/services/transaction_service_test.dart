import 'dart:ffi';

import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_cancel_reason.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_reject_reason.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_confirm_command.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_liste.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_amount.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_motif.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_schedule.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_method.dart';
import 'package:pi_mobile_app/modules/transactions/domain/services/transaction_service.dart';
import 'package:pi_mobile_app/shared/models/frequence_command.dart';

import '../infra/transaction_remote_port_mock.dart';

void main() {
  group('TransactionListe - cas succès', () {
    TransactionService service =
        TransactionService(MockTransactionOutputPort());

    test("TransactionListe - List ", () async {
      final transactionJson = {
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
            "clientPSP": "SNB000",
            "compte": "C2345454",
            "clientCompte": "Compte123",
            "endToEndId": "E2E123",
            "dateOperation": "2019-08-24T14:15:22.999Z"
          },
          {
            "montant": 55500.00,
            "sens": "credit",
            "clientNom": "Drissa Sanou",
            "clientPays": "CI",
            "compte": "C2345454",
            "clientCompte": "e35bf776-a2d3-4693-9461-df5bfab95472",
            "endToEndId": "ESNB00120230221153554KXvozkpNvhUk9e",
            "dateOperation": "2019-08-20T14:15:22.999Z"
          },
          {
            "montant": 100000.00,
            "sens": "credit",
            "clientNom": "Khadidja Ndiaye",
            "clientPays": "TG",
            "compte": "C2345454",
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
      await service
          .list(
            compte: "C2345454",
          )
          .then((value) => () {
                expect(value, TransactionListe.fromJson(transactionJson));
              });
    });

    test("TransactionListe - searchLocally ", () async {
      final transactionJson = {
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
      await service
          .search(
            compte: "C2345454",
          )
          .then((value) => () {
                expect(value, TransactionListe.fromJson(transactionJson));
              });
    });

    test("TransactionListe - initier ", () async {
      await service
          .initiate(TransactionSendCommand(
              compte: "C2345454",
              action: TransactionSendCommand.actionSendNow,
              method: TransactionSendMethod.alias))
          .then((value) => () {
                expect(value.endToEndId, "E2E123");
              });
    });

    test("TransactionListe - confirmer ", () async {
      final transactionJson = {
        "montant": 100.00,
        "sens": "debit",
        "motif": "Achat en ligne",
        "clientNom": "Amadou Ndiaye Dioum",
        "clientPays": "SN",
        "clientPSP": "SNB000",
        "clientCompte": "Compte123",
        "endToEndId": "E2E123",
        "compte": "C2345454",
        "dateOperation": "2019-08-24T14:15:22.999Z"
      };

      await service
          .confirm(TransactionConfirmCommand(
              confirmationDate: "2019-08-24T14:15:22.999Z",
              endToendId: "E2E123",
              confirmationMethode: "ok",
              motif: TransactionSendCommandMotif(value: "aide famille"),
              amount: TransactionSendCommandAmount(value: 3, solde: 2000)))
          .then((value) => () {
                expect(value, Transaction.fromJson(transactionJson));
              });
    });

    test("TransactionListe - update ", () async {
      final transaction = Transaction(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientCompte: "Compte123",
          endToEndId: "E2E123",
          compte: 'C2345454',
          dateOperation: DateTime.now());

      var result = await service.update(transaction);
      expect(() => result, isA<void>());
    });

    test("Transaction: returnFunds", () async {
      final transaction = Transaction(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientCompte: "Compte123",
          endToEndId: "E2E123",
          compte: 'C2345454',
          dateOperation: DateTime.now());

      var result = await service.returnFunds(transaction);
      expect(result, isInstanceOf<Stream<Transaction>>());
    });

    test("Transaction: cancel", () async {
      final transaction = Transaction(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientCompte: "Compte123",
          endToEndId: "E2E123",
          compte: 'C2345454',
          dateOperation: DateTime.now());

      var result =
          await service.cancel(transaction, TransactionCancelReason.dejaPaye);

      expect(result, transaction);
    });

    test("Transaction: get", () async {
      var result = await service.get("1234Eefrffef");

      expect(result.endToEndId, "1234Eefrffef");
    });

    test("schedule test", () async {
      final frequence =
          FrequenceCommand(value: Frequence.annuelle, periodicite: 1);

      final transacationSchedule = TransactionSendCommandSchedule(
          dateDebut: DateTime(2023, 12, 4, 14, 30),
          dateFin: DateTime(2023, 12, 4, 14, 30),
          frequence: frequence,
          error: TransactionSendCommandScheduleError.debutEmpty);

      var result = await service.schedule("E2E123", transacationSchedule);

      expect(result.endToEndId, "E2E123");
    });

    test("reject test", () async {
      final transaction = Transaction(
          montant: 100.00,
          sens: TransactionSens.debit,
          motif: "Achat en ligne",
          clientNom: "Amadou Ndiaye Dioum",
          clientPays: "SN",
          clientPSP: "SNB000",
          clientCompte: "Compte123",
          endToEndId: "E2E123",
          compte: 'C2345454',
          dateOperation: DateTime.now());

      var result = await service.reject(
          transaction, TransactionRejectReason.erreurMontant);

      expect(result.endToEndId, transaction.endToEndId);
    });
  });
}
