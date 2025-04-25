import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../bloc/login/login_bloc.dart';
import '../../bloc/login/login_event.dart';
import 'login_form.dart';

/// Login Page View: The design of the login page
class LoginPageDemo extends StatelessWidget {
  //
  const LoginPageDemo({super.key});

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations localisation = AppLocalizations.of(context)!;

    // Récupération du bloc de sécurité
    context.read<LoginBloc>().add(const CheckSessionEvent());

    // Link style
    var linkStyle = Theme.of(context).textButtonTheme.style!.copyWith(
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        );

    // Commencer la construction de la page
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                        localisation.loginPageTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      //
                      const SizedBox(height: 5.0),
                      // Sous titre de la page
                      Text(
                        localisation.loginPageSubTitle,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      //
                      const SizedBox(height: 32),
                      // Formulaire: champs et boutons
                      LoginForm(localisation: localisation),
                    ],
                  ),
                ),
              ),

              // Les Conditions d'utilisation
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 20.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      localisation.loginPageFooterIntro,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    TextButton(
                      onPressed: () {
                        // display CGU
                        context.push(AppRouter.loginCgu);
                      },
                      style: linkStyle,
                      child: Text(" ${localisation.loginPageFooterCGU} "),
                    ),
                    //
                    Text(
                      " ${localisation.coordinationEt} ",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    TextButton(
                      onPressed: () {
                        // Display politique confidentialité
                        context.push(AppRouter.loginPoc);
                      },
                      style: linkStyle,
                      child: Text(" ${localisation.loginPageFooterPC} "),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
