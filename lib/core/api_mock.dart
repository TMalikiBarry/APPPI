import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import '../modules/transactions/domain/models/transaction.dart';
import '../modules/transactions/domain/models/transaction_liste.dart';
import 'api.dart';

/// Simple API Mock interceptor
/// Only for demo purposes
class MockInterceptor extends Interceptor {
  //
  static final logger = Logger();
  static const _jsonDir = 'assets/json/';

  static const String httpGet = 'GET';
  static const String httpPost = 'POST';
  static const String httpDelete = 'DELETE';
  static const String httpPut = 'PUT';

  static Map<String, String> apiResponses = {
    "path": "jsonFile",
    "/oauth2/userinfo":
        "security/get_connected_user.json", // Commentez pour afficher la page de connexion
    "/login": "security/get_connected_user.json",
    "/participants": "transferts/get_participants.json",
  };

  static final Map<String, String> transactions = {
    // Transferts
    "ESNB00120230818141522TRANS633Alias9":
        "transferts/get_transfert_emis_alias.json",
    "ECIB00020240221183554TRANSreIBAN1e0":
        "transferts/get_transfert_recu_iban.json",
    "ESNB0012023082415355TRANSEmCNvhUk9e":
        "transferts/get_transfert_emis_compte.json",
    "ESNB0012023021915355TRANSrecAlias7a":
        "transferts/get_transfert_recu_alias.json",
    "ESNB00120240518153554TRANS401Factk9":
        "transferts/get_transfert_emis_401.json",
    "ESNB00120240105153554CancelpNvhUk9e": "transferts/get_annulation.json",

    // RTP
    "ESNB00120230221153554RTPok1pNvhUk9e": "transferts/get_rtp_initiee.json",
    "ESNB00120230221153554RTPre631vhUk9e": "transferts/get_rtp_recue_631.json",
    "ESNB00120240518153554RTPre631Split1":
        "transferts/get_rtp_recue_631_split.json",
    "ESNB00120240518153554RTPre500PICO01":
        "transferts/get_rtp_recue_500_pico.json",
    "ESNB00120240518153554RTPre500PICASH":
        "transferts/get_rtp_recue_500_picash.json",
    "ESNB00120240518153554RTPre500DebitD":
        "transferts/get_rtp_recue_500_debitdiff.json",
    "ESNB00120240518153554RTPre521DebitD":
        "transferts/get_rtp_recue_521_debitdiff.json",
    "ESNB00120240518153554RTPre401vhUk9e": "transferts/get_rtp_recue_401.json",

    // Default (ajouté à la fin)
    "default": "transferts/get_transfert_emis_alias.json"
  };

  TransactionListe? subscriptions;

  Future<dynamic> retrieveData(String resourcePath) async {
    final String data = await rootBundle.loadString(_jsonDir + resourcePath);
    final map = jsonDecode(data);
    return map;
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {

    // Si c'est l'historique, on ne mocke pas
    if (options.path.startsWith('/movement/history')) {
      return handler.next(options);
    }

    // Réponse spécifique pour les requêtes /alias
    if (options.path.startsWith('/alias')) {
      return handler.resolve(await _alias(options));
    }
    // Réponse spécifique pour les requêtes sur les comptes
    else if (options.path.startsWith('/comptes')) {
      return handler.resolve(await _comptes(options));
    }
    // Réponse spécifique pour les requêtes sur les transactions
    else if (options.path.startsWith('/transferts')) {
      return handler.resolve(await _transferts(options));
    }
    // Réponse spécifique pour les requêtes sur les subscriptions
    else if (options.path.startsWith('/souscriptions')) {
      return handler.resolve(await _subscriptions(options));
    }
    //
    else if (options.path.startsWith('/notifications')) {
      return handler.resolve(await _notifications(options));
    }
    //
    else {
      Response response;
      final filePath = apiResponses[options.path];
      if (filePath == null) {
        response = Response(
          statusCode: 404,
          requestOptions: options,
        );
      } //
      else {
        var map = await retrieveData(apiResponses[options.path]!);
        response = Response(
          data: map,
          statusCode: 200,
          requestOptions: options,
        );
      }
      return handler.resolve(response);
    }
  }

  /// Mock Alias Resource
  Future<Response> _alias(RequestOptions options) async {
    if (options.method == httpPost) {
      // Accédez au contenu du corps de la requête
      dynamic requestBody = options.data! as Map;

      if (options.path == "/alias/revendications") {
        var data = await retrieveData(
          'alias/revendications_post.json',
        );

        return await Future.delayed(
          const Duration(milliseconds: 500),
          () => Response(data: data, statusCode: 201, requestOptions: options),
        );
      } //
      else {
        // Creer alias
        String type = requestBody["type"];
        var data = await retrieveData(
          'alias/${options.method.toLowerCase()}_${options.path.substring(1)}_${type.toLowerCase()}.json',
        );
        return await Future.delayed(
          const Duration(milliseconds: 500),
          () => Response(data: data, statusCode: 201, requestOptions: options),
        );
      }
    }
    // PUT
    else if (options.method == httpPut) {
      dynamic requestBody = options.data! as Map;

      if (options.path.startsWith("/alias/revendications")) {
        // Accepter ou rejeter revendication
        if (options.path.endsWith("reponses")) {
          var data =
              await retrieveData('alias/revendications_put_reponses.json');
          return Response(data: data, statusCode: 200, requestOptions: options);
        }
        // Confirmer rejet revendication
        else {
          var data = await retrieveData('alias/revendications_put_rejets.json');
          return Response(data: data, statusCode: 200, requestOptions: options);
        }
      } else {
        String cle = requestBody["cle"];
        // Simulate Bad request code otp invalide
        if (cle == "+2250788495430") {
          return Response(
            statusCode: 400,
            requestOptions: options,
          );
        }
        // Le numéro de téléphone existe déjà
        else if (cle == "+221775177020") {
          return Response(
            statusCode: 403,
            requestOptions: options,
          );
        }
        // Serveur indisponible
        else if (cle == "+221775177021") {
          return Response(
            statusCode: 503,
            requestOptions: options,
          );
        }
        //
        else {
          var data = await retrieveData('alias/post_alias_mbno.json');
          return Response(
            data: data,
            statusCode: 201,
            requestOptions: options,
          );
        }
      }
    }
    // Delete alias
    else if (options.method == httpDelete) {
      return await Future.delayed(
        const Duration(milliseconds: 1000),
        () => Response(
          statusCode: 204,
          requestOptions: options,
        ),
      );
    }
    // Mock recupere alias user
    // Commenter pour forcer la création d'alias
    else if (options.method == httpGet &&
        !options.path.startsWith("/alias/revendications")) {
      var data = await retrieveData('alias/get_alias.json');
      return Response(
        data: data,
        statusCode: 200,
        requestOptions: options,
      );
    } //
    // Get /alias/revendications
    else {
      if (options.path.startsWith("/alias/revendications")) {
        var data = await retrieveData(
            'alias/revendications_${options.path.split("/")[3]}.json');
        return Response(
          data: data,
          statusCode: 200,
          requestOptions: options,
        );
      } else {
        // Pour dire que le client n'a pas d'alias
        return Response(requestOptions: options, statusCode: 404);
      }
    }
  }

  /// Mock Comptes Resource
  Future<Response> _comptes(RequestOptions options) async {
    if (options.method == httpGet) {
      String resource = options.path.endsWith("soldes") ? "solde" : "details";
      var data = await retrieveData('comptes/get_compte_$resource.json');
      return Response(
        data: data,
        statusCode: 200,
        requestOptions: options,
      );
    } //
    else {
      return Response(requestOptions: options, statusCode: 404);
    }
  }

  /// Mock Transferts Resource
  Future<Response> _transferts(RequestOptions options) async {
    if (options.method == httpGet) {
      Map<String, dynamic>? data;
      if (options.path.endsWith("details")) {
        data = await _detailsTransfert(options);
      }
      // Liste des transactions
      else {
        var res = await retrieveData('transferts/get_transferts_search.json');
        TransactionListe liste = TransactionListe.fromJson(res);
        List<Transaction> transactions = liste.data;
        // Sort list
        transactions
            .sort((a, b) => b.dateOperation!.compareTo(a.dateOperation!));
        var toRetun = {};
        if (options.queryParameters.isNotEmpty) {
          var sens = options.queryParameters["sens"];
          // Filter by Sens
          if (sens != null) {
            transactions =
                transactions.where((tx) => tx.sens?.name == sens).toList();
          }
          // Limit
          int limit = options.queryParameters["limit"] ?? 5;
          int page = options.queryParameters["page"] ?? 0;
          toRetun["data"] =
              transactions.skip(page * limit).take(limit).toList();
          toRetun["meta"] = {
            "total": res["meta"]["total"],
            "limit": limit,
            "page": page,
          };
        }
        data = {
          "data": toRetun["data"].map((e) => e.toJson()).toList(),
          "meta": toRetun["meta"]
        };
      }
      return await Future.delayed(
        const Duration(milliseconds: 1000),
        () => Response(
          data: data,
          statusCode: 200,
          requestOptions: options,
        ),
      );
    }
    // Initier un transfert
    else if (options.method == httpPost) {
      // Accédez au contenu du corps de la requête
      dynamic requestBody = options.data! as Map;
      String? responseFile;
      // Simuler paiement par qrcode
      if (requestBody["canal"] == "000") {
        responseFile = "post_transfert_qrcode";
      }
      // RTP
      else if (requestBody["canal"] == "631") {
        responseFile = "post_rtp_201";
      }
      // Transfert
      else // Simuler transfert par alias
      if (requestBody["alias"] != null) {
        responseFile = "post_transfert_alias";
      }
      // Simuler transfert par iban
      else if (requestBody["iban"] != null) {
        responseFile = "post_transfert_iban";
      }
      // Simuler transfert par othr
      else if (requestBody["othr"] != null) {
        responseFile = "post_transfert_othr";
      }

      var data = await retrieveData(
        'transferts/$responseFile.json',
      );
      return await Future.delayed(
        const Duration(milliseconds: 300),
        () => Response(
          data: data,
          statusCode: 201,
          requestOptions: options,
        ),
      );
    }
    // Confirmer transfert
    // (apres recherche d'alias ou accepter demande de paiement)
    else if (options.method == httpPut) {
      // Accédez au contenu du corps de la requête
      dynamic requestBody = options.data! as Map;
      Map<String, dynamic>? data;
      // Retours de fonds
      if (options.path.endsWith("retours")) {
        // Simuler Solde insuffisant
        if (options.path.contains("ESNB00120240221153554SoldekpNvhUk9e")) {
          return await Future.delayed(
            const Duration(milliseconds: 1000),
            () => Response(
              requestOptions: options,
              statusCode: 403,
              data: ApiProblem(
                type: "about:blank",
                title: "Forbidden",
                status: 403,
                detail: "Solde insuffisant",
                invalidParams: {
                  "name": "solde",
                },
              ),
            ),
          );
        }
        // Simuler Delai dépassé pour le retour de fonds
        if (options.path.contains("ESNB00120240101153554DelaikpNvhUk9e")) {
          return await Future.delayed(
            const Duration(milliseconds: 1000),
            () => Response(
              requestOptions: options,
              statusCode: 403,
              data: ApiProblem(
                type: "about:blank",
                title: "Forbidden",
                status: 403,
                detail: "Délai dépassé",
                invalidParams: {
                  "name": "date",
                },
              ),
            ),
          );
        }
        // Simuler Delai dépassé pour le statut retour deja effectué
        if (options.path.contains("ESNB00120240101153554StatutpNvhUk9e")) {
          return await Future.delayed(
            const Duration(milliseconds: 1000),
            () => Response(
              requestOptions: options,
              statusCode: 403,
              data: ApiProblem(
                type: "about:blank",
                title: "Forbidden",
                status: 403,
                detail: "Déjà retourné",
                invalidParams: {
                  "name": "statut",
                },
              ),
            ),
          );
        }
        // Simuler retour de fonds
        else {
          data = await retrieveData('transferts/put_return.json');
        }
      }
      // Annulation
      else if (options.path.endsWith("annulations")) {
        data = await retrieveData('transferts/put_annulation.json');
      }
      // Rejets
      else if (options.path.endsWith("rejets")) {
        data = await _detailsTransfert(options);
        if (data != null && options.path.contains("Cancel")) {
          data["annulationStatut"] = "rejete";
          data["annulationStatutRaison"] = requestBody["raison"];
        }
        if (data != null && options.path.contains("RTP")) {
          data["statut"] = "rejete";
          data["statutRaison"] = requestBody["raison"];
        }
      }

      // Confirmer transfert
      else {
        if (options.path.contains("RTP")) {
          data = await _detailsTransfert(options);
        } else {
          data = await retrieveData('transferts/put_confirmation.json');
        }
      }
      return await Future.delayed(
        const Duration(milliseconds: 1000),
        () => Response(
          data: data,
          statusCode: 200,
          requestOptions: options,
        ),
      );
    } else {
      return Response(requestOptions: options, statusCode: 404);
    }
  }

  /// Retourne les details d'un transfert
  Future<Map<String, dynamic>?> _detailsTransfert(
      RequestOptions options) async {
    final key = transactions.keys.firstWhere(
      (key) => options.path.contains(key),
      orElse: () => "default",
    );

    return await retrieveData(transactions[key]!);
  }

  /// Mock Subscriptions Resource
  Future<Response> _subscriptions(RequestOptions options) async {
    if (options.method == httpPost) {
      dynamic requestBody = options.data! as Map;
      Map<String, dynamic>? data;
      if (requestBody["dateFin"] != null) {
        data = await retrieveData('transferts/put_abonnement_fin.json');
      } else if (requestBody["frequence"] != null) {
        data = await retrieveData('transferts/put_abonnement_frequence.json');
      } else {
        data = await retrieveData('transferts/put_abonnement_once.json');
      }
      return await Future.delayed(
        const Duration(milliseconds: 1000),
        () => Response(
          data: data,
          statusCode: 200,
          requestOptions: options,
        ),
      );
    }
    // Lister
    else if (options.method == httpGet) {
      Map<String, dynamic>? data;
      if (subscriptions == null) {
        data = await retrieveData('subscriptions/get_liste.json');
        subscriptions = TransactionListe.fromJson(data!);
      } else {
        data = subscriptions!.toJson();
      }
      return await Future.delayed(
        const Duration(milliseconds: 1000),
        () => Response(
          data: data,
          statusCode: 200,
          requestOptions: options,
        ),
      );
    }
    // Desactiver Reactiver
    else if (options.method == httpPut) {
      String id = options.path.split("/")[2];
      Map<String, dynamic>? res =
          await retrieveData('subscriptions/get_liste.json');
      TransactionListe liste = TransactionListe.fromJson(res!);
      List<Transaction> transactions = liste.data;
      Transaction tx = transactions.firstWhere((t) => t.endToEndId == id);
      if (options.path.endsWith("desactivations")) {
        tx.statut = TransactionStatut.desactive;
      } else if (options.path.endsWith("reactivations")) {
        tx.statut = TransactionStatut.initie;
      }
      // Note
      else {
        dynamic requestBody = options.data! as Map;
        tx.motif = requestBody["motif"];
      }
      return await Future.delayed(
        const Duration(milliseconds: 1000),
        () => Response(
            data: tx.toJson(), statusCode: 200, requestOptions: options),
      );
    }
    // Supprimer
    else if (options.method == httpDelete) {
      String id = options.path.split("/")[2];
      if (subscriptions != null) {
        subscriptions!.data.removeWhere((s) => s.endToEndId == id);
      }
      return await Future.delayed(
        const Duration(milliseconds: 1000),
        () => Response(
          statusCode: 204,
          requestOptions: options,
        ),
      );
    }
    // Default not found
    else {
      return Response(requestOptions: options, statusCode: 404);
    }
  }

  /// Mock Notifications Resource
  Future<Response> _notifications(RequestOptions options) async {
    if (options.method == httpGet && options.path.endsWith('/non-lues')) {
      return await Future.delayed(
        const Duration(milliseconds: 1000),
        () => Response(
          data: {"total": 4},
          statusCode: 200,
          requestOptions: options,
        ),
      );
    }
    // Get liste
    else if (options.method == httpGet) {
      var data = await retrieveData('notifications/get_liste.json');
      var toRetun = {};
      if (options.queryParameters.isNotEmpty) {
        var pageP = options.queryParameters["page"];
        var limitP = options.queryParameters["limit"];
        int limit = limitP ?? 5;
        int page = pageP ?? 0;

        var notificationsList = data["data"];
        notificationsList.sort((a, b) =>
            DateTime.parse(b["dateAction"] as String)
                .compareTo(DateTime.parse(a["dateAction"] as String)));

        toRetun["data"] =
            notificationsList.skip((page) * limit).take(limit).toList();
        toRetun["meta"] = {
          "total": data["meta"]["total"],
          "limit": limit,
          "page": page,
        };
      }
      return await Future.delayed(
        const Duration(milliseconds: 1000),
        () => Response(
          data: toRetun,
          statusCode: 200,
          requestOptions: options,
        ),
      );
    }
    // Marquer comme lu
    else if (options.method == httpPut) {
      var data = await retrieveData('notifications/get_liste.json');
      var notificationsList = data["data"];
      var notif = notificationsList
          .where((e) => e["id"] == options.path.split("/")[2])
          .first;
      notif["dateLecture"] = DateTime.now().toIso8601String();
      return await Future.delayed(
        const Duration(milliseconds: 1000),
        () => Response(
          data: notif,
          statusCode: 200,
          requestOptions: options,
        ),
      );
    }
    // Other
    else {
      return Response(requestOptions: options, statusCode: 404);
    }
  }
}
