import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/amount_widget.dart';
import '../../../../../shared/widgets/avatar_circle_widget.dart';
import '../../../domain/models/subscription.dart';
import '../subscription_status_text.dart';

class SubscriptionDetailsPageHeader extends StatelessWidget {
  ///
  const SubscriptionDetailsPageHeader({super.key, required this.subscription});

  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AmountWidget(
              montant: subscription.montant,
              style: Theme.of(context).textTheme.titleSmall,
              sign: '-',
            ),
            // Nom du client
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: TextButton(
                onPressed: () => "",
                child: Text(
                  subscription.clientNom,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Date de la subscription
            Text(
              SubscriptionStatusText.nextPaymentIndication(
                context,
                traductions,
                subscription,
              ),
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
        // Image
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: AvatarCircleWidget(
            nom: subscription.clientNom,
            photo: subscription.clientPhoto,
            rounded: true,
            radius: 32,
          ),
        ),
      ],
    );
  }
}
