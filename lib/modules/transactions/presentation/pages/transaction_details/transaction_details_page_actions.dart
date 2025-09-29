import 'package:common_dependencies/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/models/frequence_command.dart';
import '../../../../../shared/widgets/cta_widget.dart';
import '../../../../alias/domain/models/alias.dart';
import '../../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../../alias/presentation/bloc/alias_state.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_canal.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../../domain/models/transaction_send/transaction_send_command_alias.dart';
import '../../../domain/models/transaction_send/transaction_send_command_schedule.dart';
import '../../bloc/transaction_details/transaction_details_bloc.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';
import 'transaction_details_page_actions_cancel.dart';
import 'transaction_details_page_actions_return.dart';

class TransactionDetailsPageActions extends StatefulWidget {
  ///
  const TransactionDetailsPageActions({
    super.key,
    required this.transaction,
  });

  final Transaction transaction;

  @override
  State<TransactionDetailsPageActions> createState() => _TransactionDetailsPageActionsState();
}

class _TransactionDetailsPageActionsState extends State<TransactionDetailsPageActions> {
  bool isTran = false;

  @override
  initState () {
    Alias alias = (context.read<AliasBloc>().state as AliasExistState).alias;
    if (alias.accountType == "TRAN") {
      isTran = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;

    TransactionDetailsBloc transactionDetailsBloc =
        context.read<TransactionDetailsBloc>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Envoyer au client
            CtaWidget(
              image: Images.iconMoneySendHeaderHP,
              label: traductions.homeActionSend,
              action: () => _actionSend(context, widget.transaction),
              //action: null,
              //disabled: true,
            ),
            // Transfert émis
            if (widget.transaction.sens?.name == TransactionSens.debit.name) ...[
              // Demander l'annulation
              CtaWidget(
                image: Images.transactionCancel,
                label: traductions.transactionDetailsAnnuler,
                //disabled: true,
                action: () => _actionCancel(
                  widget.transaction,
                  context,
                  transactionDetailsBloc,
                ),
              ),
            ],
            // Transfert reçu
            if (widget.transaction.sens?.name == TransactionSens.credit.name) ...[
              // Demander le paiement
              CtaWidget(
                image: Images.iconMoneyReceiveHeaderHP,
                label: traductions.transactionDetailsRecevoir,
                /*disabled: (
                  widget.transaction.clientAlias == null &&
                  widget.transaction.additionalInformations?.otherClient == null
                ),*/
                //disabled: !isTran,
                disabled: true,
                action: (widget.transaction.clientAlias != null || widget.transaction.additionalInformations?.otherClient != null)
                    ? () => _actionRtp(context, widget.transaction)
                    : null,
                //action: null,
              ),
              // Retour de fonds
              CtaWidget(
                image: Images.transactionCancel,
                label: traductions.transactionDetailsRetourner,
                disabled: widget.transaction.retourDate != null,
                //disabled: true,
                action: () => _actionReturn(
                  widget.transaction,
                  context,
                  transactionDetailsBloc,
                ),
              ),
            ],
            // Split payments: Plusieurs demandes de paiement
            CtaWidget(
              image: Images.transactionPartager,
              label: traductions.transactionDetailsPartager,
              //disabled: transaction.sens?.name == TransactionSens.credit.name,
              //disabled: !isTran,
              disabled: true,
              action: widget.transaction.sens?.name == TransactionSens.debit.name
                  ? () => _actionSplit(context, widget.transaction)
                  : null,
            ),

            // Programmer le paiement
            if (widget.transaction.sens?.name == TransactionSens.debit.name) ...[
              CtaWidget(
                image: Images.transactionPlanifier,
                label: traductions.transactionDetailsPlanifier,
                // disabled: transaction.subscriptionId != null,
                // disabled: !isTran,
                disabled: true,
                action: widget.transaction.subscriptionId == null
                    ? () => _actionSchedule(context, widget.transaction)
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Quand on clique sur Annuler
  _actionCancel(
    Transaction transaction,
    BuildContext context,
    TransactionDetailsBloc bloc,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => BlocProvider<TransactionDetailsBloc>.value(
        value: bloc,
        child: const TransactionDetailsPageActionsCancel(),
      ),
      isScrollControlled: true,
    );
  }

  /// Quand on clique sur Retourner
  _actionReturn(
    Transaction transaction,
    BuildContext context,
    TransactionDetailsBloc bloc,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider<TransactionDetailsBloc>.value(
          value: bloc,
          child: const TransactionDetailsPageActionsReturn(),
        );
      },
      isScrollControlled: true,
    );
  }

  /// Renvoyer la transaction
  void _actionSend(BuildContext context, Transaction transaction) {
    TransactionSendCommand command =
        TransactionSendCommand.fromTransaction(transaction);

    context
        .read<TransactionSendBloc>()
        .add(TransactionSendDisplayFormEvent(command));
    // Naviguer sur le formulaire de transaction
    AppRouter.push(context, AppRouter.transactionFormPage);
  }

  /// Demander la transaction
  void _actionRtp(BuildContext context, Transaction transaction) {
    // Passer le type de formulaire à afficher
    TransactionSendCommand command =
        TransactionSendCommand.fromTransaction(transaction);
    /*
    command.alias = widget.transaction.clientAlias != null ?
      TransactionSendCommandAlias(value: widget.transaction.clientAlias)
      : command.alias;
    command.method = TransactionSendMethod.aliasRtb;
     */
    command.action = TransactionSendCommand.actionReceiveNow;
    command.canal = TransactionCanal.transfertParRequestToPay.code;
    context
        .read<TransactionSendBloc>()
        .add(TransactionSendDisplayFormEvent(command));
    // Naviguer sur le formulaire de transaction
    AppRouter.push(context, AppRouter.transactionFormPage);
  }

  /// Planifier le paiement
  void _actionSchedule(BuildContext context, Transaction transaction) {
    // Passer le type de formulaire à afficher
    TransactionSendCommand command =
        TransactionSendCommand.fromTransaction(transaction);

    command.action = TransactionSendCommand.actionSendSchedule;
    command.schedule = TransactionSendCommandSchedule(
      dateDebut: transaction.dateOperation,
      frequence: FrequenceCommand(value: Frequence.mensuelle),
    );
    context.read<TransactionSendBloc>().add(
          TransactionSendScheduleEvent(
            command,
            transaction,
          ),
        );
    AppRouter.push(context, AppRouter.transactionFormSchedule);
  }

  /// Split payment
  void _actionSplit(BuildContext context, Transaction transaction) {
    AppRouter.push(
      context,
      AppRouter.transactionSplitPayment,
      params: {"tx": transaction},
    );
  }
}
