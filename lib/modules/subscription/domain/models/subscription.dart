import 'dart:math';

import '../../../../shared/models/frequence_command.dart';
import '../../../transactions/domain/models/transaction.dart';

class Subscription extends Transaction {
  Subscription({
    required super.compte,
    required super.endToEndId,
    required super.clientPays,
    required super.clientNom,
    required super.montant,
    required super.sens,
    super.alias,
    super.motif,
    super.canal,
    super.clientPSP,
    super.clientPSPNom,
    super.clientPhoto,
    super.clientCompte,
    super.clientAlias,
    super.statut,
    super.statutRaison,
    super.categorie,
    super.dateDebut,
    super.dateFin,
    super.frequence,
    super.periodicite,
  });

  DateTime? nextPaymentDate;

  static Subscription fromJson(Map<dynamic, dynamic> json) {
    Transaction transaction = Transaction.fromJson(json);
    Subscription subs = Subscription(
      compte: transaction.compte,
      alias: transaction.alias,
      endToEndId: transaction.endToEndId,
      clientPays: transaction.clientPays,
      clientNom: transaction.clientNom,
      montant: transaction.montant,
      sens: transaction.sens,
      motif: transaction.motif,
      canal: transaction.canal,
      clientPSP: transaction.clientPSP,
      clientPSPNom: transaction.clientPSPNom,
      clientPhoto: transaction.clientPhoto,
      clientCompte: transaction.clientCompte,
      clientAlias: transaction.clientAlias,
      statut: transaction.statut,
      statutRaison: transaction.statutRaison,
      categorie: transaction.categorie,
      //
      dateDebut: transaction.dateDebut,
      dateFin: transaction.dateFin,
      frequence: transaction.frequence,
      periodicite: transaction.periodicite,
    );
    // Compute next payment date
    subs.nextPaymentDate = computeNextPaymentDate(subs, DateTime.now());
    return subs;
  }

  // Factory constructor pour créer une Subscription à partir d'une Transaction
  factory Subscription.fromTransaction(Transaction transaction) {
    Subscription subs = Subscription(
      compte: transaction.compte,
      alias: transaction.alias,
      endToEndId: transaction.endToEndId,
      clientPays: transaction.clientPays,
      clientNom: transaction.clientNom,
      montant: transaction.montant,
      sens: transaction.sens,
      motif: transaction.motif,
      canal: transaction.canal,
      clientPSP: transaction.clientPSP,
      clientPSPNom: transaction.clientPSPNom,
      clientPhoto: transaction.clientPhoto,
      clientCompte: transaction.clientCompte,
      clientAlias: transaction.clientAlias,
      statut: transaction.statut,
      statutRaison: transaction.statutRaison,
      categorie: transaction.categorie,
      dateDebut: transaction.dateDebut,
      dateFin: transaction.dateFin,
      frequence: transaction.frequence,
      periodicite: transaction.periodicite,
    );
    // Compute next payment date
    subs.nextPaymentDate = computeNextPaymentDate(subs, DateTime.now());
    return subs;
  }

  /// Est ce que l'exécution a commencé
  bool hasStarted() {
    return DateTime.now().isAfter(dateDebut!);
  }

  /// Est ce que c'est terminé
  bool isFinished() {
    return (frequence == null && DateTime.now().isAfter(dateDebut!)) ||
        (frequence != null &&
            dateFin != null &&
            DateTime.now().isAfter(dateFin!));
  }

  /// Calcule la prochaine date de paiement après une date donnée
  static DateTime? computeNextPaymentDate(
    Subscription subs,
    DateTime fromDate,
  ) {
    if (subs.frequence == null) return subs.dateDebut;
    // Pas encore commencé
    if (fromDate.isBefore(subs.dateDebut!)) return subs.dateDebut;
    // Terminé
    if (subs.dateFin != null && fromDate.isAfter(subs.dateFin!)) return null;
    // Utilise la périodicité renseignée ou 1 par défaut
    final effectivePeriod = subs.periodicite ?? 1;
    switch (subs.frequence!) {
      case Frequence.quotidienne:
        return fromDate.add(Duration(days: effectivePeriod));
      case Frequence.hebdomadaire:
        return fromDate.add(Duration(days: effectivePeriod * 7));
      // Chaque X mois
      case Frequence.mensuelle:
        DateTime nextDate = subs.dateDebut!;
        // Trouver la prochaine date après fromDate
        while (nextDate.isBefore(fromDate)) {
          nextDate = DateTime(
            nextDate.year,
            nextDate.month + effectivePeriod, // Ajouter X mois
            min(
                nextDate.day,
                DateTime(nextDate.year, nextDate.month + effectivePeriod + 1, 0)
                    .day),
          );
        }
        return nextDate;
      case Frequence.annuelle:
        DateTime nextDate = subs.dateDebut!;
        while (nextDate.isBefore(fromDate)) {
          int nextYear = nextDate.year + effectivePeriod;
          if (nextDate.month == 2 && nextDate.day == 29) {
            
            bool isLeapYear = (nextYear % 4 == 0) &&
                (nextYear % 100 != 0 || nextYear % 400 == 0);
            nextDate = isLeapYear
                ? DateTime(nextYear, 2, 29)
                : DateTime(
                    nextYear, 2, 28); // On tombe volontairement sur le 28
          } else {
            nextDate = DateTime(nextYear, nextDate.month, nextDate.day);
          }
        }
        return nextDate;
    }
  }
}
