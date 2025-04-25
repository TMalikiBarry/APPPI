import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../domain/models/config_keys.dart';
import '../../../domain/models/config_params.dart';
import '../../../ports/input/config_input_port.dart';
import 'config_event.dart';
import 'config_state.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  //
  final logger = Logger();

  //
  final ConfigInputPort configInputPort;

  /// ConfigLoadingState est l'état initial de l'app en cours de chargement
  ConfigBloc(this.configInputPort)
      : super(ConfigLoadedState(configInputPort.recuperer(), null)) {
    // Après modification d'une configuration
    on<ConfigChangeEvent>(_onConfigChangeEvent);
  }

  void _onConfigChangeEvent(
    ConfigChangeEvent event,
    Emitter<ConfigState> emit,
  ) async {
    // Appeler le service pour charger la configuration
    await configInputPort.modifier(event.configKey.code, event.configValue);
    logger.i("Change config ${event.configKey} to ${event.configValue}");

    // Update app config params with new state datas
    Map<String, String?> params =
        (state as ConfigLoadedState).configParams.params;
    ConfigParams configParams = ConfigParams(Map.from(params));
    configParams.params[event.configKey.code] = event.configValue;
    emit(ConfigLoadedState(configParams, event.configKey));
  }

  /// Permet d'obtenir la valeur d'un paramètre après chargement de la config
  String? getParamValue(ConfigKey key) {
    Map<String, String?> params =
        (state as ConfigLoadedState).configParams.params;
    return params[key.code];
  }
}
