import '../../../../shared/models/liste_meta.dart';
import 'notification.dart';

class NotificationListe {
  List<Notification> data;
  final ListeMeta? meta;

  NotificationListe({
    required this.data,
    this.meta,
  });

  factory NotificationListe.fromJson(Map<dynamic, dynamic> json) {
    return NotificationListe(
      data: (json['data'] as List<dynamic>)
          .map((e) => Notification.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: ListeMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  factory NotificationListe.fromJsonNotPaginated(Map<dynamic, dynamic> json) {
    List<Notification> notifications = (json['response'] as List<dynamic>)
        .map((e) => Notification.fromJson(e as Map<String, dynamic>))
        .toList();
    return NotificationListe(
      data: notifications,
      meta: ListeMeta(total: notifications.length, limit: notifications.length),
    );
  }



  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => data.isNotEmpty;
}
