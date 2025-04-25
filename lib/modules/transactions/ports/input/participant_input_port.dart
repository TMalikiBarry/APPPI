import '../../domain/models/participant/participant.dart';

abstract class ParticipantInputPort {
  //
  /// Recuperer la liste des participants
  Future<List<Participant>> list();
}
