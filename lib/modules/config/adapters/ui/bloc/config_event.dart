import '../../../domain/models/config_keys.dart';
import '../../../domain/models/config_params.dart';

abstract class ConfigEvent {
  const ConfigEvent();
}

/// Au chargement de la configuration / chargement de l'application
///
class ConfigAskedEvent extends ConfigEvent {
  //
  const ConfigAskedEvent();
}

/// Pour demander le changement de configuration
/// d'un parametre
class ConfigChangeEvent extends ConfigEvent {
  //
  const ConfigChangeEvent(this.configKey, this.configValue);

  // Clé du Parametre de configuration à changer
  final ConfigKey configKey;
  // Valeur du Parametre de configuration à changer
  final String configValue;
}

/// Apres chargement de la configuration
///
class ConfigLoadedEvent extends ConfigEvent {
  //
  const ConfigLoadedEvent(this.configParams);

  // Pour obtenir les préférences enregistrées par l'utilisateur
  // La configuration peut ne pas être défini au début
  final ConfigParams? configParams;
}

/// Lorsqu'une erreur survient lors du chargement des configurations
///
class ConfigErrorEvent extends ConfigEvent {
  //
  const ConfigErrorEvent(this.error);

  // Erreur survenue
  final Exception error;
}
