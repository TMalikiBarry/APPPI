import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:micro_core/micro_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart';
import 'api.dart';
import 'env.dart';

/// Service de notifications amélioré avec Firebase Messaging
class AppNotifications {
  static final logger = Logger();
  static late SharedPreferences sharedPreferences;

  /// Plugin pour afficher nos propres notifications
  static FlutterLocalNotificationsPlugin plugin =
  FlutterLocalNotificationsPlugin();

  /// Canal de notification Android haute importance
  static const AndroidNotificationChannel highImportanceChannel =
  AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    enableVibration: true,
    playSound: true,
  );

  /// Canal pour les notifications de transaction
  static const AndroidNotificationChannel transactionChannel =
  AndroidNotificationChannel(
    'transaction_channel',
    'Transaction Notifications',
    description: 'Notifications for financial transactions',
    importance: Importance.high,
    enableVibration: true,
    playSound: true,
  );

  /// Canal pour les services foreground
  static const AndroidNotificationChannel foregroundServiceChannel =
  AndroidNotificationChannel(
    'foreground_service_channel',
    'Foreground Service',
    description: 'Persistent notifications for background services',
    importance: Importance.low,
    enableVibration: false,
    playSound: false,
  );

  /// Canal pour les notifications de progression
  static const AndroidNotificationChannel progressChannel =
  AndroidNotificationChannel(
    'progress_channel',
    'Progress Notifications',
    description: 'Notifications showing progress of operations',
    importance: Importance.low,
    enableVibration: false,
    playSound: false,
  );

  static final eventStreamController =
  StreamController<NotificationExternalEvent>.broadcast();

  static bool _isInitialized = false;

  /// Initialise le système de notifications
  static Future<void> init(SharedPreferences sharedPreferences) async {
    if (_isInitialized) return;

    AppNotifications.sharedPreferences = sharedPreferences;

    // Créer les canaux de notification
    await _createNotificationChannels();

    // Demander les permissions
    await _requestPermissions();

    // Gérer les notifications background
    await _handleBackgroundNotifications();

    // Gérer les notifications foreground
    await _handleForegroundNotifications();

    // Écouter les changements de token
    await _listenToTokenChanges();

    _isInitialized = true;
    logger.i("Système de notifications initialisé avec succès");
  }

  /// Crée les canaux de notification Android
  static Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      await plugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(highImportanceChannel);

      await plugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(transactionChannel);

      await plugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(foregroundServiceChannel);

      await plugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(progressChannel);
    }
  }

  /// Demande les permissions nécessaires
  static Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      // Permission de base pour les notifications
      PermissionStatus status = await Permission.notification.request();
      if (status != PermissionStatus.granted) {
        logger.w("Permission de notification refusée");
        return false;
      }

      // Permission pour les alarmes exactes (Android 12+)
      if (await Permission.scheduleExactAlarm.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }

      // Permission Firebase Messaging
      NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        logger.i("Permissions accordées");
        await sharedPreferences.setString("PERMISSION_NOTIFICATION", "1");
        return true;
      } else {
        logger.w("Permissions Firebase refusées");
        await sharedPreferences.setString("PERMISSION_NOTIFICATION", "0");
        return false;
      }
    }

    if (Platform.isIOS) {
      NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission();

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await sharedPreferences.setString("PERMISSION_NOTIFICATION", "1");
        return true;
      } else {
        await sharedPreferences.setString("PERMISSION_NOTIFICATION", "0");
        return false;
      }
    }

    return false;
  }

  /// Vérifie si les notifications sont autorisées
  static Future<bool> areNotificationsEnabled() async {
    String? canNotif = sharedPreferences.getString("PERMISSION_NOTIFICATION");
    return canNotif == "1";
  }

  /// Ouvre les paramètres de l'application
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  /// Gère les notifications en arrière-plan
  static Future<void> _handleBackgroundNotifications() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      await _handleBackgroundMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    logger.i("Message reçu depuis l'arrière-plan");

    try {
      _sendEvent(message);
      // Marquer qu'une notification est arrivée
    /*  NotificationArrival.lastMessage = message;
      NotificationArrival.justArrived.value = true;*/

      // Sauvegarder dans SharedPreferences
      final pref = await SharedPreferences.getInstance();
      await pref.setBool('hasUnreadNotification', true);
    } catch (e) {
      logger.e("Erreur lors de l'initialisation Firebase: $e");
    }
  }

  /// Diffuse l'événement de notification
  static _sendEvent(RemoteMessage message) {
    NotificationExternalEvent event = NotificationExternalEvent(
      idObject: message.data['idObject'],
      type: message.data['type'],
      title: message.notification?.title,
      body: message.notification?.body,
      data: message.data,
      priority: _getNotificationPriority(message.data['priority']),
    );
    eventStreamController.add(event);
  }

  /// Détermine la priorité de la notification
  static NotificationPriority _getNotificationPriority(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return NotificationPriority.high;
      case 'low':
        return NotificationPriority.low;
      default:
        return NotificationPriority.defaultPriority;
    }
  }

  /// Gère les notifications au premier plan
  static Future<void> _handleForegroundNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  /// Gère le tap sur une notification
  static void _onNotificationTap(NotificationResponse response) {
    logger.i('Notification tappée: ${response.payload}');

    try {
      if (response.payload != null) {
        Map<String, dynamic> data = jsonDecode(response.payload!);
        _handleNotificationAction(data);
      } else {
        _navigateToDefault();
      }
    } catch (e) {
      logger.e("Erreur lors du traitement du tap: $e");
      _navigateToDefault();
    }
  }

  /// Gère l'action de la notification
  static void _handleNotificationAction(Map<String, dynamic> data) {
    String? type = data['type'];
    String? route = data['route'];

    if (route != null) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        route,
            (Route<dynamic> route) => false,
        arguments: data,
      );
    } else if (type == 'transaction') {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        Routes.homeWalletTFS.value,
            (Route<dynamic> route) => false,
        arguments: RouteEvents.walletTFSEvents
            .userWalletTFSLoggedInEvent("Wallet TFS"),
      );
    } else {
      _navigateToDefault();
    }
  }

  /// Navigation par défaut
  static void _navigateToDefault() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      Routes.homeWalletTFS.value,
          (Route<dynamic> route) => false,
      arguments: RouteEvents.walletTFSEvents
          .userWalletTFSLoggedInEvent("Wallet TFS"),
    );
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    logger.i("Message reçu au premier plan");
    RemoteNotification? notification = message.notification;

    if (notification == null) return;

    // Affiche la notification locale
    _showLocalNotification(message);

    // Diffuse l'événement
    _sendEvent(message);

/*    NotificationArrival.lastMessage = message;
    NotificationArrival.justArrived.value = true;*/

    // Sauvegarder dans SharedPreferences
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('hasUnreadNotification', true);
  }

  /// Affiche une notification locale
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    if (notification == null) return;

    String channelId = _getChannelId(message.data['type']);

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance: _getImportance(message.data['priority']),
      priority: _getPriority(message.data['priority']),
      icon: message.data['icon'] ?? 'ic_stat_notify',
      enableVibration: channelId != foregroundServiceChannel.id,
      playSound: channelId != foregroundServiceChannel.id,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    Map<String, dynamic> payload = {
      ...message.data,
      'notification_id': DateTime.now().millisecondsSinceEpoch,
    };

    await plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: jsonEncode(payload),
    );
  }

  /// Détermine l'ID du canal selon le type
  static String _getChannelId(String? type) {
    switch (type?.toLowerCase()) {
      case 'transaction':
        return transactionChannel.id;
      case 'service':
        return foregroundServiceChannel.id;
      case 'progress':
        return progressChannel.id;
      default:
        return highImportanceChannel.id;
    }
  }

  /// Nom du canal
  static String _getChannelName(String channelId) {
    switch (channelId) {
      case 'transaction_channel':
        return 'Transactions';
      case 'foreground_service_channel':
        return 'Service en arrière-plan';
      case 'progress_channel':
        return 'Progression';
      default:
        return 'Notifications importantes';
    }
  }

  /// Description du canal
  static String _getChannelDescription(String channelId) {
    switch (channelId) {
      case 'transaction_channel':
        return 'Notifications pour les transactions financières';
      case 'foreground_service_channel':
        return 'Notifications persistantes pour les services';
      case 'progress_channel':
        return 'Notifications de progression des opérations';
      default:
        return 'Notifications importantes de l\'application';
    }
  }

  /// Importance Android selon la priorité
  static Importance _getImportance(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return Importance.high;
      case 'low':
        return Importance.low;
      default:
        return Importance.defaultImportance;
    }
  }

  /// Priorité Android selon la priorité
  static Priority _getPriority(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return Priority.high;
      case 'low':
        return Priority.low;
      default:
        return Priority.defaultPriority;
    }
  }

  /// Configure l'appareil pour les notifications
  static Future<String> configure() async {
    logger.i("Configuration de l'appareil pour les notifications");

    if (AppEnv.mode == "demo") {
      return "";
    }

    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken == null) {
        logger.e("Échec de la récupération du FCM Token.");
        throw NotificationException(
          name: "Token",
          message: "Impossible de récupérer le FCM Token.",
        );
      }

      await _saveFirebaseToken(fcmToken);
      await _listenToTokenChanges();

      return fcmToken;
    } catch (e) {
      logger.e("Erreur lors de la configuration: $e");
      rethrow;
    }
  }

  /// Sauvegarde le token Firebase
  static Future<String> _saveFirebaseToken(String token) async {
    String deviceId = await _getDeviceId();

    if (kDebugMode) {
     //print"Device ID récupéré : $deviceId");
    }

    try {
      await Api.post(
        '/notifications/tokens',
        data: {
          'deviceId': deviceId,
          'token': token,
        },
      );

      // Sauvegarder localement pour référence
      await sharedPreferences.setString('FCM_TOKEN', token);
      await sharedPreferences.setString('DEVICE_ID', deviceId);

      logger.i("Token sauvegardé avec succès");
    } catch (e) {
      logger.e("Erreur d'enregistrement du token: $e");
      throw NotificationException(
        name: "API",
        message: "Erreur d'enregistrement du token",
      );
    }

    return token;
  }

  /// Écoute les changements de token FCM
  static Future<void> _listenToTokenChanges() async {
    if (await areNotificationsEnabled()) {
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        if (kDebugMode) {
         //print"Nouveau FCM Token : $newToken");
        }

        try {
          await _saveFirebaseToken(newToken);
        } catch (e) {
          logger.e("Erreur lors de la mise à jour du token: $e");
        }
      });
    }
  }

  /// Retourne l'identifiant unique de l'appareil
  static Future<String> _getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return "${androidInfo.hardware}-${androidInfo.fingerprint}";
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'unknown-ios-device';
      }
    } catch (e) {
      logger.e("Erreur lors de la récupération du device ID: $e");
    }

    throw NotificationException(
      name: "Device",
      message: "Plateforme non supportée",
    );
  }

  /// Affiche une notification personnalisée de transaction
  static Future<void> showCustomTransferNotification({
    required String title,
    required String body,
    String? payload,
    Map<String, String>? additionalData,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'transaction_channel',
      'Transactions',
      channelDescription: 'Notifications de transactions',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: 'ic_stat_notify',
      enableVibration: true,
      playSound: true,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    Map<String, dynamic> notificationPayload = {
      'type': 'transaction',
      'route': Routes.homeWalletTFS.value,
      if (additionalData != null) ...additionalData,
      if (payload != null) 'custom_payload': payload,
    };

    await plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      platformChannelSpecifics,
      payload: jsonEncode(notificationPayload),
    );
  }

  /// Affiche une notification de service foreground
  static Future<void> showForegroundServiceNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool ongoing = true,
  }) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      foregroundServiceChannel.id,
      foregroundServiceChannel.name,
      channelDescription: foregroundServiceChannel.description,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: ongoing,
      autoCancel: false,
      showWhen: true,
      enableVibration: false,
      playSound: false,
      icon: 'ic_stat_notify',
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: true,
      presentSound: false,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await plugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  /// Affiche une notification avec progression
  static Future<void> showProgressNotification({
    required int id,
    required String title,
    required int progress,
    int maxProgress = 100,
    String? body,
    bool ongoing = true,
  }) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      progressChannel.id,
      progressChannel.name,
      channelDescription: progressChannel.description,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: ongoing,
      showProgress: true,
      maxProgress: maxProgress,
      progress: progress,
      onlyAlertOnce: true,
      enableVibration: false,
      playSound: false,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: true,
      presentSound: false,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await plugin.show(
      id,
      title,
      body ?? '$progress/$maxProgress',
      platformChannelSpecifics,
    );
  }

  /// Annule une notification
  static Future<void> cancelNotification(int id) async {
    await plugin.cancel(id);
  }

  /// Annule toutes les notifications
  static Future<void> cancelAllNotifications() async {
    await plugin.cancelAll();
  }

  /// Met à jour une notification existante
  static Future<void> updateNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    // Réaffiche la notification avec le même ID
    await showForegroundServiceNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
    );
  }

  /// Nettoyage des ressources
  static void dispose() {
    eventStreamController.close();
  }
}

/// Exception personnalisée pour les notifications
class NotificationException implements Exception {
  final String name;
  final String message;

  NotificationException({
    required this.message,
    required this.name,
  });

  @override
  String toString() => 'NotificationException($name): $message';
}

/// Priorités de notification
enum NotificationPriority { high, defaultPriority, low }

/// Événement de notification externe amélioré
class NotificationExternalEvent {
  static const String notificationStyleSnackBar = "snackbar";
  static const String notificationStyleDialog = "dialog";

  final String? idObject;
  final String? type;
  final String? title;
  final String? body;
  final Map<String, dynamic>? data;
  final NotificationPriority priority;
  final DateTime timestamp;

  NotificationExternalEvent({
    this.idObject,
    this.type,
    this.title,
    this.body,
    this.data,
    this.priority = NotificationPriority.defaultPriority,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Conversion en Map pour sérialisation
  Map<String, dynamic> toMap() => {
    'idObject': idObject,
    'type': type,
    'title': title,
    'body': body,
    'data': data,
    'priority': priority.index,
    'timestamp': timestamp.toIso8601String(),
  };

  /// Création depuis une Map
  factory NotificationExternalEvent.fromMap(Map<String, dynamic> map) =>
      NotificationExternalEvent(
        idObject: map['idObject'],
        type: map['type'],
        title: map['title'],
        body: map['body'],
        data: map['data'],
        priority: NotificationPriority.values[map['priority'] ?? 1],
        timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      );
}