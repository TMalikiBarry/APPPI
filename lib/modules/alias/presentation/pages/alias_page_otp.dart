import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AliasPageOtp extends StatefulWidget {
  //
  final int pinLength;
  final String title;
  final String subtitle;
  final String? errorMessage;
  final Widget? countdownTimer;
  final Function(List<int> otpCode) onOtpComplete;
  final bool autoFocus;

  const AliasPageOtp({
    super.key,
    required this.pinLength,
    required this.title,
    required this.subtitle,
    this.errorMessage,
    this.countdownTimer,
    required this.onOtpComplete,
    this.autoFocus = true,
  });

  @override
  State<AliasPageOtp> createState() => _AliasPageOtpState();
}

class _AliasPageOtpState extends State<AliasPageOtp> {
  late List<FocusNode> fieldFocusList;
  late List<TextEditingController> fieldControllerList;
  double fieldWidth = 0;

  @override
  void initState() {
    super.initState();
    fieldFocusList = List.generate(widget.pinLength, (index) => FocusNode());
    fieldControllerList =
        List.generate(widget.pinLength, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var node in fieldFocusList) {
      node.dispose();
    }
    for (var controller in fieldControllerList) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calcul de la largeur des champs
    double paddingX = 20;
    double formWidth = MediaQuery.of(context).size.width - (paddingX * 2);
    fieldWidth = (formWidth / widget.pinLength) - 8;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Titre de la page
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        //
        const SizedBox(height: 5.0),

        // Sous titre de la page
        Text(
          widget.subtitle,
          style: Theme.of(context).textTheme.displaySmall,
        ),

        //
        const SizedBox(height: 32),

        // Code Pin input
        Form(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: List.generate(widget.pinLength, (index) {
              return TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
                autofocus: widget.autoFocus && index == 0,
                focusNode: fieldFocusList[index],
                controller: fieldControllerList[index],
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
                ),
                onChanged: (text) {
                  handleOtpInputChange(text, index);
                },
              );
            }),
          ),
        ),
        // Séparateur
        const SizedBox(height: 24),

        // Message d'erreur
        if (widget.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 2.0, bottom: 5.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '\u26a0 ${widget.errorMessage}',
                style: Theme.of(context).inputDecorationTheme.errorStyle,
              ),
            ),
          ),

        // Compte à rebours
        if (widget.countdownTimer != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [widget.countdownTimer!],
          ),
      ],
    );
  }

  void handleOtpInputChange(String text, int index) {
    if (text.isNotEmpty) {
      if (index < widget.pinLength - 1) {
        fieldFocusList[index].unfocus();
        FocusScope.of(context).requestFocus(fieldFocusList[index + 1]);
        fieldControllerList[index + 1].text = " ";
      }
    } else if (index > 0 && text.isEmpty) {
      fieldFocusList[index].unfocus();
      FocusScope.of(context).requestFocus(fieldFocusList[index - 1]);
      fieldControllerList[index - 1].text = " ";
    }

    verifyOtpCompletion();
  }

  void verifyOtpCompletion() {
    List<int> pin = [];
    for (var i = 0; i < widget.pinLength; i++) {
      if (fieldControllerList[i].text.trim().isNotEmpty) {
        pin.add(int.parse(fieldControllerList[i].text));
      }
    }

    if (pin.length == widget.pinLength) {
      widget.onOtpComplete(pin);
    }
  }
}
