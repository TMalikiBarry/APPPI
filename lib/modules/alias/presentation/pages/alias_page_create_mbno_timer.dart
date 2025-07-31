import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pi_mobile_app/core/theme.dart';

import '../../../../l10n/app_localizations.dart';

class AliasMBNOCountdownTimer extends StatefulWidget {
  //
  const AliasMBNOCountdownTimer({super.key, required this.onResendOtp});

  final void Function(String? channel) onResendOtp;

  @override
  AliasMBNOCountdownTimerState createState() => AliasMBNOCountdownTimerState();
}

class AliasMBNOCountdownTimerState extends State<AliasMBNOCountdownTimer> {
  late int minutes;
  late int seconds;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    minutes = 1;
    seconds = 0;
    const oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (timer) {
      if (minutes == 0 && seconds == 0) {
        // Timer is complete
        timer.cancel();
        // Handle timer completion here
      } else if (seconds == 0) {
        minutes--;
        seconds = 59;
      } else {
        seconds--;
      }
      setState(() {}); // Update the UI with the new time
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localisation = AppLocalizations.of(context)!;

    // Temps restant
    String timing = '${minutes.toString().padLeft(2, '0')}'
        ':${seconds.toString().padLeft(2, '0')}';

    return (minutes == 0 && seconds == 0) ?
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 5),
          PopupMenuButton<String>(
            //tooltip: AppLocalizations.of(context).resend,
            tooltip: localisation.aliaMBNOResendMessageBtn,
            onSelected: (value) async {
              // renvoyer code OTP
              widget.onResendOtp(value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'WHATSAPP',
                child: Row(
                  children: [
                    Image.asset(
                      package: 'common_dependencies',
                      'assets/images/whatsapp_icon.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('WhatsApp'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'SMS',
                child: Row(
                  children: [
                    Image.asset(
                      package: 'common_dependencies',
                      'assets/images/sms.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('SMS'),
                  ],
                ),
              ),
            ],
            child: Row(
              children: [
                Text(
                  localisation.aliaMBNOResendMessageBtn,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                    color: Themer.primary
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ],
      )
      : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer_sharp),
            const SizedBox(width: 5),
            Text(
              "$timing sec",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.30,
              ),
            ),
          ],
        );
  }
}
