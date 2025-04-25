import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../transactions/domain/models/transaction.dart';
import '../../domain/models/subscription.dart';

class SubscriptionStatusText {
  /// Retourner une description du sttaut de la souscription
  static String nextPaymentIndication(
    BuildContext context,
    AppLocalizations traductions,
    Subscription subscription,
  ) {
    final DateFormat formatter = DateFormat('d MMM yyyy');
    // Abonnement désactivé Si Subscription.statut = "DESACTIVE"
    if (subscription.statut == TransactionStatut.desactive) {
      return traductions.subscriptionDisabled;
    }
    final today = DateTime.now();
    final DateTime? nextPayment = subscription.nextPaymentDate;
    // Cas où le paiement est pour aujourd'hui
    if (nextPayment != null &&
        nextPayment.year == today.year &&
        nextPayment.month == today.month &&
        nextPayment.day == today.day) {
      return traductions.subscriptionDateToday;
    }
    // Cas où il s'agit d'un abonnement (avec fréquence)
    if (subscription.frequence != null) {
      if (nextPayment == null) {
        return traductions
            .subscriptionDateEndsSince(formatter.format(subscription.dateFin!));
      }
      if (nextPayment.isAfter(today)) {
        return traductions
            .subscriptionDateNextPayment(formatter.format(nextPayment));
      }
    }
    // Cas d'un paiement programmé unique (sans fréquence)
    else {
      if (nextPayment!.isAfter(today)) {
        return traductions
            .subscriptionDateScheduledFor(formatter.format(nextPayment));
      }
      return traductions
          .subscriptionDateEndsSince(formatter.format(nextPayment));
    }
    return "";
  }
}
