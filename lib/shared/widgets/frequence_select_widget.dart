import 'package:flutter/material.dart';

import '../../../../../core/theme.dart';
import '../../core/router.dart';
import '../../l10n/app_localizations.dart';
import '../models/frequence_command.dart';
import 'number_inc_widget.dart';

class FrequenceSelectWidget extends StatefulWidget {
  ///
  const FrequenceSelectWidget({
    super.key,
    required this.title,
    required this.command,
    required this.frequences,
    required this.onChange,
  });

  final String title;
  final FrequenceCommand command;
  final List<Frequence> frequences;
  final ValueChanged<FrequenceCommand> onChange;

  @override
  State<FrequenceSelectWidget> createState() => _FrequenceSelectWidgetState();

  static String frequenceText(Frequence freq, AppLocalizations traductions) {
    if (freq == Frequence.quotidienne) {
      return traductions.transactionFormScheduleFrequenceQuotidienne;
    } else if (freq == Frequence.hebdomadaire) {
      return traductions.transactionFormScheduleFrequenceHebdomadaire;
    } else if (freq == Frequence.mensuelle) {
      return traductions.transactionFormScheduleFrequenceMensuelle;
    } else {
      return traductions.transactionFormScheduleFrequenceAnnuelle;
    }
  }

  static String periodiciteText(
    BuildContext context,
    AppLocalizations traductions,
    Frequence freq,
  ) {
    if (freq == Frequence.quotidienne) {
      return traductions.transactionDetailsFrequenceJour;
    } else if (freq == Frequence.hebdomadaire) {
      return traductions.transactionDetailsFrequenceSemaine;
    } else if (freq == Frequence.mensuelle) {
      return traductions.transactionDetailsFrequenceMois;
    } else {
      return "";
    }
  }
}

class _FrequenceSelectWidgetState extends State<FrequenceSelectWidget> {
  late FrequenceCommand selected;

  @override
  void initState() {
    super.initState();
    setState(() {
      selected = widget.command;
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Fréquence
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                //
                const SizedBox(height: 20),

                // Supprimer sur mesure
                if (widget.command.periodicite != null) ...[
                  _frequencesCustomCard(
                    context,
                    traductions,
                    [
                      Frequence.quotidienne,
                      Frequence.hebdomadaire,
                      Frequence.mensuelle
                    ],
                    Icon(Icons.close, color: Themer.systemErrorColor, size: 18),
                    () {
                      // définit la fréquence à null (une seule fois)
                      selected.value = null;
                      // définit la périodicité à null
                      selected.periodicite = null;
                      selected.done = false;
                      widget.onChange(selected);
                      AppRouter.pop(context);
                    },
                  ),
                ],

                //  Une fois, jour, semaine, mois année
                _frequencesOptionsCard(
                  context,
                  traductions,
                  widget.frequences,
                  selected.periodicite == null,
                  selected.periodicite == null
                      ? (freq) {
                          setState(() {
                            selected.value = freq;
                            widget.onChange(selected);
                            AppRouter.pop(context);
                          });
                        }
                      : (freq) {
                          setState(() {
                            selected.value = freq;
                          });
                        },
                ),
                const SizedBox(height: 20),

                // Option Sur mesure
                if (selected.periodicite == null) ...[
                  _frequencesCustomCard(
                    context,
                    traductions,
                    [
                      Frequence.quotidienne,
                      Frequence.hebdomadaire,
                      Frequence.mensuelle
                    ],
                    Icon(Icons.arrow_forward_ios, size: 18),
                    () {
                      // définit la fréquence à quotidienne
                      selected.value = Frequence.quotidienne;
                      // définit la périodicité à 2 (c'est le minimum)
                      selected.periodicite = 2;
                      widget.onChange(selected);
                      AppRouter.pop(context);
                    },
                  ),
                ],

                // Périodicité
                if (selected.periodicite != null) ...[
                  // Increment decrement button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                          traductions.transactionFormSchedulePeriodiciteLabel,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      // Decrement Increment button
                      NumberIncWidget(
                        number: selected.periodicite!,
                        onChange: (value) {
                          setState(() {
                            selected.periodicite = value;
                          });
                        },
                      ),
                    ],
                  ),

                  // Computed Frequence
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      traductions.transactionFormScheduleFrequenceSelected(
                        selected.periodicite.toString(),
                        FrequenceSelectWidget.periodiciteText(
                          context,
                          traductions,
                          selected.value!,
                        ),
                      ),
                      style: const TextStyle(color: Themer.successColor),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bouton valider
                  ElevatedButton(
                    onPressed: () {
                      selected.done = true;
                      widget.onChange(selected);
                      AppRouter.pop(context);
                    },
                    child: Text(traductions.popupSelectDateBtnValider),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Card liste des options de programmation: fréquences possibles
  Widget _frequencesOptionsCard(
    BuildContext context,
    AppLocalizations traductions,
    List<Frequence> frequences,
    bool uneSeuleFois,
    Function(Frequence freq) onTap,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Une seule fois
            if (uneSeuleFois)
              ListTile(
                title:
                    Text(traductions.transactionFormScheduleFrequenceUnefois),
                contentPadding: const EdgeInsets.all(0),
                minVerticalPadding: 0,
                onTap: () {
                  setState(() {
                    selected.value = null;
                    widget.onChange(selected);
                    AppRouter.pop(context);
                  });
                },
                trailing: selected.value == null
                    ? const Icon(Icons.check, size: 18)
                    : null,
              ),

            // Frequences
            ...frequences.map(
              (freq) {
                return ListTile(
                  title: Text(
                    FrequenceSelectWidget.frequenceText(freq, traductions),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  minVerticalPadding: 0,
                  onTap: () => onTap(freq),
                  trailing: freq == selected.value
                      ? const Icon(Icons.check, size: 18)
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Option de fréquence sur mesure
  Widget _frequencesCustomCard(
    BuildContext context,
    AppLocalizations traductions,
    List<Frequence> frequences,
    Icon icon,
    Function onTap,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sur mesure
            ListTile(
              title: Text(
                traductions.transactionFormScheduleFrequenceSurMesure,
              ),
              contentPadding: const EdgeInsets.all(0),
              minVerticalPadding: 0,
              onTap: () => onTap(),
              trailing: icon,
            ),
          ],
        ),
      ),
    );
  }
}
