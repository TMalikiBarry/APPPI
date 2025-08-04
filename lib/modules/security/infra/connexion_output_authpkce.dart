import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:oauth2/oauth2.dart';

import '../domain/models/connected_user.dart';
import '../domain/models/connexion_response.dart';
import '../ports/output/connexion_output_port.dart';

class ConnexionOutputAuthpkce implements ConnexionOutputPort {
  //
  //
  static final logger = Logger();
  static const keyAccessToken = "ACCESS_TOKEN";
  static const keyIdToken = "ID_TOKEN";
  static const keyRefreshToken = "REFRESH_TOKEN";
  final FlutterSecureStorage secureStorage;
  //
  static final dio = Dio();
  // L'identifiant du client Keycloak
  static const clientId = 'customer-api';
  // Liste des scopes autorisés
  static const scopes = [
    'openid',
    'roles',
    'email',
    'phone',
    'profile',
    'offline_access',
    'address'
  ];

  // Authentifier et autoriser l'accès à ses données ou ressources
  final authorizationEndpoint =
      const String.fromEnvironment('KEYCLOAK_AUTHORIZATION_ENDPOINT');
  // Permettre de récupérer des tokens d'accès
  static final tokenEndpoint = 
    const String.fromEnvironment('KEYCLOAK_TOKEN_ENDPOINT');
  // Permettre la redirection après connexion
  final redirectUri =
      Uri.parse(const String.fromEnvironment('KEYCLOAK_REDIRECT_URI'));
  // Permettre la fermeture de la session
  final logoutEndpoint =
      const String.fromEnvironment('KEYCLOAK_LOGOUT_ENDPOINT');
  // Permettre la révocation du token d'accès
  final revocationEndpoint =
      const String.fromEnvironment('KEYCLOAK_REVOCATION_ENDPOINT');

  late AuthorizationCodeGrant grant;
  late Uri authUrl;

  /// Constructor
  /// [secureStorage] est utilisé pour enregistrer les tokens en local
  ConnexionOutputAuthpkce(this.secureStorage) {
    grant = _createGrant();
    authUrl = grant.getAuthorizationUrl(redirectUri, scopes: scopes);
  }

  @override
  Future<ConnectedUser?> loadConnectedUser() async {
    String? idToken = await secureStorage.read(key: keyIdToken);
    logger.i(idToken);

    // Si l'id token n'exsite pas  => no user
    if (idToken == null) return null;
    return _decodeIdToken(idToken);
  }

  @override
  Future<ConnexionResponse> login(String url, String password) async {
    Uri redirected = Uri.parse(url);

    ConnectedUser response = await _handleAuthorizationResponse(
      grant,
      redirected.queryParameters,
    );

    logger.i(response.toString());

    logger.i('RESPONSE FROM SERVER : $response');

    return ConnexionResponse(user: response);
  }

  @override
  Uri getAuthorizationUrl() {
    return authUrl;
  }

  @override
  Future<void> logout() async {
    String? accessToken = await secureStorage.read(key: keyAccessToken);
    await _revokeAccessToken(accessToken!, clientId);

    String? refreshToken = await secureStorage.read(key: keyRefreshToken);
    await _performLogout(accessToken, refreshToken);
  }

  // Initialiser une configuration de type "Code Grant" pour l'authentification
  // et l'autorisation OAuth 2.0,
  AuthorizationCodeGrant _createGrant() {
    return AuthorizationCodeGrant(
      clientId,
      Uri.parse(authorizationEndpoint),
      Uri.parse(tokenEndpoint),
      secret: "EAG1ehduLAeSGVye3FLPBvNJbumGi6uJ"
    );
  }

  // Gérer la réponse du serveur d'autorisation après que l'utilisateur
  // s'est authentifié et a donné son consentement
  Future<ConnectedUser> _handleAuthorizationResponse(
      AuthorizationCodeGrant grant, Map<String, String> queryParams) async {
    logger.i("HANDLE Authorization RESPONSE");
    //logger.i(queryParams.toString());

    try {
      final httpClient = await grant.handleAuthorizationResponse(queryParams);

      logger.i("Authorization Response: ${httpClient.toString()}");
      logger.i("HANDLE RESPONSE");

      final credentials = httpClient.credentials;

      logger.i('ACCESS TOKEN: ${credentials.accessToken}');
      logger.i('REFRESH TOKEN: ${credentials.refreshToken}');
      logger.i('EXPIRATION: ${credentials.expiration}');
      logger.i('SCOPES: ${credentials.scopes}');
      logger.i('ID TOKEN: ${credentials.idToken}');

      secureStorage.write(key: keyAccessToken, value: credentials.accessToken);
      secureStorage.write(key: keyIdToken, value: credentials.idToken);
      secureStorage.write(
          key: keyRefreshToken, value: credentials.refreshToken);

      return _decodeIdToken(credentials.idToken!);
    } catch (e) {
      //
      // Gérez l'exception ici, enregistrez-la et
      // renvoyez éventuellement une réponse d'erreur.
      logger.e("Error handling authorization response: $e");
      // Vous pouvez lancer votre exception personnalisée
      // ou renvoyer un objet de réponse d'erreur ici.
      throw Exception("Error handling authorization response: $e");
    }
  }

  ConnectedUser _decodeIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);

    final Map<String, dynamic> json = jsonDecode(
      utf8.decode(
        base64Url.decode(
          base64Url.normalize(parts[1]),
        ),
      ),
    );
    logger.i("DECODED TOKEN : $json");
    ConnectedUser userInfos = ConnectedUser(
      id: json["sub"],
      username: json["preferred_username"],
      firstName: json["given_name"],
      lastName: json["family_name"],
      country: json["address"] != null && json["address"]["country"] != null
          ? json["address"]["country"]
          : null,
      address: json["address"] != null && json["address"]["locality"] != null
          ? json["address"]["locality"]
          : "DK",
      telephone: json["phone_number"],
      email: json["email"],
      avatar: null,
    );
    logger.i("USER INFO : $userInfos");
    return userInfos;
  }

  // Permettre la déconnexion en fermant la session
  Future<void> _performLogout(String accessToken, String? refreshToken) async {
    // Effectuez une requête HTTP POST vers l'URL de déconnexion
    // avec le token d'accès.
    final response = await dio.post(
      logoutEndpoint,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
      data: {
        'client_id': clientId,
        'refresh_token': refreshToken,
      },
    );

    // Vérifiez la réponse pour vous assurer que la déconnexion a réussi.
    if (response.statusCode == 204) {
      logger.i('Déconnexion réussie');
    } else {
      logger.i('Erreur de déconnexion');
      logger.i(response.data);
    }

    // Supprimer les tokens enregistrés localement
    secureStorage.delete(key: keyAccessToken);
    secureStorage.delete(key: keyAccessToken);
    secureStorage.delete(key: keyIdToken);
    secureStorage.delete(key: keyRefreshToken);
  }

  // Permettre de révoquer le token d'accès
  Future<void> _revokeAccessToken(String accessToken, String clientId) async {
    // Les données de révocation (access token à révoquer).
    final Map<String, dynamic> data = {
      'token': accessToken,
      'client_id': clientId
    };
    //
    Options options = Options(headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    });
    // Effectuer la requête HTTP POST.
    final response = await dio.post(
      revocationEndpoint,
      data: data,
      options: options,
    );

    if (response.statusCode == 200) {
      logger.i('Access token révoqué avec succès.');
    } else {
      logger.i('Échec de la révocation de l\'access token.');
      logger.i('Code de réponse : ${response.statusCode}');
    }
  }

  static Future<String?> refreshToken() async {
    FlutterSecureStorage secuStorage = FlutterSecureStorage();
    String? refreshToken = await secuStorage.read(key: keyRefreshToken);
    if(refreshToken == null) return null;
    // Effectuez une requête au point de terminaison du jeton d’actualisation
    // et renvoyez le nouveau jeton d’accès.
    final response = await dio.post(
      tokenEndpoint,
      options: Options(
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
      data: {
        'grant_type': 'refresh_token',
        'client_id': clientId,
        'refresh_token': refreshToken,
      },
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<dynamic,dynamic>;
      logger.log(Level.info," Success refresh Token  => $data");
      final accessToken = data["access_token"];
      final idToken = data["id_token"];
      final refreshToken = data["refresh_token"];
      await secuStorage.write( key: keyAccessToken, value: accessToken);
      await secuStorage.write( key: keyIdToken, value: idToken);
      await secuStorage.write( key: keyRefreshToken, value: refreshToken);
      //
      return accessToken;
    }
    logger.log(Level.error," Failed refresh Token");
    return null;
  }
}
