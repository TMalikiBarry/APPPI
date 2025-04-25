import '../../../transactions/domain/models/transaction_send/transaction_send_command_motif.dart';
import '../../../transactions/domain/models/transaction_send/transaction_send_command_schedule.dart';

/// Modele d'edition d'une subscription'
class SubscriptionCommand {
  //
  SubscriptionCommand({
    this.schedule,
    this.motif,
    this.categorie,
  });

  TransactionSendCommandMotif? motif;
  TransactionSendCommandSchedule? schedule;
  String? categorie;

  bool isValid() {
    if (schedule == null && motif == null && categorie == null) {
      return false;
    }
    // Valide le motif s'il est renseigné
    final isMotifValid = motif == null || motif!.isValid();

    // Valide le schedule s'il est renseigné
    final isScheduleValid = schedule == null || schedule!.isValid();

    // Les deux doivent être valides si renseignés
    return isMotifValid && isScheduleValid;
  }

  /// Convertit un objet TransactionSendCommand en JSON
  Map<String, dynamic> toJson() {
    if (motif != null) {
      return {'motif': motif?.value};
    } else if (categorie != null) {
      return {'categorie': categorie};
    } else {
      return schedule!.toJson();
    }
  }
}
