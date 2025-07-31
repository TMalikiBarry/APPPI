import 'package:common_dependencies/utils/numeric_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pi_mobile_app/core/theme.dart';
import 'package:pinput/pinput.dart';
import 'package:common_dependencies/utils/utils.dart';

class AliasPageOtp extends StatefulWidget {
  //
  final int pinLength;
  final String title;
  final String subtitle;
  final String? errorMessage;
  final Widget? countdownTimer;
  final Function(List<int> otpCode, String? channel) onOtpComplete;
  final bool autoFocus;
  final String? channel;

  const AliasPageOtp({
    super.key,
    required this.pinLength,
    required this.title,
    required this.subtitle,
    this.errorMessage,
    this.countdownTimer,
    required this.onOtpComplete,
    this.autoFocus = true,
    this.channel
  });

  @override
  State<AliasPageOtp> createState() => _AliasPageOtpState();
}

class _AliasPageOtpState extends State<AliasPageOtp> {
  late List<FocusNode> fieldFocusList;
  late List<TextEditingController> fieldControllerList;
  var codeOtpController = TextEditingController();
  double fieldWidth = 0;

  @override
  void initState() {
    super.initState();
    fieldFocusList = List.generate(widget.pinLength, (index) => FocusNode());
    fieldControllerList =
        List.generate(widget.pinLength, (index) => TextEditingController());

      logger.i("channel : _AliasPageOtpState ${widget.channel}");
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
        Align(
          alignment: Alignment.center,
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),


        //
        const SizedBox(height: 15),

        Stack(children: [
          Container(
            margin: EdgeInsets.fromLTRB(40.5, 30, 40.5, 10),
            padding: EdgeInsets.fromLTRB(21.5, 20 , 21.5 , 0 ),
            width: double.infinity,
            height: 100 ,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(100 ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0 , 30 , 0 , 22.54 ),
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 100 ,
              height: 100.50 ,
              child: Image.asset(
                package: 'common_dependencies',
                'assets/images/code_otp.png',
                width: 60 ,
                height: 120 ,
              ),
            ),
          ),
        ]),

        //
        const SizedBox(height: 10.0),

        // Sous titre de la page
        Align(
          alignment: Alignment.center,
          child: Text(
            widget.subtitle,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),

        //
        const SizedBox(height: 10.0),

        // Code Pin input
        SizedBox(
          width: 327,
          height: 100,
          child: Pinput(
            androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
            controller: codeOtpController,
            keyboardType: TextInputType.none,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: submittedPinTheme,
            length: 4,
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
            onCompleted: (pin) {
              if (pin.length == 4) {
                widget.onOtpComplete([int.parse(pin[0]),int.parse(pin[1]),int.parse(pin[2]),int.parse(pin[3])], widget.channel);
              }
            },
          ),
        ),

        // Séparateur
        const SizedBox(height: 20),

        // Compte à rebours
        if (widget.countdownTimer != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [widget.countdownTimer!],
          ),

        // Séparateur
        const SizedBox(height: 24),

        // Message d'erreur
        if (widget.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 2.0, bottom: 5.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '\u26a0 ${widget.errorMessage}',
                style: Theme.of(context).inputDecorationTheme.errorStyle,
              ),
            ),
          ),

        // Clavier numérique personnalisé
        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                ],
              ),
              Row(
                children: [
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                ],
              ),
              Row(
                children: [
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                ],
              ),
              Row(
                children: [
                  _buildButton(''),
                  _buildButton('0'),
                  _buildButton('⌫', onPressed: _backspace),
                ],
              ),
            ],
          ),
        )
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
      widget.onOtpComplete(pin, widget.channel);
    }
  }

  Widget _buildButton(String text, {VoidCallback? onPressed}) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed ?? () => _input(text),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 22,
            color: Themer.primaryColor,
          ),
        ),
      ),
    );
  }

  void _input(String text) {
    final value = codeOtpController.text + text;
    codeOtpController.text = value;
  }

  void _backspace() {
    final value = codeOtpController.text;
    if (value.isNotEmpty) {
      codeOtpController.text = value.substring(0, value.length - 1);
    }
  }
}
