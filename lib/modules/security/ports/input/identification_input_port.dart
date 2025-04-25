import '../../domain/models/biometric_method.dart';
import '../../domain/models/identification_response.dart';
import '../../domain/models/pin_command.dart';

abstract class IdentificationInputPort {
  //
  /// Pour vérifier si l'utilisateur a déjà créé un code PIN
  Future<bool> isPinCreated();

  /// Cette fonctionnalité permet à un utilisateur de créer son code pin
  /// Elle prend en parametre le code pin saisi
  Future<void> setupCodePin(PinCommand codePin);

  /// Cette fonctionnalité permet de verifier le code pin saisi
  /// lors de l'authorisation
  /// Elle prend en parametre le code pin saisi
  Future<IdentificationResponse> identifyUsingCodePin(PinCommand codePin);

  /// Cette fonctionnalité pemet de vérifier si l'utilisateur
  /// dispose de la fonctionalité de biométrie
  Future<bool> isBiometryPossible();

  /// Cette fonctionnalité permet de vérifier si l'utilisateur
  /// a autorisé l'application à utiliser la biométrie
  /// true => autorisé
  /// false => pas autorisé
  /// null => pas encore défini
  Future<bool?> isBiometryAutorized();

  /// Permet de marquer le statut de configuration de la biométrie
  /// [acceptation] marque l'acceptation de l'utilisateur pour l'utilisation
  /// [methods] que l'utilisateur a autorisé
  Future<void> setupBiometry(bool acceptation, List<BiometricMethod> methods);

  /// Cette fonctionnalité pemet de s'identifier par biométrie
  /// Elle prend en charge le faceId ou l'empreinte
  Future<IdentificationResponse> identifyUsingBiometric();

  /// Liste les méthodes d'identification par biométrie possible
  Future<List<BiometricMethod>> listMethods();
}
