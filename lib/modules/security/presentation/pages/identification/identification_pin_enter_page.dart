import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../../core/assets.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../domain/models/biometric_method.dart';
import '../../../domain/models/connected_user.dart';
import '../../../domain/models/identification_response.dart';
import '../../../domain/models/pin_command.dart';
import '../../bloc/identification/identification_bloc.dart';
import '../../bloc/identification/identification_event.dart';
import '../../bloc/identification/identification_state.dart';
import '../../bloc/login/login_bloc.dart';

class IdentificationPinEnterPage extends StatelessWidget {
  //
  const IdentificationPinEnterPage({super.key});

  static final logger = Logger();

  // Nombre de chiffres du code PIN
  final int pinLength = PinCommand.pinSize;
  //
  static const IconData circle = IconData(0xe163, fontFamily: 'MaterialIcons');

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;
    double formWidth = MediaQuery.of(context).size.width - (20 * 2);
    double padPadding = 32;
    double padHeight = ((formWidth - padPadding * 2) / 3) * 4;

    return Builder(
      builder: (context) {
        // Security state to obtain the user details
        final loginBloc = context.read<LoginBloc>();

        return BlocBuilder<IdentificationBloc, IdentificationState>(
          builder: (context, identificationState) {
            // read bloc
            final identificationBloc = context.read<IdentificationBloc>();

            return Scaffold(
              // Contenu de la page de connexion
              body: MyPageContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Connected user
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // "assets/images/avatar.png"
                        _buildUserDetailsWidget(context, 64,
                            loginBloc.getConnectedUser()!, traductions),
                      ],
                    ),

                    // Enter your pin indication
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (identificationState.pinCode.isEmpty)
                          Text(
                            traductions.identificationFormLoginMessage,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),

                        // Pin input indicator
                        if (identificationState.pinCode.isNotEmpty)
                          _buildPinEnterIndicator(
                              context, identificationState.pinCode),

                        // Message d'erreur
                        if (identificationState is IdentificationErrorState)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(
                              _getErrorMessage(
                                  identificationState.error, traductions),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error),
                            ),
                          )
                      ],
                    ),

                    // Virtual keyboard
                    SizedBox(
                      height: padHeight,
                      child: GridView.count(
                        crossAxisCount: 3,
                        padding: EdgeInsets.all(padPadding),
                        children: drawNumberPad(
                          context,
                          identificationState,
                          identificationBloc,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: SizedBox(
                height: 60,
                child: TextButton(
                  onPressed: () {
                    logger.i('mot de passe oublié');
                  },
                  child: Text(traductions.identificationFormForgotMessage),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Construit la partie d'affichage de l'avatar et du nom de l'utilisateur
  /// "assets/images/avatar.png", "khady DIOP",
  Widget _buildUserDetailsWidget(
    BuildContext context,
    double avatarDimension,
    ConnectedUser user,
    traductions,
  ) {
    // Si l'image de l'avatar n'est pas fourni, utiliser les initiales du nom
    ShapeDecoration boxDecoration;
    RoundedRectangleBorder border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(avatarDimension / 3),
    );
    Widget? child;
    if (user.avatar != null && user.avatar!.isNotEmpty) {
      boxDecoration = ShapeDecoration(
        color: Colors.transparent,
        shape: border,
        image: DecorationImage(
            image: NetworkImage(user.avatar!), fit: BoxFit.fill),
      );
      // Affiche que l'image
      child = null;
    } else {
      boxDecoration = ShapeDecoration(
        color: Theme.of(context).colorScheme.secondary,
        shape: border,
      );
      // Affiche les initiales
      child = Center(child: Text(user.initiales()));
    }
    // Retourne l'avatar et le nom
    return Column(
      children: [
        // Avatar
        Container(
          width: avatarDimension,
          height: avatarDimension,
          decoration: boxDecoration,
          child: child,
        ),
        // Séparateur
        const SizedBox(height: 10.0),
        // Texte de bonjour
        Center(
          child: Text(
            traductions.identificationHelloUser(user.nomComplet()),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ],
    );
  }

  /// Affiche le clavier virtuel pour la saisie du code PIN
  /// La position des chiffres est aléatoire
  List<TextButton> drawNumberPad(
    BuildContext context,
    IdentificationState identificationState,
    IdentificationBloc identificationBloc,
  ) {
    PinCommand pinCode = PinCommand(identificationState.pinCode);
    List<BiometricMethod> methods = identificationState.methods;
    List<TextButton> btns = [];
    for (var i = 1; i < 10; i++) {
      btns.add(
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.titleMedium,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            if (pinCode.value.length < PinCommand.pinSize) {
              identificationBloc.add(CheckCodePinEvent(
                i,
                pinCode,
                pinCode.value.length,
                methods,
              ));
            }
          },
          child: Text("$i"),
        ),
      );
    }
    // Bouton pour s'authentifier avec la biométrie si c'est activée
    if (methods.isNotEmpty) {
      // Determiner la méthode préférée configurée
      BiometricMethod highlightedMethod = methods.length > 1
          ? //
          Platform.isIOS
              ? BiometricMethod.face
              : BiometricMethod.fingerprint
          : methods[0];
      // Si plus d'une méthode possible est choisie,
      // alors si IOS affiche face sinon fingerprint
      var biometryIcon = highlightedMethod == BiometricMethod.face //
          ? ImageIcon(
              AssetImage(Images.virtualKeyboardIconsFace),
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ) //
          : Icon(
            Icons.fingerprint_rounded, 
            color: Theme.of(context).colorScheme.onSurface
          );
      btns.add(
        TextButton.icon(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.titleMedium,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            identificationBloc.add(CheckBiometryEvent(methods));
          },
          icon: biometryIcon,
          label: const Text(""),
        ),
      );
    }
    // N'affiche aucun contrôle si la biométrie n'est pas activée
    else {
      btns.add(
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.titleMedium,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: null,
          child: const Text(""),
        ),
      );
    }
    // Bouton 0
    btns.add(
      TextButton(
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.titleMedium,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () {
          if (pinCode.value.length < PinCommand.pinSize) {
            identificationBloc.add(CheckCodePinEvent(
              0,
              pinCode,
              pinCode.value.length,
              methods,
            ));
          }
        },
        child: const Text("0"),
      ),
    );
    // Bouton effacer
    btns.add(
      TextButton.icon(
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.titleMedium,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () {
          if (pinCode.value.isNotEmpty) {
            identificationBloc.add(CheckCodePinEvent(
              -1,
              pinCode,
              pinCode.value.length,
              methods,
            ));
          }
        },
        icon: Icon(
          Icons.backspace_outlined, 
          color: Theme.of(context).colorScheme.onSurface
        ),
        label: const Text(""),
      ),
    );
    return btns;
  }

  /// Affiche l'indicateur du nombre de digits lors de la saisie du code PIN
  Row _buildPinEnterIndicator(
    BuildContext context,
    List<int> pinCode,
  ) {
    // Nombre de chiffres déjà saisi
    int entered = pinCode.length;
    Color selectedColor = Theme.of(context).primaryColor;

    List<Widget> icons = [];
    for (var i = 1; i <= pinLength; i++) {
      if (i <= entered) {
        // affiche un cercle coloré
        icons.add(Icon(
          circle,
          color: selectedColor,
          size: 10,
        ));
      } else {
        // affiche un cercle gris
        icons.add(const Icon(circle, size: 8));
      }
      if (i != pinLength) icons.add(const SizedBox(width: 8));
    }
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: icons);
  }

  /// Retourne le message d'erreur approprié
  String _getErrorMessage(
    IdentificationResponseError error,
    AppLocalizations traductions,
  ) {
    // Invalid pin
    if (error == IdentificationResponseError.pinIncorrect) {
      return traductions.identificationErrorPinInvalid;
    }
    // Not managed error
    else {
      throw UnimplementedError();
    }
  }
}
