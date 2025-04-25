import '../../../domain/models/connected_user.dart';
import '../../../domain/models/login_command.dart';

abstract class LoginState {
  // Constructor
  const LoginState(this.values, this.passwordVisible);
  // Données du formulaire
  final LoginCommand values;
  // Mot de passe visible
  final bool passwordVisible;
}

/// Etat du formulaire
class LoginFormState extends LoginState {
  LoginFormState(super.values, super.passwordVisible);
}

/// Montre le loading quand l'utilisateur attend la reponse du serveur
final class LoginLoadingState extends LoginState {
  LoginLoadingState(super.values, super.passwordVisible);
}

/// Etat montrant que la connexion à l'application est effective
final class LoginSuccessState extends LoginState {
  final ConnectedUser? user;
  LoginSuccessState(super.values, super.passwordVisible, this.user);
}

/// Etat montrant qu'une erreur de tentative de connexion est survenue
final class LoginErrorState extends LoginState {
  final String error;
  LoginErrorState(super.values, super.passwordVisible, this.error);
}

/// Etat quand l'utilisateur a pu se connecter
/// Elle permet d'afficher le challenge a l'utilisateur
final class LoginChallengedState extends LoginState {
  //
  LoginChallengedState(super.values, super.passwordVisible, this.challenge);
  //
  final String challenge;
}
