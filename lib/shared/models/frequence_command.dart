/// Frequences
class FrequenceCommand {
  //
  static String custom = "CUSTOM";

  FrequenceCommand({this.value, this.periodicite});

  Frequence? value;
  int? periodicite;
  bool done = false;
}

/// Frequences de paiement
enum Frequence {
  //  Quotidienne
  quotidienne("DAILY"),
  // hebdomadaire
  hebdomadaire("WEEKLY"),
  // Mensuelle
  mensuelle("MONTHLY"),
  // Annuelle
  annuelle("YEARLY");

  // Codification du paramètre
  final String code;

  const Frequence(this.code);
}
