import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

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
    AppLocalizations traductions = AppLocalizations.of(context)!;

    var userName = transaction.sens == TransactionSens.debit
        ? transaction.acquirerAccountLabel!
        : transaction.clientNom;

    if(userName.contains('---')){
      userName = traductions.externalCustomer;
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: _generateColorFromString(userName),
            child: Text(
              _getInitials(userName),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
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
              userName,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: const Color(0xFF344054),
                  fontWeight: FontWeight.w600
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Montant
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: AmountWidget(
              montant: transaction.montant,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(color:  Themer.primaryColor, fontWeight: FontWeight.bold),
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
            .bodyMedium!
            .copyWith(
                color: const Color(0xFF667085)
            ),
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

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    } else {
      return (parts.first[0] + parts.last[0]).toUpperCase();
    }
  }

  Color _generateColorFromString(String input) {
    final hash = input.runes.fold(0, (prev, code) => prev + code);
    // Tu choisis un ensemble de couleurs prédéfinies
    const palette = [
      Color(0xE6E57373),
      Color(0xE6BA68C8),
      Color(0xE664B5F6),
      Color(0xE681C784),
      Color(0xE6FFD54F),
      Color(0xE6A1887F),
      Color(0xE6204093),
      Color(0xE6DC1A36),
      Color(0xE6F6EA64),
      Color(0xE60BEA14),
      Color(0xE69A29E4),
      Color(0xE6A1887F),
      Color(0xE604ECB5),
      Color(0xE6BD7F0C),
      Color(0xE60A8DF6),
      Color(0xE60FED19),
      Color(0xE6011423),
      Color(0xE65A349F),
    ];
    return palette[hash % palette.length];
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
