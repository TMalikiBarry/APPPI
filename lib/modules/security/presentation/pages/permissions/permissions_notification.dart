import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/notifications.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/models/permission_type.dart';
import '../../bloc/permissions/permissions_bloc.dart';
import '../../bloc/permissions/permissions_event.dart';
import '../../bloc/permissions/permissions_state.dart';

class PermissionsNotification extends StatelessWidget {
  //
  const PermissionsNotification({super.key});

  static final logger = Logger();

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;
    PermissionType permission = PermissionType.notification;

    // Largeur contenu: 20 padding global de la page
    double largeurImage = MediaQuery.of(context).size.width - 20 * 2;
    double hauteurImage = MediaQuery.of(context).size.height - 400;
    double tailleImage = min(largeurImage, hauteurImage);
    return BlocListener<PermissionBloc, PermissionState>(
      listenWhen: (context, state) {
        return state is PermissionGrantedState;
      },
      listener: (context, state) {
        logger.i('Permission accordée');
        AppNotifications.configure();
      },
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
                traductions.permissionNotificationTitle,
                style: TextStyle(color: Themer.blackColor, fontSize: 28,
                  fontWeight: FontWeight.w600,),
              ),

              // Séparateur
              const SizedBox(height: 8.0),

              // Sous titre de la page
              Text(
                traductions.permissionNotificationSubTitle,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),

          // Images illustration
          Card(
            clipBehavior: Clip.antiAlias,
            child: Center(
              child: Image.asset(
                Images.permissionNotification,
                width: tailleImage,
                height: tailleImage,
              ),
            ),
          ),

          // Actions buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bouton Activer les notifications
              ElevatedButton(
                onPressed: () {
                  context
                      .read<PermissionBloc>()
                      .add(AcceptPermissionEvent(permission, true));
                },
                child: SizedBox(
                  height: Themer.btnNormalHeight,
                  child: Center(
                    child: Text(
                      traductions.permissionNotificationEnableBtn,
                      style: TextStyle(color: Themer.whiteColor, fontSize: 17,
                        fontWeight: FontWeight.w500, height: 1.53),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          )
        ],
      ),
    );
  }
}
