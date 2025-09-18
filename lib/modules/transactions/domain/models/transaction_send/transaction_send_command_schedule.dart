import '../../../../../shared/models/frequence_command.dart';

/// Modeles et regles de validation du champ schedule
class TransactionSendCommandSchedule {
  //
  TransactionSendCommandSchedule({
    this.dateDebut,
    this.dateFin,
    this.frequence,
    this.error,
  });

  DateTime? dateDebut;
  DateTime? dateFin;
  FrequenceCommand? frequence;

  TransactionSendCommandScheduleError? error;

  bool isValid() {
    // lorsque la date de début ou d'execution n'est pas renseignée
    if (dateDebut == null) {
      error = TransactionSendCommandScheduleError.debutEmpty;
    } else {
      error = null;
    }
    return error == null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      //'dateDebut': dateDebut!.toIso8601String(),
      "year": dateDebut!.year,
      "month": dateDebut!.month,
      "dayOfMonth": dateDebut!.day,
    };

    if (frequence != null && frequence!.value != null) {
      json["frequence"] = frequence!.value!.code;
    }
    if (frequence != null && frequence!.periodicite != null) {
      json["periodicite"] = frequence!.periodicite!;
    }
    if (dateFin != null) {
      json["dateFin"] = dateFin!.toIso8601String();
    }
    return json;
  }
}

/// Types d'erreurs possibles sur le schedule
enum TransactionSendCommandScheduleError {
  //
  debutEmpty;
}
