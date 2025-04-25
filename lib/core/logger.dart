import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'env.dart';

/// Cette classe contient la configuration pour la journalisation
/// - Logger
/// - Crashlitics
class AppLogger {
  //
  /// private constructor which prevents the class from being instantiated.
  AppLogger._();

  /// Configure le système de journalisation
  static Future<void> config() async {
    //

    // Définit le niveau de journalisation
    _defineLevel();

    // Pour ne pas polluer les dashboards de crashlytics en mode debug
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(kDebugMode ? false : true);

    // Pour écouter sur les erreurs de flutter et les envoyer vers Crashlytics
    // = FirebaseCrashlytics.instance.recordFlutterFatalError;
    FlutterError.onError = (details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      FlutterError.presentError(details);
      if (kReleaseMode) exit(1);
    };

    // Transmettre toutes les erreurs asynchrones non détectées
    // qui ne sont pas gérées par le framework Flutter à Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  /// Définit le niveau de journalisation
  static void _defineLevel() {
    //
    String logLevel = AppEnv.logLevel;

    if (logLevel == Level.debug.name) {
      Logger.level = Level.debug;
    }
    //
    else if (logLevel == Level.fatal.name) {
      Logger.level = Level.fatal;
    }
    //
    else if (logLevel == Level.error.name) {
      Logger.level = Level.error;
    }
    //
    else if (logLevel == Level.warning.name) {
      Logger.level = Level.warning;
    }
    //
    else if (logLevel == Level.info.name) {
      Logger.level = Level.info;
    }
    //
    else if (logLevel == Level.trace.name) {
      Logger.level = Level.trace;
    }
    //
    else if (logLevel == Level.off.name) {
      Logger.level = Level.off;
    }
    //
    else {
      Logger.level = Level.all;
    }
  }
}
