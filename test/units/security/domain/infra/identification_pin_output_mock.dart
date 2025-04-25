import 'package:pi_mobile_app/modules/security/domain/exceptions/identification_exception.dart';
import 'package:pi_mobile_app/modules/security/ports/output/indentification_pin_output_port.dart';

class MockIdentificationPinOutputPort implements IdentificationPinOutputPort {
  @override
  Future<bool> checkPin(String codePin) async {
    return true;
  }

  @override
  Future<void> createPin(String codePin) async {
    //
  }

  @override
  Future<bool> isPinCreated() async {
    return true;
  }
}

class MockIdentificationPinOutputPortErrors
    implements IdentificationPinOutputPort {
  @override
  Future<bool> checkPin(String codePin) async {
    throw IdentificationException("Error connexion par un code pin");
  }

  @override
  Future<bool> isPinCreated() async {
    return true;
  }

  @override
  Future<void> createPin(String codePin) {
    throw Exception("Error");
  }
}
