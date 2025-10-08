import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/assets.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/input_text.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../../domain/models/transaction_send/transaction_send_command_alias.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';

class TransactionFormInputAlias extends StatefulWidget {
  ///
  const TransactionFormInputAlias({
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
  State<TransactionFormInputAlias> createState() => 
    _TransactionFormInputAliasState();
}

class _TransactionFormInputAliasState 
  extends State<TransactionFormInputAlias> {
  
  TextEditingController pasteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialisation des données
    if (widget.command.alias?.value != null) {
      pasteCtrl.text = widget.command.alias!.value!;
      pasteCtrl.selection = TextSelection.fromPosition(TextPosition(
        offset: pasteCtrl.text.length,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    return CustomTextInput(
      labelText: widget.traductions.aliasFormLabel,
      // Forme du champ
      hintText: widget.traductions.aliasFormHint,
      controller: pasteCtrl,
      readOnly: widget.readOnly,
      // Btn coller alias
      suffixIcon: widget.readOnly
          ? null
          : IconButton(
              icon: ImageIcon(
                const AssetImage(Images.iconTransactionPasteAlias,package: 'common_dependencies'),
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              onPressed: widget.readOnly
                  ? null
                  : () async {
                      final clipboardData =
                          await Clipboard.getData(Clipboard.kTextPlain);
                      if (clipboardData != null && clipboardData.text != null) {
                        String clipboardText = clipboardData.text!;
                        setState(() {
                          pasteCtrl.text = clipboardText;
                          pasteCtrl.selection = TextSelection.fromPosition(
                            TextPosition(offset: pasteCtrl.text.length,
                          ));
                        });
                        widget.command.alias =
                            TransactionSendCommandAlias(value: clipboardText);
                        widget.transactionFormBloc!
                          .add(TransactionSendFormChangedEvent(widget.command));
                      }
                    },
            ),
      // Message d'erreur à afficher
      messageError: widget.command.alias?.error != null
          ? getAliasErrorMessage(widget.command.alias!.error!)
          : "",
      // Quand le texte change
      onChange: (value) {
        widget.command.alias = TransactionSendCommandAlias(value: value);
        widget.transactionFormBloc!.add(TransactionSendFormChangedEvent(
          widget.command));
      },
    );
  }

  /// Retourne le message d'erreur sur le champ nom d'utilisateur
  String getAliasErrorMessage(TransactionSendCommandAliasError error) {
    // Empty alias
    if (error == TransactionSendCommandAliasError.empty) {
      return widget.traductions.aliasFormEmpty;
    }
    // Invalid alias
    else if (error == TransactionSendCommandAliasError.invalid) {
      return widget.traductions.aliasFormInvalid;
    }
    // Invalid shid
    else if (error == TransactionSendCommandAliasError.invalidOnlySHID) {
      return widget.traductions.aliasFormInvalidOnlySHID;
    }
    // notFound alias
    else if (error == TransactionSendCommandAliasError.notFound) {
      return widget.traductions.aliasFormNotFound;
    }
    // Not translated error
    else {
      return '';
    }
  }
}
