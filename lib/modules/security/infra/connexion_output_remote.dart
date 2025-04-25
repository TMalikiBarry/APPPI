import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import '../../../core/api.dart';
import '../domain/models/connected_user.dart';
import '../domain/models/connexion_response.dart';
import '../ports/output/connexion_output_port.dart';

class ConnexionOutputRemote implements ConnexionOutputPort {
  //
  static final logger = Logger();
  static const keyUser = "USER";
  final FlutterSecureStorage secureStorage;

  /// [clientHttp] est utilisé pour effectuer des appels via Http à l'API
  const ConnexionOutputRemote(this.secureStorage);

  @override
  Future<ConnectedUser?> loadConnectedUser() async {
    //
    try {
      final Response response = await Api.client.get('/oauth2/userinfo');
      return response.data != null
          ? ConnectedUser.fromJson(response.data)
          : null;
    } //
    on ApiException catch (e) {
      // Vérifier si c'est un problème de connectivité
      if (e.error == ApiError.noInternetConnection) {
        logger.i("Check local storage");
        // recuperer le dernier user stocké
        String? userJson = await secureStorage.read(key: keyUser);
        if (userJson != null) {
          Map<String, dynamic> user = jsonDecode(userJson);
          return ConnectedUser.fromJson(user);
        }
        return null;
      } // Si c'est pas un probleme de connexion propage l'erreur
      else {
        logger.i("Not a connectivity problem");
        rethrow;
      }
    }
  }

  @override
  Future<ConnexionResponse> login(String username, String password) async {
    final Response response = await Api.client.post('/login');
    return response.data != null
        ? ConnexionResponse(user: ConnectedUser.fromJson(response.data))
        : ConnexionResponse();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Uri getAuthorizationUrl() {
    throw UnimplementedError();
  }
}
