import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/input_text.dart';
import '../../../domain/models/change_password_command.dart';
import '../../bloc/change_password/change_password_bloc.dart';
import '../../bloc/change_password/change_password_event.dart';
import '../../bloc/change_password/change_password_state.dart';

class ChangePasswordForm extends StatelessWidget {
  //
  final AppLocalizations localisation;
  //
  final String username;

  ///
  const ChangePasswordForm({
    super.key,
    required this.localisation,
    required this.username,
  });

  ///
  @override
  Widget build(BuildContext context) {
    //
    final formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => ChangePasswordBloc(username),
      child: Form(
        key: formKey,
        child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
          // Build form
          builder: (context, passwordState) {
            // recuperer la lgoique de gestion du formulaire
            ChangePasswordBloc passwordBloc =
                context.read<ChangePasswordBloc>();

            // Données du formulaire
            ChangePasswordCommand formDatas = passwordState.values;

            // Affichage du formulaire
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // champs du Formulaire
                // - champ mot de passe 1
                CustomTextInput(
                  labelText: localisation.changePasswordFormPasswordHint,
                  // Forme du champ
                  hintText: localisation.changePasswordFormPasswordHint,
                  // Type de champ password
                  obscureText: !(passwordState.passwordVisible),
                  enableSuggestions: false,
                  autocorrect: false,
                  // icon eye to show/hide password
                  suffix: InkWell(
                    onTap: () => passwordBloc.add(PasswordToggledEvent(
                      formDatas,
                      passwordState.passwordVisible,
                    )),
                    child: Icon(
                      Icons.visibility,
                      color: Theme.of(context)
                          .inputDecorationTheme
                          .suffixIconColor,
                    ),
                  ),
                  // Message d'erreur à afficher
                  messageError: formDatas.password != null &&
                          formDatas.password!.error != null
                      ? getPasswordErrorMessage(formDatas.password!.error!)
                      : "",
                  // Quand le texte change
                  onChange: (value) {
                    formDatas.password =
                        ChangePasswordCommandPassword(value: value);
                    passwordBloc.add(FormChangedEvent(
                      formDatas,
                      passwordState.passwordVisible,
                    ));
                  },
                ),
                // Séparateur
                const SizedBox(height: 20.0),
                // - Champ mot de passe confirmation
                CustomTextInput(
                  labelText: localisation.changePasswordFormConfirmHint,
                  // Type de champ password
                  obscureText: !(passwordState.passwordVisible),
                  enableSuggestions: false,
                  autocorrect: false,
                  // icon eye to show/hide password
                  suffix: InkWell(
                    onTap: () => passwordBloc.add(PasswordToggledEvent(
                        formDatas, passwordState.passwordVisible)),
                    child: Icon(
                      Icons.visibility,
                      color: Theme.of(context)
                          .inputDecorationTheme
                          .suffixIconColor,
                    ),
                  ),
                  // Texte d'ide
                  hintText: localisation.changePasswordFormConfirmHint,
                  // Message d'erreur
                  messageError: formDatas.passwordConfirmation != null &&
                          formDatas.passwordConfirmation!.error != null
                      ? getPasswordErrorMessage(
                          formDatas.passwordConfirmation!.error!)
                      : formDatas.error != null
                          ? getGlobalErrorMessage(formDatas.error!)
                          : "",
                  onChange: (value) {
                    formDatas.passwordConfirmation =
                        ChangePasswordCommandPassword(value: value);
                    passwordBloc.add(FormChangedEvent(
                      formDatas,
                      passwordState.passwordVisible,
                    ));
                  },
                ),
                // Séparateur
                const SizedBox(height: 24),

                // Bouton de connexion loading
                Container(
                    // Largeur du Container en fonction de l'état de chargement
                    width: passwordState is ChangePasswordLoadingState
                        ? 36.0
                        : null,
                    alignment:
                        Alignment.center, // Centrez le contenu horizontalement
                    child: passwordState is ChangePasswordLoadingState
                        ? circularContainer(false)
                        : buildButton(formDatas, passwordBloc))
              ],
            );
          },
          // Ecoute sur certains états pour naviguer vers les pages suivantes
          listenWhen: (context, state) {
            return state is ChangePasswordSuccessState;
          },
          listener: (context, state) {
            // Si succed,
            if (state is ChangePasswordSuccessState) {
              // Navigate to change password screen
              // Because I assume that it's the only challenge implemented
              context.push(AppRouter.identificationInitial);
            }
          },
        ),
      ),
    );
  }

  // If Button State is init : show Normal submit button
  Widget buildButton(formDatas, passwordBloc) {
    return ElevatedButton(
      onPressed: () {
        if (formDatas.isValid()) passwordBloc.add(SendPasswordEvent(formDatas));
      },
      child: Text(localisation.changePasswordFormBtnConnexion),
    );
  }

  // this is custom Widget to show rounded container
  // we are showing loading indicator on container
  // After completion,  show a Icon.
  Widget circularContainer(bool done) {
    return Container(
      decoration: const BoxDecoration(
          shape: BoxShape.circle, color: Colors.transparent),
      child: Center(
        child: done
            ? const Icon(Icons.done, size: 50, color: Colors.white)
            : const CircularProgressIndicator(color: Colors.amber),
      ),
    );
  }

  /// Retourne le bon  message d'erreur à afficher
  String? getPasswordErrorMessage(ChangePasswordCommandPasswordError error) {
    // Empty password
    if (error == ChangePasswordCommandPasswordError.empty) {
      return localisation.changePasswordErrorEmpty;
    }
    // Invalid password
    else if (error == ChangePasswordCommandPasswordError.invalid) {
      return localisation.changePasswordErrorInvalid;
    }
    // Not translated error
    else {
      return 'Error';
    }
  }

  /// Retourne le bon  message d'erreur à afficher
  String? getGlobalErrorMessage(ChangePasswordCommandError error) {
    // Different password
    if (error == ChangePasswordCommandError.passwordDifferent) {
      return localisation.changePasswordErrorDifferent;
    }
    // Not translated error
    else {
      return 'Error';
    }
  }
}
