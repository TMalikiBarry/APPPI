import '../../../domain/models/change_password_command.dart';

abstract class ChangePasswordEvent {
  const ChangePasswordEvent();
}

/// Pour valider le formulaire
class FormChangedEvent extends ChangePasswordEvent {
  //
  const FormChangedEvent(this.values, this.passwordVisible);
  //
  final ChangePasswordCommand values;
  // Mot de passe visible
  final bool passwordVisible;
}

/// Pour afficher /cacher le mot de passe
class PasswordToggledEvent extends ChangePasswordEvent {
  //
  const PasswordToggledEvent(this.values, this.toggle);

  final ChangePasswordCommand values;
  final bool toggle;
}

/// Quand l'utilisateur veut changer son mot de passe
class SendPasswordEvent extends ChangePasswordEvent {
  //
  const SendPasswordEvent(this.changePasswordData);
  //
  final ChangePasswordCommand changePasswordData;
}
