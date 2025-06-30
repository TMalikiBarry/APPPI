import 'package:flutter/material.dart';

import '../../../../../core/assets.dart';
import '../../../../l10n/app_localizations.dart';

class NotificationPageListeEmpty extends StatelessWidget {
  ///
  const NotificationPageListeEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Images illustration
        Center(
          child: Image.asset(
            Images.notificationCloche,
            width: 140,
            height: 140,
              package: 'common_dependencies'
          ),
        ),
        const SizedBox(height: 30.0),

        // Titre de la page
        Text(
          traductions.notificationPageListeEmptyTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),

        // Séparateur
        const SizedBox(height: 16.0),

        // Sous titre de la page
        SizedBox(
          width: (MediaQuery.of(context).size.width / 12) * 8,
          child: Text(
            traductions.notificationPageListeEmptySubTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
      ],
    ));
  }
}
