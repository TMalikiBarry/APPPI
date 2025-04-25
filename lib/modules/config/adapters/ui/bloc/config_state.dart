import '../../../domain/models/config_keys.dart';
import '../../../domain/models/config_params.dart';

abstract class ConfigState {
  // paramètre de configuration
  final ConfigParams configParams;
  const ConfigState(this.configParams);
}

/// La configuration a chargé
/// L'état de l'application après chargement de la configuration
class ConfigLoadedState extends ConfigState {
  //
  final ConfigKey? updatedKey;
  const ConfigLoadedState(super.configParams,this.updatedKey);
}
