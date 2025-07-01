import 'dart:async';
import 'dart:convert';

import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:logger/logger.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/mappers/movement_mappers.dart';

// 1) On importe le modèle Transaction en n'important QUE les symboles dont on a besoin
import '../domain/models/transaction.dart'
    show Transaction, TransactionSens;

// 2) On importe la réponse de send transaction sans ramener TransactionSens
import '../domain/models/transaction_send/transaction_send_response.dart'
    hide TransactionSens;

import '../../../core/api.dart';
import '../../../core/env.dart';
import '../../../shared/models/liste_meta.dart';
import '../domain/models/new/movement_list_dto.dart';
import '../domain/models/transaction.dart';
import '../domain/models/transaction_cancel_reason.dart';
import '../domain/models/transaction_liste.dart';
import '../domain/models/transaction_send/transaction_confirm_command.dart';
import '../domain/models/transaction_send/transaction_send_command.dart';
import '../domain/models/transaction_send/transaction_send_command_schedule.dart';

/// Online repository
class TransactionOutputRemote {
  ///
  TransactionOutputRemote();

  ///
  final logger = Logger();

  final String token = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJVMkhtakpleFlmWHNJdzAwVU9GeUI0S1cxaEhmZ2dtRDZaSWRqdjhfTmlBIn0.eyJleHAiOjE3NTEzNzM5MjgsImlhdCI6MTc1MTM3MjEyOCwianRpIjoiNTdkOTdiYWItYjkxMS00NDI1LTkzYzQtNWE0YjliNWIyODFkIiwiaXNzIjoiaHR0cHM6Ly9pbnRvdWNoZ3UyLXFsZi53b3JsZGxpbmUtc29sdXRpb25zLmNvbS9hdXRoL3JlYWxtcy9zc28taW50b3VjaC1pYWNjIiwiYXVkIjpbImFnZW50YXBpIiwiYWNjb3VudCJdLCJzdWIiOiJkZjNkYzI5NS1kMGIxLTQ3YTctYjM0Mi05ZjViNTFiMDU5NGEiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJteXRvdWNocG9pbnQtYXBpIiwic2Vzc2lvbl9zdGF0ZSI6IjBiYjhhOGYyLTA0N2ItNDU3OC1iMTIzLTVjNGJmYzVjN2I3YiIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiaHR0cDovL2xvY2FsaG9zdDo4MDgyIl0sInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJkZWZhdWx0LXJvbGVzLXNzby1pbnRvdWNoLXFsZiIsIm9mZmxpbmVfYWNjZXNzIiwidW1hX2F1dGhvcml6YXRpb24iXX0sInJlc291cmNlX2FjY2VzcyI6eyJhZ2VudGFwaSI6eyJyb2xlcyI6WyJhZ2VudCIsImNsaWVudCIsImdyb3NzaXN0ZSJdfSwiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiMGJiOGE4ZjItMDQ3Yi00NTc4LWIxMjMtNWM0YmZjNWM3YjdiIiwiY291bnRyeSI6IlNOIiwiYWNjb3VudF9udW1iZXIiOiJTTkNDVVNUMjUwMDAwMDE2OCIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZ2VuZGVyIjoiTUFMRSIsImlkZW50aWZpYW50IjoiMjIxNzYxOTkyMjExIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiMjIxNzYxOTkyMjExIiwicHJvZHVjdF9jb2RlIjoiTVlUUCIsImdpdmVuX25hbWUiOiJNYWxpa2kiLCJwaG9uZU51bWJlciI6IisyMjE3NjE5OTIyMTEiLCJuYW1lIjoiTWFsaWtpIEJhcnJ5IiwicGhvbmVfbnVtYmVyIjoiKzIyMTc2MTk5MjIxMSIsImZhbWlseV9uYW1lIjoiQmFycnkiLCJlbWFpbCI6InRoaWVybm8uYmFycnkwMUBpbnRvdWNoZ3JvdXAubmV0In0.EBFZypkF6aPN0IdZKz3oCkomqg00RFG23gmuY9B3GBAQhX9bBgFOHaewb_7nvwJvzw5Gqp-cGfyfFHIKrrGE60244aGY8SfMKKM_4ZGgjs0aBIv5ns3cD0tVtvSvT_ZEAphwAFQPSj9sJeUso1cDdAiN6FgpPKvcIl2s3rKLYKyHGvXcomeXez2TRPi8TCcJJoaS_lgIR5Cjwy3_A1QmNnLQE1PEtzN8QHLLMgleHoHM9zCLhK5tY3XySKAph98x0tAxNmb7LD3fqauPTl1xfxH5VTqS1xX4PeIjqyCm_VMS-wCghpdPqgbhMe1YSn0oVM17fpTatHwDW8DUkUT3cA";

  /// Historique des transactions à partir du serveur
  Future<TransactionListe> history({
    DateTime? startDate,
    DateTime? endDate,
    int size = 10,
    int page = 0,
  }) async {
    final now    = DateTime.now();
    final start  = startDate ?? now.subtract(const Duration(days: 200));
    final finish = endDate   ?? now;

    final qs = {
      'startDate': start.toIso8601String().split('T').first,
      'endDate'  : finish.toIso8601String().split('T').first,
      'size'     : size.toString(),
      'page'     : page.toString(),
    };
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // 1) Appel relatif
    final resp = await Api.get(
      '/movement/history',
      queryParameters: qs,
      headers: headers,
    );

    // 2) Log pour debug
    logger.i('← history() status=${resp.statusCode}');
    logger.i('← history() data=${resp.data}');

    // 3) Validation minimale
    final raw = resp.data;
    if (raw == null || raw is! Map<String, dynamic>) {
      throw Exception('history() returned invalid data: $raw');
    }

    final envelope = raw['response'];
    if (envelope == null || envelope is! Map<String, dynamic>) {
      throw Exception('history() missing "response" field: $raw');
    }

    // 4) Désérialisation DTO
    final dto = MovementListDTO.fromJson(envelope);

    // 5) Récupère ton numéro (ou une valeur par défaut)
    final myPhone = await Api.secureStorage.read(key: 'PHONE') ?? '';

    // 6) Mappe en Transaction en calculant le sens
    final txs = dto.data.map((md) {
      final tx = md.toTransaction();
      final isDebit = (tx.compte == myPhone)
          || (tx.clientCompte == myPhone);
      tx.sens = isDebit
          ? TransactionSens.debit
          : TransactionSens.credit;
      return tx;
    }).toList();

    // 7) Reconstruit la meta
    final meta = ListeMeta(total: dto.total, limit: dto.size);

    // 8) Retourne la liste enrichie des infos HTTP
    return TransactionListe(
      data: txs,
      meta: meta,
      httpStatusCode: resp.statusCode,
      httpMessage: raw['message'] as String?,
      httpStatus: raw['status'] as int?,
    );
  }


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
      '/transferts',
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
    // Send transfer
    final ApiResponse response = await Api.post(
      '/transferts',
      data: command.toJson(),
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
