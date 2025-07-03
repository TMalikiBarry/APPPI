import 'dart:async';
import 'dart:convert';

import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api.dart';
import '../../../core/env.dart';
import '../domain/models/transaction.dart';
import '../domain/models/transaction_cancel_reason.dart';
import '../domain/models/transaction_liste.dart';
import '../domain/models/transaction_send/transaction_confirm_command.dart';
import '../domain/models/transaction_send/transaction_send_command.dart';
import '../domain/models/transaction_send/transaction_send_command_schedule.dart';
import '../domain/models/transaction_send/transaction_send_response.dart';

/// Online repository
class TransactionOutputRemote {
  ///
  TransactionOutputRemote();

  ///
  final logger = Logger();

  /// Lister les transactions
  Future<TransactionListe> list({
    required String compte,
    String? alias,
    int? page,
    int? limit,
    String? sortBy,
    String? fields,
    String? sens,
    DateTime? dateOperationDebut,
    DateTime? dateOperationFin,
    String? keyword, // Nom du client et montant
  }) async {
    final Map<String, dynamic> queryParameters = {
      'compte': compte,
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
      if (sortBy != null) 'sortBy': sortBy,
      if (fields != null) 'fields': fields,
      if (sens != null) 'sens': sens,
      if (alias != null) 'alias': alias,
      if (dateOperationDebut != null) 'dateDebut': dateOperationDebut,
      if (dateOperationFin != null) 'dateFin': dateOperationFin,
      if (keyword != null) 'keyword': keyword,
    };

    final ApiResponse response = await Api.get(
      '/movement/history',
      queryParameters: queryParameters,
    );

    return TransactionListe.fromJson(response.data);
  }

  /// Recuperer une transaction
  Future<Transaction> get(String reference) async {
    final ApiResponse response = await Api.get(
      '/transferts/$reference/details',
    );
    return Transaction.fromJson(response.data);
  }

  /// Initier une transaction
  Future<Transaction> initiate(TransactionSendCommand command) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var phoneNumberFrom = pref.getString("phone_number");
    var userLogin = pref.getString('phoneNumber');
    // Send transfer
    Map<String, dynamic> request = command.toJson();
    request.addAll({
      'aliasFrom': phoneNumberFrom,
      'phoneNumberFrom': phoneNumberFrom,
      'userLogin': userLogin,
    });
    final ApiResponse response = await Api.post(
      '/transfer/eme/external',
      data: request,
    );
    //
    return Transaction.fromJson(response.data);
  }

  /// Programmer une transaction
  Future<Transaction> schedule(
    String endToEndId,
    TransactionSendCommandSchedule command,
  ) async {
    // Schedule transfer
    var datas = command.toJson();
    datas["endToEndId"] = endToEndId;
    final ApiResponse response = await Api.post('/souscriptions', data: datas);
    //
    return Transaction.fromJson(response.data);
  }

  /// Génère les headers communs pour les requêtes SSE
  Map<String, String> _getSSEHeaders(String? accessToken) {
    return {
      "Accept": "text/event-stream",
      "Cache-Control": "no-cache",
      "Authorization": "Bearer $accessToken",
    };
  }

  Future<Stream<Transaction>> confirm(
    String endToEndId,
    TransactionConfirmCommand command,
  ) async {
    // Send transfer
    final ApiResponse response = await Api.put(
      '/transferts/$endToEndId',
      data: command.toJson(),
    );

    Transaction transaction = Transaction.fromJson(response.data);

    // GET REQUEST
    try {
      if (AppEnv.mode == "demo") {
        // TODO remove this demo code before release
        final controller = StreamController<Transaction>();
        Future.delayed(
          const Duration(seconds: 1),
          () {
            transaction.dateOperation = DateTime.now();
            transaction.statut = TransactionStatut.irrevocable;
            controller.add(transaction);
          },
        );
        return controller.stream;
      } //
      else {
        return streamResponse(transaction);
      }
    } catch (e) {
      logger.e("Reception reponse erreur", error: e);
      return Stream.error(e);
    }
  }

  Stream<Transaction> streamResponse(Transaction transaction) async* {
    const timeoutDuration = Duration(seconds: 30); // Timeout configurable
    String? accessToken = await Api.secureStorage.read(key: "ACCESS_TOKEN");
    await for (final event in SSEClient.subscribeToSSE(
      method: SSERequestType.GET,
      url: '${Api.url}/transferts/${transaction.endToEndId}/reponses',
      header: _getSSEHeaders(accessToken),
    ).timeout(
      timeoutDuration,
      onTimeout: (eventSink) {
        eventSink.addError(TimeoutException('Timeout after $timeoutDuration'));
        eventSink.close();
      },
    )) {
      try {
        logger.i("Received response => ${event.data}");

        if (event.data != null) {
          final ack = TransactionSendResponse.fromJson(jsonDecode(event.data!));
          transaction
            ..dateOperation = ack.dateIrrevocabilite
            ..statut = TransactionStatut.values
                .where((element) => element.name == ack.statut)
                .first
            ..statutRaison = ack.codeRejet;
        }
        yield transaction;
      } catch (e) {
        logger.e("Data parsing error", error: e);
        yield* _emitErrorState(transaction, 'Invalid data format');
      }
    }
  }

  // Helper pour émettre une transaction en erreur avant de propager l'exception
  Stream<Transaction> _emitErrorState(
    Transaction transaction,
    String error,
  ) async* {
    transaction
      ..statut = TransactionStatut.rejete
      ..statutRaison = error;
    yield transaction;
    // Optionnel : yield* Stream.error(error); // Pour propager l'erreur après avoir notifié l'UI
  }

  /// Retourner les fonds
  Future<Stream<Transaction>> returnFunds(
    Transaction transaction,
  ) async {
    // Send transfer
    await Api.put('/transferts/${transaction.endToEndId}/retours');

    // GET REQUEST
    try {
      // TODO Remove this code before release
      if (AppEnv.mode == "demo") {
        final controller = StreamController<Transaction>();
        Future.delayed(
          const Duration(seconds: 1),
          () {
            if (transaction.endToEndId ==
                "ESNB00120240101153554Destinataire9e") {
              transaction.retourStatut = TransactionStatut.rejete;
              transaction.retourStatutRaison = "AG10";
            } else if (transaction.endToEndId ==
                "ESNB00120240101153554Participant19e") {
              transaction.retourStatut = TransactionStatut.rejete;
              transaction.retourStatutRaison = "AM04";
            } else {
              transaction.annulationStatut = TransactionStatut.irrevocable;
              transaction.retourStatut = TransactionStatut.irrevocable;
              transaction.retourDate = DateTime.now();
            }

            controller.add(transaction);
          },
        );
        return controller.stream;
      } //
      else {
        String? accessToken = await Api.secureStorage.read(key: "ACCESS_TOKEN");
        return SSEClient.subscribeToSSE(
          method: SSERequestType.GET,
          url:
              '${Api.url}/transferts/${transaction.endToEndId}/retours/reponses',
          header: _getSSEHeaders(accessToken),
        ).map(
          (event) {
            logger.i("Received response after return => ${event.data}");
            if (event.data != null) {
              TransactionSendResponse ack = TransactionSendResponse.fromJson(
                jsonDecode(event.data!),
              );
              transaction.retourStatut = TransactionStatut.values
                  .where((element) => element.name == ack.statut)
                  .first;
              transaction.retourDate = ack.dateIrrevocabilite;
              transaction.retourStatutRaison = ack.codeRejet;
            }
            return transaction;
          },
        );
      }
    } catch (e) {
      logger.e("Reception reponse retour de fonds erreur", error: e);
      return Stream.error(e);
    }
  }

  Future<Transaction> cancel(
    Transaction transaction,
    TransactionCancelReason reason,
  ) async {
    // Send transfer
    final ApiResponse response = await Api.put(
      '/transferts/${transaction.endToEndId}/annulations',
      data: {"raison": reason.code},
    );
    //
    return Transaction.fromJson(response.data);
  }

  Future<Transaction> reject(
    Transaction transaction,
    String reason,
  ) async {
    // Send transfer
    final ApiResponse response = await Api.put(
      '/transferts/${transaction.endToEndId}/rejets',
      data: {"raison": reason},
    );
    //
    return Transaction.fromJson(response.data);
  }
}
