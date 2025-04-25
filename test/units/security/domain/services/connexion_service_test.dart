import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/security/domain/models/connected_user.dart';
import 'package:pi_mobile_app/modules/security/domain/models/connexion_response.dart';
import 'package:pi_mobile_app/modules/security/domain/models/login_command.dart';
import 'package:pi_mobile_app/modules/security/domain/services/connexion_service.dart';

import '../infra/connexion_output_mock.dart';

void main() {
  group('ConnexionService - cas succès', () {
    ConnexionService service = ConnexionService(MockConnexionOutputPort());
    test("loadConnectedUser - les parametres ", () async {
      final data = {
        "sub": "12547852",
        "username": "06946",
        "firstName": "Khady",
        "lastName": "Diop",
        "country": "SN",
        "address": "nord foire",
        "telephone": "+221773242452"
      };

      expect((await service.loadConnectedUser()).toString(),
          ConnectedUser.fromJson(data).toString());
    });
    test("login - success ", () async {
      final data = {
        "sub": "12547852",
        "username": "06946",
        "firstName": "Khady",
        "lastName": "Diop",
        "country": "SN",
        "address": "nord foire",
        "telephone": "+221773242452"
      };
      ConnectedUser user = ConnectedUser.fromJson(data);
      LoginCommand login = LoginCommand(
          username: LoginCommandUsername(value: "fmasoro"),
          password: LoginCommandPassword(value: "1234ABCD"));
      expect(
          (await service.login(login)).toString(),
          ConnexionResponse(user: user, challenge: "CHANGE_PASSWORD")
              .toString());
    });
    test("login - success ", () async {
      expect(service.logout(), isA<void>());
    });
    test("getAuthorizationUrl - success ", () async {
      expect(service.getAuthorizationUrl(),
          Uri(host: "test.pocs-bceao.com", port: 80));
    });
  });
  group('ConnexionService - cas erreur', () {
    ConnexionService serviceErrors =
        ConnexionService(MockConnexionOutputPortErrors());
    test("login - erros ", () async {
      LoginCommand login = LoginCommand(
          username: null, password: LoginCommandPassword(value: "1234ABCD"));
      try {
        await serviceErrors.login(login);
      } catch (e) {
        expect(
            e.toString(),
            Exception(
                    'Error rencontrée pendant la connexion Null check operator'
                    ' used on a null value')
                .toString());
      }
    });

    test("logout - erros ", () async {
      try {
        await serviceErrors.logout();
      } catch (e) {
        expect(
            e.toString(),
            'Exception: Error rencontrée pendant la deconnexion Exception:'
            ' Error rencontrée pendant la connexion Null check operator used on'
            ' a null value');
      }
    });
  });
}
