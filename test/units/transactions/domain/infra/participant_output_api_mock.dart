import 'package:pi_mobile_app/modules/transactions/domain/models/participant/participant.dart';
import 'package:pi_mobile_app/modules/transactions/ports/output/participant_output_port.dart';

/// Support offline mode and online mode
class ParticipantOutputApiMock implements ParticipantOutputPort {
  @override
  Future<List<Participant>> list() async {
    final json = {
      "pays": "SN",
      "codeMembre": "SNB000",
      "nomMembre": "PSP Virtuel SNB000",
      "nomOfficiel": "Participant virtuel de mariam",
      "codeBanque": "SN012",
      "statut": "ACTIVE"
    };
    return [Participant.fromJson(json)];
  }
}
