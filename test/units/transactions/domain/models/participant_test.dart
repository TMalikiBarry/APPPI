import 'package:flutter_test/flutter_test.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/participant/participant.dart';
import 'package:pi_mobile_app/shared/models/uemoa_countries.dart';

void main() {
  group('Valid', () {
    test('Valid other', () {
      // Accept
      final json = {
        "pays": "SN",
        "codeMembre": "SNB000",
        "nomMembre": "PSP Virtuel SNB000",
        "codeBanque": "SN012",
        "statut": "active"
      };
      expect(
          Participant(
                  nomMembre: "PSP Virtuel SNB000",
                  statut: ParticipantEtat.active,
                  codeBanque: "SN012",
                  codeMembre: "SNB000",
                  pays: UEMOACountry.get("SN")!.iso)
              .toJson(),
          json);
    });
  });
}
