import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/input_text.dart';
import '../../../domain/models/login_command.dart';
import '../../bloc/login/login_bloc.dart';
import '../../bloc/login/login_event.dart';
import '../../bloc/login/login_state.dart';

class LoginForm extends StatelessWidget {
  //
  final AppLocalizations localisation;

  ///
  const LoginForm({super.key, required this.localisation});

  ///
  @override
  Widget build(BuildContext context) {
    //
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: BlocConsumer<LoginBloc, LoginState>(
        // Build form
        builder: (context, loginState) {
          // recuperer la lgoique de gestion du formulaire
          LoginBloc loginBloc = context.read<LoginBloc>();
          // Modele du formulaire
          LoginCommand connexionData = loginState.values;
          // Affichage du formulaire
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // champs du Formulaire
              // - champ identifiant
              CustomTextInput(
                labelText: localisation.loginFormUsernameLabel,
                // Forme du champ
                hintText: localisation.loginFormUsernameHint,
                // Message d'erreur à afficher
                messageError: connexionData.username != null &&
                        connexionData.username!.error != null
                    ? getUsernameErrorMessage(connexionData.username!.error!)
                    : "",
                // Quand le texte change
                onChange: (value) {
                  connexionData.username = LoginCommandUsername(value: value);
                  loginBloc.add(FormChangedEvent(
                    connexionData,
                    loginState.passwordVisible,
                  ));
                },
              ),

              // Séparateur
              const SizedBox(height: 20.0),

              // - Champ mot de passe
              CustomTextInput(
                labelText: localisation.loginFormPasswordLabel,
                // Forme du champ
                hintText: localisation.loginFormPasswordHint,
                // Type de champ password
                obscureText: !(loginState.passwordVisible),
                enableSuggestions: false,
                autocorrect: false,
                // Icon eye to show/hide password
                // suffixIcon: const Icon(Icons.visibility),
                suffix: InkWell(
                  onTap: () => loginBloc.add(PasswordToggledEvent(
                    connexionData,
                    loginState.passwordVisible,
                  )),
                  child: Icon(
                    Icons.visibility,
                    color:
                        Theme.of(context).inputDecorationTheme.suffixIconColor,
                  ),
                ),
                // Message d'erreur
                messageError: connexionData.password != null &&
                        connexionData.password!.error != null
                    ? getPasswordErrorMessage(connexionData.password!.error!)
                    : "",
                onChange: (value) {
                  connexionData.password = LoginCommandPassword(value: value);
                  loginBloc.add(FormChangedEvent(
                    connexionData,
                    loginState.passwordVisible,
                  ));
                },
              ),

              // Séparateur
              const SizedBox(height: 24),

              // Bouton de connexion loading
              Container(
                width: loginState is LoginLoadingState ? 36.0 : null,
                alignment:
                    Alignment.center, // Centrez le contenu horizontalement
                child: loginState is LoginLoadingState
                    ? circularContainer(false)
                    : buildButton(connexionData, loginBloc),
              )
            ],
          );
        },
        listener: (context, state) {
          // Si challenge,
          if (state is LoginChallengedState) {
            // Navigate to change password screen
            // Because I assume that it's the only challenge
            // But the navigation must depend on the challenge
            AppRouter.pushReplacement(
              context,
              '${AppRouter.loginChangePassword}/${state.values.username!.value!}',
            );
          }
          // Si succed,
          if (state is LoginSuccessState) {
            // Navigate to change password screen
            // Because I assume that it's the only challenge implemented
            AppRouter.pushReplacement(
              context,
              AppRouter.identificationInitial,
            );
          }
        },
      ),
    );
  }

  /// If Button State is init : show Normal submit button
  Widget buildButton(connexionData, loginBloc) {
    return ElevatedButton(
      onPressed: () {
        if (connexionData.isValid()) {
          loginBloc.add(ConnexionEvent(connexionData));
        }
      },
      child: Text(localisation.loginFormBtnConnexion),
    );
  }

  /// Show loader or button
  Widget circularContainer(bool done) {
    return Container(
      decoration: const BoxDecoration(
          shape: BoxShape.circle, color: Colors.transparent),
      child: Center(
        child: done
            ? const Icon(Icons.done, size: 50, color: Colors.white)
            : const CircularProgressIndicator(
                color: Colors.amber,
              ),
      ),
    );
  }

  /// Retourne le message d'erreur sur le champ nom d'utilisateur
  String getUsernameErrorMessage(LoginCommandUsernameError error) {
    // Empty username
    if (error == LoginCommandUsernameError.empty) {
      return localisation.loginUsernameErrorEmpty;
    }
    // Invalid username
    else if (error == LoginCommandUsernameError.invalid) {
      return localisation.loginUsernameErrorInvalid;
    }
    // Not translated error
    else {
      return '';
    }
  }

  /// Retourne le message d'erreur sur le champ mot de passe
  String? getPasswordErrorMessage(LoginCommandPasswordError error) {
    // Empty password
    if (error == LoginCommandPasswordError.empty) {
      return localisation.loginPasswordErrorEmpty;
    }
    // Invalid password
    else if (error == LoginCommandPasswordError.invalid) {
      return localisation.loginPasswordErrorInvalid;
    }
    // Not translated error
    else {
      return 'Error';
    }
  }
}
