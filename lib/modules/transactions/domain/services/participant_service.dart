import '../../ports/input/participant_input_port.dart';
import '../../ports/output/participant_output_port.dart';
import '../models/participant/participant.dart';

class ParticipantService implements ParticipantInputPort {
  //
  final ParticipantOutputPort participantOutputPort;

  ///
  ParticipantService(this.participantOutputPort);

  @override
  Future<List<Participant>> list() async {
    return await participantOutputPort.list();
  }
}
