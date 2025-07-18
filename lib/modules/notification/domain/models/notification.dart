import 'package:intl/intl.dart';

import 'notification_type.dart';

class Notification {
  Notification(
        {
          this.id,
          this.type,
          this.idObject,
          this.dateAction,
          this.title,
          this.body,
          this.dateLecture,
          this.details,
          this.timestamp
        }
      );

  /// identifant de la notification
  final String? id;

  /// reference de l'objet concerné
  final String? idObject;

  final String? title;
  final String? body;

  /// Type de la notification
  final NotificationType? type;

  /// Date de l'action à l'origine de la notification
  final DateTime? dateAction;

  /// Indique la date où le clien a lu la notification
  final DateTime? dateLecture;

  final DateTime? timestamp;

  /// Details sur la notification
  final Map<dynamic, dynamic>? details;

  static DateTime? _parseDateAction(String? raw) {
    if (raw == null) return null;
    try {
      // Essaye d'abord ISO
      return DateTime.parse(raw);
    } catch (_) {
      // Fallback: "Mon Jul 14 20:39:38 GMT 2025"
      try {
        return DateFormat("EEE MMM dd HH:mm:ss 'GMT' yyyy", 'en_US')
            .parseUtc(raw)
            .toLocal();
      } catch (e) {
        // Si ça échoue, on renvoie null ou DateTime.now() par précaution
        return null;
      }
    }
  }

  static Notification fromJson(Map<dynamic, dynamic> json) {
    return Notification(
        id: json['id'] as String?,
        type: json['type']!=null? NotificationType.get(json['type']): null,
        idObject: json['idObject'] as String?,
        title: json['title'] as String?,
        body: json['body'] as String?,
        dateAction: _parseDateAction(json['dateAction'] as String?),
        dateLecture: _parseDateAction(json['dateLecture'] as String?), // même parsing
        timestamp: _parseDateAction(json['timestamp'] as String?),
        /*dateAction: json['dateAction']!= null ?
              DateTime.parse(json['dateAction'] as String) : null,
        dateLecture: json['dateLecture'] != null
            ? DateTime.parse(json['dateLecture'] as String)
            : null,
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'] as String)
            : null,*/
        details: json['details'] as Map<dynamic, dynamic>?);
  }

  Map<dynamic, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (type != null) 'type': type!.value,
      if (idObject != null) 'idObject': idObject,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (dateAction != null) 'dateAction': dateAction!.toIso8601String(),
      if (dateLecture != null) 'dateLecture': dateLecture!.toIso8601String(),
      if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
      if (details != null) 'details': details,
    };
  }
}
