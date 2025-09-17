import 'dart:async';
import 'dart:convert';

import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:pi_mobile_app/modules/security/domain/models/connected_user.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/mappers/movement_mappers.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_reject_reason.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1) On importe le modèle Transaction en n'important QUE les symboles dont on a besoin
import '../domain/models/new/movement_details_dto.dart';
import '../domain/models/transaction.dart'
    show Transaction, TransactionSens;

// 2) On importe la réponse de send transaction sans ramener TransactionSens
import '../domain/models/transaction_send/transaction_send_method.dart';
import '../domain/models/transaction_send/transaction_send_response.dart'
    hide TransactionSens;
import 'package:shared_preferences/shared_preferences.dart';

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

  /// Historique des transactions à partir du serveur
  Future<TransactionListe> history({
    DateTime? startDate,
    DateTime? endDate,
    int size = 10,
    int page = 0,
  }) async {
    var pref = await SharedPreferences.getInstance();
    String? issuerAccount
    = pref.getString("accountNumber");

    if(issuerAccount == null || issuerAccount.isEmpty) {
      issuerAccount = pref.getString("phoneNumber");
    }


    // ConnectedUser.current?.username;
    final now    = DateTime.now();
    final start  = startDate ?? now.subtract(const Duration(days: 1000));
    final finish = endDate   ?? now.add(const Duration(days: 1));

    final qs = {
      'startDate': start.toIso8601String().split('T').first,
      'endDate'  : finish.toIso8601String().split('T').first,
      'size'     : size.toString(),
      'page'     : page.toString(),
      'issuerAccount' : issuerAccount,
      'scope' : 'PI',
      'status': 'SUCCESSFUL',
    };

    // 1) Appel relatif
    final resp = await Api.get(
      '/movement/history',
      queryParameters: qs,
      // headers: headers,
    );

    // 2) Log pour debug
    logger.i('← history() status=${resp.statusCode}');
    logger.i('← history() data=${resp.data}');

    logger.i("#### this is the value of accountNumber $issuerAccount");
    logger.i("#### this is the value of phoneNumber ${pref.getString("phoneNumber")}");
    logger.i("#### this is the value of phone_number ${pref.getString("phone_number")}");

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
      /*final isDebit = (tx.compte == myPhone)
          || (tx.clientCompte == myPhone);*/
      final isDebit = tx.clientCompte == issuerAccount || tx.compte == issuerAccount;

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

    int xlimit = (limit== null || limit <1 ) ? 1: limit;

    int xpage = page ?? 0;

    return history(size: xlimit, page: xpage);
  }

  /// Recuperer une transaction
  Future<Transaction> get(String reference) async {
    var pref = await SharedPreferences.getInstance();
    String? issuerAccount = pref.getString("accountNumber");

    if(issuerAccount == null || issuerAccount.isEmpty) {
      issuerAccount = pref.getString("phoneNumber");
    }

    // ConnectedUser.current?.username;

    final qs = {
      'startDate': DateTime.now().toIso8601String().split('T').first,
      'endDate'  : DateTime.now().add(const Duration(days: 1)).toIso8601String().split('T').first,
      'size'     : "1",
      'page'     : "0",
      'issuerAccount' : issuerAccount,
      'scope' : 'PI',
      'status': 'SUCCESSFUL',
      'guID': reference,
    };
    logger.i('← details() data=${qs}');

    // 1) Appel relatif
    final ApiResponse response = await Api.get(
      '/movement/history',
      queryParameters: qs,
      // headers: headers,
    );

    // 2) Log pour debug
    logger.i('← details() status=${response.statusCode}');
    logger.i('← details() data=${response.data}');

    logger.i("#### this is the value of accountNumber $issuerAccount");
    logger.i("#### this is the value of phoneNumber ${pref.getString("phoneNumber")}");
    logger.i("#### this is the value of phone_number ${pref.getString("phone_number")}");

    // 4) Désérialisation DTO

    final dataList = response.data["response"]["data"];
    if (dataList is List && dataList.isNotEmpty) {
      return MovementDetailsDTO.fromJson(dataList[0]).toTransaction();
    } else {
      // Handle empty response appropriately
      throw ApiException(error: ApiError.unknowError, statusCode: 404);
    }
  }

  /// Initier une transaction
  Future<Transaction> initiate(TransactionSendCommand command) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var aliasFrom = ConnectedUser.current?.alias;
    if (aliasFrom != null){
      aliasFrom = ConnectedUser.current?.alias;
    } else {
      aliasFrom = pref.getString("phone_number");
    }
    var userLogin = pref.getString('phoneNumber');
    // Send transfer
    Map<String, dynamic> request = command.toJson();
    request.addAll({
      'aliasFrom': aliasFrom,
      'clientId': aliasFrom,
      'userLogin': userLogin,
    });
    if (command.method == TransactionSendMethod.alias
      || command.method == TransactionSendMethod.qrcode
      || command.method == TransactionSendMethod.aliasRtb
    ) {
      final ApiResponse response = await Api.get('/alias/sync/search/${command.alias!.value}');
      return Transaction.fromJsonTransactionVerificationSearchAlias(response.data["response"]);
    } else if (command.method == TransactionSendMethod.iban){
      request = {
        'clientIban': command.iban?.value,
        'bankName': command.pspNom,
        //'participantMemberCode': command.pspCode,
      };
      final ApiResponse response = await Api.post('/participant/identity-verification', data: request);
      return Transaction.fromJsonTransactionVerificationSearchIban(response.data["response"]);
    } else {
      request = {
        'otherClient': command.othr?.value,
        'participantMemberCode': command.pspCode,
      };
      final ApiResponse response = await Api.post('/participant/identity-verification', data: request);
      return Transaction.fromJsonTransactionVerificationSearchOthr(response.data["response"]);
    }
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
    // Confirm transfer
    SharedPreferences pref = await SharedPreferences.getInstance();
    var aliasFrom = ConnectedUser.current?.alias;
    if (aliasFrom != null){
      aliasFrom = ConnectedUser.current?.alias;
    } else {
      aliasFrom = pref.getString("phone_number");
    }
    var userLogin = pref.getString('phoneNumber');
    var url = '/transfer/eme/external';
    Map<String, dynamic> request = {
      'clientId': aliasFrom,
      'aliasFrom': aliasFrom,
      'userLogin': userLogin,
    };
    request.addAll(command.toJson());
    if (
      command.confirmationMethode.toString() == TransactionSendMethod.alias.toString() ||
      command.confirmationMethode.toString() == TransactionSendMethod.qrcode.toString()
    ){
      if (command.confirmationMethode.toString() == TransactionSendMethod.qrcode.toString()) {
        request.addAll({
          'channel': command.channel,
        });
      }
      request['alias'] = command.transactionVerificationResultAlias!.alias;
    } else if (command.confirmationMethode.toString() == TransactionSendMethod.aliasRtb.toString()) {
      url = '/payments/init-claim';
      request.remove("aliasFrom");
      request.remove("aliasTo");
      request.addAll({
        'requestSenderAlias': aliasFrom,
        'requestReceiverAlias': command.transactionVerificationResultAlias!.toJson(),
        'reason': command.motif ?? 'PI_REQUEST_TO_PAY'
      });
    }
      else if (command.confirmationMethode.toString() == TransactionSendMethod.iban.toString()){
      logger.i("On est la");
      url = '/transfer/eme/external?transferType=IBAN';
    } else if (command.confirmationMethode.toString() == TransactionSendMethod.othr.toString()) {
      url = '/transfer/eme/external?transferType=ACCOUNT';
    }

    if (command.confirmationMethode.toString() == "RtpAcceptPay") {
      url = '/payments/respond-claim';
      logger.i("RtpAcceptPay");
      request = {
        "requestReceiverAlias": {
          "alias": aliasFrom
        },
        "requestSenderAlias": command.clientAlias,
        "amount": command.amount?.value,
        "response": "IMMEDIATE",
        "userLogin": userLogin,
        "clientId": aliasFrom,
        "endToEndId": command.endToendId,
        "guID": command.guID,
        "longitude": command.longitude,
        "lattitude": command.latitude,
        "codeMembreParticipantPayer" : command.codeMembreParticipantPayer
      };
    }

    // Send transfer
    final ApiResponse response = await Api.post(url, data: request);
    logger.i("response : ${response.data}");
    Transaction? transaction;
    if (command.confirmationMethode.toString() == "RtpAcceptPay") {
      transaction = Transaction.fromJsonTransfer(response.data['response'], isRtp: true);
    } else {
      transaction = Transaction.fromJsonTransfer(response.data['response'], isRtp: false);
    }

    // GET REQUEST
    try {
      if (AppEnv.mode == "demo") {
        // TODO remove this demo code before release
        final controller = StreamController<Transaction>();
        Future.delayed(
          const Duration(seconds: 1),
          () {
            transaction!.dateOperation = DateTime.now();
            transaction.statut = TransactionStatut.irrevocable;
            controller.add(transaction);
          },
        );
        return controller.stream;
      } //
      else {
        //return streamResponse(transaction);
        // Return transaction directly without contacting SSE endpoint
        final controller = StreamController<Transaction>();
        transaction.dateOperation = DateTime.now();
        if (
          command.confirmationMethode.toString() == "RtpAcceptPay"
        ) {
          logger.i("RtpAcceptPay jsonEncode(transaction)");
          logger.i(jsonEncode(transaction));
          transaction = transaction.copyWith(statut: TransactionStatut.irrevocable, canal: "631"); // or whatever default status you want
          //transaction.statut = TransactionStatut.r; // or whatever default status you want
        } else if (command.confirmationMethode.toString() == TransactionSendMethod.aliasRtb.toString()){
          transaction.statut = TransactionStatut.initie;
        } else {
          transaction.statut = TransactionStatut.irrevocable; // or whatever default status you want
        }
        controller.add(transaction);
        controller.close();
        return controller.stream;
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
    final ApiResponse response;
    // GET REQUEST
    try {
      // TODO Remove this code before release
      /*if (AppEnv.mode == "demo") {
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
      }*/
      // Send transfer
      if (transaction.sens?.name == TransactionSens.credit.name) {
        response = await Api.post(
          '/movement/fund-return',
          data: {
            "guID": transaction.guID,
            "reason": "MD06",
            "clientID": transaction.clientId,
            "amount": transaction.montant.toInt(),
            "clientName": transaction.clientNom,
            "endToEndId": transaction.additionalInformations?.endToEndId
          },
        );
        transaction.annulationStatut = TransactionStatut.irrevocable;
        //
        transaction = transaction;
      } else {
        response = await Api.post(
          '/movement/respond-fund-return',
          data: {
            "guID": transaction.guID,
            "amount": transaction.montant.toInt(),
            "reason": TransactionRejectReason.autre.code,
            "clientID": transaction.clientId,
            "decision": "ACCEPTED",
            "codeMembreParticipantPayeur": transaction.codeMembreParticipantPayeur
          },
        );
        transaction.annulationStatut = TransactionStatut.irrevocable;
        //
        transaction = transaction;
      }
    } on ApiException catch (e) {
      throw ApiException(error: e.error, statusCode: e.statusCode);
    }
    catch (e) {
      logger.e("Reception reponse retour de fonds erreur", error: e);
      throw ApiException(error: ApiError.internalServerError, statusCode: 500);
      //return Stream.error(e);
    }

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
        //return streamResponse(transaction);
        // Return transaction directly without contacting SSE endpoint
        //logger.i(transaction.toJson());
        final controller = StreamController<Transaction>();
        transaction.dateOperation = DateTime.now();
        transaction.statut = TransactionStatut.irrevocable; // or whatever default status you want
        controller.add(transaction);
        controller.close();
        return controller.stream;
      }
    }  on ApiException catch (e) {
      throw ApiException(error: e.error, statusCode: e.statusCode);
    } catch (e) {
      logger.e("Reception reponse erreur", error: e);
      throw ApiException(error: ApiError.internalServerError, statusCode: 500);
      //return Stream.error(e);
    }
  }

  Future<Transaction> cancel(
    Transaction transaction,
    TransactionCancelReason reason,
  ) async {
    try {
      // Send transfer
      final ApiResponse response = await Api.post(
        '/movement/init-fund-return',
        data: {
          "guID": transaction.guID,
          "reason": reason.code,
          "clientID": transaction.clientAlias,
          "clientName": "${ConnectedUser.current?.firstName} ${ConnectedUser.current?.lastName}",
          "amount": transaction.montant,
          "impactDate": "${transaction.dateOperation}",
          "clientCountry": transaction.additionalInformations?.payePays,
          "codeMembreParticipantPaye": transaction.additionalInformations?.participant
        },
      );
      //
      return Transaction.fromJsonCancel(response.data, transaction);
    }  on ApiException catch (e) {
      throw ApiException(error: e.error, statusCode: e.statusCode);
    } catch (e) {
      // Handle empty response appropriately
      throw ApiException(error: ApiError.internalServerError, statusCode: 500);
    }
  }

  Future<Transaction> reject(
    Transaction transaction,
    String reason,
      {bool isRtp = false}
    ) async {

    try {
      if (isRtp){
        // Récuperer position GPS
        Position? position;
        try {
          position = await _askPosition();
        } //
        catch (e) {
          position = await _askPosition();
        }
        // S'il ne donne pas sa position on fait rien
        if (position == null) {
          // Il reste sur le formulaire - pas de confirmation
        } else {
          SharedPreferences pref = await SharedPreferences.getInstance();
          var aliasFrom = ConnectedUser.current?.alias;
          if (aliasFrom != null){
            aliasFrom = ConnectedUser.current?.alias;
          } else {
            aliasFrom = pref.getString("phone_number");
          }
          var userLogin = pref.getString('phoneNumber');

          final ApiResponse response = await Api.post(
            '/payments/respond-claim',
            data: {
              "requestReceiverAlias": {
                "alias": aliasFrom
              },
              "requestSenderAlias": transaction.clientAlias,
              "amount": "${transaction.montant.toInt()}",
              "reason": reason,
              "response":"REJECTED",
              "userLogin": userLogin,
              "clientId": aliasFrom,
              "endToEndId": transaction.endToEndId,
              "guID": transaction.guID,
              "longitude": position.longitude,
              "lattitude": position.latitude,
              "codeMembreParticipantPayer": transaction.codeMembreParticipantPayer
            },
          );
        }
      }
      else {
        // Send transfer
        final ApiResponse response = await Api.post(
          '/movement/respond-fund-return',
          data: {
            "guID": transaction.guID,
            "amount": transaction.montant.toInt(),
            "reason": TransactionRejectReason.autre.code,
            "clientID": transaction.clientId,
            "decision": "REFUSED",
            "codeMembreParticipantPayeur": transaction.codeMembreParticipantPayeur
          },
        );
      }
      // Pour modifier l'objet
      transaction = transaction.copyWith(
        statut: TransactionStatut.rejete,
        annulationStatut: TransactionStatut.rejete,
      );
      //
      return transaction;
    }  on ApiException catch (e) {
      throw ApiException(error: e.error, statusCode: e.statusCode);
    } catch (e) {
      // Handle empty response appropriately
      logger.i("No transaction data available in reject response.");
      rethrow;
      //throw Exception("No transaction data available in reject response.");
    }
  }

  // Demander position GPS
  Future<Position> _askPosition() async {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }
}
