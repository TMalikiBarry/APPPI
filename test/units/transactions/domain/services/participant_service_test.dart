import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/participant/participant.dart';
import 'package:pi_mobile_app/modules/transactions/domain/services/participant_service.dart';

import '../infra/participant_output_api_mock.dart';

void main() {
  group('participant - cas succès', () {
    ParticipantService service = ParticipantService(ParticipantOutputApiMock());
    test("TransactionListe - searchLocally ", () async {
      final json = {
        "pays": "SN",
        "codeMembre": "SNB000",
        "nomMembre": "PSP Virtuel SNB000",
        "nomOfficiel": "Participant virtuel de mariam",
        "codeBanque": "SN012",
        "statut": "ACTIVE"
      };
      await service.list().then((value) => () {
            expect(value, [Participant.fromJson(json)]);
          });
    });
  });
}
