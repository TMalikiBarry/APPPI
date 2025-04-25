import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/notification/domain/models/notification.dart';
import 'package:pi_mobile_app/modules/notification/domain/models/notification_type.dart';

void main() {
  group('NotificationCommand', () {
    test('notifcation toJson ', () {


      final date = DateTime.now();
      final result = Notification(
        id: "1234",
        idObject: "123errrr",
        type: NotificationType.rtpRecue,
        dateAction: date
        );
      
      expect(result.toJson()["type"], "RTP_RECUE");
    });

    test('notifcation fromJson sans dateLecture', () {

      final json = {
            'id': '1234',
            'type': 'RTP_RECUE',
            'idObject': '123errrr',
            'dateAction':'2025-03-27T13:22:05.237808'
          };

      expect(Notification.fromJson(json).id, "1234");
    });


    test('notifcation fromJson avec dateLecture', () {

      final json = {
            'id': '1234',
            'type': 'RTP_RECUE',
            'idObject': '123errrr',
            'dateAction':'2025-03-27T13:22:05.237808',
            'dateLecture': '2025-03-27T13:22:05.237808'
          };

      expect(Notification.fromJson(json).id, "1234");
    });

  });
}
