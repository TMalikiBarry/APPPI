import '../../domain/models/connected_user.dart';
import '../../domain/models/connexion_response.dart';

abstract class ConnexionOutputPort {
  //
  /// Générer et retourner l'URL du serveur d'autorisation
  /// l'URL vers laquelle l'utilisateur sera redirigé pour s'authentifier
  Uri getAuthorizationUrl();

  /// Cette fonctionnalité permet de récupérer l'utilisateur connecté
  Future<ConnectedUser?> loadConnectedUser();

  /// Cette fonction permet a un utilisateur de se connecter
  /// en utilisant son [Username] et son [Password]
  /// Elle retourne un objet [ConnexionResponse] qui contient
  /// les informations sur la session de l'utilisateur
  Future<ConnexionResponse> login(String username, String password);

  /// Cette fonction permet la déconnexion d'un utilisateur
  /// Elle permet de detruire la session courante d'un utilisateur
  Future<void> logout();
}
