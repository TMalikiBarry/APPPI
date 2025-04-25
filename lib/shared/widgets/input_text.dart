import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Définition du champ de formulaire personnalisé
/// pour respecter le design de champ input tel que
/// donné par les designers
class CustomTextInput extends StatefulWidget {
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
  final List<TextInputFormatter>? inputFormatters;
  //
  final TextInputType? keyboardType;
  //
  final TextEditingController? controller;
  final FocusNode? focus;
  final bool? readOnly;
  //
  final Function()? onEditingComplete;
  //
  final TextInputAction? textInputAction;

  ///
  const CustomTextInput({
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
    this.inputFormatters,
    this.keyboardType,
    this.controller,
    this.focus,
    this.readOnly,
    this.onEditingComplete,
    this.textInputAction,
  });

  @override
  CustomTextInputState createState() => CustomTextInputState();
}

class CustomTextInputState extends State<CustomTextInput> {
  //
  late FocusNode _focusNode;

  Color? _borderColor;

  @override
  void initState() {
    _focusNode = widget.focus??FocusNode();
    /// On écoute sur le focus et met à jour la couleur de bordeur du container
    _focusNode.addListener(() {
      setState(() {
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
        Container(
          // padding: const EdgeInsets.only(
          //   bottom: 1.0,
          // ),
          constraints: const BoxConstraints(maxHeight: 56),
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
          child: TextField(
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            enableSuggestions: widget.enableSuggestions,
            autocorrect: widget.autocorrect,
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.keyboardType,
            controller: widget.controller,
            readOnly: widget.readOnly ?? false,
            onEditingComplete: widget.onEditingComplete,
            textInputAction: widget.textInputAction,
            // Style du texte
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(decorationThickness: 0),
            // Forme du champ
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              prefix: widget.preffix,
              suffix: widget.suffix,
              fillColor: Colors.transparent,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              suffixIcon: widget.suffixIcon,
              suffixIconColor:
                  Theme.of(context).inputDecorationTheme.suffixIconColor,
            ),
            // The validator receives the text that the user has entered.
            onChanged: widget.onChange,
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
}
