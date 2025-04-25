import '../../ports/input/connexion_input_port.dart';
import '../../ports/output/connexion_output_port.dart';
import '../models/connected_user.dart';
import '../models/connexion_response.dart';
import '../models/login_command.dart';

class ConnexionService implements ConnexionInputPort {
  //
  final ConnexionOutputPort connexionOutputPort;

  const ConnexionService(this.connexionOutputPort);

  @override
  Future<ConnectedUser?> loadConnectedUser() {
    return connexionOutputPort.loadConnectedUser();
  }

  @override
  Uri getAuthorizationUrl() {
    return connexionOutputPort.getAuthorizationUrl();
  }

  @override
  Future<ConnexionResponse> login(LoginCommand loginData) async {
    try {
      return await connexionOutputPort.login(
        loginData.username!.value!,
        loginData.password!.value!,
      );
    } catch (e) {
      throw Exception("Error rencontrée pendant la connexion $e");
    }
  }

  @override
  Future<void> logout() async {
    try {
      await connexionOutputPort.logout();
    } catch (e) {
      throw Exception("Error rencontrée pendant la deconnexion $e");
    }
  }
}
