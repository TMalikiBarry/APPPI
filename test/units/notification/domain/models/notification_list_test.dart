import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/notification/domain/models/notification_liste.dart';
import 'package:pi_mobile_app/modules/notification/domain/models/notification_type.dart';

void main() {
  group('NotificationListe', () {
    test('notifcationList fromJson ', () {

      Map<String, dynamic> listJson = {
        "data":[
            {
              "id": "1234",
              "idObject": "123errrr",
              "type": "REVENDICATION_INITIEE",
              "dateAction": DateTime.now().toString()
            },
            {
              "id": "1234567",
            "idObject": "123errrr8999",
            "type":"RTP_RECUE",
            "dateAction": DateTime.now().toString()
            }
          ],
        "meta": {
           "total": 2,
            "limit": 2
        }
      };

      final notificationListe = NotificationListe.fromJson(listJson);
      
      expect(notificationListe.isEmpty, false);
      expect(notificationListe.isNotEmpty, true);
    });

  });
}
