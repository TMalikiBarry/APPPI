import '../../ports/input/config_input_port.dart';
import '../../ports/output/config_output_port.dart';
import '../models/config_keys.dart';
import '../models/config_params.dart';

/// Service contenant la logique de gestion des configurations
class ConfigService implements ConfigInputPort {
  //
  /// Le service a besoin de [configOutputPort] pour stocker
  /// et recuperer les paramètres de configuration
  const ConfigService(this.configOutputPort);

  /// Port - Repository pour l'enregistrement et la récupération des paramètres
  final ConfigOutputPort configOutputPort;

  @override
  ConfigParams recuperer() {
    // Récuperer toute la config et Appeler le systeme de stockage
    return configOutputPort
        .recuperer(ConfigKey.values.map((el) => el.code).toList());
  }

  @override
  Future<void> modifier(String key, String value) async {
    await configOutputPort.modifier(key, value);
  }
}
