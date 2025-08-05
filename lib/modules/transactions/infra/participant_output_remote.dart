import '../../../core/api.dart';
import '../domain/models/participant/participant.dart';
import '../domain/models/participant/participant_liste.dart';

class ParticipantOutputRemote {
  ///
  const ParticipantOutputRemote();

  ///
  static const String collectionId = "participants";

  /// Lister les participants
  Future<List<Participant>> list(String? countryCode) async {
    var url = '/participant/index';
    if (countryCode != null) {
      url += '?countryCode=$countryCode';
    }
    final ApiResponse response = await Api.get(
      url,
    );
    ParticipantListe liste = ParticipantListe.fromJson(response.data["response"]);
    List<Participant> actifs = liste.data;
    if(liste.data.isNotEmpty) {
      actifs = liste.data
          .where((u) => u.statut == ParticipantEtat.ENBL)
          .toList();
    }
    return actifs;
  }
}
