import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/models/permission_type.dart';
import '../../bloc/permissions/permissions_bloc.dart';
import '../../bloc/permissions/permissions_event.dart';

class PermissionsContact extends StatelessWidget {
  //
  const PermissionsContact({super.key});

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    PermissionType permission = PermissionType.contact;

    // Largeur contenu: 20 padding global de la page
    double largeurImage = MediaQuery.of(context).size.width - 20 * 2;
    double hauteurImage = MediaQuery.of(context).size.height - 400;
    double tailleImage = min(largeurImage, hauteurImage);

    return Column(
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
              traductions.permissionContactTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),

            // Séparateur
            const SizedBox(height: 8.0),

            // Sous titre de la page
            Text(
              traductions.permissionContactSubTitle1,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              traductions.permissionContactSubTitle2,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),

        // Images illustration
        Card(
          clipBehavior: Clip.antiAlias,
          child: Center(
            child: Image.asset(
              Images.permissionContact,
              width: tailleImage,
              height: tailleImage,
              package: 'common_dependencies'
            ),
          ),
        ),

        // Actions buttons
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                    traductions.permissionContactEnableBtn,
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
                context
                    .read<PermissionBloc>()
                    .add(AcceptPermissionEvent(permission, false));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).secondaryHeaderColor,
              ),
              child: SizedBox(
                height: Themer.btnNormalHeight,
                child: Center(
                  child: Text(
                    traductions.permissionContactNotNowBtn,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        )
      ],
    );
  }
}
