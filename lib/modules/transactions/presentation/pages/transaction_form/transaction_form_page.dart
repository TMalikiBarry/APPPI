import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../../domain/models/transaction_send/transaction_send_method.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';
import '../../bloc/transaction_send/transaction_send_state.dart';
import '../transaction_send/transaction_send_page_error.dart';
import '../transaction_send/transaction_send_page_succes.dart';
import 'transaction_form_page_alias.dart';
import 'transaction_form_page_iban.dart';
import 'transaction_form_page_othr.dart';

class TransactionFormPage extends StatelessWidget {
  ///
  const TransactionFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return BlocConsumer<TransactionSendBloc, TransactionSendState>(
      listenWhen: (previous, current) =>
          current is TransactionSendFormVerificationAskingState ||
          current is TransactionSendFormVerificationLoadingState ||
          (previous is TransactionSendFormVerificationLoadingState &&
              current is TransactionSendFormInputState) ||
          (previous is TransactionSendFormVerificationAskingState &&
              current is TransactionSendInitialState) ||
          (current is TransactionSendFormSuccessState &&
              current.transaction.isRTP()) ||
          current is TransactionSendFormErrorState,
      listener: (context, state) async {
        if (state is TransactionSendFormVerificationLoadingState) {
          CustomLoadingDialog.show(context);
        }
        if (state is TransactionSendFormInputState) {
          CustomLoadingDialog.hide(context);
        }
        // Show verification Page
        if (state is TransactionSendFormVerificationAskingState) {
          CustomLoadingDialog.hide(context);
          // Replace with verification page (pushReplacement important)
          AppRouter.pushReplacement(
            context,
            AppRouter.transactionFormVerification,
            params: context.read<TransactionSendBloc>(),
          );
          //
        }
        // Envoyé avec erreur
        if (state is TransactionSendFormErrorState) {
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
        // Annuler après la recherche d'alias ou verif
        if (state is TransactionSendInitialState) {
          AppRouter.go(context, AppRouter.transactionSend);
        }
        // Envoyé avec succès - RTP initiée
        if (state is TransactionSendFormSuccessState) {
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
          // Rediriger sur la page d'accueil après 3 secondes
          Future.delayed(const Duration(seconds: 3), () {
            if (context.mounted && !isBottomSheetClosed) {
              AppRouter.pop(context);
              AppRouter.go(context, AppRouter.home);
            }
          });
        }
      },
      buildWhen: (previous, current) =>
          current is TransactionSendFormInputState,
      builder: (context, state) {
        if (state is TransactionSendFormInputState) {
          return Scaffold(
            // Pour avoir le bouton de retour
            appBar: AppBar(),
            // Contenu de la page
            body: MyPageContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildForm(state.command),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: state.command.isValid()
                          ? () {
                              // initiate
                              print("value : ${state.command.toJson()}");
                              print("value : ${state.command.pspNom}");
                              context.read<TransactionSendBloc>().add(
                                  TransactionSendInitiateEvent(state.command));
                            }
                          : null,
                      child: Text(traductions.transactionFormContinueBtn),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  /// Retourne les champs du formulaire en fonction du type de transaction
  /// et de la méthode de paiement demandée (alias, iban, othr)
  Widget _buildForm(
    TransactionSendCommand command,
  ) {
    TransactionSendMethod method = command.method;
    if (method == TransactionSendMethod.alias ||
        method == TransactionSendMethod.qrcode) {
      return TransactionFormPageAlias(formValues: command);
    } //
    else if (method == TransactionSendMethod.iban) {
      return TransactionFormPageIban(formValues: command);
    } //
    else {
      return const TransactionFormPageOthr();
    }
  }
}
