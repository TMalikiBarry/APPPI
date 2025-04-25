import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../domain/models/pin_command.dart';
import '../../bloc/identification/identification_bloc.dart';
import '../../bloc/identification/identification_event.dart';
import '../../bloc/identification/identification_state.dart';

class IdentificationPinCreatePage extends StatelessWidget {
  //
  const IdentificationPinCreatePage({super.key});
  static final logger = Logger();
  // Nombre de chiffres du code PIN
  final num pinLength = PinCommand.pinSize;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations localisation = AppLocalizations.of(context)!;

    // Form width
    double paddingX = 20;
    double formWidth = MediaQuery.of(context).size.width - (paddingX * 2);
    double fieldWidth = (formWidth / pinLength) - 8;

    // Number pad height
    double padPadding = 32;
    double padHeight = ((formWidth - padPadding * 2) / 3) * 4;

    // Commencer la construction de la page
    return BlocBuilder<IdentificationBloc, IdentificationState>(
      builder: (context, identificationState) {
        // recuperer la lgoique de gestion du formulaire
        IdentificationBloc identificationBloc =
            context.read<IdentificationBloc>();
        // Gestion du focus des champs
        FocusNode focusNode = FocusNode();
        return Scaffold(
          // Pour avoir le bouton de retour
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                logger.i('on close');
              },
              child: const Icon(Icons.close),
            ),
          ),
          // Contenu de la page de connexion
          body: MyPageContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Le formulaire
                //Expanded(
                //child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Titre de la page
                    Text(
                      localisation.createCodePinFormTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),

                    // Séparateur
                    const SizedBox(height: 5.0),

                    // Sous titre de la page
                    Text(
                      localisation.createCodePinFormSubTitle,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),

                    // Séparateur
                    const SizedBox(height: 32),

                    // Code Pin input
                    Form(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: drawPinInputFields(
                          context,
                          fieldWidth,
                          focusNode,
                          identificationState.pinCode,
                        ),
                      ),
                    ),
                  ],
                ),
                // Keyboard Virtual
                SizedBox(
                  height: padHeight,
                  child: GridView.count(
                    crossAxisCount: 3,
                    padding: EdgeInsets.all(padPadding),
                    children: drawNumberPad(
                        context,
                        PinCommand(identificationState.pinCode),
                        identificationBloc,
                        focusNode),
                  ),
                ),
                // Séparateur
                const SizedBox(height: 2.0),
              ],
            ),
          ),
        );
      },
    );
  }

  /// context,  fieldWidth, identificationState.pinCode,
  List<TextFormField> drawPinInputFields(
    BuildContext context,
    double fieldWidth,
    FocusNode focusNode,
    List<int> pin,
  ) {
    List<TextFormField> fields = [];

    for (var i = 0; i < pinLength; i++) {
      // Ajoute les champs du formulaire
      fields.add(TextFormField(
        // Default => show number pad
        keyboardType: TextInputType.none,
        // Accepts digits only
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        // Style du texte
        style: Theme.of(context).textTheme.headlineMedium,
        //
        textAlign: TextAlign.center,
        // Autofocus
        focusNode: i == pin.length ? focusNode : null,
        // Valeur du champ
        controller: TextEditingController(
            text: pin.length > i ? pin[i].toString() : ""),
        readOnly: true,
        // Taille du champ
        decoration: InputDecoration(
          labelText: "",
          constraints: BoxConstraints(
            minWidth: fieldWidth,
            maxWidth: fieldWidth,
            minHeight: 56,
            maxHeight: 56,
          ),
          labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
          hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
          enabledBorder: i <= pin.length
              ? Theme.of(context).inputDecorationTheme.focusedBorder
              : null,
        ),
      ));
    }
    return fields;
  }

  /// Affiche le clavier virtuel pour la saisie du code PIN
  List<TextButton> drawNumberPad(
    context,
    PinCommand pinCode,
    identificationBloc,
    FocusNode focusNode,
  ) {
    List<TextButton> btns = [];
    for (var i = 1; i < 10; i++) {
      btns.add(
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.titleMedium,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            if (pinCode.value.length < PinCommand.pinSize) {
              focusNode.requestFocus();
              identificationBloc.add(
                  PinNumberSelectedEvent(i, pinCode, pinCode.value.length));
            }
          },
          child: Text("$i"),
        ),
      );
    }
    btns.add(
      TextButton(
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.titleMedium,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: null,
        child: const Text(""),
      ),
    );
    btns.add(
      TextButton(
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.titleMedium,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () {
          if (pinCode.value.length < PinCommand.pinSize) {
            identificationBloc
                .add(PinNumberSelectedEvent(0, pinCode, pinCode.value.length));
          }
        },
        child: const Text("0"),
      ),
    );
    // Bouton effacer
    btns.add(
      TextButton.icon(
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.titleMedium,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () {
          if (pinCode.value.isNotEmpty) {
            identificationBloc
                .add(PinNumberSelectedEvent(-1, pinCode, pinCode.value.length));
          }
        },
        icon: Icon(
          Icons.backspace_outlined,
          color: Theme.of(context).colorScheme.onSurface,
          size: 20,
        ),
        label: const Text(""),
      ),
    );
    return btns;
  }
}
