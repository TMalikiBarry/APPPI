class Compte {
  Compte({
    required this.participant,
    required this.agence,
    required this.numero,
    required this.type,
    required this.dateOuverture,
  });
  late String participant;
  late String agence;
  late String numero;
  late String type;
  late String dateOuverture;

  Compte.fromJson(Map<dynamic, dynamic> json) {
    participant = json['participant'];
    agence = json['agence'];
    numero = json['numero'];
    type = json['type'];
    dateOuverture = json['dateOuverture'];
  }

  Map<dynamic, dynamic> toJson() {
    Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['participant'] = participant;
    data['agence'] = agence;
    data['numero'] = numero;
    data['type'] = type;
    data['dateOuverture'] = dateOuverture;
    return data;
  }
}
