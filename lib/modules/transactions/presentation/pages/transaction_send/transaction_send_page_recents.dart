import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_canal.dart';

import '../../../../../core/assets.dart';
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
          if (transactions != null && transactions!.isNotEmpty) ...[
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
              transaction.clientNom,
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
        prefixText: transaction.sens.name == TransactionSens.debit.name
            ? traductions.transactionsSendRecentItemYouSend
            : traductions.transactionsSendRecentItemYouReceive,
        // surfixText: 'francs CFA',
        style: Theme.of(context).textTheme.displaySmall,
      ),
      onTap: () {
        // envoie à un client à qui tu as dejà payé ou à qui t'a payé
        _displayForm(context, transaction);
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
