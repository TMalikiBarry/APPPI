import '../../ports/input/identification_input_port.dart';
import '../../ports/output/identification_biometric_output_port.dart';
import '../../ports/output/indentification_pin_output_port.dart';
import '../exceptions/identification_exception.dart';
import '../models/biometric_method.dart';
import '../models/identification_response.dart';
import '../models/pin_command.dart';

class IdentificationService implements IdentificationInputPort {
  //
  final IdentificationBiometricOutputPort identificationBiometricOutputPort;
  final IdentificationPinOutputPort identificationPinOutputPort;

  ///
  const IdentificationService(
    this.identificationBiometricOutputPort,
    this.identificationPinOutputPort,
  );

  @override
  Future<bool> isPinCreated() {
    return identificationPinOutputPort.isPinCreated();
  }

  @override
  Future<void> setupCodePin(PinCommand codePin) {
    try {
      return identificationPinOutputPort.createPin(codePin.value.join());
    } //
    catch (e) {
      throw Exception(
          "Error rencontrée pendant la configuration du code pin $e");
    }
  }

  @override
  Future<IdentificationResponse> identifyUsingCodePin(
      PinCommand codePin) async {
    try {
      bool response =
          await identificationPinOutputPort.checkPin(codePin.value.join());
      return IdentificationResponse(
        passed: response,
        methods: [],
        method: IdentificationResponseMethod.pin,
      );
    } //
    catch (e) {
      throw IdentificationException("Error connexion par un code pin", e);
    }
  }

  @override
  Future<bool> isBiometryPossible() async {
    return await identificationBiometricOutputPort.isBiometryPossible();
  }

  @override
  Future<bool?> isBiometryAutorized() async {
    return await identificationBiometricOutputPort.isBiometryAutorized();
  }

  @override
  Future<void> setupBiometry(
      bool acceptation, List<BiometricMethod> methods) async {
    await identificationBiometricOutputPort.configureBiometry(
      acceptation,
      methods,
    );
  }

  @override
  Future<List<BiometricMethod>> listMethods() async {
    return await identificationBiometricOutputPort.listMethods();
  }

  @override
  Future<IdentificationResponse> identifyUsingBiometric() async {
    try {
      return await identificationBiometricOutputPort.authenticate();
    } //
    catch (e) {
      throw IdentificationException("Biometric identification error", e);
    }
  }
}
