import 'dart:async';

import 'package:pi_mobile_app/modules/transactions/domain/models/transaction.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_cancel_reason.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_confirm_command.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_liste.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_schedule.dart';
import 'package:pi_mobile_app/modules/transactions/ports/output/transaction_output_port.dart';

class MockTransactionOutputPort implements TransactionOutputPort {
  @override
  Future<Stream<Transaction>> confirm(TransactionConfirmCommand command) async {
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

    return Stream.value(Transaction.fromJson(transactionJson));
  }

  @override
  Future<Transaction> initiate(TransactionSendCommand command) async {
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
    return Transaction.fromJson(transactionJson);
  }

  @override
  Future<void> update(Transaction transaction) async {
    //
  }

  @override
  Future<Stream<Transaction>> returnFunds(Transaction transaction) async {
    final controller = StreamController<Transaction>();
    Future.delayed(
      const Duration(seconds: 1),
      () {
        transaction.retourDate = DateTime.now();
        transaction.retourStatut = TransactionStatut.irrevocable;
        controller.add(transaction);
      },
    );
    return controller.stream;
  }

  @override
  Future<Transaction> cancel(
      Transaction transaction, TransactionCancelReason reason) async {
    return transaction;
  }

  @override
  Future<Transaction> get(String reference) async {
    return Transaction(
        montant: 100.00,
        sens: TransactionSens.debit,
        motif: "Achat en ligne",
        clientNom: "Amadou Ndiaye Dioum",
        clientPays: "SN",
        clientPSP: "SNB000",
        clientCompte: "Compte123",
        endToEndId: reference,
        compte: 'C2345454');
  }

  @override
  Future<Transaction> reject(Transaction transaction, String reason, {isRtp = false}) async {
    return Transaction(
        montant: 100.00,
        sens: TransactionSens.debit,
        motif: "Achat en ligne",
        clientNom: "Amadou Ndiaye Dioum",
        clientPays: "SN",
        clientPSP: "SNB000",
        clientCompte: "Compte123",
        endToEndId: transaction.endToEndId,
        dateOperation: DateTime.now(),
        compte: 'C2345454');
  }

  @override
  Future<Transaction> schedule(
      String endToEndId, TransactionConfirmCommand confirmCommand, TransactionSendCommandSchedule command) async {
    return Transaction(
        montant: 100.00,
        sens: TransactionSens.debit,
        motif: "Achat en ligne",
        clientNom: "Amadou Ndiaye Dioum",
        clientPays: "SN",
        clientPSP: "SNB000",
        clientCompte: "Compte123",
        endToEndId: endToEndId,
        dateOperation: DateTime.now(),
        compte: 'C2345454');
  }

  @override
  Future<TransactionListe> list(
      {required String compte,
      String? alias,
      int? page,
      int? limit,
      String? sortBy,
      String? fields,
      String? sens,
      DateTime? dateOperationDebut,
      DateTime? dateOperationFin,
      List<String>? categories,
      String? keyword}) async {
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
          "endToEndId": "ESNB00120230221153554KXvozkpNvhUk9e",
          "compte": "C2345454",
          "dateOperation": "2019-08-20T14:15:22.999Z"
        },
        {
          "montant": 100000.00,
          "sens": "debit",
          "clientNom": "Mariam Traore",
          "clientPays": "TG",
          "clientAlias": "e35bf776-a2d3-4693-9461-df5bfab95472",
          "endToEndId": "ESNB00120230219153554KXvozkpNvhUk7a",
          "compte": "C2345454",
          "dateOperation": "2019-08-18T14:15:22.999Z"
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
          "clientPays": "CI",
          "clientCompte": "e35bf776-a2d3-4693-9461-df5bfab95472",
          "endToEndId": "ESNB00120230221153554KXvozkpNvhUk9e",
          "compte": "C2345454",
          "dateOperation": "2019-08-20T14:15:22.999Z"
        },
        {
          "montant": 100000.00,
          "sens": "credit",
          "clientNom": "Khadidja Ndiaye",
          "clientPays": "TG",
          "clientCompte": "e35bf776-a2d3-4693-9461-df5bfab95472",
          "endToEndId": "ESNB00120230219153554KXvozkpNvhUk7a",
          "compte": "C2345454",
          "dateOperation": "2019-08-18T14:15:22.999Z"
        },
        {
          "montant": 100000.00,
          "sens": "credit",
          "clientNom": "Mboré Seye",
          "clientPays": "TG",
          "clientCompte": "e35bf776-a2d3-4693-9461-df5bfab95472",
          "endToEndId": "ESNB00120230219153554KXvozkpNvhUk7a",
          "compte": "C2345454",
          "dateOperation": "2019-08-18T14:15:22.999Z"
        },
        {
          "montant": 100.00,
          "sens": "debit",
          "motif": "Achat en ligne",
          "clientNom": "Amadou Ndiaye Dioum",
          "clientPays": "SN",
          "clientPSP": "SNB000",
          "clientCompte": "Compte123",
          "compte": "C2345454",
          "endToEndId": "E2E123",
          "dateOperation": "2019-08-24T14:15:22.999Z"
        }
      ],
      "meta": {"total": 10, "limit": 8}
    };

    return TransactionListe.fromJson(transactionJson);
  }

  @override
  Future<TransactionListe> search(
      {required String compte,
      String? alias,
      int? page,
      int? limit,
      String? sortBy,
      String? fields,
      String? sens,
      DateTime? dateOperationDebut,
      DateTime? dateOperationFin,
      List<String>? categories,
      String? keyword}) async {
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
          "endToEndId": "ESNB00120230221153554KXvozkpNvhUk9e",
          "compte": "C2345454",
          "dateOperation": "2019-08-20T14:15:22.999Z"
        },
        {
          "montant": 100000.00,
          "sens": "debit",
          "clientNom": "Mariam Traore",
          "clientPays": "TG",
          "clientAlias": "e35bf776-a2d3-4693-9461-df5bfab95472",
          "endToEndId": "ESNB00120230219153554KXvozkpNvhUk7a",
          "compte": "C2345454",
          "dateOperation": "2019-08-18T14:15:22.999Z"
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
          "clientPays": "CI",
          "clientCompte": "e35bf776-a2d3-4693-9461-df5bfab95472",
          "endToEndId": "ESNB00120230221153554KXvozkpNvhUk9e",
          "compte": "C2345454",
          "dateOperation": "2019-08-20T14:15:22.999Z"
        },
        {
          "montant": 100000.00,
          "sens": "credit",
          "clientNom": "Khadidja Ndiaye",
          "clientPays": "TG",
          "clientCompte": "e35bf776-a2d3-4693-9461-df5bfab95472",
          "endToEndId": "ESNB00120230219153554KXvozkpNvhUk7a",
          "compte": "C2345454",
          "dateOperation": "2019-08-18T14:15:22.999Z"
        },
        {
          "montant": 100000.00,
          "sens": "credit",
          "clientNom": "Mboré Seye",
          "clientPays": "TG",
          "clientCompte": "e35bf776-a2d3-4693-9461-df5bfab95472",
          "endToEndId": "ESNB00120230219153554KXvozkpNvhUk7a",
          "compte": "C2345454",
          "dateOperation": "2019-08-18T14:15:22.999Z"
        },
        {
          "montant": 100.00,
          "sens": "debit",
          "motif": "Achat en ligne",
          "clientNom": "Amadou Ndiaye Dioum",
          "clientPays": "SN",
          "clientPSP": "SNB000",
          "clientCompte": "Compte123",
          "compte": "C2345454",
          "endToEndId": "E2E123",
          "dateOperation": "2019-08-24T14:15:22.999Z"
        }
      ],
      "meta": {"total": 10, "limit": 8}
    };

    return TransactionListe.fromJson(transactionJson);
  }

  @override
  Future<TransactionListe> fetchHistory({required DateTime startDate, required DateTime endDate, required int size, required int page}) {
    // TODO: implement fetchHistory
    throw UnimplementedError();
  }
}
