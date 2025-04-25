import '../../domain/models/config_params.dart';
import '../../ports/output/config_output_port.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigOutputPrefs implements ConfigOutputPort {
  //
  final SharedPreferences sharedPreferences;

  /// [sharedPreferences] est utilisé pour stocker et
  /// recuperer les paramètres de configuration
  const ConfigOutputPrefs(this.sharedPreferences);

  @override
  ConfigParams recuperer(List<String> keys) {
    // récupérer les configurations et les mettre dans un map
    Map<String, String?> params = {
      for (var paramkey in keys) paramkey: sharedPreferences.getString(paramkey)
    };
    return ConfigParams(params);
  }

  @override
  Future<void> modifier(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }
}
