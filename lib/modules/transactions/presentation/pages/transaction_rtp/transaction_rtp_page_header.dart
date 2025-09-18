import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/avatar_circle_widget.dart';
import '../../../domain/models/transaction.dart';

class TransactionRtpPageHeader extends StatelessWidget {
  ///
  const TransactionRtpPageHeader({super.key, required this.tx});

  final Transaction tx;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre de la page
                Text(
                  NumberFormat.currency(
                    locale: Localizations.localeOf(context).toString(),
                    symbol: '',
                    decimalDigits: 0,
                  ).format(tx.montant),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                // Vous devez à ou Vous avez demandé à
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    tx.sens == TransactionSens.credit
                        ? traductions
                            .transactionRtpDetailsTitleInitiee(
                              tx.acquirerAccountLabel ??
                              tx.additionalInformations?.clientName ??
                              tx.additionalInformations?.issuerName
                            ?? "")
                        : traductions
                            .transactionRtpDetailsTitleRecue(tx.acquirerAccountLabel ??
                    tx.additionalInformations?.clientName ?? ""),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Sous titre Demande de paiement
                Text(
                  traductions.transactionsSendTitleRequest2Pay,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ),
          // Image
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: AvatarCircleWidget(
              nom: tx.clientNom,
              photo: tx.clientPhoto,
              rounded: true,
              radius: 32,
            ),
          ),
        ],
      ),
    );
  }
}
