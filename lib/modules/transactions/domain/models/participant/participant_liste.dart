import '../../../../../shared/models/liste_meta.dart';
import 'participant.dart';

class ParticipantListe {
  final List<Participant> data;
  final ListeMeta? meta;

  ParticipantListe({
    required this.data,
    this.meta,
  });

  factory ParticipantListe.fromJson(List<dynamic> json) {
    return ParticipantListe(
      data: json
          .map((e) => Participant.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: null,
    );
  }

  bool get isEmpty => data.isEmpty;
}
