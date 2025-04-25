import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../../config/adapters/ui/bloc/config_state.dart';
import '../../../../config/domain/models/config_keys.dart';
import '../../bloc/identification/identification_bloc.dart';
import '../../bloc/identification/identification_state.dart';
import 'identification_biometric_configure_page.dart';
import 'identification_pin_create_page.dart';
import 'identification_pin_enter_page.dart';

/// Cette page permet à l'utilisateur de s'identifier à l'ouverture de l'app
/// Si l'utilisateur n'a pas de code PIN => le formulaire de création
/// Si l'utilisateur a un code PIN => le formulaire de saisie du code PIN
/// A chaque fois que l'utilisateur ouvre l'app, une identification est requise
/// Aprés création du code PIN, demander configuration de la biométrie
/// si le téléphone de l'utilisateur dispose du hardware nécessaire pour cela
/// L'utilisateur peut passer la configuration biométrie (bouton pas maintenant)
/// S'il le fait, il ne lui sera pas demandé la prochaine fois
/// mais pourra le configurer dans les paramètres
class IdentificationPage extends StatelessWidget {
  //
  const IdentificationPage({super.key, required this.action});

  //
  final String action;

  @override
  Widget build(BuildContext context) {
    // TODO remove this logic
    // IdentificationBloc idBloc = context.read<IdentificationBloc>();
    // if (idBloc.state is IdentificationSuccessState) {
    //   handleIdentificationSuccess(context, configState);
    // }

    // Commencer la construction de la page
    return BlocBuilder<ConfigBloc, ConfigState>(
      buildWhen: (previous, current) => current is ConfigLoadedState,
      builder: (context, configState) {
        if (configState is! ConfigLoadedState) {
          return SafeArea(child: LoadingPage());
        }
        return SafeArea(
          child: BlocConsumer<IdentificationBloc, IdentificationState>(
            listenWhen: (context, state) {
              return state is IdentificationSuccessState;
            },
            listener: (context, state) {
              if (state is IdentificationSuccessState) {
                handleIdentificationSuccess(context, configState);
              }
            },
            builder: (context, identificationState) {
              if (identificationState is IdentificationSuccessState) {
                handleIdentificationSuccess(context, configState);
              }

              // Demande de configuration
              if (identificationState is IdentificationNotConfiguredState) {
                return const IdentificationPinCreatePage();
              }
              if (identificationState is BiometryNotConfiguredState) {
                return IdentificationBiometricConfigurePage(
                  methods: identificationState.methods,
                );
              }
              // Demande d'identification
              else if (identificationState is IdentificationRequiredState ||
                  identificationState is IdentificationErrorState) {
                return const IdentificationPinEnterPage();
              }
              // Etat Inderterminé
              else {
                return LoadingPage(
                    bgColor: Theme.of(context).colorScheme.surface);
              }
            },
          ),
        );
      },
    );
  }

  void handleIdentificationSuccess(
      BuildContext context, ConfigLoadedState configState) {
    if (action == "initial") {
      Map<String, String?> configParams = configState.configParams.params;
      // Prochaine page à afficher (permissions ou home)
      if (configParams[ConfigKey.permissionNotification.code] == null ||
          configParams[ConfigKey.permissionContact.code] == null) //
      {
        AppRouter.pushReplacement(context, AppRouter.permissions);
      } else {
        AppRouter.pushReplacement(context, AppRouter.home);
      }
    } else {
      AppRouter.pop(context, value: true);
    }
  }
}
