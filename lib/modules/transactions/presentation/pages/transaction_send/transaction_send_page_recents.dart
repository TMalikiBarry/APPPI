import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_canal.dart';

import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/amount_widget.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_liste.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';
import '../transaction_list_loading_widget.dart';

class TransactionSendPageRecents extends StatelessWidget {
  //
  const TransactionSendPageRecents({super.key, this.transactions, this.action});

  /// input liste des transactions
  final TransactionListe? transactions;

  /// send_now, receive_now, send_schedule
  final String? action;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;
    if (transactions != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (transactions != null && transactions!.data.isNotEmpty) ...[
            Text(
              traductions.transactionsSendTitleRecents,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall! //
                  .copyWith(color: Themer.neural05Color),
            ),
            const SizedBox(height: 17),
          ],
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: transactions!.data.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => TransactionSendPageRecentsItem(
                  transaction: transactions!.data[index],
                  action: action,
                ),
              ),
            ),
          )
        ],
      );
    } else {
      return const TransactionListLoadingWidget();
    }
  }
}

class TransactionSendPageRecentsItem extends StatelessWidget {
  ///
  const TransactionSendPageRecentsItem({
    super.key,
    required this.transaction,
    this.action,
  });

  /// Pour écrire des logs
  static final logger = Logger();

  /// Liste des transactions à afficher
  final Transaction transaction;

  /// send_now, receive_now, send_schedule
  final String? action;

  @override
  Widget build(BuildContext context) {
    //
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
          /*const CircleAvatar(
            backgroundImage: AssetImage(Images.transactionAvatar,package: 'common_dependencies'),
          ),*/
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
                shape: const CircleBorder(
                    side: BorderSide(
                  width: 2,
                  color: Colors.white,
                )),
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
              style: Theme.of(context).textTheme.headlineSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Montant
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              DateFormat('d MMM').format(transaction.dateOperation!),
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  . //
                  copyWith(color: Themer.neural04Color),
            ),
          ),
        ],
      ),
      // Montant envoyé ou reçu
      subtitle: AmountWidget(
        montant: transaction.montant,
        prefixText: transaction.sens?.name == TransactionSens.debit.name
            ? traductions.transactionsSendRecentItemYouSend
            : traductions.transactionsSendRecentItemYouReceive,
        // surfixText: 'francs CFA',
        style: Theme.of(context).textTheme.displaySmall?.
          copyWith(color: transaction.sens == TransactionSens.debit ? Themer.error: Themer.brownColor),
      ),
      onTap: () {
        // envoie à un client à qui tu as dejà payé ou à qui t'a payé
        // _displayForm(context, transaction);
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
  Color _generateColorFromString(String input) {
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

/*
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
*/

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

  /// Action effectuée quand on clique sur un option de transaction
  void _displayForm(BuildContext context, Transaction transaction) {
    // Passer le type de formulaire à afficher
    TransactionSendCommand command =
        TransactionSendCommand.fromTransaction(transaction);
    command.action = action!;
    command.canal = action == TransactionSendCommand.actionReceiveNow
        ? TransactionCanal.transfertParRequestToPay.code
        : TransactionCanal.defaultCanal.code;
    context
        .read<TransactionSendBloc>()
        .add(TransactionSendDisplayFormEvent(command));
    // Naviguer sur le formulaire de transaction
    AppRouter.push(context, AppRouter.transactionFormPage);
  }
}
