import '../../../core/api.dart';
import '../domain/models/participant/participant.dart';
import '../domain/models/participant/participant_liste.dart';

class ParticipantOutputRemote {
  ///
  const ParticipantOutputRemote();

  ///
  static const String collectionId = "participants";

  /// Lister les participants
  Future<List<Participant>> list() async {
    final ApiResponse response = await Api.get(
      '/participants',
    );
    ParticipantListe liste = ParticipantListe.fromJson(response.data);
    return liste.data;
  }
}
