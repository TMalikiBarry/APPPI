/// Permet d'utiliser les variables d'environnement de l'application
/// Firebase env not displayed here
class AppEnv {
  //
  // dev, test, qa, prod
  static String env = const String.fromEnvironment('ENV');

  // mode demo, reality
  static String mode = const String.fromEnvironment('MODE');

  // niveau de log activé
  static String logLevel = const String.fromEnvironment('LOG_LEVEL');

  // version de l'app
  static String version = const String.fromEnvironment('VERSION');

  /// private constructor which prevents the class from being instantiated.
  AppEnv._();

  /// Récupère la valeur d'une variable d'environnement
  static String getValueFromEnv(String name) => String.fromEnvironment(name);
}
