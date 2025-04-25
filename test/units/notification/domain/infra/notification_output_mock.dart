import 'package:pi_mobile_app/modules/notification/domain/models/notification.dart';
import 'package:pi_mobile_app/modules/notification/domain/models/notification_liste.dart';
import 'package:pi_mobile_app/modules/notification/domain/models/notification_type.dart';
import 'package:pi_mobile_app/modules/notification/ports/output/notification_output_port.dart';
import 'package:pi_mobile_app/shared/models/liste_meta.dart';


class MockNotificationOutputPort implements NotificationOutputPort {
  
  @override
  Future<NotificationListe> list({required String compte, int? page, int? limit, DateTime? dateDebut, DateTime? dateFin, List<String> types = const [], String? keyword, String? sortBy, String? fields}) async {
    
    List<Notification> notifications = [
      Notification(
        id: "1234",
        idObject: "123errrr",
        type: NotificationType.rtpRecue,
        dateAction: DateTime.now()
        ),
      Notification(
        id: "1234567",
        idObject: "123errrr8999",
        type: NotificationType.revendicationInitiee,
        dateAction: DateTime.now()
        )
    ];
    return NotificationListe(
      data: notifications,
      meta: ListeMeta(
        total: notifications.length,
        limit: notifications.length,
      ),
    );
  }

  @override
  Future<Notification> read(String id) async {
    return Notification(
        id: "1234",
        idObject: "123errrr",
        type: NotificationType.rtpRecue,
        dateAction: DateTime.now()
        );
  }

  @override
  Future<NotificationListe> search({required String compte, int? page, int? limit, DateTime? dateDebut, DateTime? dateFin, List<String> types = const [], String? keyword, String? sortBy, String? fields}) async {
    
    List<Notification> notifications = [
      Notification(
        id: "1234",
        idObject: "123errrr",
        type: NotificationType.rtpRecue,
        dateAction: DateTime.now()
        ),
      Notification(
        id: "1234567",
        idObject: "123errrr8999",
        type: NotificationType.revendicationInitiee,
        dateAction: DateTime.now()
        )
    ];
    return NotificationListe(
      data: notifications,
      meta: ListeMeta(
        total: notifications.length,
        limit: notifications.length,
      ),
    );
  }
  
  @override
  Future<int> count(String compte) async {
    return 2;
  }
}

