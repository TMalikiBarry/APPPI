import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../security/presentation/bloc/identification/identification_bloc.dart';
import '../../../../security/presentation/bloc/identification/identification_event.dart';
import '../../../../security/presentation/bloc/identification/identification_state.dart';
import '../../../domain/models/transaction.dart';
import '../../bloc/transaction_rtp/transaction_rtp_bloc.dart';
import '../../bloc/transaction_rtp/transaction_rtp_event.dart';
import 'transaction_rtp_page_actions_reject.dart';

class TransactionRtpPageActions extends StatelessWidget {
  ///
  const TransactionRtpPageActions({
    super.key,
    required this.tx,
    required this.bloc,
  });

  final Transaction tx;
  final TransactionRtpBloc bloc;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Programmer Possible si c'est 631, 401, 520
          if (tx.canSchedule()) ...[
            FloatingActionButton(
              onPressed: () {
                //transactionSendBloc.add(TransactionSendScheduleEvent(command));
              },
              elevation: 0,
              heroTag: "schedule",
              child: const Icon(Icons.calendar_month_outlined, size: 24),
            ),
            const SizedBox(width: 16),
          ],

          // Rejeter
          Expanded(
            child: FilledButton.tonal(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (context) => BlocProvider<TransactionRtpBloc>.value(
                    value: bloc,
                    child: const TransactionRtpPageActionsReject(),
                  ),
                  isScrollControlled: true,
                );
              },
              child: Text(traductions.btnTextReject),
            ),
          ),
          //
          const SizedBox(width: 16),
          // Confirmer
          Expanded(
            child: BlocListener<IdentificationBloc, IdentificationState>(
              listener: (context, state) async {
                // Pour afficher page code pin form
                if (state is IdentificationRequiredState) {
                  await AppRouter.push(context, AppRouter.identificationCheck);
                }
                // Pour envoyer la transaction après confirmation
                if (state is IdentificationSuccessState) {
                  bloc.add(TransactionRtpAcceptPayEvent(tx, state.method));
                }
              },
              listenWhen: (previous, current) =>
                  previous is IdentificationSuccessState ||
                  current is IdentificationSuccessState,
              child: ElevatedButton(
                onPressed: () {
                  context
                      .read<IdentificationBloc>() //
                      .add(const AskIdentificationBeforeActionEvent());
                },
                child: Text(traductions.btnTextPay),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
