import 'package:flutter/material.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/amount_widget.dart';
import '../../../domain/models/subscription.dart';
import '../subscription_status_text.dart';

class SubscriptionListItemWidget extends StatelessWidget {
  ///
  const SubscriptionListItemWidget({
    super.key,
    required this.subscription,
    required this.detailsBackRoute,
    this.noLink,
  });

  /// Subscription
  final Subscription subscription;
  // Route de redirection
  final String detailsBackRoute;
  final bool? noLink;

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Stack(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage(Images.transactionAvatar,package: 'common_dependencies'),
          ),
          if (subscription.clientAlias != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: ShapeDecoration(
                  color: Themer.brownColor,
                  shape: CircleBorder(
                    side: BorderSide(
                      width: 2, 
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
                child: Image.asset(Images.iconsPiBadge,
                    package: 'common_dependencies'),
              ),
            ),
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Nom et prenoms du client
          Expanded(
            child: Text(
              subscription.clientNom,
              style: Theme.of(context).textTheme.headlineSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Montant
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: AmountWidget(
              montant: subscription.montant,
              style: Theme.of(context).textTheme.headlineSmall,
              sign: '-',
            ),
          ),
        ],
      ),
      // Prochain paiement
      subtitle: Text(
        SubscriptionStatusText.nextPaymentIndication(
          context,
          traductions,
          subscription,
        ),
        style: Theme.of(context)
            .textTheme
            .displaySmall!
            .copyWith(color: Themer.neural04Color),
      ),
      onTap: noLink != null && noLink == true
          ? null
          : () {
              AppRouter.push(
                context,
                AppRouter.subscriptionDetails,
                params: {"tx": subscription, "route": detailsBackRoute},
              );
            },
    );
  }
}
