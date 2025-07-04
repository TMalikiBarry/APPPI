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
      '/participant/index',
    );
    ParticipantListe liste = ParticipantListe.fromJson(response.data["response"]);
    return liste.data;
  }
}
