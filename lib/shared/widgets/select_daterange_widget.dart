import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/router.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';

class SelectDateRangeWidget extends StatefulWidget {
  //
  final DateTime? dateDebut;
  final DateTime? dateFin;
  final DateTime? firstDate;
  final String title;
  final ValueChanged<List<DateTime>> onSelect;
  //
  const SelectDateRangeWidget({
    super.key,
    this.dateDebut,
    this.dateFin,
    this.firstDate,
    required this.title,
    required this.onSelect,
  });

  @override
  State<SelectDateRangeWidget> createState() => _SelectDateRangeWidgetState();

  /// Display calendar to select date range
  static Future<List<DateTime>> show({
    required BuildContext context,
    required String title,
    DateTime? dateDebut,
    DateTime? dateFin,
    DateTime? firstDate,
  }) async {
    List<DateTime> dates = [];
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      builder: (BuildContext context) {
        return SelectDateRangeWidget(
          title: title,
          firstDate: firstDate,
          dateDebut: dateDebut,
          dateFin: dateFin,
          onSelect: (List<DateTime> value) {
            dates = value;
          },
        );
      },
    );
    return dates;
  }

  /// Return description of selected range
  static String plage(
    AppLocalizations traductions,
    DateFormat formatter,
    DateTime dateDebut,
    DateTime? dateFin,
  ) {
    if (dateFin != null) {
      return traductions.transactionFormScheduleDateRange(
        formatter.format(dateDebut),
        formatter.format(dateFin),
      );
    } else {
      return traductions.transactionFormScheduleDateSelected(
        formatter.format(dateDebut),
      );
    }
  }
}

class _SelectDateRangeWidgetState extends State<SelectDateRangeWidget> {
  ///
  late DateTime? dateDebut;
  late DateTime? dateFin;

  @override
  void initState() {
    super.initState();
    setState(() {
      dateDebut = widget.dateDebut;
      dateFin = widget.dateFin;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    var formatter =
        DateFormat('d MMMM yyyy', Localizations.localeOf(context).toString());
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // Calendrier
          Expanded(
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: _calendar(),
            ),
          ),

          // Plage selectionné
          if (dateDebut != null || dateFin != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 0,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  style: const TextStyle(color: Themer.successColor),
                  SelectDateRangeWidget.plage(
                    traductions,
                    formatter,
                    dateDebut!,
                    dateFin,
                  ),
                ),
              ),
            ),

          // Valider Btn
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: ElevatedButton(
              onPressed: () => AppRouter.pop(context),
              child: Text(traductions.popupSelectDateBtnValider),
            ),
          ),
        ],
      ),
    );
  }

  /// Calendrier
  Widget _calendar() {
    return CalendarDatePicker2(
      config: CalendarDatePicker2Config(
        calendarType: CalendarDatePicker2Type.range,
        // date avant laquelle on peut plus choisir
        firstDate: widget.firstDate,
        controlsTextStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.w600),
        // Date du jour
        todayTextStyle: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontSize: 17, color: Theme.of(context).primaryColor),
        dayTextStyle:
            Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 17),
        // Jour selectionné
        selectedDayTextStyle: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontSize: 17, color: Themer.whiteColor),
        // Dates desactivés en gris
        disabledDayTextStyle: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontSize: 17, color: Themer.gray),
        weekdayLabelTextStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.w600),
        // Icones pour naviguer
        lastMonthIcon: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).primaryColor,
        ),
        nextMonthIcon: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).primaryColor,
        ),
      ),
      // Selected value
      value: [dateDebut, dateFin],
      onValueChanged: (List<DateTime?> dates) {
        if (dates.length == 2) {
          setState(() {
            dateDebut = dates[0];
            dateFin = dates[1];
            widget.onSelect([dateDebut!, dateFin!]);
          });
        } else if (dates.length == 1) {
          setState(() {
            dateDebut = dates[0];
            dateFin = null;
            widget.onSelect([dateDebut!]);
          });
        }
      },
    );
  }
}
