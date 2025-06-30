import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../domain/models/biometric_method.dart';
import '../../bloc/identification/identification_bloc.dart';
import '../../bloc/identification/identification_event.dart';
import '../../bloc/identification/identification_state.dart';

class IdentificationBiometricConfigurePage extends StatelessWidget {
  //
  const IdentificationBiometricConfigurePage(
      {super.key, required this.methods});

  // Nombre de chiffres du code PIN
  final List<BiometricMethod> methods;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    // Méthode mis en évidence en fonction du telephone de l'utilisateur
    BiometricMethod highlightedMethod =
        methods.length > 1 ? BiometricMethod.all : methods[0];

    // Methode demandée
    String method = highlightedMethod == BiometricMethod.fingerprint
        ? traductions.configureBiometryMethodFingerprint
        : highlightedMethod == BiometricMethod.face
            ? traductions.configureBiometryMethodFace
            : traductions.configureBiometryMethod;

    // Image illustrée
    String image = Images.identificationPermissions[highlightedMethod.name]!;
    // Largeur contenu: 20 padding global de la page
    double largeurImage = MediaQuery.of(context).size.width - 20 * 2;
    double hauteurImage = MediaQuery.of(context).size.height - 400;
    double tailleImage = min(largeurImage, hauteurImage);

    // Commencer la construction de la page
    return BlocBuilder<IdentificationBloc, IdentificationState>(
      builder: (context, identificationState) {
        // recuperer la logique de gestion
        IdentificationBloc identificationBloc =
            context.read<IdentificationBloc>();

        return Scaffold(
          // Pour avoir le bouton de retour
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                identificationBloc.add(const SetupBiometryEvent([]));
              },
              child: const Icon(Icons.close),
            ),
          ),
          // Contenu de la page de connexion
          body: MyPageContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Titre et sous titre
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Titre de la page
                    Text(
                      traductions.configureBiometryFormTitle(method),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),

                    // Séparateur
                    const SizedBox(height: 8.0),

                    // Sous titre de la page
                    Text(
                      traductions.configureBiometryFormSubTitle(method),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),

                // Images illustration
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Center(
                    child: Image.asset(image,
                        width: tailleImage, height: tailleImage,
                        package: 'common_dependencies'),
                  ),
                ),

                // Actions buttons
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        identificationBloc.add(SetupBiometryEvent(methods));
                      },
                      child: SizedBox(
                        height: Themer.btnNormalHeight,
                        child: Center(
                          child: Text(
                            traductions.configureBiometryFormSubmitBtn(method),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        identificationBloc.add(const SetupBiometryEvent([]));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                      ),
                      child: SizedBox(
                        height: Themer.btnNormalHeight,
                        child: Center(
                          child: Text(
                            traductions.configureBiometryFormNotNowBtn,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
