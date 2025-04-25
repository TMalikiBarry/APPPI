import 'dart:ffi';

import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/subscription/domain/models/subscription.dart';
import 'package:pi_mobile_app/modules/subscription/domain/models/subscription_command.dart';
import 'package:pi_mobile_app/modules/subscription/domain/services/subscription_service.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_liste.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_motif.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_send/transaction_send_command_schedule.dart';
import 'package:pi_mobile_app/shared/models/frequence_command.dart';

import '../infra/souscription_output_mock.dart';


void main() {
  group('SubscriptionService - cas succès', () {
    SubscriptionService service =
        SubscriptionService(MockSouscriptionOutputPort());

    test("SubscriptionService - List ", () async {
      
      await service.list(compte: "CI32100008888").then((value) => () {
            expect(value[0].endToEndId, "Esnfbg566");
          });
    });

    test("SubscriptionService - update ", () async {

      final transacationSchedule = TransactionSendCommandSchedule(
        dateDebut: DateTime(2023, 12, 4, 14, 30),
        dateFin: DateTime(2023, 12, 4, 14, 30),
        frequence: FrequenceCommand( value: Frequence.annuelle, periodicite: 1),
        error: TransactionSendCommandScheduleError.debutEmpty
      );

      final souscriptionCommand = SubscriptionCommand(
        schedule: transacationSchedule,
        motif: TransactionSendCommandMotif(value: "error"),
        categorie: 'C'
      );
      
      await service.update("ZE222", souscriptionCommand)
        .then((value) => () {
            expect(value.endToEndId, "Esnfbg566");
          });
    });

    test("SubscriptionService - DELETE ", () async {

      final souscription = Subscription(
      endToEndId: "Esnfbg566",
      clientNom: "Mariam",
      clientPays: "SN",
      montant: 100,
      sens: TransactionSens.credit,
      compte: 'C2345454'
      );
      final result = await service.delete(souscription);
      expect(() => result, isA<void>());
    });

    test("SubscriptionService - update ", () async {

      final transacationSchedule = TransactionSendCommandSchedule(
        dateDebut: DateTime(2023, 12, 4, 14, 30),
        dateFin: DateTime(2023, 12, 4, 14, 30),
        frequence: FrequenceCommand( value: Frequence.annuelle, periodicite: 1),
        error: TransactionSendCommandScheduleError.debutEmpty
      );

      final souscriptionCommand = SubscriptionCommand(
        schedule: transacationSchedule,
        motif: TransactionSendCommandMotif(value: "error"),
        categorie: 'C'
      );
      
      await service.update("ZE222", souscriptionCommand)
        .then((value) => () {
            expect(value.endToEndId, "Esnfbg566");
          });
    });

    test("SubscriptionService - disable ", () async {

      final souscription = Subscription(
      endToEndId: "Esnfbg566",
      clientNom: "Mariam",
      clientPays: "SN",
      montant: 100,
      sens: TransactionSens.credit,
      compte: 'C2345454'
      );
      
      await service.disable(souscription)
        .then((value) => () {
            expect(value.endToEndId, "Esnfbg566");
          });
    });
    
    test("SubscriptionService - enable ", () async {

      final souscription = Subscription(
      endToEndId: "Esnfbg566",
      clientNom: "Mariam",
      clientPays: "SN",
      montant: 100,
      sens: TransactionSens.credit,
      compte: 'C2345454'
      );
      
      await service.enable(souscription)
        .then((value) => () {
            expect(value.endToEndId, "Esnfbg566");
          });
    });
  });
}
