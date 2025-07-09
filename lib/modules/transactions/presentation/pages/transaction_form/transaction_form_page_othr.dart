import 'package:common_dependencies/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

import '../../../../../shared/models/uemoa_countries.dart';
import '../../../domain/models/participant/participant.dart';
import '../../../domain/models/transaction_send/transaction_send_command.dart';
import '../../bloc/transaction_send/transaction_send_bloc.dart';
import '../../bloc/transaction_send/transaction_send_event.dart';
import '../../bloc/transaction_send/transaction_send_state.dart';
import 'transaction_form_input_amount.dart';
import 'transaction_form_input_motif.dart';
import 'transaction_form_input_othr.dart';

class TransactionFormPageOthr extends StatelessWidget {
  ///
  const TransactionFormPageOthr({super.key});

  @override
  Widget build(BuildContext context) {
    ///
    AppLocalizations traductions = AppLocalizations.of(context)!;
    final List<UEMOACountry> countries = [
      UEMOACountry(
        iso: "SN",
        name: "Senegal",
        phoneCode: "+221",
        flag: "🇸🇳",
      ),
    ];
    ;

    // BLOC
    TransactionSendBloc transactionSendBloc =
        context.read<TransactionSendBloc>();
    //
    return BlocBuilder<TransactionSendBloc, TransactionSendState>(
      bloc: transactionSendBloc,
      buildWhen: (previous, current) =>
          current is TransactionSendFormInputState,
      builder: (context, state) {
        if (state is TransactionSendFormInputState) {
          //
          TransactionSendCommand formValues = state.command;
          //
          List<Participant>? participants = state.participants;

          // Filtrer le pays au Sénégal si ce n'est pas déjà fait
          if (formValues.pspPays != 'SN') {

            formValues.pspPays = 'SN';
            // Optionnel: déclencher l'événement pour mettre à jour le state
            WidgetsBinding.instance.addPostFrameCallback((_) {
              transactionSendBloc.add(TransactionSendFormChangedEvent(formValues));
            });
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Titre de la page
              Text(
                traductions.transactionsSendFormOthrTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),

              //
              const SizedBox(height: 5.0),

              // Sous titre de la page
              Text(
                traductions.transactionsSendFormOthrSubtitle,
                style: Theme.of(context).textTheme.displaySmall,
              ),

              //
              const SizedBox(height: 32),

              // Formulaire: champs et boutons
              TransactionFormInputOthr(
                command: formValues,
                transactionFormBloc: transactionSendBloc,
                traductions: traductions,
              ),

              // Espacement de 16 pixels
              const SizedBox(height: 16),

              // Pays
              Container(
                width: MediaQuery.of(context).size.width - 48,
                decoration: ShapeDecoration(
                  color: Theme.of(context).cardTheme.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    minWidth: 100,
                    child: DropdownButtonFormField<String>(
                      // Valeur par défaut
                      value: formValues.pspPays,
                      // Taille du texte
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(decorationThickness: 0),
                      // Ne pas afficher l'icone de dropdown
                      // icon: const SizedBox.shrink(),
                      onChanged: (String? value) {
                        formValues.pspPays = value;
                        transactionSendBloc
                            .add(TransactionSendFormChangedEvent(formValues));
                      },
                      items: countries
                          .map<DropdownMenuItem<String>>((UEMOACountry value) {
                        return DropdownMenuItem<String>(
                          value: value.iso,
                          child: Text("${value.flag} ${value.name}"),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        labelText: traductions.transactionFormOthrPaysLabel,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Participant
              Container(
                width: MediaQuery.of(context).size.width - 48,
                decoration: ShapeDecoration(
                  color: Theme.of(context).cardTheme.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    minWidth: 100,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      // Valeur par défaut
                      value: formValues.pspCode,
                      // Taille du texte
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(decorationThickness: 0),
                      // Ne pas afficher l'icone de dropdown
                      // icon: const SizedBox.shrink(),
                      onChanged: (String? value) {
                        formValues.pspCode = value;
                        transactionSendBloc
                            .add(TransactionSendFormChangedEvent(formValues));
                      },
                      items: participants != null
                          ? participants.map<DropdownMenuItem<String>>(
                              (Participant value) {
                              return DropdownMenuItem<String>(
                                value: value.codeMembre,
                                child: Text(value.nomMembre),
                              );
                            }).toList()
                          : [],
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        labelText: traductions.transactionFormOthrNomLabel,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Montant
              TransactionFormInputAmount(
                command: formValues,
                transactionFormBloc: transactionSendBloc,
                traductions: traductions,
              ),

              // Espacement de 16 pixels
              const SizedBox(height: 16),

              // Note
              TransactionFormInputMotif(
                command: formValues,
                transactionFormBloc: transactionSendBloc,
                traductions: traductions,
              ),

              // Espacement de 32 pixels
              const SizedBox(height: 32),
            ],
          );
        } //
        else {
          return Container();
        }
      },
    );
  }
}
