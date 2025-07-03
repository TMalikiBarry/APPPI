enum ParticipantEtat { active, desactive }

class Participant {
  Participant({
    required this.nomMembre,
    required this.codeMembre,
    required this.pays,
    this.codeBanque,
    this.statut,
  });

  late final String codeMembre;
  late final String? codeBanque;
  late final String nomMembre;
  late final String nomOfficiel;
  late final String pays;
  late final ParticipantEtat? statut;

  Participant.fromJson(Map<dynamic, dynamic> json) {
    nomMembre = json['officialName'] as String;
    codeMembre = json['participantMemberCode'] as String;
    //nomOfficiel = json['nomOfficiel'] as String;
    codeBanque = json['bankCode'] as String?;
    pays = codeMembre.substring(0, 2);
    statut = json['status'] == ParticipantEtat.active.name
        ? ParticipantEtat.active
        : ParticipantEtat.desactive;
  }

  Map<String, dynamic> toJson() {
    return {
      'nomMembre': nomMembre,
      'codeMembre': codeMembre,
      //'nomOfficiel': nomOfficiel,
      'codeBanque': codeBanque,
      'pays': pays,
      'statut': statut?.name,
    };
  }
}
