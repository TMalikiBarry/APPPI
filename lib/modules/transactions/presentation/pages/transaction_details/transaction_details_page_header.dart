import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme.dart';
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
              style: transaction.sens == TransactionSens.credit ?
                Theme.of(context).textTheme.labelSmall : Theme.of(context).textTheme.labelMedium,
              sign: transaction.sens == TransactionSens.credit ? '+' : '-',
            ),
            // Nom du client
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: TextButton(
                onPressed: () => "",
                child: Text(
                  transaction.sens == TransactionSens.debit ?
                    transaction.acquirerAccountLabel! : transaction.clientNom,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Themer.brownColor
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Date de la transaction
            if (transaction.dateOperation != null)
              Text(
                DateFormat('d MMM, HH:mm') //
                    .format(transaction.dateOperation!),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: Themer.brownColor
                ),
              ),
          ],
        ),
        // Image
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: AvatarCircleWidget(
            nom: transaction.sens == TransactionSens.debit ?
              transaction.acquirerAccountLabel! : transaction.clientNom ,
            photo: transaction.clientPhoto,
            rounded: true,
            radius: 32,
          ),
        ),
      ],
    );
  }
}
