import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/core/notifications.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/frequence_input_widget.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';
import '../../bloc/transaction_send/transaction_send_state.dart';
import '../transaction_send/transaction_send_page_error.dart';
import '../transaction_send/transaction_send_page_succes.dart';
import 'transaction_form_input_date.dart';
import 'transaction_form_page_schedule_btn.dart';

class TransactionFormPageSchedule extends StatefulWidget {
  ///
  const TransactionFormPageSchedule({super.key});

  @override
  State<TransactionFormPageSchedule> createState() => _TransactionFormPageScheduleState();
}

class _TransactionFormPageScheduleState extends State<TransactionFormPageSchedule> {
  Transaction? seletedTransaction;

  @override
  Widget build(BuildContext context) {
    ///
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    return BlocConsumer<TransactionSendBloc, TransactionSendState>(
      listenWhen: (previous, current) =>
          current is TransactionSendLoadingState ||
          current is TransactionSendFormSendingState ||
          current is TransactionSendFormSuccessState ||
          current is TransactionSendFormVerificationAskingState ||
          current is TransactionSendFormErrorState,
      listener: (context, state) async {
        // Envoie en cours
        if (state is TransactionSendFormSendingState) {
          CustomLoadingDialog.show(context);
        }
        // Envoyé avec succès - Irrevocable
        else if (state is TransactionSendFormSuccessState) {

          // Notification en cas de success
          AppNotifications.showCustomTransferNotification(
            title: "Opération réussie",
            body: "Votre opération a été éffectuée avec succès!",
          );

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
          // Fermer le bottom sheet après 3 secondes
          Future.delayed(const Duration(seconds: 3), () {
            if (context.mounted && !isBottomSheetClosed) {
              AppRouter.pop(context);
              AppRouter.pushReplacement(context, AppRouter.home);
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
          CustomLoadingDialog.hide(context);
          // Replace with verification page (pushReplacement important)
          seletedTransaction = state.transaction;
          //
        }
      },
      buildWhen: (previous, current) =>
          current is TransactionSendFormScheduleState ||
          current is TransactionSendLoadingState,
      builder: (context, state) {
        if (state is TransactionSendFormScheduleState) {
          TransactionSendCommand command = state.command;
          seletedTransaction = state.transaction;
          return Scaffold(
            // Pour avoir le bouton de retour
            appBar: AppBar(),
            // Contenu de la page de connexion
            body: MyPageContainer(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Titre de la page
                    Text(
                      traductions.transactionFormScheduleTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    //
                    const SizedBox(height: 5.0),
                    // Sous titre de la page
                    Text(
                      traductions.transactionFormScheduleSubtitle,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    //
                    const SizedBox(height: 32),

                    // Fréquence
                    FrequenceInputWidget(
                      command: command.schedule!.frequence!,
                      onChange: (value) {
                        command.schedule!.frequence = value;
                        context.read<TransactionSendBloc>().add(
                              TransactionSendScheduleEvent(command, seletedTransaction!),
                            );
                      },
                    ),
                    // Séparateur
                    const SizedBox(height: 16),

                    // Date
                    TransactionSendFormInputDate(
                      command: command,
                      transaction: seletedTransaction!,
                      traductions: traductions,
                    ),

                    // Espacement de 32 pixels
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              minimum: const EdgeInsets.all(16),
              child: TransactionFormPageScheduleBtn(
                command: command,
                transaction: seletedTransaction!,
              ),
            ),
          );
        } else  {
          return const Scaffold(
            body: LoadingPage(),
          );
        }
      }
    );
  }
}
