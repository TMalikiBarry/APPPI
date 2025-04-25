import 'package:flutter/material.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

import '../../core/assets.dart';

/// Page affichage erreur de l'app
class ErrorPage extends StatelessWidget {
  //
  final Color? bgColor;
  final ErrorType type;
  final Function()? retry;
  const ErrorPage({
    super.key,
    this.bgColor,
    required this.type,
    this.retry,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: bgColor ?? Colors.transparent,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Images.gifError,
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 15),
            Text(
              type == ErrorType.internetError
                  ? traductions.internetErrorTitle
                  : traductions.serverErrorTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 15),
            Text(
              type == ErrorType.internetError
                  ? traductions.internetErrorSubtitle
                  : traductions.serverErrorSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (retry != null) ...[
              const SizedBox(height: 25),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: retry,
                  child: Text(traductions.reessayer),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

enum ErrorType {
  internetError,
  serverError;
}
