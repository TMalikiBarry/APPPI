import '../../../../../shared/models/liste_meta.dart';
import 'participant.dart';

class ParticipantListe {
  final List<Participant> data;
  final ListeMeta meta;

  ParticipantListe({
    required this.data,
    required this.meta,
  });

  factory ParticipantListe.fromJson(Map<String, dynamic> json) {
    return ParticipantListe(
      data: (json['data'] as List<dynamic>)
          .map((e) => Participant.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: ListeMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  bool get isEmpty => data.isEmpty;
}
