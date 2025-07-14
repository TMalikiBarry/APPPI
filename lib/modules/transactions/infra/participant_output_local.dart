import '../../../core/storage.dart';
import '../domain/models/participant/participant.dart';

class ParticipantOutputLocal {
  ///
  const ParticipantOutputLocal();

  ///
  static const String collectionId = "participants";

  /// Lister les participants à partir des données en local
  Future<List<Participant>> list(String? countryCode) async {
    //
    var collection = collectionId;
    if (countryCode != null){
      collection = "${collectionId}_$countryCode";
    }
    return await AppStorage.list<Participant>(
      collection,
      (json) => Participant.fromJson(json),
    );
  }

  /// Enregistre un participant dans la base locale
  Future<void> save(List<Participant> psps, String? countryCode) async {
    List<Map<dynamic, dynamic>> items = psps.map((e) => e.toJson()).toList();
    var collection = collectionId;
    if (countryCode != null){
      collection = "${collectionId}_$countryCode";
    }
    await AppStorage.saveList(collection, "codeMembre", items);
  }
}
