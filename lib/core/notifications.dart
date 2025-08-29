import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart';
import 'api.dart';
import 'env.dart';

/// Notifications avec Firebase Messaging
class AppNotifications {
  //
  static final logger = Logger();

  //
  static late SharedPreferences sharedPreferences;

  /// Plugin that display our own notification to user
  static FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  /// On Android, notification messages are sent to Notification Channels
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  static final eventStreamController =
      StreamController<NotificationExternalEvent>.broadcast();

  /// Initaliser le système d'ecoute et de gestion des notifications
  static Future<void> init(
    SharedPreferences sharedPreferences,
  ) async {
    // Pour lire paramètres de configuration
    AppNotifications.sharedPreferences = sharedPreferences;

    // Les notifiations lorsque l'app n'est pas au premier plan
    await _handleBackgroundNotifications();

    // Les notifications lorsque l'app est au premier plan
    await _handleForegroundNotifications();

    // Gere l'enregistrement de l'appareil au niveau de firebase
    await _listenToTokenChanges();
  }

  /// Handle notifications when the app is in the background or terminated
  ///
  /// If the application is terminated it will be started,
  /// if it is in the background it will be brought to the foreground.
  static Future<void> _handleBackgroundNotifications() async {
    // If the application is opened from a terminated state
    // a Future containing a RemoteMessage will be returned.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      await _handleBackgroundMessage(initialMessage);
    }

    // Handle any interaction when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    logger.i("Message From Background");
    // Comme l'utilisateur n'est pas dans l'application / on initialise firebase
    await Firebase.initializeApp(
      name: 'pibceao',
      options: DefaultFirebaseOptions.currentPlatform,
    );

    _sendEvent(message);
  }

  /// Diffuse la notification
  static _sendEvent(RemoteMessage message) {
    NotificationExternalEvent event = NotificationExternalEvent(
      idObject: message.data['idObject'],
      type: message.data['type'],
      title: message.notification?.title,
      body: message.notification?.body,
    );
    eventStreamController.add(event);
  }

  /// Handle notifications when the app is in used
  ///
  /// Foreground notifications (also known as "heads up") are those
  /// which display for a brief period of time  above existing applications,
  /// and should be used for important events.
  static Future<void> _handleForegroundNotifications() async {
    // Activer les notifications au premier plan
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    plugin.initialize(initializationSettings);

    // the Firebase Android SDK will block displaying any FCM notification
    // no matter what Notification Channel has been set
    // We need to handle an incoming notification message using onMessage stream
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    logger.i("Handle foreground message");
    RemoteNotification? notification = message.notification;
    if (notification == null) return;
    _sendEvent(message);
  }

  /// Enregistre l'appareil pour l'envoi des notifications
  static Future<String> configure() async {
    logger.i("Configure device for notification");
    if (AppEnv.mode == "demo") {
      return "";
    }
    // To send a message, we need the device's registration token.
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken == null) {
      logger.e("Échec de la récupération du FCM Token.");
      throw NotificationException(
        name: "Token",
        message: "Impossible de récupérer le FCM Token.",
      );
    }

    if (kDebugMode) {
    }

    // Save toekn after configuration
    await _saveFirebaseToken(fcmToken);

    // Listen to token changes
    await _listenToTokenChanges();

    return fcmToken;
  }

  /// Enregister le token qui sera utiliser pour notifier l'appareil
  static Future<String> _saveFirebaseToken(String token) async {
    String deviceId = await _getDeviceId();
    if (kDebugMode) {
      print("deviceId récupéré : $deviceId");
    }
    // Vous pouvez choisir de l'enregistrer où vous voulez.
    // Le backend doit pouvoir le récupérer pour envoyer une notification
    try {
      await Api.post(
        '/notifications/tokens',
        data: {
          'deviceId': deviceId,
          'token': token,
        },
      );
    } //
    catch (e) {
      throw NotificationException(
        name: "API",
        message: "Erreur d'enregistrement du token",
      );
    }

    return token;
  }

  /// Ecoute sur les changements du token FCM
  static Future<void> _listenToTokenChanges() async {
    // Only if notifications are activated
    String? canNotif =
        AppNotifications.sharedPreferences.getString("PERMISSION_NOTIFICATION");
    if (canNotif != null && canNotif == "1") {
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        if (kDebugMode) {
          print("New FCM Token : $newToken");
        }

        await _saveFirebaseToken(newToken);
      });
    }
  }

  /// Retourne l'identifiant de l'appareil
  static Future<String> _getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return "${androidInfo.hardware}-${androidInfo.fingerprint}";
    } //
    else if (defaultTargetPlatform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor!;
    }
    throw NotificationException(
      name: "Device",
      message: "Unsupported plateform",
    );
  }

  static Future<void> showCustomTransferNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'transaction_channel',
      'Transaction',
      channelDescription: 'Notification de transaction',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: 'ic_stat_notify',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
    DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}

class NotificationException implements Exception {
  //
  late final String name;
  late final String message;

  NotificationException({
    required this.message, //
    required this.name,
  });
}

class NotificationExternalEvent {
  //
  static const String notificationStyleSnackBar = "snackbar";
  static const String notificationStyleDialog = "dialog";

  NotificationExternalEvent({
    this.idObject,
    this.type,
    this.title,
    this.body,
  });

  final String? idObject; // identifinant de l'objet concerné
  final String? type;
  final String? title;
  final String? body;
}
