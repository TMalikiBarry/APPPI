import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

import '../../../domain/models/transaction.dart';
import '../../../domain/models/transaction_search/transaction_search_command.dart';
import '../../bloc/transaction_search/transaction_search_bloc.dart';

class TransactionSearchPageFiltersSensItem {
  const TransactionSearchPageFiltersSensItem({
    required this.sens,
    required this.label,
    required this.icon,
    required this.selected,
  });
  final TransactionSens sens;
  final String label;
  final IconData icon;
  final bool selected;
}

class TransactionSearchPageFiltersSens extends StatefulWidget {
  const TransactionSearchPageFiltersSens({Key? key}) : super(key: key);

  @override
  TransactionSearchPageFiltersSensState createState() =>
      TransactionSearchPageFiltersSensState();
}

class TransactionSearchPageFiltersSensState
    extends State<TransactionSearchPageFiltersSens> {
  //
  bool? sensDebit;
  bool? sensCredit;

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    TransactionSearchCommand command =
        context.read<TransactionSearchBloc>().state.command;
    // Les deux sens debit et credit
    sensCredit = command.filters.sens == null
        ? true
        : command.filters.sens == TransactionSens.credit;
    sensDebit = command.filters.sens == null
        ? true
        : command.filters.sens == TransactionSens.debit;
    //
    final List<TransactionSearchPageFiltersSensItem> sensListe = [
      TransactionSearchPageFiltersSensItem(
        sens: TransactionSens.credit,
        label: traductions.transactionSearchInputFilterCategoriesSensRecus,
        icon: Icons.arrow_forward,
        selected: sensCredit!,
      ),
      TransactionSearchPageFiltersSensItem(
        sens: TransactionSens.debit,
        label: traductions.transactionSearchInputFilterCategoriesSensPayes,
        icon: Icons.arrow_back_ios,
        selected: sensDebit!,
      ),
    ];
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sensListe.map<Widget>((sensItem) {
          return CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Row(
              children: [
                // Icon
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(14.0)),
                  ),
                  child: Icon(sensItem.icon),
                ),
                const SizedBox(width: 12),
                // label
                Text(
                  sensItem.label,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            value: sensItem.selected,
            // On select
            onChanged: (bool? value) {
              // TransactionSens.credit
              // && command.filters.sens == TransactionSens.debit
              setState(() {
                // si on selectionne
                if (value != null && value) {
                  if (command.filters.sens != null &&
                      sensItem.sens != command.filters.sens) {
                    // Ce la veut dire qu'il veut filtrer selon tous les deux
                    sensCredit = value;
                    sensDebit = value;
                    command.filters.sens = null;
                  } else {
                    sensCredit = sensItem.sens == TransactionSens.credit;
                    sensDebit = sensItem.sens == TransactionSens.debit;
                    command.filters.sens = sensItem.sens;
                  }
                }
                // Si on deselectionne value = false
                else if (value == false) {
                  if (sensItem.sens == TransactionSens.debit) {
                    sensDebit = value;
                    sensCredit = !value!;
                    command.filters.sens = TransactionSens.credit;
                  } else {
                    sensCredit = value;
                    sensDebit = !value!;
                    command.filters.sens = TransactionSens.debit;
                  }
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
