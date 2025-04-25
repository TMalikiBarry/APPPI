import 'notification_type.dart';

class Notification {
  Notification(
      {required this.id,
      required this.type,
      required this.idObject,
      required this.dateAction,
      this.dateLecture,
      this.details});

  /// identifant de la notification
  final String id;

  /// reference de l'objet concerné
  final String idObject;

  /// Type de la notification
  final NotificationType type;

  /// Date de l'action à l'origine de la notification
  final DateTime dateAction;

  /// Indique la date où le clien a lu la notification
  final DateTime? dateLecture;

  /// Details sur la notification
  final Map<dynamic, dynamic>? details;

  static Notification fromJson(Map<dynamic, dynamic> json) {
    return Notification(
        id: json['id'] as String,
        type: NotificationType.get(json['type']),
        idObject: json['idObject'] as String,
        dateAction: DateTime.parse(json['dateAction'] as String),
        dateLecture: json['dateLecture'] != null
            ? DateTime.parse(json['dateLecture'] as String)
            : null,
        details: json['details'] as Map<dynamic, dynamic>?);
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'type': type.value,
      'idObject': idObject,
      'dateAction': dateAction.toIso8601String(),
      if (dateLecture != null) 'dateLecture': dateLecture!.toIso8601String(),
      if (details != null) 'details': details,
    };
  }
}
