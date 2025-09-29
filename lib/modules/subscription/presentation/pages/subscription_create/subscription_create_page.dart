import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../../shared/models/frequence_command.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../transactions/domain/models/transaction.dart';
import '../../../../transactions/domain/models/transaction_send/transaction_send_command.dart';
import '../../../../transactions/domain/models/transaction_send/transaction_send_command_schedule.dart';
import '../../../../transactions/presentation/bloc/transaction_send/transaction_send_bloc.dart';
import '../../../../transactions/presentation/bloc/transaction_send/transaction_send_event.dart';
import '../../../../transactions/presentation/bloc/transaction_send/transaction_send_state.dart';
import '../../../../transactions/presentation/pages/transaction_form/transaction_form_page_schedule_btn.dart';
import '../../../../transactions/presentation/pages/transaction_send/transaction_send_page_error.dart';
import '../../../../transactions/presentation/pages/transaction_send/transaction_send_page_succes.dart';
import '../../../domain/models/subscription.dart';
import 'subscription_create_page_list.dart';

class SubscriptionCreatePage extends StatefulWidget {
  ///
  const SubscriptionCreatePage({super.key});

  ///
  @override
  State<SubscriptionCreatePage> createState() => _SubscriptionCreatePageState();
}

class _SubscriptionCreatePageState extends State<SubscriptionCreatePage> {
  Transaction? seletedTransaction;

  @override
  Widget build(BuildContext context) {
    //
    return BlocConsumer<TransactionSendBloc, TransactionSendState>(
      listenWhen: (previous, current) =>
          current is TransactionSendFormSendingState ||
          current is TransactionSendFormSuccessState ||
          current is TransactionSendLoadingState ||
          current is TransactionSendFormVerificationAskingState ||
              // UNIQUEMENT rediriger à l'accueil si on sort de VerificationAskingState
          (previous is TransactionSendFormVerificationAskingState && current is TransactionSendInitialState) ||
          current is TransactionSendFormErrorState,
      listener: (context, state) async {
        // Process en cours
        if (state is TransactionSendFormSendingState) {
          CustomLoadingDialog.show(context);
        }
        // Envoyé avec succès
        else if (state is TransactionSendFormSuccessState) {
          // Hide loader
          CustomLoadingDialog.hide(context);
          // Show success popup
          bool isBottomSheetClosed = false;
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return TransactionSendPageSuccess(
                transaction: state.transaction,
                onClose: () => isBottomSheetClosed = true,
              );
            },
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
          );
          // Fermer le bottom sheet après 1 secondes
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted && !isBottomSheetClosed) {
              AppRouter.pop(context);
              AppRouter.pushReplacement(
                context,
                AppRouter.subscriptionDetails,
                params: {
                  "tx": Subscription.fromTransaction(state.transaction),
                  "route": AppRouter.subscriptionList
                },
              );
            }
          });
        }
        // Envoyé avec erreur -  Rejete
        else if (state is TransactionSendFormErrorState) {
          // Hide loader
          CustomLoadingDialog.hide(context);
          // Show success popup
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return TransactionSendPageError(error: state.error);
            },
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
          );
        }
        // Show verification Page
        else if (state is TransactionSendFormVerificationAskingState) {
          // Hide loader
          CustomLoadingDialog.hide(context);
          seletedTransaction = state.transaction;

          context.read<TransactionSendBloc>().add(TransactionSendScheduleEvent(
            state.command,
            seletedTransaction!,
          ));
          AppRouter.push(context, AppRouter.transactionFormSchedule);
        }
      },
      builder: (context, state) {
        if (state is TransactionSendLoadingState) {
          return const Scaffold(
            body: LoadingPage(),
          );
        } else {
          return Scaffold(
            // Pour avoir le bouton de retour
            appBar: AppBar(),
            // Contenu de la page
            body: MyPageContainer(
              child: SubscriptionCreatePageList(
                  selectTransaction: _selectTransaction),
            ),
            bottomNavigationBar: seletedTransaction != null ? _confirmBtn(seletedTransaction!) : null,
          );
        }
      }
    );
  }

  /// Selectionne une transaction
  _selectTransaction(Transaction? tx) {
    setState(() {
      seletedTransaction = tx;
    });
  }

  /// Bouton de confirmation
  _confirmBtn(Transaction transaction) {
    // Command transaction
    TransactionSendCommand command =
        TransactionSendCommand.fromTransaction(transaction);
    command.action = TransactionSendCommand.actionSendSchedule;
    command.schedule = TransactionSendCommandSchedule(
      dateDebut: DateTime.now(),
      frequence: FrequenceCommand(value: Frequence.mensuelle),
    );
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TransactionFormPageScheduleBtn(
          command: command,
          transaction: transaction,
          fromSuscriptionPage: true,
        ),
      ),
    );
  }
}
