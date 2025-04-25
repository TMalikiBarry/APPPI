import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class AliasMBNOCountdownTimer extends StatefulWidget {
  //
  const AliasMBNOCountdownTimer({super.key, required this.onResendOtp});

  final Function() onResendOtp;

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

    return TextButton(
      onPressed: minutes == 0 && seconds == 0
          ? () {
              startTimer();
              // renvoyer code OTP
              widget.onResendOtp();
            }
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(minutes == 0 && seconds == 0
              ? '${localisation.aliaMBNOResendMessageBtn} '
              : '${localisation.aliaMBNOResendMessage(timing)} '),
          if (minutes == 0 && seconds == 0)
            const Icon(Icons.refresh_outlined, size: 20),
        ],
      ),
    );
  }
}
