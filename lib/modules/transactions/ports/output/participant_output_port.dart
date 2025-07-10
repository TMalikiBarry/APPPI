import '../../domain/models/participant/participant.dart';

abstract class ParticipantOutputPort {
  //
  /// Recuperer la liste des participants
  Future<List<Participant>> list(String? countryCode);
}
