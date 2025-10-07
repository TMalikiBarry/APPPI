import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';
import 'package:pi_mobile_app/modules/security/domain/models/connected_user.dart';

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
    var user = ConnectedUser.current;
    var userName = transaction.sens == TransactionSens.debit
        ? transaction.acquirerAccountLabel!
        : transaction.clientNom.isNotEmpty
        && !transaction.clientNom.contains('---')
        ? transaction.clientNom
        : transaction.additionalInformations?.issuerName
          ?? transaction.additionalInformations?.clientName
          ?? transaction.additionalInformations?.otherClient
          ?? transaction.additionalInformations?.externalAlias
          ?? traductions.externalCustomer;

    if(userName.isEmpty || userName.contains('---')
        || (user != null && userName.contains(user.nomComplet()))){
      userName = traductions.externalCustomer;
    }

    final color = generateVividColorFromString(userName);
    final textColor = idealTextColorForBackground(color);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Stack(
        children: [
          CircleAvatar(
            // backgroundColor: _generateColorFromString(userName),
            backgroundColor: color,
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

  /// djb2 hash — meilleure distribution que sum(runes)
  int _djb2(String input) {
    int hash = 5381;
    for (final code in input.runes) {
      hash = ((hash << 5) + hash + code) & 0x7fffffff; // hash * 33 + code, keep positive
    }
    return hash;
  }

  /// Convert HSL -> Color (expects h in 0..360, s,l in 0..1)
  Color _hslToColor(double h, double s, double l) {
    final c = (1.0 - (2.0 * l - 1.0).abs()) * s;
    final hh = h / 60.0;
    final x = c * (1.0 - ((hh % 2) - 1.0).abs());
    double r = 0, g = 0, b = 0;
    if (hh >= 0 && hh < 1) {
      r = c;
      g = x;
      b = 0;
    } else if (hh < 2) {
      r = x;
      g = c;
      b = 0;
    } else if (hh < 3) {
      r = 0;
      g = c;
      b = x;
    } else if (hh < 4) {
      r = 0;
      g = x;
      b = c;
    } else if (hh < 5) {
      r = x;
      g = 0;
      b = c;
    } else {
      r = c;
      g = 0;
      b = x;
    }
    final m = l - c / 2.0;
    final R = ((r + m) * 255).round().clamp(0, 255);
    final G = ((g + m) * 255).round().clamp(0, 255);
    final B = ((b + m) * 255).round().clamp(0, 255);
    return Color.fromARGB(0xFF, R, G, B);
  }

  /// Génère une couleur vive, opaque (FF), pseudo-unique pour une string.
  Color generateVividColorFromString(String input) {
    final hash = _djb2(input);

    // Hue réparti sur 0..359
    final hue = (hash % 360).toDouble();

    // Petite variation de saturation & lightness selon bits du hash
    // Saturation entre 0.62 .. 0.88 (vives)
    final sat = 0.62 + ((hash >> 8) % 27) / 100.0; // 0.62..0.88

    // Lightness entre 0.40 .. 0.55 (évite très sombre ou trop clair)
    final light = 0.40 + ((hash >> 16) % 16) / 100.0; // 0.40..0.55

    return _hslToColor(hue, sat.clamp(0.0, 1.0), light.clamp(0.0, 1.0));
  }

  /// Retourne Colors.white ou Colors.black selon contraste (WCAG-like simple)
  Color idealTextColorForBackground(Color bg) {
    // Perception luminance (ITU-R BT.709)
    final lum = (0.299 * bg.red + 0.587 * bg.green + 0.114 * bg.blue) / 255.0;
    // seuil 0.6 est conservateur pour texte lisible sur couleurs vives
    return lum > 0.6 ? Colors.black : Colors.white;
  }

  Color _generateColorFromString(String input) {
    final hash = input.runes.fold(0, (prev, code) => prev + code);
    // Tu choisis un ensemble de couleurs prédéfinies
    const palette = [
      Color(0xE6E57373),
      Color(0xE6BA68C8),
      Color(0xE664B5F6),
      Color(0xE699EDB1),
      Color(0xE6FFD54F),
      Color(0xE6A1887F),
      Color(0xE6204093),
      Color(0xE6DC1A36),
      Color(0xE657050F),
      Color(0xE60BEA14),
      Color(0xFF603942),
      Color(0xE6836503),
      Color(0xFF5C0A4E),
      Color(0xE6BD7F0C),
      Color(0xE60A8DF6),
      Color(0xE6047E0A),
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
