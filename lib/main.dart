import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart';
import 'core/api.dart';
import 'core/app.dart';
import 'core/di.dart';
import 'core/logger.dart';
import 'core/notifications.dart';
import 'core/observer.dart';
import 'core/storage.dart';

Future<void> main() async {
  // It’s worth noting that calling ensureInitialized()
  // more than once will throw an exception,
  // so it’s important to make sure that this method
  // is only called once per app execution.
  // https://api.flutter.dev/flutter/widgets/WidgetsFlutterBinding/ensureInitialized.html
  // WidgetsFlutterBinding.ensureInitialized();

  // Temporairement à cause du certificat autosigné
  // utilisé sur keycloak dans l'env de test
  HttpOverrides.global = MyHttpOverrides();
  final logger = Logger();

  // // Initialisation de firebase: Système de journalisation, de notification
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // Initialisation de Firebase avec gestion des erreurs
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      logger.w('Firebase Initialisation Erreur ', error: e);
      rethrow; // Relance les erreurs non gérées
    }
    // Ignore spécifiquement l'erreur de duplication
    logger.w('Firebase déjà initialisé ');
  }

/*  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }*/

/*
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      // si ce n’est pas l’erreur de duplication, on remonte
      rethrow;
    }
    // sinon on l’ignore
  }
*/

  // Avant toute chose initialiser le système de journalisation
  await AppLogger.config();

  // Créer une instance de stockage sécurisée
  // Keychain pour IOS et keystore pour android
  const secureStorage = FlutterSecureStorage();

  // Créer une instance de SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initaliser le client API
  Api.initClient(secureStorage);

  // Initialize the caching service
  await AppStorage.init(secureStorage);

  // Initialise le système d'injection des dépendances
  Di.init(prefs, secureStorage);

  // Observer les bloc
  Bloc.observer = AppObserver(); // Ajoutez un observer personnalisé

  // Initialisation du système de gestion des notifications
  await AppNotifications.init(prefs);

  // Run the app
  runApp(App());
}

// TODO Supprimer cette logique avant mise en production
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
