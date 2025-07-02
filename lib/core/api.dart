import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:common_dependencies/utils/constants.dart';
import 'package:common_dependencies/utils/utils.dart';
import '../modules/security/infra/connexion_output_authpkce.dart';
import 'api_mock.dart';
import 'env.dart';

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

    if (AppEnv.mode != "demo") {
      // - Ajouter l'intercepteur qui ajoute le token
      client.interceptors.add(TokenInterceptor(client));
    }
    // - Sinon mocker les APIs en mode démo
    else {
      client.interceptors.add(MockInterceptor());
    }

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

  final accessToken = 'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJVMkhtakpleFlmWHNJdzAwVU9GeUI0S1cxaEhmZ2dtRDZaSWRqdjhfTmlBIn0.eyJleHAiOjE3NDU5NDk4NzIsImlhdCI6MTc0NTk0ODA3MiwianRpIjoiYjcyMDliMjQtNTExZC00Mjg0LWJhMWItZTIxMTYxNGM1ODNkIiwiaXNzIjoiaHR0cHM6Ly9pbnRvdWNoZ3UyLXFsZi53b3JsZGxpbmUtc29sdXRpb25zLmNvbS9hdXRoL3JlYWxtcy9zc28taW50b3VjaC1pYWNjIiwiYXVkIjpbImFnZW50YXBpIiwiYWNjb3VudCJdLCJzdWIiOiJkZjNkYzI5NS1kMGIxLTQ3YTctYjM0Mi05ZjViNTFiMDU5NGEiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJteXRvdWNocG9pbnQtYXBpIiwic2Vzc2lvbl9zdGF0ZSI6IjcxOGY4Y2Y4LTQyNzEtNDdmZi05ZWM1LTY5NjRiMjEyNThjNSIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiaHR0cDovL2xvY2FsaG9zdDo4MDgyIl0sInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJkZWZhdWx0LXJvbGVzLXNzby1pbnRvdWNoLXFsZiIsIm9mZmxpbmVfYWNjZXNzIiwidW1hX2F1dGhvcml6YXRpb24iXX0sInJlc291cmNlX2FjY2VzcyI6eyJhZ2VudGFwaSI6eyJyb2xlcyI6WyJhZ2VudCIsImNsaWVudCIsImdyb3NzaXN0ZSJdfSwiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiNzE4ZjhjZjgtNDI3MS00N2ZmLTllYzUtNjk2NGIyMTI1OGM1IiwiY291bnRyeSI6IlNOIiwiYWNjb3VudF9udW1iZXIiOiJTTkNDVVNUMjUwMDAwMDE2OCIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZ2VuZGVyIjoiTUFMRSIsImlkZW50aWZpYW50IjoiMjIxNzYxOTkyMjExIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiMjIxNzYxOTkyMjExIiwicHJvZHVjdF9jb2RlIjoiTVlUUCIsImdpdmVuX25hbWUiOiJNYWxpa2kiLCJwaG9uZU51bWJlciI6IisyMjE3NjE5OTIyMTEiLCJuYW1lIjoiTWFsaWtpIEJhcnJ5IiwicGhvbmVfbnVtYmVyIjoiKzIyMTc2MTk5MjIxMSIsImZhbWlseV9uYW1lIjoiQmFycnkiLCJlbWFpbCI6InRoaWVybm8uYmFycnkwMUBpbnRvdWNoZ3JvdXAubmV0In0.fEizyz3UUckyU8B9od5KYuCjmsLV67BDxiTQ7vSzrlFXA7lYGExiYfnhCX750whloOnlLP798jSkA-Y5IDVYEam9bp5koT7ABSokT37EsSV60_5SdZUzgIqMJUvorQpZxAIjg8HS8iLh_z8GH8Lwlu7ufjAyczIKujO3qwUMFacK9EhCPBfvdwLybVfWxUiO6x0BAULTQ_25g27EbfP4piJWJPzgs1OrQQX9SChTUezUB-l2GAv8iQ7mrEIOD_QIVjDvY3FskdNVkU1j0UmK4qcTCqTfNMq0NPPGwLU0jV2imw3cM47JuyZWlUJREVrLMeSbQYvLmd0pyM60hpHMnw';

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
    options.headers['Authorization'] = 'Bearer $accessToken';
    return handler.next(options);
  }

  /// Si la session est expirée
  @override
  void onError(DioException error, ErrorInterceptorHandler handler) async {
    logger.e("Error HTTP - dans Token interceptor", error: error);
    // Si c'est un problème d'autorisations
    if (error.response?.statusCode == 401) {
      // Si une réponse 401 est reçue, actualisez le jeton d'accès
      String? newAccessToken = await ConnexionOutputAuthpkce.refreshToken();
      if (newAccessToken != null) {
        // Mettre à jour l'en-tête de la requête avec le nouveau jeton d'accès
        error.requestOptions.headers['Authorization'] =
            'Bearer $newAccessToken';
        // Relancer la requête originale avec les mêmes options
        return handler.resolve(await client.request(
          error.requestOptions.path, // Garder le même endpoint
          options: Options(
            method: error.requestOptions
                .method, // Garder la même méthode / (GET, POST, PUT, etc.)
            headers:
                error.requestOptions.headers, // Utiliser les nouveaux / headers
          ),
          data: error.requestOptions
              .data, // Garde le corps de la requête (utile pour POST/PUT)
          queryParameters: error
              .requestOptions.queryParameters, // Garde les / paramètres GET
        ));
      }
    }
    return handler.next(error);
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
