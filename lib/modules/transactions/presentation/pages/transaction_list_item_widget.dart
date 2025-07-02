import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/assets.dart';
import '../../../../core/router.dart';
import '../../../../core/theme.dart';
import '../../../../shared/widgets/amount_widget.dart';
import '../../domain/models/transaction.dart';

class TransactionListItemWidget extends StatelessWidget {
  ///
  const TransactionListItemWidget({
    super.key,
    required this.transaction,
    this.detailsBackRoute,
    this.noLink,
    this.onSelect,
    this.isSelected,
  });

  /// Liste des transactions à afficher
  final Transaction transaction;
  // Route de redirection
  final String? detailsBackRoute;
  final bool? noLink;
  final bool? isSelected;
  final Function? onSelect;

  @override
  Widget build(BuildContext context) {
    if (onSelect != null) {
      return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        value: isSelected ?? false,
        onChanged: (bool? value) => {
          onSelect!(value),
        },
        title: _listTile(context),
      );
    } else {
      return _listTile(context);
    }
  }

  Widget _listTile(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Stack(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage(Images.transactionAvatar,package: 'common_dependencies'),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 20,
              height: 20,
              decoration: ShapeDecoration(
                color: _getSensColor(context, transaction),
                shape: CircleBorder(
                  side: BorderSide(
                    width: 2, 
                    color: Theme.of(context).colorScheme.surface,
                  )
                ),
              ),
              child: Center(child: _getSensIcon(context, transaction)),
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
              transaction.sens == TransactionSens.debit ?
                transaction.clientNom : transaction.acquirerAccountLabel!,
              style: Theme.of(context).textTheme.headlineSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Montant
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: AmountWidget(
              montant: transaction.montant,
              style: Theme.of(context).textTheme.headlineSmall,
              sign: transaction.sens == TransactionSens.debit ? '-' : '',
            ),
          ),
        ],
      ),
      // Date d'irrévocabilité
      subtitle: Text(
        DateFormat('d MMM, HH:mm').format(transaction.dateOperation!),
        style: Theme.of(context)
            .textTheme
            .displaySmall!
            . //
            copyWith(color: Themer.neural04Color),
      ),
      onTap: noLink != null && noLink == true
          ? null
          :() => _showDetails(context),
    );
  }

  _showDetails(BuildContext context) {
    AppRouter.push(
      context,
      AppRouter.transactionSendDetails,
      params: {
        "tx": transaction, 
        "route": detailsBackRoute,
      },
    );
  }
  Color _getSensColor(BuildContext context, Transaction transaction) {
    if (transaction.sens == TransactionSens.debit) {
      return Theme.of(context).colorScheme.error;
    } else if (transaction.sens == TransactionSens.credit) {
      return Themer.successColor;
    } else {
      return Themer.neural01Color;
    }
  }

  Icon? _getSensIcon(BuildContext context, Transaction transaction) {
    if (transaction.sens == TransactionSens.debit) {
      return const Icon(Icons.arrow_back, size: 14, color: Colors.white);
    } else if (transaction.sens == TransactionSens.credit) {
      return const Icon(Icons.arrow_forward, size: 14, color: Colors.white);
    } else {
      return null;
    }
  }
}
