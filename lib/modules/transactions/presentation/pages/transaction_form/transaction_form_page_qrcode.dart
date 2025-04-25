import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';
import '../../bloc/transaction_send/transaction_send_state.dart';
import 'transaction_form_page.dart';

/// Page tampon logique de redirection après scan d'un QR Code
class TransactionFormPageQrcode extends StatelessWidget {
  ///
  const TransactionFormPageQrcode({super.key, required this.command});

  final TransactionSendCommand command;

  @override
  Widget build(BuildContext context) {
    debugPrint("ACTION => ${command.action}");
    // Bloc de gestion des transactions
    TransactionSendBloc transactionSendBloc =
        context.read<TransactionSendBloc>();

    // SI le qr code contine ttoutes les infos
    // Alors directement faire la recherche d'alias
    if (command.amount?.value != null) {
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
            // Show verification Page
            if (state is TransactionSendFormVerificationAskingState) {
              CustomLoadingDialog.hide(context);
              AppRouter.push(
                context,
                AppRouter.transactionFormVerification,
                params: transactionSendBloc,
              );
              //
            }
          },
          buildWhen: (previous, current) =>
              current is TransactionSendFormVerificationLoadingState ||
              current is TransactionSendFormVerificationAskingState,
          builder: (context, state) {
            return LoadingPage(bgColor: Theme.of(context).colorScheme.surface);
          },
        ),
      );
    }
    // Si le QR Code ne contine tpas de montant
    // Alors affiche le formulaire prérenseigné avec l'alias
    else {
      // Afficher form pour la saisie du montant
      transactionSendBloc.add(
        TransactionSendDisplayFormEvent(command),
      );
      // Naviguer sur le formulaire de transaction
      return BlocProvider<TransactionSendBloc>.value(
        value: transactionSendBloc,
        child: const TransactionFormPage(),
      );
    }
  }
}
