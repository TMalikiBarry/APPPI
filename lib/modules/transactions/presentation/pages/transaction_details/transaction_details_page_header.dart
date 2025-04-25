import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/widgets/amount_widget.dart';
import '../../../../../shared/widgets/avatar_circle_widget.dart';
import '../../../domain/models/transaction.dart';

class TransactionDetailsPageHeader extends StatelessWidget {
  ///
  const TransactionDetailsPageHeader({super.key, required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
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
              montant: transaction.montant,
              style: Theme.of(context).textTheme.titleSmall,
              sign: transaction.sens == TransactionSens.credit ? '+' : '-',
            ),
            // Nom du client
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: TextButton(
                onPressed: () => "",
                child: Text(
                  transaction.clientNom,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Date de la transaction
            if (transaction.dateOperation != null)
              Text(
                DateFormat('d MMM, HH:mm') //
                    .format(transaction.dateOperation!),
                style: Theme.of(context).textTheme.displaySmall,
              ),
          ],
        ),
        // Image
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: AvatarCircleWidget(
            nom: transaction.clientNom,
            photo: transaction.clientPhoto,
            rounded: true,
            radius: 32,
          ),
        ),
      ],
    );
  }
}
