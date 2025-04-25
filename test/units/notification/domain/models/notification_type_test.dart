import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/notification/domain/models/notification_type.dart';

void main() {
  group('NotificationType', () {
    test('NotificationType ArgumentError test', () {

      expect(() => NotificationType.get("INCONNUE"), throwsA(isA<ArgumentError>()));

    });

    test('List of NotificationType test ', () {
      List<NotificationType> list = [
              NotificationType.revendicationInitiee,
              NotificationType.annulationDemandee,
              NotificationType.annulationRejetee,
              NotificationType.rtpInitiee,
              NotificationType.rtpRecue
            ];
      expect(NotificationType.list(), list);

    });
  });
}
