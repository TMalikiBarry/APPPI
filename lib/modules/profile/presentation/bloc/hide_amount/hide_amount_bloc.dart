import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../../config/adapters/ui/bloc/config_event.dart';
import '../../../../config/domain/models/config_keys.dart';
import 'hide_amount_event.dart';
import 'hide_amount_state.dart';

class ParametreHideAmountBloc
    extends Bloc<ParametreHideAmountEvent, ParametreHideAmountState> {
  //
  final logger = Logger();

  /// Bloc de gestion de la config
  final ConfigBloc configBloc;

  StreamSubscription<AccelerometerEvent>? subscription;
  //
  double? oldZ;
  //
  bool downState = false;
  bool upState = false;
  DateTime? downStateTime;
  DateTime? upStateTime;

  ParametreHideAmountBloc(this.configBloc)
      : super(const ParametreHideAmountState()) {
    // Pour initialiser le service
    on<ParametreHideAmountInitEvent>(_onParametreHideAmountInitEvent);
    // Pour ecouter sur les evenements de flip down du device
    on<ParametreHideAmountStartEvent>(_onParametreHideAmountStartEvent);
    // Pour afficher / cacher le montant
    on<ParametreHideAmountStopEvent>(_onParametreHideAmountStopEvent);
  }

  /// Init listening to device flip: start listening or not
  void _onParametreHideAmountInitEvent(
    ParametreHideAmountInitEvent event,
    Emitter<ParametreHideAmountState> emit,
  ) {
    // Paramètre d'ecoute sur le mouvement de rotation (cache l'oeil si activé)
    String? hideEye = configBloc.getParamValue(ConfigKey.hideEye);
    // Souscrire en fonction de la valeur du paramètre de configuration
    if (subscription == null && hideEye == "1") {
      _subscribe();
    }
  }

  /// Start listening to device flip
  void _onParametreHideAmountStartEvent(
    ParametreHideAmountStartEvent event,
    Emitter<ParametreHideAmountState> emit,
  ) {
    if (subscription == null) {
      _subscribe();
      configBloc.add(const ConfigChangeEvent(ConfigKey.hideEye, "1"));
    }
  }

  /// Stop listening to device flip
  void _onParametreHideAmountStopEvent(
    ParametreHideAmountStopEvent event,
    Emitter<ParametreHideAmountState> emit,
  ) {
    _unsubscribe();
    configBloc.add(const ConfigChangeEvent(ConfigKey.hideEye, "0"));
  }

  // Start listening
  void _subscribe() {
    subscription = accelerometerEvents.listen((AccelerometerEvent event) {
      doucoure(event);
    });
  }

  // Stop listening
  void _unsubscribe() {
    if (subscription != null) {
      subscription
          ?.cancel() //
          .then((value) => subscription = null);
    }
  }

  // Hide / Show amount
  void _toggleDisplay() {
    // Paramètre d'affichage du montant
    String? displayAmountParam =
        configBloc.getParamValue(ConfigKey.displayAmount);
    // Inverser l'état
    configBloc.add(
      ConfigChangeEvent(
        ConfigKey.displayAmount,
        displayAmountParam == "1" ? "0" : "1",
      ),
    );
  }

  /// Check position
  void doucoure(AccelerometerEvent event) {
    double xAcceleration = event.x;
    double yAcceleration = event.y;
    double zAcceleration = event.z;

    double elevation = acos(zAcceleration /
            sqrt(pow(xAcceleration, 2) +
                pow(yAcceleration, 2) +
                pow(zAcceleration, 2))) *
        (180.0 / pi).round();

    if (elevation > 0.0 && elevation < 90.0 && !upState) {
      //upStateTime = DateTime.now();
      upState = true;
    }

    if (elevation > 160.0 && elevation < 180.0 && upState) {
      //downStateTime = DateTime.now();
      downState = true;
    }

    if (downState && upState) {
      _toggleDisplay();
      downState = false;
      upState = false;
    }
  }
}
