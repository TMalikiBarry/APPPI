import 'package:flutter/material.dart';

import '../../../../../../shared/widgets/input_text.dart';
import '../../l10n/app_localizations.dart';
import '../models/frequence_command.dart';
import 'frequence_select_widget.dart';

class FrequenceInputWidget extends StatelessWidget {
  ///
  const FrequenceInputWidget({
    super.key,
    required this.command,
    required this.onChange,
    this.readOnly = true, // Add a default value for the readonly parameter
  });

  final FrequenceCommand command;
  final ValueChanged<FrequenceCommand> onChange;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    // Si fréquence et période définies
    final TextEditingController pasteCtrl = TextEditingController();
    if (command.value != null && command.periodicite != null) {
      pasteCtrl.text = traductions.transactionFormScheduleFrequenceSelected(
        command.periodicite.toString(),
        FrequenceSelectWidget.periodiciteText(
          context,
          traductions,
          command.value!,
        ),
      );
    }
    // Si fréquence définie uniquement
    else if (command.value != null) {
      pasteCtrl.text =
          FrequenceSelectWidget.frequenceText(command.value!, traductions);
    }
    // Pas de valeur = > une seule fois
    else {
      pasteCtrl.text = traductions.transactionFormScheduleFrequenceUnefois;
    }
    pasteCtrl.selection = TextSelection.fromPosition(TextPosition(
      offset: pasteCtrl.text.length,
    ));

    if (command.periodicite != null && command.done == false) {
      // show custom frequence form
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showBottomSheet(
          context,
          traductions,
          [Frequence.quotidienne, Frequence.hebdomadaire, Frequence.mensuelle],
        );
      });
    }
    // Input
    return InkWell(
      onTap: () => _select(context, traductions),
      child: CustomTextInput(
        labelText: traductions.transactionFormScheduleFrequenceLabel,
        controller: pasteCtrl,
        readOnly: readOnly,
        suffixIcon: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_outlined),
          onPressed: () => _select(context, traductions),
        ),
      ),
    );
  }

  void _select(
    BuildContext context,
    AppLocalizations traductions,
  ) {
    _showBottomSheet(
      context,
      traductions,
      [
        Frequence.quotidienne,
        Frequence.hebdomadaire,
        Frequence.mensuelle,
        Frequence.annuelle,
      ],
    );
  }

  /// show frequence form in bottom sheet
  void _showBottomSheet(
    BuildContext context,
    AppLocalizations traductions,
    List<Frequence> frequences,
  ) {
    if (command.periodicite != null) {}
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FrequenceSelectWidget(
          title: traductions.transactionFormScheduleFrequenceLabel,
          command: command,
          frequences: frequences,
          onChange: (value) => onChange(value),
        );
      },
    );
  }
}
