import 'package:common_dependencies/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../security/presentation/bloc/identification/identification_bloc.dart';
import '../../../../security/presentation/bloc/identification/identification_event.dart';
import '../../../../security/presentation/bloc/identification/identification_state.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';

class TransactionFormPageScheduleBtn extends StatelessWidget {
  ///
  TransactionFormPageScheduleBtn({
    super.key,
    required this.command,
    required this.transaction,
    this.fromSuscriptionPage = false,
  });
  final TransactionSendCommand command;
  final Transaction transaction;
  bool fromSuscriptionPage;

  @override
  Widget build(BuildContext context) {
    ///
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    return ElevatedButton(
      onPressed: command.schedule != null && command.schedule!.isValid()
        ? () async {
          // Authorize
          if (!fromSuscriptionPage) {
            context.read<TransactionSendBloc>().add(
              TransactionSendConfirmEvent(
                command,
                transaction,
                command.method,
              ),
            );
          } else {
            context.read<TransactionSendBloc>().add(TransactionSendInitiateEvent(command));
          }
        }
        : null,
      child: Text(traductions.transactionFormVerificationBtnConfirm),
    );
    /*
    return BlocListener<IdentificationBloc, IdentificationState>(
      listener: (context, state) async {
        // Pour afficher page code pin form
        if (state is IdentificationRequiredState) {
          await AppRouter.push(context, AppRouter.identificationCheck);
        }
        // Pour envoyer la transaction après confirmation
        else if (state is IdentificationSuccessState) {
          context.read<TransactionSendBloc>().add(
                TransactionSendConfirmEvent(
                  command,
                  transaction,
                  command.method,
                ),
              );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Expanded(
          child: ElevatedButton(
            onPressed: command.schedule != null && command.schedule!.isValid()
                ? () async {
                    // Authorize
                    context
                        .read<IdentificationBloc>() //
                        .add(const AskIdentificationBeforeActionEvent());
                  }
                : null,
            child: Text(traductions.transactionFormVerificationBtnConfirm),
          ),
        ),
      ),
    );
    */
  }
}
