import 'biometric_method.dart';

class IdentificationResponse {
  //

  IdentificationResponse({
    required this.passed,
    this.error,
    required this.methods,
    this.method,
  });
  final bool passed;
  final IdentificationResponseError? error;
  final List<BiometricMethod> methods;
  final IdentificationResponseMethod? method;
}

/// Types d'erreurs possibles lors de l'identification
enum IdentificationResponseError {
  //
  pinIncorrect,
  pinNotExist;
}

/// Méthode utilisée pour l'identification
enum IdentificationResponseMethod {
  //
  biometry,
  pin;
}
