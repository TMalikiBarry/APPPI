import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/assets.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/input_text.dart';
import '../models/alias_pi.dart';

class InputAliasWidget extends StatelessWidget {
  ///
  const InputAliasWidget({
    super.key,
    required this.command,
    required this.onChange,
    this.readOnly = false,
  });

  final AliasPI command;
  final ValueChanged<String> onChange;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;
    TextEditingController? pasteCtrl = TextEditingController();
    if (command.value != null) {
      pasteCtrl.text = command.value!;
      pasteCtrl.selection = TextSelection.fromPosition(TextPosition(
        offset: pasteCtrl.text.length,
      ));
    }
    //
    return CustomTextInput(
      labelText: traductions.aliasFormLabel,
      // Forme du champ
      hintText: traductions.aliasFormHint,
      controller: pasteCtrl,
      readOnly: readOnly,
      // Btn coller alias
      suffixIcon: readOnly
          ? null
          : IconButton(
              icon: ImageIcon(
                const AssetImage(Images.iconTransactionPasteAlias),
                color: Theme.of(context).colorScheme.onPrimary,
                size: 24,
              ),
              onPressed: readOnly
                  ? null
                  : () async {
                      final clipboardData =
                          await Clipboard.getData(Clipboard.kTextPlain);
                      if (clipboardData != null && clipboardData.text != null) {
                        String clipboardText = clipboardData.text!;
                        command.value = clipboardText;
                        // Notifiy parent
                        onChange(clipboardText);
                      }
                    },
            ),
      // Message d'erreur à afficher
      messageError: command.error != null
          ? getAliasErrorMessage(command.error!, traductions)
          : "",
      // Quand le texte change
      onChange: (value) {
        command.value = value;
        // Notifiy parent
        onChange(value);
      },
    );
  }

  /// Retourne le message d'erreur sur le champ alias
  String getAliasErrorMessage(
    AliasPIError error,
    AppLocalizations traductions,
  ) {
    // Empty alias
    if (error == AliasPIError.empty) {
      return traductions.aliasFormEmpty;
    }
    // Invalid alias
    else if (error == AliasPIError.invalid) {
      return traductions.aliasFormInvalid;
    }
    // notFound alias
    else if (error == AliasPIError.notFound) {
      return traductions.aliasFormNotFound;
    }
    // Not translated error
    else {
      return '';
    }
  }
}
