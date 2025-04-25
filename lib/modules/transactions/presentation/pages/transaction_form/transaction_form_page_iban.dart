import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

import '../../../../../shared/models/uemoa_countries.dart';
import '../../../../../shared/widgets/input_text.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import 'transaction_form_input_amount.dart';
import 'transaction_form_input_iban.dart';
import 'transaction_form_input_motif.dart';

class TransactionFormPageIban extends StatelessWidget {
  ///
  const TransactionFormPageIban({super.key, required this.formValues});

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
          traductions.transactionsSendFormIbanTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),

        //
        const SizedBox(height: 5.0),

        // Sous titre de la page
        Text(
          traductions.transactionsSendFormIbanSubtitle,
          style: Theme.of(context).textTheme.displaySmall,
        ),

        //
        const SizedBox(height: 32),

        // Champ IBAN
        TransactionFormInputIban(
          command: formValues,
          transactionFormBloc: transactionSendBloc,
          traductions: traductions,
        ),

        // Espacement de 16 pixels
        const SizedBox(height: 16),

        // Pays  - déduit de IBAN
        CustomTextInput(
          labelText: traductions.transactionFormIbanPaysLabel,
          controller: TextEditingController(
            text: formValues.pspPays != null
                ? UEMOACountry.get(formValues.pspPays!)!.name
                : null,
          ),
          readOnly: true,
        ),

        // Espacement de 16 pixels
        const SizedBox(height: 16),

        // Nom  - déduit de IBAN
        CustomTextInput(
          labelText: traductions.transactionFormIbanNomLabel,
          controller: TextEditingController(text: formValues.pspNom),
          readOnly: true,
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

        // // Bouton
        // TransactionFormBtnContinue(
        //   command: formValues,
        //   transactionSendBloc: transactionSendBloc,
        //   traductions: traductions,
        // ),
      ],
    );
  }
}
