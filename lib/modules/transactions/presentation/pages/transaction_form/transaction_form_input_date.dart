import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../shared/widgets/input_text.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/select_date_widget.dart';
import '../../../../../shared/widgets/select_daterange_widget.dart';
import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../../domain/models/transaction_send/transaction_send_command_schedule.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';

class TransactionSendFormInputDate extends StatelessWidget {
  ///
  const TransactionSendFormInputDate({
    super.key,
    required this.command,
    required this.traductions,
    required this.transaction,
    this.readOnly = true, // Add a default value for the readonly parameter
  });

  final TransactionSendCommand command;
  final Transaction transaction;

  final AppLocalizations traductions;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    //
    final locale = Localizations.localeOf(context).toString();
    final formatter = DateFormat('d MMMM yyyy', locale);
    //
    final TextEditingController pasteCtrl = TextEditingController();
    if (command.schedule != null && command.schedule!.dateDebut != null) {
      // Si c'est une fréquence
      if (command.schedule!.frequence?.value != null) {
        pasteCtrl.text = SelectDateRangeWidget.plage(
          traductions,
          formatter,
          command.schedule!.dateDebut!,
          command.schedule!.dateFin,
        );
      }
      // Si c'est une seule fois
      else {
        pasteCtrl.text = formatter.format(command.schedule!.dateDebut!);
      }
      pasteCtrl.selection = TextSelection.fromPosition(TextPosition(
        offset: pasteCtrl.text.length,
      ));
    }

    //
    return CustomTextInput(
      labelText: command.schedule!.frequence!.value != null
          ? traductions.transactionFormScheduleDateRangeLabel
          : traductions.transactionFormScheduleDateLabel,
      controller: pasteCtrl,
      readOnly: readOnly,
      suffixIcon: IconButton(
        icon: const Icon(Icons.date_range),
        onPressed: () => _handleDateSelection(context),
      ),
      // Message d'erreur à afficher
      messageError: command.schedule != null && command.schedule!.error != null
          ? getDateErrorMessage(command.schedule!.error!, traductions)
          : "",
    );
  }

  Future<void> _handleDateSelection(BuildContext context) async {
    if (command.schedule!.frequence!.value != null) {
      await _showDateRangeSelect(context);
    } else {
      await _showDateSelect(context);
    }
  }

  /// Afficher le calendrier pour selectionner une date
  _showDateSelect(BuildContext context) async {
    var selected = await SelectDateWidget.show(
      context: context,
      title: traductions.transactionFormScheduleDateSelectTitle,
      selected: command.schedule?.dateDebut,
      firstDate: DateTime.now().add(const Duration(days: 1)), // Demain
    );

    if (!context.mounted || selected == null) return;
    command.schedule!.dateDebut = selected;
    _dispatchScheduleEvent(context);
  }

  /// Afficher le calendrier pour selectionner une plage de dates
  _showDateRangeSelect(BuildContext context) async {
    var selected = await SelectDateRangeWidget.show(
      context: context,
      title: traductions.transactionFormScheduleDateRangeSelectTitle,
      dateDebut: command.schedule!.dateDebut,
      dateFin: command.schedule!.dateFin,
      firstDate: DateTime.now().add(const Duration(days: 1)), // Demain
    );
    if (!context.mounted) return;

    if (selected.isNotEmpty) {
      command.schedule!.dateDebut = selected[0];
      command.schedule!.dateFin = selected.length == 2 ? selected[1] : null;
    } else {
      command.schedule!.dateDebut = null;
      command.schedule!.dateFin = null;
    }
    _dispatchScheduleEvent(context);
  }

  void _dispatchScheduleEvent(BuildContext context) {
    context
        .read<TransactionSendBloc>()
        .add(TransactionSendScheduleEvent(command, transaction));
  }

  /// Retourne le message d'erreur sur le champ date debut
  String getDateErrorMessage(
    TransactionSendCommandScheduleError error,
    AppLocalizations traductions,
  ) {
    return error == TransactionSendCommandScheduleError.debutEmpty
        ? traductions.aliasFormEmpty
        : '';
  }
}
