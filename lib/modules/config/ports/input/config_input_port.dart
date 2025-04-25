import '../../domain/models/config_params.dart';

///
/// Porte d'entrée pour pouvoir gerer la configuration de l'app
///
abstract class ConfigInputPort {
  ///
  /// Récupère la configuration de l'application
  ///
  ConfigParams recuperer();

  ///
  /// Mets à jour la configuration de [key] avec la valeur [value]
  ///
  Future<void> modifier(String key, String value);
}
