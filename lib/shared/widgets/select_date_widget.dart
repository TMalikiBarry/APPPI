import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

import '../../core/router.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';

class SelectDateWidget extends StatefulWidget {
  final DateTime? selected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String title;
  final String? subTitle;
  final ValueChanged<DateTime?> onSelect;
  const SelectDateWidget({
    super.key,
    this.selected,
    this.firstDate,
    this.lastDate,
    required this.title,
    this.subTitle,
    required this.onSelect,
  });

  @override
  State<SelectDateWidget> createState() => _SelectDateWidgetState();

  static Future<DateTime?> show({
    required BuildContext context,
    DateTime? selected,
    DateTime? firstDate,
    DateTime? lastDate,
    required String title,
    String? subTitle,
  }) async {
    DateTime? dateTime;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      builder: (BuildContext context) {
        return SelectDateWidget(
          title: title,
          subTitle: subTitle,
          firstDate: firstDate,
          lastDate: lastDate,
          selected: selected,
          onSelect: (DateTime? value) {
            dateTime = value;
          },
        );
      },
    );
    return dateTime;
  }
}

class _SelectDateWidgetState extends State<SelectDateWidget> {
  void _onSelect(DateTime locale) {
    widget.onSelect(locale);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localisation = AppLocalizations.of(context)!;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30.0,
          ),

          /// Title and button action
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 12,
                ),
                if (widget.subTitle != null) ...[
                  Text(
                    widget.subTitle!,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      // date avant laquelle on peut plus choisir
                      firstDate: widget.firstDate,
                      lastDate: widget.lastDate,
                      // date selectionné par defaut
                      currentDate:
                          widget.selected ?? widget.firstDate ?? DateTime.now(),
                      calendarType: CalendarDatePicker2Type.single,
                      controlsTextStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      todayTextStyle: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                              fontSize: 17,
                              color: Theme.of(context).primaryColor),
                      dayTextStyle: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 17),
                      selectedDayTextStyle: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 17, color: Themer.whiteColor),
                      disabledDayTextStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 17, color: Themer.gray),
                      weekdayLabelTextStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      lastMonthIcon: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).primaryColor,
                      ),
                      nextMonthIcon: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    value: const [],
                    onValueChanged: (List<DateTime?> dates) {
                      if (dates.length == 1) {
                        DateTime? date = dates[0];
                        if (date != null) {
                          _onSelect(date);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: ElevatedButton(
              onPressed: () => AppRouter.pop(context),
              child: Text(localisation.popupSelectDateBtnValider),
            ),
          ),
        ],
      ),
    );
  }
}
