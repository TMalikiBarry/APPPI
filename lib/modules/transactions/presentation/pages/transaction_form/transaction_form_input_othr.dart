import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/input_text.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../../domain/models/transaction_send/transaction_send_command_othr.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';

class TransactionFormInputOthr extends StatefulWidget {
  ///
  const TransactionFormInputOthr({
    super.key,
    required this.command,
    required this.traductions,
    this.transactionFormBloc,
    this.readonly = false, // Add a default value for the readonly parameter
  });

  final TransactionSendCommand command;
  final TransactionSendBloc? transactionFormBloc;
  final AppLocalizations traductions;
  final bool readonly;

  @override
  State<TransactionFormInputOthr> createState() => 
    _TransactionFormInputOthrState();
}

class _TransactionFormInputOthrState 
  extends State<TransactionFormInputOthr> {
  
  TextEditingController pasteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialisation des données
    if (widget.command.othr?.value != null) {
      pasteCtrl.text = widget.command.othr!.value!;
      pasteCtrl.selection = TextSelection.fromPosition(TextPosition(
        offset: pasteCtrl.text.length,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {

    //
    return CustomTextInput(
      labelText: widget.traductions.transactionFormOthrLabel,
      controller: pasteCtrl,
      // Forme du champ
      hintText: widget.traductions.transactionFormOthrHint,
      // Message d'erreur à afficher
      messageError: widget.command.othr?.error != null
          ? getOthrErrorMessage(widget.command.othr!.error!, widget.traductions)
          : "",
      // Quand le texte change
      onChange: (value) {
        widget.command.othr = TransactionSendCommandOthr(value: value);
        widget.transactionFormBloc!.add(TransactionSendFormChangedEvent(
          widget.command));
      },
    );
  }

  /// Retourne le message d'erreur sur le champ nom d'utilisateur
  String getOthrErrorMessage(
    TransactionSendCommandOthrError error,
    AppLocalizations traductions,
  ) {
    // Empty account number
    if (error == TransactionSendCommandOthrError.empty) {
      return traductions.transactionFormOthrEmpty;
    }
    // Not translated error
    else {
      return '';
    }
  }
}
