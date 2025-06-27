import 'package:flutter/material.dart';
import 'package:micro_core/micro_core.dart';
import 'package:micro_core/services/routing/routing_transitions.dart';
import 'package:pi_mobile_app/modules/pi_app_events.dart';
import 'package:pi_mobile_app/modules/pi_app_inject.dart';

import '../core/app.dart';

class BceaoPIResolver implements MicroApp {
  @override
  String get microAppName => "/bceao-pi";

  @override
  Map<String, WidgetBuilderArgs> get routes => {
    microAppName: (context, args) => const App(), // Try to find a way to merge the to path
    Routes.bceaoPI.value: (context, args) => const App(), // Home PI
  };

  @override
  void initEventListeners() {
    CustomEventBus.on<BceaoPiAppEvent>((event) {
      Routing.pushNamed(Routes.bceaoPI, arguments: event);
    });
  }

  @override
  BceaoPIEvents microAppEvents() => BceaoPIEvents();

  @override
  Widget? microAppWidget() => null;

  @override
  void injectionsRegister() => InjectBceaoPI.initialize();

  @override
  TransitionType? get transitionType => TransitionType.fade;
}