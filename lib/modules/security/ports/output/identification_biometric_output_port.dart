import '../../domain/models/biometric_method.dart';
import '../../domain/models/identification_response.dart';

abstract class IdentificationBiometricOutputPort {
  //
  /// Cette fonctionnalité pemet de vérifier si l'utilisateur
  /// dispose de la fonctionalité de biométrie
  /// Son appareil le supporte et il l'a configuré
  Future<bool> isBiometryPossible();

  /// Cette fonctionnalité permet de vérifier si l'utilisateur
  /// a autorisé l'application à utiliser la biométrie
  Future<bool?> isBiometryAutorized();

  /// Cette fonctionnalité pemet de dire si l'utilisateur
  /// configure l'identification par biométrie ou pas
  Future<void> configureBiometry(
    bool acceptation,
    List<BiometricMethod> methods,
  );

  /// Cette fonctionnalité permet de se connecter par biométrie
  Future<IdentificationResponse> authenticate();

  /// Liste les méthodes d'identification par biométrie possible
  Future<List<BiometricMethod>> listMethods();
}
