import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/models/frequence_command.dart';
import '../../../../../shared/widgets/cta_widget.dart';
import '../../../../transactions/domain/models/transaction.dart';
import '../../../../transactions/domain/models/transaction_send/transaction_send_command.dart';
import '../../../../transactions/domain/models/transaction_send/transaction_send_command_schedule.dart';
import '../../../../transactions/presentation/bloc/transaction_send/transaction_send_bloc.dart';
import '../../../../transactions/presentation/bloc/transaction_send/transaction_send_event.dart';
import '../../../domain/models/subscription.dart';
import '../../bloc/subscription_details/subscription_details_bloc.dart';
import '../../bloc/subscription_details/subscription_details_event.dart';

class SubscriptionDetailsPageActions extends StatelessWidget {
  ///
  const SubscriptionDetailsPageActions({
    super.key,
    required this.subscription,
  });

  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Edit tant que c'est pas encore exécuté une fois
            CtaWidget(
              image: Images.iconEdit,
              label: traductions.btnTextEdit,
              disabled: subscription.hasStarted(),
              action: () => !subscription.hasStarted()
                  ? _edit(context, subscription)
                  : null,
            ),

            // Désactiver
            if (subscription.statut != TransactionStatut.desactive)
              CtaWidget(
                icon: const Icon(Icons.cancel_outlined),
                label: traductions.btnTextDisable,
                disabled: subscription.isFinished(),
                action: () => !subscription.hasStarted()
                    ? context.read<SubscriptionDetailsBloc>().add(
                          SubscriptionDetailsDisableEvent(subscription),
                        )
                    : null,
              ),
            // Activer
            if (subscription.statut == TransactionStatut.desactive)
              CtaWidget(
                icon: const Icon(Icons.check_circle_outline),
                disabled: subscription.isFinished(),
                label: traductions.btnTextEnable,
                action: () => !subscription.hasStarted()
                    ? context.read<SubscriptionDetailsBloc>().add(
                          SubscriptionDetailsEnableEvent(subscription),
                        )
                    : null,
              ),

            // Supprimer
            CtaWidget(
              image: Images.iconDelete,
              label: traductions.btnTextDelete,
              action: () => context.read<SubscriptionDetailsBloc>().add(
                    SubscriptionDetailsDeleteEvent(subscription),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _edit(
    BuildContext context,
    Subscription transaction,
  ) {
    TransactionSendCommand command =
        TransactionSendCommand.fromTransaction(transaction);
    //
    command.action = TransactionSendCommand.actionSendSchedule;
    command.schedule = TransactionSendCommandSchedule(
      dateDebut: transaction.dateDebut,
      dateFin: transaction.dateFin,
      frequence: FrequenceCommand(
        value: transaction.frequence,
        periodicite: transaction.periodicite,
      ),
    );
    // Display Schedule Form
    context.read<TransactionSendBloc>().add(TransactionSendScheduleEvent(
          command,
          transaction,
        ));
    AppRouter.push(context, AppRouter.transactionFormSchedule);
  }
}
