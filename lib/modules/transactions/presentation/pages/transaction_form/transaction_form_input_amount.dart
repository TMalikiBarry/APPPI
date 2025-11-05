import 'package:flutter/material.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

import '../../../../../shared/widgets/input_amount.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../../domain/models/transaction_send/transaction_send_command_amount.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';
import 'package:intl/intl.dart';

class TransactionFormInputAmount extends StatefulWidget {
  ///
  const TransactionFormInputAmount({
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
  State<TransactionFormInputAmount> createState() => 
    _TransactionFormInputAmountState();
}

class _TransactionFormInputAmountState 
  extends State<TransactionFormInputAmount> {
  
  TextEditingController ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialisation des données
    if (widget.command.amount?.value != null) {
      ctrl.text = widget.command.amount!.value!.toInt().toString();
      ctrl.selection = TextSelection.fromPosition(TextPosition(
        offset: ctrl.text.length,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,##0', 'fr_SN');
    //
    return InputAmount(
      //
      solde: widget.command.solde ?? 0,
      hintText: widget.traductions.transactionFormAmountHint,
      // Message d'erreur à afficher
      messageError: widget.command.amount?.error != null
          ? getAmountErrorMessage(widget.command.amount!.error!, 
            widget.traductions)
          : "",
      // Quand le texte change
      onChange: (value) {
        /// 🔹 Formatage dynamique pendant la saisie
        // Supprime les espaces ou séparateurs existants
        String numericString = value.replaceAll(RegExp(r'\D'), '');

        if (numericString.isEmpty) {
          ctrl.clear();
          return;
        }

        // Convertit en nombre
        final number = double.tryParse(numericString) ?? 0;

        // Formate en ajoutant des espaces
        final formatted =
        formatter.format(number).replaceAll(',', ' ');

        // Mets à jour le texte formaté
        ctrl.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(
            offset: formatted.length,
          ),
        );
        widget.command.amount = TransactionSendCommandAmount(
          value: value.isNotEmpty ? double.parse(value) : 0.0,
          solde: widget.command.solde,
        );
        widget.transactionFormBloc!.add(TransactionSendFormChangedEvent(
          widget.command));
      },
      controller: ctrl,
      readOnly: widget.readOnly,
    );
  }

  /// Retourne le message d'erreur sur le champ nom d'utilisateur
  String getAmountErrorMessage(
    TransactionSendCommandAmountError error,
    AppLocalizations traductions,
  ) {
    // Empty amount
    if (error == TransactionSendCommandAmountError.empty) {
      return traductions.transactionFormAmountEmpty;
    }
    // Invalid amount (insufficient balance)
    else if (error == TransactionSendCommandAmountError.invalid) {
      return traductions.transactionFormAmountInvalid;
    }
    // Invalid amount (too low)
    else if (error == TransactionSendCommandAmountError.low) {
      return traductions.transactionFormAmountLow;
    }
    // Not translated error
    else {
      return '';
    }
  }
}
