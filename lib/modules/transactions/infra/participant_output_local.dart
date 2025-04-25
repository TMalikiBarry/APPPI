import '../../../core/storage.dart';
import '../domain/models/participant/participant.dart';

class ParticipantOutputLocal {
  ///
  const ParticipantOutputLocal();

  ///
  static const String collectionId = "participants";

  /// Lister les participants à partir des données en local
  Future<List<Participant>> list() async {
    //
    return await AppStorage.list<Participant>(
      collectionId,
      (json) => Participant.fromJson(json),
    );
  }

  /// Enregistre un participant dans la base locale
  Future<void> save(List<Participant> psps) async {
    List<Map<dynamic, dynamic>> items = psps.map((e) => e.toJson()).toList();
    await AppStorage.saveList(collectionId, "codeMembre", items);
  }
}
