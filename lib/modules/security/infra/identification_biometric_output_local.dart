import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';

import '../domain/exceptions/identification_exception.dart';
import '../domain/models/biometric_method.dart';
import '../domain/models/identification_response.dart';
import '../ports/output/identification_biometric_output_port.dart';

class IdentificationBiometricOutputLocal
    implements IdentificationBiometricOutputPort {
  //
  static final logger = Logger();
  //
  final FlutterSecureStorage secureStorage;
  //
  static const keyPermissionCode = "BIOMETRY_AUTHORIZED";
  //
  static final LocalAuthentication _auth = LocalAuthentication();

  // Constructeur
  const IdentificationBiometricOutputLocal(this.secureStorage);

  @override
  Future<bool> isBiometryPossible() async {
    // Vérifie si le device dispose du harware nécessaire pour la biométrie
    // Vérifie également si l'utilisateur a enregistré son face ID ou empreinte
    return await _auth.isDeviceSupported() && await _auth.canCheckBiometrics;
  }

  @override
  Future<bool?> isBiometryAutorized() async {
    // Vérifie si l'application est autorisée à utiliser la biométrie
    String? biometryInfoJson = await secureStorage.read(key: keyPermissionCode);
    if (biometryInfoJson == null) return null;
    // Vérifier si l'utilisateur a marqué qon accord
    final biometryInfo = jsonDecode(biometryInfoJson) as Map<String, dynamic>;
    return biometryInfo["acceptation"] == "1" ? true : false;
  }

  @override
  Future<void> configureBiometry(
    bool acceptation,
    List<BiometricMethod> methods,
  ) async {
    // enregistrer les informations de la configuration
    Map<String, String> biometryInfo = {
      "acceptation": acceptation ? "1" : "0",
      "methods": methods.map((method) => method.name).join(','),
      "date": DateTime.now().toIso8601String()
    };
    String biometryInfoJson = jsonEncode(biometryInfo);
    await secureStorage.write(key: keyPermissionCode, value: biometryInfoJson);
  }

  @override
  Future<IdentificationResponse> authenticate() async {
    try {
      bool isAuthenticate = await _auth.authenticate(
        localizedReason: "Veuillez vous authentifier pour continuer",
        options: const AuthenticationOptions(
          biometricOnly: true,
          // set the stickyAuth option on the plugin to true
          // so that plugin does not return failure
          // if the app is put to background by the system.
          // This might happen if the user receives a phone call
          // before they get a chance to authenticate
          stickyAuth: true,
        ),
      );
      // connexion reussi
      if (isAuthenticate) {
        logger.i("Connexion biometrique réussie");
        // retourner l'utilisateur connecté
        return IdentificationResponse(
          passed: true,
          methods: [],
          method: IdentificationResponseMethod.biometry,
        );
      } else {
        logger.i("Connexion biometrique échouée");
        // echec de la connexion
        return IdentificationResponse(passed: false, methods: []);
      }
    } catch (e) {
      throw IdentificationException(
          "Probleme lors de l'authentification par biométrie", e);
    }
  }

  @override
  Future<List<BiometricMethod>> listMethods() async {
    // Currently the following biometric types are implemented:
    // BiometricType.face
    // BiometricType.fingerprint
    // BiometricType.weak
    // BiometricType.strong
    // Android 11 now divides the biometric options into “strong” and “weak”.
    // Fingerprints are strong; face recognition is weak.
    List<BiometricType> biometricTypes = await _auth.getAvailableBiometrics();
    // Return list of biometic type as asked by the service
    List<BiometricMethod> result = [];
    for (var type in biometricTypes) {
      if (type == BiometricType.fingerprint || type == BiometricType.strong) {
        result.add(BiometricMethod.fingerprint);
      }
      if (type == BiometricType.face || type == BiometricType.weak) {
        result.add(BiometricMethod.face);
      }
      if (type == BiometricType.iris) result.add(BiometricMethod.iris);
    }
    return result;
  }
}
