import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../core/theme.dart';
import 'amount_widget.dart';

/// Définition du champ de formulaire personnalisé
/// pour saisir les montants à envoyer ou recevoir
class InputAmount extends StatefulWidget {
  //
  final String? labelText;
  final String? hintText;
  final Widget? preffix;
  final Widget? suffix;
  final ValueChanged<String>? onChange;
  final String? messageError;
  // N'affiche pas la valeur du champ
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  // Icon input suffix
  final Widget? suffixIcon;
  //
  final TextEditingController? controller;
  final bool? readOnly;

  final double solde;

  ///
  const InputAmount({
    super.key,
    this.labelText,
    this.hintText,
    this.onChange,
    this.preffix,
    this.suffix,
    this.suffixIcon,
    this.messageError,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.controller,
    this.readOnly,
    required this.solde,
  });

  @override
  InputAmountState createState() => InputAmountState();
}

class InputAmountState extends State<InputAmount> {
  //
  final FocusNode _focusNode = FocusNode();

  Color? _borderColor;
  var formatter = NumberFormat('#,##0', 'en_US');

  @override
  void initState() {
    /// On écoute sur le focus et met à jour la couleur de bordeur du container
    _focusNode.addListener(() {
      setState(() {
        /// Si on est rentré dans le champ de saisi
        /// on met la bordure en [primaryColor]
        /// Sinon met la bordure en inputDecorationTheme.fillColor
        _borderColor = _focusNode.hasFocus
            ? Theme.of(context).primaryColor
            : Theme.of(context).inputDecorationTheme.fillColor!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Définition d'un conteneur qui va contenir le champ et le label
        GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_focusNode),
          child: Container(
            // constraints: const BoxConstraints(
            //   minWidth: 80,
            //   maxHeight: 72,
            // ),
            padding: const EdgeInsets.only(bottom: 16),
            // La couleur de bordure dépend de l'état du champ
            decoration: BoxDecoration(
              color: Theme.of(context).inputDecorationTheme.fillColor,
              border: Border.all(
                /// s'il y à une erreur,
                /// On met la couleur du bordure a rouge
                /// Sinon on applique la couleur normale
                color: (widget.messageError != null &&
                        widget.messageError!.isNotEmpty)
                    ? Theme.of(context).inputDecorationTheme.errorStyle!.color!
                    : (_borderColor ??
                        Theme.of(context).inputDecorationTheme.fillColor!),
              ),
              borderRadius: BorderRadius.circular(14.0),
            ),
            // Champ input du formulaire
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                  child: TextField(
                    focusNode: _focusNode,
                    obscureText: widget.obscureText,
                    enableSuggestions: widget.enableSuggestions,
                    autocorrect: widget.autocorrect,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: false,
                    ),
                    controller: widget.controller,
                    readOnly: widget.readOnly ?? false,
                    // Style du texte
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(decorationThickness: 0),
                    // Forme du champ
                    decoration: InputDecoration(
                      labelText:
                          widget.readOnly != null && widget.readOnly! == true
                              ? widget.labelText
                              : null,
                      hintText: widget.hintText,
                      prefix: widget.preffix,
                      suffix: widget.suffix,
                      fillColor: Colors.transparent,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      suffixIcon: widget.suffixIcon,
                      suffixIconColor: Theme.of(context)
                          .inputDecorationTheme
                          .suffixIconColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0.0,
                      ),
                    ),
                    // The validator receives the text that the user has entered
                    onChanged: widget.onChange,
                  ),
                ),
                // Solde
                if (widget.readOnly == null || widget.readOnly == false)
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 26),
                    child: AmountWidget(
                      montant: widget.solde,
                      prefixText: "solde ",
                      // surfixText: 'francs CFA',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge! //
                          .copyWith(color: Themer.neural04Color),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Messages d'erreurs existants à afficher
        if (widget.messageError != null && widget.messageError!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              top: 2.0,
              bottom: 5.0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '\u26a0 ${widget.messageError ?? ''}',
                style: Theme.of(context).inputDecorationTheme.errorStyle,
              ),
            ),
          ),
        ]
      ],
    );
  }

  String formatWithSpaces(double? number) {
    String formattedNumber = "";
    if(number != null) {
      formattedNumber = formatter.format(number);
    }

    return formattedNumber.replaceAll(',', ' ');
  }
}
