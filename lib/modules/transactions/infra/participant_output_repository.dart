import 'package:logger/logger.dart';

import '../domain/models/participant/participant.dart';
import '../ports/output/participant_output_port.dart';
import 'participant_output_local.dart';
import 'participant_output_remote.dart';

/// Permet d'obtenir la liste des participants dans le cadre d'un transfert
class ParticipantOutputRepository implements ParticipantOutputPort {
  ///
  ParticipantOutputRepository();

  final ParticipantOutputRemote repoRemote = const ParticipantOutputRemote();
  final ParticipantOutputLocal repoLocal = const ParticipantOutputLocal();

  ///
  final logger = Logger();

  @override
  Future<List<Participant>> list() async {
    try {
      List<Participant> liste = await repoRemote.list();
      if (liste.isNotEmpty) {
        // Save last version
        repoLocal.save(liste);
      }
      return liste;
    } //
    catch (e) {
      logger.e("Impossible de lister les PSPs", error: e);
      // try to fetch locally
      return await repoLocal.list();
    }
  }
}
