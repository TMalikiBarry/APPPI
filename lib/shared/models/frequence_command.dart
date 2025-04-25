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
  quotidienne("J"),
  // hebdomadaire
  hebdomadaire("S"),
  // Mensuelle
  mensuelle("M"),
  // Annuelle
  annuelle("A");

  // Codification du paramètre
  final String code;

  const Frequence(this.code);
}
