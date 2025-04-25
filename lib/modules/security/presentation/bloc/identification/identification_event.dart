import '../../../domain/models/biometric_method.dart';
import '../../../domain/models/pin_command.dart';

abstract class IdentificationEvent {
  const IdentificationEvent();
}

/// Quand le système demande à l'utilisateur de créer un code PIN
class AskCodePinCreationEvent extends IdentificationEvent {
  //
  const AskCodePinCreationEvent();
}

/// Pour afficher /cacher le mot de passe
class PinNumberSelectedEvent extends IdentificationEvent {
  //
  const PinNumberSelectedEvent(this.digit, this.pinCode, this.position);
  // Numero selectionne
  final int digit;
  // Position du numéro
  final int position;
  // Code Pin entier
  final PinCommand pinCode;
}

/// Quand l'utilisateur crée son code pin
class SetupCodePinEvent extends IdentificationEvent {
  //
  const SetupCodePinEvent(this.pinCode);

  final PinCommand pinCode;
}

/// Quand l'utilisateur veut se connecter en utilisant le code PIN
class CheckCodePinEvent extends IdentificationEvent {
  //
  const CheckCodePinEvent(
    this.digit,
    this.pinCode,
    this.position,
    this.methods,
  );
  // Numero selectionne
  final int digit;
  // Position du numéro
  final int position;
  // Code Pin entier
  final PinCommand pinCode;
  // Permet de donner la possibilité de basculer sur la biométrie
  final List<BiometricMethod> methods;
}

/// Quand le système demande à l'utilisateur de  configurer la biométrie
class AskBiometryConfigurationEvent extends IdentificationEvent {
  //
  const AskBiometryConfigurationEvent();
}

/// Quand l'utilisateur configure sa biométrie
class SetupBiometryEvent extends IdentificationEvent {
  //
  const SetupBiometryEvent(this.methods);
  // Méthodes configurées
  final List<BiometricMethod> methods;
}

/// Quand l'utilisateur veut se connecter en utilisant le code PIN
class CheckBiometryEvent extends IdentificationEvent {
  //
  const CheckBiometryEvent(this.methods);
  final List<BiometricMethod> methods;
}

/// Quand le système demande à l'utilisateur de saisir son code PIN
class AskIdentificationEvent extends IdentificationEvent {
  //
  const AskIdentificationEvent(
    this.codePinConfigured,
    this.biometryPossible,
    this.methods,
  );
  //
  final bool codePinConfigured;
  final bool biometryPossible;
  final List<BiometricMethod> methods;
}

/// Quand le système demande à l'utilisateur de s'authentifier
/// pour autoriser une action
class AskIdentificationBeforeActionEvent extends IdentificationEvent {
  //
  const AskIdentificationBeforeActionEvent();
}
