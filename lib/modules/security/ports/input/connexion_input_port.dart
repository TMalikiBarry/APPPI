import '../../domain/models/connected_user.dart';
import '../../domain/models/connexion_response.dart';
import '../../domain/models/login_command.dart';

abstract class ConnexionInputPort {
  //
  Uri getAuthorizationUrl();

  /// Cette fonctionnalité permet d'avoir l'utilisateur connecté
  /// Elle retourne potentiellement le nom et l'avatar
  // tream<ConnectedUser?> loadConnectedUser();
  Future<ConnectedUser?> loadConnectedUser();

  /// Cette fonctionnalité permet a un utilisateur de se connecter
  /// en utilisant son [Username] et  son [Password]
  /// Elle retourne un objet [ConnexionResponse] qui contient
  /// les informations sur la session de l'utilisateur
  Future<ConnexionResponse> login(LoginCommand loginData);

  /// Cette fonctionnalité permet la déconnexion d'un utilisateur
  /// à l'application mobile
  /// Elle permet de detruire la session courante d'un utilisateur
  Future<void> logout();
}
