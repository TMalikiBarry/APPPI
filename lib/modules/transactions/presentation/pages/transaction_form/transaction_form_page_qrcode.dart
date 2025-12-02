import 'package:common_dependencies/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/core/app.dart';

import '../../../../../core/router.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';
import '../../bloc/transaction_send/transaction_send_state.dart';
import '../transaction_send/transaction_send_page_error.dart';
import 'transaction_form_page.dart';

/// Page tampon logique de redirection après scan d'un QR Code
class TransactionFormPageQrcode extends StatelessWidget {
  ///
   TransactionFormPageQrcode( {super.key, required this.command,  this.ctx});

  final TransactionSendCommand command;

  BuildContext? ctx;



  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(ctx ?? context)!.settings.arguments;
    final route = ModalRoute.of(ctx ?? context)!.settings.name;

    print("✅ Navigation reçue");
    print("➡️ URL: $route");
    print("➡️ Arguments: $args");

    debugPrint("ACTION => ${command.action}");
    debugPrint("txId => ${command.txId}");
    // Bloc de gestion des transactions
    TransactionSendBloc transactionSendBloc =
    (ctx ?? context).read<TransactionSendBloc>();

    // SI le qr code contine ttoutes les infos
    // Alors directement faire la recherche d'alias
    if (command.amount?.value != null && route != AppRouter.qrcodeTransactionSendTp) {
      // Rechercher alias et Afficher page de vérification
      transactionSendBloc.add(TransactionSendInitiateEvent(command));

      return BlocProvider<TransactionSendBloc>.value(
        value: transactionSendBloc,
        child: BlocConsumer<TransactionSendBloc, TransactionSendState>(
          listenWhen: (previous, current) =>
              current is TransactionSendFormVerificationAskingState ||
              current is TransactionSendFormVerificationLoadingState ||
              current is TransactionSendFormErrorState,
          listener: (context, state) async {
            logger.i("state : listener transaction_page_qrcode $state");
            if (state is TransactionSendFormErrorState) {
              // Hide loader
              CustomLoadingDialog.hide(ctx ?? context);
              // Show success popup
              showModalBottomSheet<void>(
                context: ctx ?? context,
                builder: (BuildContext context) {
                  return TransactionSendPageError(error: state.error);
                },
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
              );
            }
            // Show verification Page
            if (state is TransactionSendFormVerificationAskingState) {
              CustomLoadingDialog.hide(ctx ?? context);
              AppRouter.push(
                ctx ?? context,
                AppRouter.transactionFormVerification,
                params: transactionSendBloc,
              );
              //
            }
          },
          buildWhen: (previous, current) =>
              current is TransactionSendLoadingState ||
              current is TransactionSendFormVerificationLoadingState ||
              current is TransactionSendFormVerificationAskingState,
          builder: (context, state) {
            logger.i("state : builder transaction_page_qrcode $state");
            return LoadingPage(bgColor: Theme.of(ctx ?? context).colorScheme.surface);
          },
        ),
      );
    }
    // Si le QR Code ne contine tpas de montant
    // Alors affiche le formulaire prérenseigné avec l'alias
    else {
      logger.i("fromScanTouchPoint qrcode ${route == AppRouter.qrcodeTransactionSendTp}");
      if (command.amount?.value != null && route == AppRouter.qrcodeTransactionSendTp) {
        transactionSendBloc.add(TransactionSendInitiateEvent(command));
      } else {
        // Afficher form pour la saisie du montant
        transactionSendBloc.add(
          TransactionSendDisplayFormEvent(command),
        );
      }
      // Naviguer sur le formulaire de transaction
      return BlocProvider<TransactionSendBloc>.value(
        value: transactionSendBloc,
        child: TransactionFormPage(fromScanTouchPoint: route == AppRouter.qrcodeTransactionSendTp),
      );
    }
  }
}
