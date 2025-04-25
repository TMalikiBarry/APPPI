import 'package:pi_mobile_app/modules/security/domain/models/connected_user.dart';
import 'package:pi_mobile_app/modules/security/domain/models/connexion_response.dart';
import 'package:pi_mobile_app/modules/security/ports/output/connexion_output_port.dart';

class MockConnexionOutputPort implements ConnexionOutputPort {
  @override
  Uri getAuthorizationUrl() {
    return Uri(host: "test.pocs-bceao.com", port: 80);
  }

  @override
  Future<ConnectedUser?> loadConnectedUser() async {
    final data = {
      "sub": "12547852",
      "username": "06946",
      "firstName": "Khady",
      "lastName": "Diop",
      "country": "SN",
      "address": "nord foire",
      "telephone": "+221773242452"
    };
    return ConnectedUser.fromJson(data);
  }

  @override
  Future<ConnexionResponse> login(String username, String password) async {
    final data = {
      "sub": "12547852",
      "username": "fmasoro",
      "firstName": "Khady",
      "lastName": "Diop",
      "country": "SN",
      "address": "nord foire",
      "telephone": "+221773242452"
    };
    ConnectedUser user = ConnectedUser.fromJson(data);

    return ConnexionResponse(user: user, challenge: "CHANGE_PASSWORD");
  }

  @override
  Future<void> logout() async {
    //
  }
}

class MockConnexionOutputPortErrors implements ConnexionOutputPort {
  @override
  Uri getAuthorizationUrl() {
    throw UnimplementedError();
  }

  @override
  Future<ConnectedUser?> loadConnectedUser() {
    throw UnimplementedError();
  }

  @override
  Future<ConnexionResponse> login(String username, String password) {
    throw Exception(
        'Error rencontrée pendant la connexion Null check operator used on a '
        'null value');
  }

  @override
  Future<void> logout() async {
    throw Exception(
        'Error rencontrée pendant la connexion Null check operator used on a '
        'null value');
  }
}
