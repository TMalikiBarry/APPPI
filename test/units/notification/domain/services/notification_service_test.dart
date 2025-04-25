import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/notification/domain/models/notification_type.dart';
import 'package:pi_mobile_app/modules/notification/domain/services/notification_service.dart';
import 'package:pi_mobile_app/modules/notification/ports/input/notification_input_port.dart';

import '../infra/notification_output_mock.dart';

void main() {
  group('NotificationService - cas succès', () {
    NotificationInputPort service = NotificationService(MockNotificationOutputPort());

    test("lister ", () async {
      await service.list(
        page: 1,
        limit: 2,
        dateDebut: DateTime.now(),
        dateFin:  DateTime.now(), 
        compte: 'CI123456789'
      ).then((value) => () {
            expect(value.data[0].id, "1234");
          });
    });

    test(" search ", () async {
      await service.search(
            page: 1,
            limit: 2,
            dateDebut: DateTime.now(),
            dateFin:  DateTime.now(), 
            compte: 'CI123456789'
          ).then((value) => () {
            expect(value.data[1].id, "1234567");
          });
    });

    test(" read ", () async {
      await service.read("12345").then((value) => () {
            expect(value.type, NotificationType.rtpRecue);
          });
    });

    test(" cunt ", () async {
       await service.count("12345").then((value) => () {
            expect(value, 2);
          });
    });

     
  });

}
