import 'package:common_dependencies/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/models/frequence_command.dart';
import '../../../../alias/domain/models/alias.dart';
import '../../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../../alias/presentation/bloc/alias_state.dart';
import '../../../../security/presentation/bloc/identification/identification_bloc.dart';
import '../../../../security/presentation/bloc/identification/identification_event.dart';
import '../../../../security/presentation/bloc/identification/identification_state.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../../domain/models/transaction_send/transaction_send_command_schedule.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';

class TransactionFormBtnConfirm extends StatefulWidget {
  ///
  const TransactionFormBtnConfirm({
    super.key,
    required this.command,
    required this.transaction,
    required this.traductions,
  });

  final TransactionSendCommand command;
  final Transaction transaction;
  final AppLocalizations traductions;

  @override
  State<TransactionFormBtnConfirm> createState() => _TransactionFormBtnConfirmState();
}

class _TransactionFormBtnConfirmState extends State<TransactionFormBtnConfirm> {
  bool isTran = false;

  @override
  initState () {
    Alias alias = (context.read<AliasBloc>().state as AliasExistState).alias;
    if (alias.accountType == "TRAN") {
      isTran = true;  // indices des onglets à griser
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // schedule
          if (widget.command.action !=
              TransactionSendCommand.actionSendSchedule && isTran &&
              widget.command.action !=
                  TransactionSendCommand.actionReceiveNow
          ) ...[
            FloatingActionButton(
              onPressed: () {
                _scheduleTransaction(context);
              },
              elevation: 0,
              heroTag: "schedule",
              child: const Icon(Icons.calendar_month_outlined, size: 24),
            ),
          ],


          // Séparateur
          const SizedBox(width: 16),

          // Annuler
          Expanded(
            child: FilledButton.tonal(
              onPressed: () {
                Navigator.pop(context);
                // reject
                context
                    .read<TransactionSendBloc>()
                    .add(TransactionSendRejectEvent(widget.command));
              },
              child: Text(
                widget.traductions.transactionFormVerificationBtnReject,
                style: (isTran || widget.command.action ==
                    TransactionSendCommand.actionReceiveNow) ? const TextStyle(
                  fontSize: 14,
                ) : null,
              ),
            ),
          ),

          // Séparateur
          const SizedBox(width: 16),

          // Confirm
          if (widget.command.action !=
              TransactionSendCommand.actionSendSchedule) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  context
                      .read<TransactionSendBloc>() //
                      .add(TransactionSendConfirmEvent(
                    widget.command,
                    widget.transaction,
                    widget.command.method,
                  ));
                },
                child:
                Text(
                  widget.traductions.transactionFormVerificationBtnConfirm,
                  style: (isTran || widget.command.action ==
                      TransactionSendCommand.actionReceiveNow) ? const TextStyle(
                    fontSize: 14,
                  ) : null,
                ),
              ),
            ),
          ],

          // Programmer
          if (widget.command.action ==
              TransactionSendCommand.actionSendSchedule) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  _scheduleTransaction(context);
                },
                child: Text(widget.traductions.transactionFormScheduleTitle),
              ),
            ),
          ],
        ],
      ),
    );

    /*
    return BlocListener<IdentificationBloc, IdentificationState>(
      listenWhen: (previous, current) =>
          current is IdentificationRequiredState ||
          current is IdentificationSuccessState,
      listener: (context, state) async {
        if (state is IdentificationRequiredState) {
          await AppRouter.push(context, AppRouter.identificationCheck);
        }
        // Pour envoyer la transaction après confirmation
        if (state is IdentificationSuccessState) {
          if (context.mounted) {
            context
                .read<TransactionSendBloc>() //
                .add(TransactionSendConfirmEvent(
                  command,
                  transaction,
                  state.method.toString(),
                ));
          }
        }
      },
      child: SizedBox(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // schedule

            if (command.action !=
                TransactionSendCommand.actionSendSchedule) ...[
              FloatingActionButton(
                onPressed: () {
                  _scheduleTransaction(context);
                },
                elevation: 0,
                heroTag: "schedule",
                child: const Icon(Icons.calendar_month_outlined, size: 24),
              ),
            ],


            // Séparateur
            const SizedBox(width: 16),

            // Annuler
            Expanded(
              child: FilledButton.tonal(
                onPressed: () {
                  Navigator.pop(context);
                  // reject
                  context
                      .read<TransactionSendBloc>()
                      .add(TransactionSendRejectEvent(command));
                },
                child: Text(traductions.transactionFormVerificationBtnReject),
              ),
            ),

            // Séparateur
            const SizedBox(width: 16),

            // Confirm
            if (command.action !=
                TransactionSendCommand.actionSendSchedule) ...[
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    // Authorize
                    context
                        .read<IdentificationBloc>() //
                        .add(const AskIdentificationBeforeActionEvent());
                  },
                  child:
                      Text(traductions.transactionFormVerificationBtnConfirm),
                ),
              ),
            ],

            // Programmer
            if (command.action ==
                TransactionSendCommand.actionSendSchedule) ...[
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    _scheduleTransaction(context);
                  },
                  child: Text(traductions.transactionFormScheduleTitle),
                ),
              ),
            ],
          ],
        ),
      ),
    );
    */
  }

  void _scheduleTransaction(BuildContext context) {
    // Init
    widget.command.schedule = TransactionSendCommandSchedule(
      frequence: FrequenceCommand(),
    );
    // Send Schedule
    context.read<TransactionSendBloc>().add(
          TransactionSendScheduleEvent(
            widget.command,
            widget.transaction,
          ),
        );
    AppRouter.pushReplacement(context, AppRouter.transactionFormSchedule);
  }
}
