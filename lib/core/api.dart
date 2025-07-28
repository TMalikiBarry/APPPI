import 'package:common_dependencies/interceptors/HttpInterceptors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:common_dependencies/utils/constants.dart';
import 'package:common_dependencies/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modules/security/infra/connexion_output_authpkce.dart';
import 'api_mock.dart';
import 'env.dart';
import 'package:micro_core/micro_core.dart' as micro_core;
import 'package:micro_core/services/routing/routes.dart';


/// Core Api Service pour effectuer les appels aux APIs
/// Dio est utilisé pour les appels Http dans le projet.
/// Vous pouvez modifier cette classe pour utiliser un autre client http
/// En gardant la meme signature des méthodes, ce changement sera transparent
/// aux classes qui l'utilisent sur la couche infra
class Api {
  //
  static final logger = Logger();

  static late String url;

  static late Dio client;

  static late FlutterSecureStorage secureStorage;

  /// Créer le client HTTP
  static void initClient(FlutterSecureStorage secureStorage) {
    //
    Api.secureStorage = secureStorage;

    // Recuperer l'URL de l'API

    //String apiUrl = const String.fromEnvironment("API_URL");
    String apiUrl = BASE_API_URL;
    logger.i("API URL $apiUrl");
    url = apiUrl;

    // Créer l'instance Dio
    client = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(minutes: 1), // 60 seconds
        receiveTimeout: const Duration(minutes: 1), // 60 seconds
      ),
    );

    // L'ordre des intercepteurs compte
    // - Ajouter l'intercepteur pour logger
    if (kDebugMode) client.interceptors.add(LoggingInterceptor());

    // if (AppEnv.mode != "demo") {

      // - Ajouter l'intercepteur qui ajoute le token
      client.interceptors.add(TokenInterceptor(client));
    /*}
    // - Sinon mocker les APIs en mode démo
    else {
      client.interceptors.add(MockInterceptor());
    }*/

    // - Ajouter l'intercepteur pour les erreurs
    client.interceptors.add(ErrorInterceptor());
  }

  /// Effectue un appel GET
  /// En fonction du client Http que vous souhaitez utilisez,
  /// vous pouvez modifier l'implémentation de cette méthode
  static Future<ApiResponse> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? responseType,
    int? sendTimeout,
    Map<String, dynamic>? extra,
  }) async {
    // Create dio options from params
    Options options = Options(headers: headers, extra: extra);
    if (sendTimeout != null) {
      options.sendTimeout = Duration(milliseconds: sendTimeout);
    }
    // Call the dio client to make the api call
    try {
      final response = await client.get(path,
          data: data, queryParameters: queryParameters, options: options);
      return ApiResponse(response.data, response.statusCode);
    } //
    on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  static Future<ApiResponse> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? responseType,
    int? sendTimeout,
    Map<String, dynamic>? extra,
  }) async {
    // Create dio options from params
    Options options = Options(headers: headers, extra: extra);
    if (sendTimeout != null) {
      options.sendTimeout = Duration(milliseconds: sendTimeout);
    }
    // Call the dio client to make the api call
    try {
      final response = await client.delete(path,
          data: data, queryParameters: queryParameters, options: options);
      return ApiResponse(response.data, response.statusCode);
    } //
    on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  static Future<ApiResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? responseType,
    int? sendTimeout,
    Map<String, dynamic>? extra,
  }) async {
    // Create dio options from params
    Options options = Options(headers: headers, extra: extra);
    if (sendTimeout != null) {
      options.sendTimeout = Duration(milliseconds: sendTimeout);
    }

    // Call the dio client to make the POST request
    try {
      final response = await client.post(path,
          data: data, queryParameters: queryParameters, options: options);
      ErrorInterceptor.checkErrors(response);
      return ApiResponse<T>(response.data, response.statusCode);
    } //
    on DioException catch (e) {
      throw e.error as ApiException;
    }
  }

  static Future<ApiResponse<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? responseType,
    int? sendTimeout,
    Map<String, dynamic>? extra,
  }) async {
    try {
      final response = await Api.client.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers, extra: extra),
      );
      ErrorInterceptor.checkErrors(response);
      return ApiResponse<T>(response.data, response.statusCode);
    } //
    on DioException catch (e) {
      throw e.error as ApiException;
    }
  }
}

// Modèle de reponse de l'API
class ApiResponse<T> {
  final T? data;
  final int? statusCode;

  ApiResponse(this.data, this.statusCode);
}

// Codification des erreurs de retour de l'API
enum ApiError {
  //
  /// The exception for an expired bearer token.
  tokenExpired,

  /// The exception for a failed connection attempt.
  timeOut,

  /// The exception for no internet connectivity.
  noInternetConnection,

  /// The exception for an incorrect parameter in a request/response.
  badRequest,

  /// The exception for an unauthorizeed api call
  unauthorized,

  /// The exception for a forbidden action (403)
  forbidden,

  /// Not found
  notFound,

  // Erreur api interne
  internalServerError,

  /// The exception for an unknown exception from the api.
  unknowError,

  /// The exception for an unknown type of failure.
  unrecognizedError,

  /// The exception for any parsing failure encountered during
  /// serialization/deserialization of a request.
  serializationError,
}

/// Modele de réponse de l'API en cas d'erreur
class ApiProblem {
  final String type;
  final String title;
  final int status;
  final String detail;
  final Map<String, dynamic>? invalidParams;
  final Map<String, dynamic>? object;

  ApiProblem({
    required this.type,
    required this.title,
    required this.status,
    required this.detail,
    this.invalidParams,
    this.object,
  });

  factory ApiProblem.fromJson(Map<String, dynamic> json) {
    return ApiProblem(
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? 0,
      detail: json['detail'] ?? '',
      invalidParams: json['invalid-params'],
      object: json['object'],
    );
  }

  @override
  String toString() {
    return 'ApiProblem{type: $type, title: $title, status: $status,'
        'detail: $detail, invalidParams: $invalidParams, object: $object}';
  }
}

/// Classe d'exception custom pour les erreurs d'appels vers les APis
class ApiException implements Exception {
  //
  final int? statusCode;
  final ApiError error;
  late final String? name;
  late final String? message;
  late final ApiProblem? problem;

  ApiException({
    required this.statusCode, //
    required this.error,
    this.message, //
    this.name,
    this.problem,
  });
}

/// Ajoute le token avant chaque requête
class TokenInterceptor extends Interceptor {
  //
  static final logger = Logger();

  final Dio client;

  TokenInterceptor(this.client);

  /// Ajouter le token avant chaque requête
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    logger.i("Requete vers ${options.path}");
    // lire le token
    // String? accessToken = await Api.secureStorage.read(key: "ACCESS_TOKEN");
    // logger.i("Requete accessToken $accessToken");
    // Ajouter le jeton utilisateur à la demande s'il existe
    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString("accessToken");
    options.headers['Authorization'] = 'Bearer $token';
    // options.headers["Accept"] = "application/json";
    // options.headers["Content-Type"] = "application/json";
    return handler.next(options);
  }

  /// Si la session est expirée
  @override
  void onError(DioException error, ErrorInterceptorHandler handler) async {
    logger.e("Error HTTP - dans Token interceptor", error: error);

    if (error.response?.statusCode == 401) {
      var pref = await SharedPreferences.getInstance();
      int? expirationDateStr = pref.getInt("tokenExpiration");
      int? refreshExpirationDateStr = pref.getInt("refreshTokenExpiration");
      print("expirationDateStr: $expirationDateStr");
      print("refreshExpirationDateStr: $refreshExpirationDateStr");
      var now = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Valeur actuelle en secondes
      print("now: $now");

      if (now >= expirationDateStr! && now < refreshExpirationDateStr!) {
        print("Token expired but refresh token is still valid, refreshing token...");
        await HttpInterceptors().refreshToken();
      }
      else {
        print("Both token and refresh token expired, redirecting to login...");
        _triggerRefreshServiceEvent();
      }
    }
    return handler.next(error);
  }

  void _triggerRefreshServiceEvent() {
    micro_core.CustomEventBus.emit(
      RouteEvents.walletTFSEvents.refreshServiceEvent("USER"),
    );
    return;
    //print("Événement refreshServiceEvent déclenché.");
  }

}

/// Pour logger ce qui se passe
class LoggingInterceptor extends Interceptor {
  //
  static final logger = Logger();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    logger.i('''--> ${options.method.toUpperCase()} 
        ${options.baseUrl}${options.path}''');
    logger.i("Request Headers:");
    options.headers.forEach((k, v) => logger.i('$k: $v'));
    logger.i("Request queryParameters:");
    options.queryParameters.forEach((k, v) => logger.i('$k: $v'));
    if (options.data != null) {
      logger.i("Request Body: ${options.data}");
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.i("<-- ${err.message} ${err.requestOptions.path}");
    logger.i("${err.response != null ? err.response!.data : 'Unknown Error'}");
    logger.i("<-- End error");
    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i("<-- ${response.statusCode} ${response.requestOptions.path}");
    logger.i("Response Headers:");
    response.headers.forEach((k, v) => logger.i('$k: $v'));
    logger.i('''Response:  ${response.statusCode} 
        ${response.requestOptions.path} ${response.data}''');
    return super.onResponse(response, handler);
  }
}

/// Pour gérer des erreurs personnalisées détaillées spécifiques
class ErrorInterceptor extends Interceptor {
  //
  ErrorInterceptor();
  static final logger = Logger();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e("Error HTTP - dans Token interceptor", error: err);
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw ApiException(
          error: ApiError.timeOut,
          statusCode: err.response?.statusCode,
          message: err.message,
        );
      case DioExceptionType.connectionError:
        throw ApiException(
          error: ApiError.noInternetConnection,
          statusCode: err.response?.statusCode,
          message: err.message,
        );
      case DioExceptionType.badResponse:
        checkErrors(err.response!);
      default:
        throw ApiException(
          error: ApiError.unknowError,
          statusCode: err.response?.statusCode,
          message: err.message,
        );
    }
  }

  static void checkErrors(Response response) {
    if (response.statusCode == 400) {
      throw ApiException(
        error: ApiError.badRequest,
        statusCode: response.statusCode,
      );
    } else if (response.statusCode == 401) {
      throw ApiException(
        error: ApiError.unauthorized,
        statusCode: response.statusCode,
      );
    } else if (response.statusCode == 403) {
      throw ApiException(
        error: ApiError.forbidden,
        statusCode: response.statusCode,
        problem: ApiProblem.fromJson(response.data),
      );
    } else if (response.statusCode == 404) {
      throw ApiException(
        error: ApiError.notFound,
        statusCode: response.statusCode,
      );
    } else if (response.statusCode == 500 || response.statusCode == 503) {
      throw ApiException(
        error: ApiError.internalServerError,
        statusCode: response.statusCode,
      );
    } else if (![200, 201, 202, 204].contains(response.statusCode)) {
      throw ApiException(
        error: ApiError.unknowError,
        statusCode: response.statusCode,
      );
    }
  }
}
