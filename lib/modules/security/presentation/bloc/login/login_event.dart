import '../../../domain/models/login_command.dart';

abstract class LoginEvent {
  const LoginEvent();
}

/// Pour valider le formulaire
class FormChangedEvent extends LoginEvent {
  //
  const FormChangedEvent(this.values, this.passwordVisible);

  final LoginCommand values;
  // Mot de passe visible
  final bool passwordVisible;
}

/// Pour afficher /cacher le mot de passe
class PasswordToggledEvent extends LoginEvent {
  //
  const PasswordToggledEvent(this.values, this.toggle);

  final LoginCommand values;
  final bool toggle;
}

/// Quand l'utilisateur veut se connecter
class ConnexionEvent extends LoginEvent {
  //
  const ConnexionEvent(this.loginData);
  final LoginCommand loginData;
}

/// Quand l'utilisateur veut se connecter
class DeconnexionEvent extends LoginEvent {
  //
  const DeconnexionEvent();
}

/// Quand On veut vérifier si l'utilisateur est connecté
/// Utilisé en mode Demo seulement
class CheckSessionEvent extends LoginEvent {
  //
  const CheckSessionEvent();
}
