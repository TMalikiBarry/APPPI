import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import '../ports/output/indentification_pin_output_port.dart';

class IdentificationPinOutputLocal implements IdentificationPinOutputPort {
  //
  static final logger = Logger();
  static const keyPinCode = "PIN_CODE";
  static const Hash hasher = sha256;

  final FlutterSecureStorage secureStorage;

  // Constrctor
  const IdentificationPinOutputLocal(this.secureStorage);

  @override
  Future<bool> isPinCreated() async {
    // recuperer le code pin de l'utilisateur
    String? userCodePin = await secureStorage.read(key: keyPinCode);
    return userCodePin != null && userCodePin.isNotEmpty;
  }

  /// Cette fonctionnalité nous permet d'enregistrer
  /// le code pin de l'utilisateur
  /// Elle prend en parametre le code pin [codePin]
  @override
  Future<void> createPin(String codePin) async {
    try {
      // encoder le code pin en utf8
      Digest codePinHash = _hashPin(codePin);

      // enregistrer le code pin de l'utilisateur
      Map<String, String> pinDatas = {
        "code": codePinHash.toString(),
        "date": DateTime.now().toIso8601String()
      };
      String jsonPin = jsonEncode(pinDatas);
      await secureStorage.write(key: keyPinCode, value: jsonPin);
      logger.i("PIN is saved");
    } catch (e) {
      logger.i("Problem during pin code saving $e");
      throw Exception("Problem during pin code saving $e");
    }
  }

  /// Calcule et retourne un hash du code PIN
  Digest _hashPin(String codePin) {
    // encoder le code pin en utf8
    var codePinEncode = utf8.encode(codePin);
    // hasher le code pin
    return hasher.convert(codePinEncode);
  }

  /// Cette fonctionnalité permet la connexion à partir du code pin
  @override
  Future<bool> checkPin(String codePin) async {
    try {
      // recuperer le  hash du code pin de l'utilisateur
      String? jsonPin = await secureStorage.read(key: keyPinCode);

      // Si le code pin saisi existe dans le local Storage
      if (jsonPin!.isNotEmpty) {
        final pinDatas = jsonDecode(jsonPin) as Map<String, dynamic>;

        // Hasher le code PIN à verifier
        Digest pinToCheck = _hashPin(codePin);

        // Comparer le PIN enregistrée avec le PIN donné
        if (pinDatas["code"].toString() == pinToCheck.toString()) {
          logger.i("Connexion établie avec le code Pin");
          return true;
        } else {
          logger.i("Le code pin saisi est incorrecte");
          return false;
        }
      }
      // connexion échoué car code pin inccorrecte
      else {
        logger.i("Problem invalid pin code");
        return false;
      }
    } catch (e) {
      logger.i("Problem during connexion with pin code\n $e");
      throw Exception("Problem during connexion with pin code $e");
    }
  }
}
