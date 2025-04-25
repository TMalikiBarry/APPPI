import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/assets.dart';
import '../../../../core/router.dart';
import '../../../../l10n/app_localizations.dart';

class ProfilePageInvitation extends StatelessWidget {
  //
  const ProfilePageInvitation({super.key});

  ///
  final double avatarDimension = 64;

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(Images.iconsAddUser,
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 20,
                  height: 20),
              const SizedBox(width: 10.0),
              Text(
                traductions.profilePageBtnInviter,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        onTap: () => context.push(AppRouter.inviteFriends),
      ),
    );
  }
}
