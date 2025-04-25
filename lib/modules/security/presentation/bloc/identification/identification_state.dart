import '../../../domain/models/biometric_method.dart';
import '../../../domain/models/identification_response.dart';

abstract class IdentificationState {
  const IdentificationState(this.pinCode, this.methods);

  // Code PIN
  final List<int> pinCode;
  // Biometry
  final List<BiometricMethod> methods;
}

/// Etat initial de l'identification (identifié ou pas)
final class IdentificationInitialState extends IdentificationState {
  IdentificationInitialState(super.pinCode, super.methods);
}

/// Etat quand l'utilisateur n'a pas de codePin
/// => Demander à l'utilisateur de créer un code PIN
final class IdentificationNotConfiguredState extends IdentificationState {
  IdentificationNotConfiguredState(super.pinCode, super.methods);
}

/// Etat quand l'utilisateur n'est pas encore autorisé à faire des actions
/// => Demander à l'utilisateur de s'authentifier
final class IdentificationRequiredState extends IdentificationState {
  IdentificationRequiredState(super.pinCode, super.methods);
}

/// Etat quand l'utilisateur n'a pas configurer la biométrie
/// => Demander à l'utilisateur d'activer l'identification biométrique
final class BiometryNotConfiguredState extends IdentificationState {
  //
  BiometryNotConfiguredState(super.pinCode, super.methods);
}

/// Etat quand une erreur d'identification survient
final class IdentificationErrorState extends IdentificationState {
  IdentificationErrorState(super.pinCode, super.biometryPossible, this.error);
  final IdentificationResponseError error;
}

/// Etat quand l'utilisateur s'est identifié avec succès
final class IdentificationSuccessState extends IdentificationState {
  final String method;
  IdentificationSuccessState(super.pinCode, super.methods, this.method);
}

/// Etat quand une identification est demandée par une fonctionnalité de l'app
final class IdentificationAskedState extends IdentificationState {
  IdentificationAskedState(super.pinCode, super.methods);
}
