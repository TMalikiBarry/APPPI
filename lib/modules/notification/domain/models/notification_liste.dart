import '../../../../shared/models/liste_meta.dart';
import 'notification.dart';

class NotificationListe {
  List<Notification> data;
  final ListeMeta meta;

  NotificationListe({
    required this.data,
    required this.meta,
  });

  factory NotificationListe.fromJson(Map<dynamic, dynamic> json) {
    return NotificationListe(
      data: (json['data'] as List<dynamic>)
          .map((e) => Notification.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: ListeMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => data.isNotEmpty;
}
