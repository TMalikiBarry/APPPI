import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../../domain/models/transaction_send/transaction_send_method.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import 'transaction_form_input_alias.dart';
import 'transaction_form_input_amount.dart';
import 'transaction_form_input_motif.dart';

class TransactionFormPageAlias extends StatelessWidget {
  ///
  const TransactionFormPageAlias({super.key, required this.formValues});

  final TransactionSendCommand formValues;

  @override
  Widget build(BuildContext context) {
    ///
    AppLocalizations traductions = AppLocalizations.of(context)!;

    // Récupère transactionSendBloc
    TransactionSendBloc transactionSendBloc =
        context.read<TransactionSendBloc>();

    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Titre de la page
        Text(
          _pageTitle(traductions),
          style: Theme.of(context).textTheme.titleSmall,
        ),

        //
        const SizedBox(height: 5.0),

        // Sous titre de la page
        Text(
          _pageSubtitle(traductions),
          style: Theme.of(context).textTheme.displaySmall,
        ),

        //
        const SizedBox(height: 32),

        // Formulaire: champs et boutons

        // Alias
        TransactionFormInputAlias(
          command: formValues,
          transactionFormBloc: transactionSendBloc,
          traductions: traductions,
          readOnly: formValues.method == TransactionSendMethod.qrcode,
        ),

        // Espacement de 16 pixels
        const SizedBox(height: 16),

        // Montant
        TransactionFormInputAmount(
          command: formValues,
          transactionFormBloc: transactionSendBloc,
          traductions: traductions,
        ),

        // Espacement de 16 pixels
        const SizedBox(height: 16),

        // Note
        TransactionFormInputMotif(
          command: formValues,
          transactionFormBloc: transactionSendBloc,
          traductions: traductions,
        ),

        // Espacement de 32 pixels
        const SizedBox(height: 32),
      ],
    );
  }

  String _pageTitle(AppLocalizations traductions) {
    if (formValues.method == TransactionSendMethod.qrcode) {
      // En fonction du canal
      if (formValues.canal == "731") {
        return traductions.transactionsSendFormQrCodeTitleTransfer;
      } else {
        return traductions.transactionsSendFormQrCodeTitlePayment;
      }
    } //
    else {
      if (formValues.action == TransactionSendCommand.actionReceiveNow) {
        return traductions.transactionsSendTitleRequest2Pay;
      } else {
        return traductions.transactionsSendFormAliasTitle;
      }
    }
  }

  String _pageSubtitle(AppLocalizations traductions) {
    if (formValues.method == TransactionSendMethod.qrcode) {
      return traductions.transactionsSendFormQrCodeSubtitle;
    } //
    else {
      return traductions.transactionsSendFormAliasSubtitle;
    }
  }
}
