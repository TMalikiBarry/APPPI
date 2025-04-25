import '../../../domain/models/change_password_command.dart';

abstract class ChangePasswordState {
  const ChangePasswordState(this.values, this.passwordVisible);
  // Données du formulaire
  final ChangePasswordCommand values;
  // Mot de passe visible
  final bool passwordVisible;
}

/// Etat du formulaire
class ChangePasswordFormState extends ChangePasswordState {
  ChangePasswordFormState(super.values, super.passwordVisible);
}

/// Montre le loading quand l'utilisateur attend la reponse du serveur
final class ChangePasswordLoadingState extends ChangePasswordState {
  ChangePasswordLoadingState(super.values, super.passwordVisible);
}

/// Etat montrant que le changement de mot de passe a réussi
final class ChangePasswordSuccessState extends ChangePasswordState {
  ChangePasswordSuccessState(super.values, super.passwordVisible);
}

/// Etat montrant que la modification du mot de passe a échoué
final class ChangePasswordErrorState extends ChangePasswordState {
  ChangePasswordErrorState(super.values, super.passwordVisible, this.error);
  final String error;
}
