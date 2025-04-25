import 'package:pi_mobile_app/modules/security/domain/exceptions/identification_exception.dart';
import 'package:pi_mobile_app/modules/security/domain/models/biometric_method.dart';
import 'package:pi_mobile_app/modules/security/domain/models/identification_response.dart';
import 'package:pi_mobile_app/modules/security/ports/output/identification_biometric_output_port.dart';

class MockIdentificationBiometricOutputPort
    implements IdentificationBiometricOutputPort {
  @override
  Future<IdentificationResponse> authenticate() async {
    return IdentificationResponse(passed: true, methods: []);
  }

  @override
  Future<void> configureBiometry(
      bool acceptation, List<BiometricMethod> methods) async {
    //
  }

  @override
  Future<bool?> isBiometryAutorized() async {
    return true;
  }

  @override
  Future<bool> isBiometryPossible() async {
    return true;
  }

  @override
  Future<List<BiometricMethod>> listMethods() async {
    return [
      BiometricMethod.face,
      BiometricMethod.fingerprint,
      BiometricMethod.iris
    ];
  }
}

class MockIdentificationBiometricOutputPortErrors
    implements IdentificationBiometricOutputPort {
  @override
  Future<IdentificationResponse> authenticate() async {
    throw IdentificationException("Biometric identification error");
  }

  @override
  Future<void> configureBiometry(
      bool acceptation, List<BiometricMethod> methods) async {
    //
  }

  @override
  Future<bool?> isBiometryAutorized() async {
    return true;
  }

  @override
  Future<bool> isBiometryPossible() async {
    return true;
  }

  @override
  Future<List<BiometricMethod>> listMethods() async {
    return [
      BiometricMethod.face,
      BiometricMethod.fingerprint,
      BiometricMethod.iris
    ];
  }
}
