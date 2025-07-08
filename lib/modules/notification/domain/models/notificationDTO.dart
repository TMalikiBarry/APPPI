class NotificationDTO {
  final String phoneNumber;
  final String body;
  final String title;
  final String fcmToken;
  final int seconds;
  final int nanos;

  NotificationDTO({
    required this.phoneNumber,
    required this.body,
    required this.title,
    required this.fcmToken,
    required this.seconds,
    required this.nanos,
  });

  factory NotificationDTO.fromJson(Map<String, dynamic> json) => NotificationDTO(
    phoneNumber: json['phoneNumber'] as String,
    body:        json['body'] as String,
    title:       json['title'] as String,
    fcmToken:    json['fcmToken'] as String,
    seconds:     (json['timestamp']['seconds'] as num).toInt(),
    nanos:       (json['timestamp']['nanos']   as num).toInt(),
  );

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'body':        body,
    'title':       title,
    'fcmToken':    fcmToken,
    'timestamp': {
      'seconds': seconds,
      'nanos':   nanos,
    },
  };
}

// Modèle Dart utilisé dans l’app
class NotificationModel {
  final String phoneNumber;
  final String body;
  final String title;
  final String fcmToken;
  final DateTime timestamp;

  NotificationModel({
    required this.phoneNumber,
    required this.body,
    required this.title,
    required this.fcmToken,
    required this.timestamp,
  });
}

extension NotificationMapper on NotificationDTO {
  NotificationModel toModel() {
    return NotificationModel(
      phoneNumber: phoneNumber,
      body:        body,
      title:       title,
      fcmToken:    fcmToken,
      timestamp:   DateTime.fromMillisecondsSinceEpoch(
        seconds * 1000 + (nanos / 1e6).round(),
      ),
    );
  }
}