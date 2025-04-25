import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di.dart';
import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/custom_alert_dialog.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../../config/adapters/ui/bloc/config_state.dart';
import '../../../../config/domain/models/config_keys.dart';
import '../../../domain/models/permission_type.dart';
import '../../bloc/permissions/permissions_bloc.dart';
import '../../bloc/permissions/permissions_event.dart';
import '../../bloc/permissions/permissions_state.dart';
import 'permissions_contact.dart';
import 'permissions_notification.dart';

/// Pour afficher les vues d'explications des permissions demandées dans l'APP
/// - notifications
/// - contacts
/// Pour la géolocalisation, une vue d'explication n'est pas donnée
/// La permission de géolocalisation sera demandée
/// la première fois que l'utilisateur fera un transfert
class PermissionsPage extends StatefulWidget {
  //
  const PermissionsPage({super.key});
  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  late PermissionBloc permissionBloc;

  @override
  void initState() {
    super.initState();
    // Récupération du bloc de configuration
    ConfigBloc configBloc = context.read<ConfigBloc>();
    // La config étant déjà chargée au démarrage de l'app
    ConfigLoadedState configState = configBloc.state as ConfigLoadedState;
    Map<String, String?> configParams = configState.configParams.params;

    // Création du bloc pour les permissions
    PermissionType permissionToAsk =
        configParams[ConfigKey.permissionNotification.code] == null
            ? PermissionType.notification
            : PermissionType.contact;
    permissionBloc = PermissionBloc(
      Di.getPermissionInputPort(),
      configBloc,
      permissionToAsk,
    );
  }

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        // Pour avoir le bouton de retour
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              permissionBloc.add(const FinishPermissionEvent());
            },
            child: const Icon(Icons.close),
          ),
        ),
        // Contenu de la page de connexion
        body: BlocProvider(
          create: (BuildContext context) => permissionBloc,
          child: BlocListener<PermissionBloc, PermissionState>(
            listenWhen: (previous, current) => current is PermissionErrorState,
            listener: (context, state) {
              final errorCode = (state as PermissionErrorState).errorCode;
              // Demander à l'utilisateur de revoir sa connexion puis / reessayer
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomAlertDialog(
                    title: traductions.serverErrorTitle,
                    // Ces 3 erreurs possibles:
                    // Token "Impossible de récupérer le FCM Token."
                    // API "Erreur d'enregistrement du token",
                    // Device "Unsupported plateform",
                    // Unknown error
                    description: errorCode == "API"
                        ? traductions.permissionErrorApi
                        : errorCode == "Device"
                            ? traductions.permissionErrorDevice
                            : errorCode == "Token"
                                ? traductions.permissionErrorToken
                                : traductions.erreurInattendue,
                    confirmBtnText: traductions.errorDialogOk,
                    confirmBtnAction: () {
                      AppRouter.pop(context);
                    },
                  );
                },
              );
            },
            child: MyPageContainer(
              child: BlocProvider(
                create: (context) => permissionBloc,
                child: BlocConsumer<PermissionBloc, PermissionState>(
                  listenWhen: (context, state) {
                    return state is PermissionFinalState;
                  },
                  listener: (context, state) {
                    if (state is PermissionFinalState) {
                      AppRouter.pushReplacement(context, AppRouter.home);
                    }
                  },
                  builder: (context, permissionState) {
                    if (permissionState is PermissionInitialState ||
                        permissionState is PermissionErrorState) {
                      final permission =
                          (permissionState as dynamic).permission;
                      if (permission == PermissionType.notification) {
                        return const PermissionsNotification();
                      } else {
                        return const PermissionsContact();
                      }
                    } else {
                      return const LoadingPage();
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
