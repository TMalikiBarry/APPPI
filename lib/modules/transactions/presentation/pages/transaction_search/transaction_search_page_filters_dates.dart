import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/select_daterange_widget.dart';
import '../../../domain/models/transaction_search/transaction_search_command.dart';
import '../../bloc/transaction_search/transaction_search_bloc.dart';

class TransactionSearchPageFiltersDates extends StatefulWidget {
  const TransactionSearchPageFiltersDates({super.key});

  @override
  TransactionSearchPageFiltersDatesState createState() =>
      TransactionSearchPageFiltersDatesState();
}

class TransactionSearchPageFiltersDatesState
    extends State<TransactionSearchPageFiltersDates> {
  //
  DateTime? dateDebut;
  DateTime? dateFin;

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    TransactionSearchBloc transactionSearchBloc =
        context.read<TransactionSearchBloc>();

    TransactionSearchCommand command = transactionSearchBloc.state.command;

    dateDebut = command.filters.dateDebut;
    dateFin = command.filters.dateFin;
    //
    return Card(
      child: ListTile(
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(14)),
          ),
          child: const Icon(Icons.calendar_month_outlined),
        ),
        // Indication: Selectionner la plage
        title: Text(
          traductions.transactionSearchInputFilterDateSubTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        // Affichage de la plage choisie
        subtitle: Text(
          traductions.transactionSearchInputFilterDateRange(
              dateDebut != null ? DateFormat('d MMM').format(dateDebut!) : '',
              dateFin != null ? DateFormat('d MMM').format(dateFin!) : ''),
          style: Theme.of(context).textTheme.displaySmall,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () async {
          var dates = await SelectDateRangeWidget.show(
            context: context,
            title: traductions.transactionSearchInputFilterDateSelectTitle,
          );
          setState(() {
            if (dates.isNotEmpty) {
              dateDebut = dates[0];
              dateFin = dates.length == 2 ? dates[1] : null;
            } else {
              dateDebut = null;
              dateFin = null;
            }
            command.filters.dateDebut = dateDebut;
            command.filters.dateFin = dateFin;
          });
        },
      ),
    );
  }
}
