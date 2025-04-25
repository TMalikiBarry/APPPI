import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/assets.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/input_text.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../../domain/models/transaction_send/transaction_send_command_iban.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';

class TransactionFormInputIban extends StatefulWidget {
  ///
  const TransactionFormInputIban({
    super.key,
    required this.command,
    required this.traductions,
    this.transactionFormBloc,
    this.readOnly = false, // Add a default value for the readonly parameter
  });

  final TransactionSendCommand command;
  final TransactionSendBloc? transactionFormBloc;
  final AppLocalizations traductions;
  final bool readOnly;

  @override
  State<TransactionFormInputIban> createState() => 
    _TransactionFormInputIbanState();
}

class _TransactionFormInputIbanState 
  extends State<TransactionFormInputIban> {
  
  TextEditingController pasteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialisation des données
    if ( widget.command.iban?.value != null) {
      pasteCtrl.text = widget.command.iban!.value!;
      pasteCtrl.selection = TextSelection.fromPosition(TextPosition(
        offset: pasteCtrl.text.length,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextInput(
      labelText: widget.traductions.transactionFormIbanLabel,
      // Forme du champ
      hintText: widget.traductions.transactionFormIbanHint,
      controller: pasteCtrl,
      readOnly: widget.readOnly,
      // Btn coller alias
      suffixIcon: IconButton(
        icon: ImageIcon(
          const AssetImage(Images.iconTransactionPasteAlias),
          color: Theme.of(context).colorScheme.onPrimary,
          size: 24,
        ),
        onPressed: () async {
          final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
          if (clipboardData != null && clipboardData.text != null) {
            String clipboardText = clipboardData.text!;
            setState(() {
              pasteCtrl.text = clipboardText;
              pasteCtrl.selection = TextSelection.fromPosition(
                TextPosition(offset: pasteCtrl.text.length,
              ));
            });
            widget.command.iban = TransactionSendCommandIban(
              value: clipboardText);
            widget.transactionFormBloc!.add(TransactionSendFormChangedEvent(
              widget.command));
          }
        },
      ),
      // Message d'erreur à afficher
      messageError: widget.command.iban?.error != null
          ? getIbanErrorMessage(widget.command.iban!.error!, widget.traductions)
          : "",
      // Quand le texte change
      onChange: (value) {
        widget.command.iban = TransactionSendCommandIban(value: value);
        widget.transactionFormBloc!.add(TransactionSendFormChangedEvent(
          widget.command));
      },
    );
  }

  /// Retourne le message d'erreur sur le champ nom d'utilisateur
  String getIbanErrorMessage(
    TransactionSendCommandIbanError error,
    AppLocalizations traductions,
  ) {
    // Empty iban
    if (error == TransactionSendCommandIbanError.empty) {
      return traductions.transactionFormIbanEmpty;
    }
    // Invalid iban format
    else if (error == TransactionSendCommandIbanError.invalid) {
      return traductions.transactionFormIbanInvalid;
    }
    // Not translated error
    else {
      return '';
    }
  }
}
