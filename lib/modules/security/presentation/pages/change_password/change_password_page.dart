import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import 'change_password_form.dart';

class ChangePasswordPage extends StatelessWidget {
  //
  const ChangePasswordPage({super.key, required this.username});
  //
  final String username;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations localisation = AppLocalizations.of(context)!;

    // Commencer la construction de la page
    return Scaffold(
      // Pour avoir le bouton de retour
      appBar: AppBar(),
      // Contenu de la page de connexion
      body: MyPageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Le formulaire
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Titre de la page
                    Text(
                      localisation.changePasswordPageTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    //
                    const SizedBox(height: 5.0),
                    // Sous titre de la page
                    Text(
                      localisation.changePasswordPageSubTitle,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    //
                    const SizedBox(height: 32),
                    // Formulaire: champs et boutons
                    ChangePasswordForm(
                        localisation: localisation, username: username),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
