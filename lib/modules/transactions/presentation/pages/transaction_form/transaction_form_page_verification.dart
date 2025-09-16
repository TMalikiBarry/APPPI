import 'package:common_dependencies/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/core/notifications.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/models/uemoa_countries.dart';
import '../../../../../shared/widgets/input_text.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_state.dart';
import '../transaction_send/transaction_send_page_error.dart';
import '../transaction_send/transaction_send_page_succes.dart';
import 'transaction_form_btn_confirm.dart';

class TransactionVerificationPage extends StatelessWidget {
  ///
  const TransactionVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    ///
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    return BlocConsumer<TransactionSendBloc, TransactionSendState>(
      listenWhen: (previous, current) =>
          current is TransactionSendFormSendingState ||
          current is TransactionSendFormSuccessState ||
          current is TransactionSendFormErrorState,
      listener: (context, state) async {
        // Envoie en cours
        if (state is TransactionSendFormSendingState) {
          //CustomLoadingDialog.show(context);
        }
        // Envoyé avec succès - Irrevocable
        else if (state is TransactionSendFormSuccessState) {
          // Hide loader
          //CustomLoadingDialog.hide(context);

          // Notification en cas de success
          AppNotifications.showCustomTransferNotification(
            title: "Opération réussie",
            body: "Votre opération a été éffectuée avec succès!",
          );

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
      },
      buildWhen: (previous, current) =>
          current is TransactionSendFormVerificationAskingState ||
          current is TransactionSendLoadingState,
      builder: (context, state) {
        logger.i("transaction_form_page_verification state : $state");
        /*if (state is! TransactionSendFormVerificationAskingState) {
          return const LoadingPage();
        }*/
        if (state is TransactionSendFormVerificationAskingState) {
          TransactionSendCommand command = state.command;
          Transaction transaction = state.transaction;
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
                      traductions.transactionFormVerificationTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    //
                    const SizedBox(height: 5.0),
                    // Sous titre de la page
                    Text(
                      traductions.transactionFormVerificationSubtitle,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    //
                    const SizedBox(height: 32),

                    // Alias
                    if (command.alias != null) ... [
                      CustomTextInput(
                        labelText: traductions.aliasFormLabel,
                        controller: TextEditingController(
                            text: command.alias!.value.toString()),
                        readOnly: true,
                      ),
                    ]

                    // IBAN
                    else if (command.iban != null) ...[
                      // Type
                      CustomTextInput(
                        labelText:
                            traductions.transactionFormVerificationTypeLabel,
                        controller: TextEditingController(
                          text: traductions.transactionFormVerificationTypeIBAN,
                        ),
                        readOnly: true,
                      ),

                      // Séparateur
                      const SizedBox(height: 16),

                      // Valeur de l'iban
                      CustomTextInput(
                        labelText: traductions.transactionFormIbanHint,
                        controller: TextEditingController(
                            text: command.iban!.value.toString()),
                        readOnly: true,
                      ),

                      // Séparateur
                      const SizedBox(height: 16),

                      // Nom de la Banque
                      CustomTextInput(
                        labelText: traductions.transactionFormIbanNomLabel,
                        controller: TextEditingController(text: command.pspNom!),
                        readOnly: true,
                      ),
                    ]

                    // Othr
                    else if (command.othr != null) ...[
                      // Type
                      CustomTextInput(
                        labelText:
                            traductions.transactionFormVerificationTypeLabel,
                        controller: TextEditingController(
                          text: traductions.transactionFormVerificationTypeOTHR,
                        ),
                        readOnly: true,
                      ),

                      // Séparateur
                      const SizedBox(height: 16),

                      // Valeur de l'oth
                      CustomTextInput(
                        labelText: traductions.transactionFormOthrLabel,
                        controller: TextEditingController(
                            text: command.othr!.value.toString()),
                        readOnly: true,
                      ),

                      // Séparateur
                      const SizedBox(height: 16),

                      // Institution
                      CustomTextInput(
                        labelText: traductions.transactionFormOthrNomLabel,
                        controller: TextEditingController(
                            text: command.pspNom!.toString()),
                        readOnly: true,
                      ),
                    ],

                    // Séparateur
                    const SizedBox(height: 16),

                    // Pays  de l'institution
                    if (transaction.clientPays.isNotEmpty)
                        CustomTextInput(
                          labelText: traductions.transactionFormOthrPaysLabel,
                          controller: TextEditingController(
                            text: UEMOACountry.get(transaction.clientPays)!.name,
                          ),
                          readOnly: true,
                        ),

                        // Séparateur
                        const SizedBox(height: 16),

                    // Nom du client
                    if (transaction.clientNom.isNotEmpty)
                        CustomTextInput(
                          labelText:
                              traductions.transactionFormVerificationClientName,
                          controller: TextEditingController(
                            text: transaction.sens == TransactionSens.debit ?
                            transaction.clientNom : transaction.acquirerAccountLabel!,
                          ),
                          readOnly: true,
                        ),

                        // Séparateur
                        const SizedBox(height: 16),

                    // Montant
                    CustomTextInput(
                      labelText: traductions.transactionFormAmountHint,
                      controller: TextEditingController(
                          text: command.amount!.value.toString()),
                      readOnly: true,
                    ),

                    // Séparateur
                    const SizedBox(height: 16),

                    // Motif
                    CustomTextInput(
                      labelText: traductions.transactionFormMotifLabel,
                      controller: TextEditingController(
                        text: command.motif?.value.toString(),
                      ),
                      readOnly: true,
                    ),

                    const SizedBox(height: 32),

                    // Bouton de confirmation ou rejet ou programmation
                    // Espacement de 32 pixels
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: TransactionFormBtnConfirm(
                command: command,
                transaction: transaction,
                traductions: traductions,
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: LoadingPage(),
          );
        }
      },
    );
  }
}
