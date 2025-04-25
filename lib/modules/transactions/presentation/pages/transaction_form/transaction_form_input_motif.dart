import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/input_text.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../../domain/models/transaction_send/transaction_send_command_motif.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';

class TransactionFormInputMotif extends StatelessWidget {
  ///
  const TransactionFormInputMotif({
    super.key,
    required this.command,
    required this.traductions,
    this.pasteCtrl,
    this.transactionFormBloc,
    this.readonly = false, // Add a default value for the readonly parameter
  });

  final TransactionSendCommand command;
  final TransactionSendBloc? transactionFormBloc;
  final TextEditingController? pasteCtrl;
  final AppLocalizations traductions;
  final bool readonly;

  @override
  Widget build(BuildContext context) {
    //
    return CustomTextInput(
      labelText: traductions.transactionFormMotifHint,
      // Message d'erreur à afficher
      messageError: command.motif != null && command.motif!.error != null
          ? getMotifErrorMessage(command.motif!.error!, traductions)
          : "",
      // Quand le texte change
      onChange: (value) {
        command.motif = TransactionSendCommandMotif(value: value);
        transactionFormBloc!.add(TransactionSendFormChangedEvent(command));
      },
    );
  }

  /// Retourne le message d'erreur sur le champ nom d'utilisateur
  String getMotifErrorMessage(
    TransactionSendCommandMotifError error,
    AppLocalizations traductions,
  ) {
    // Invalid motif
    if (error == TransactionSendCommandMotifError.invalid) {
      return traductions.transactionFormMotifInvalid;
    }
    // Not translated error
    else {
      return '';
    }
  }
}
