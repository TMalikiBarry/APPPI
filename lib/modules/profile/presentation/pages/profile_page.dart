import 'package:flutter/material.dart';

import '../../../../core/assets.dart';
import '../../../../core/env.dart';
import '../../../../core/router.dart';
import '../../../../core/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/my_page_container.dart';
import '../../../security/presentation/pages/login/logout_btn.dart';
import 'profile_menu.dart';
import 'profile_page_avatar.dart';
import 'profile_page_invitation.dart';

class ProfilePage extends StatelessWidget {
  //
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    // Version de l'app
    String appVersion = AppEnv.version;

    return Scaffold(
      // Pour avoir le bouton de retour
      appBar: AppBar(),

      // Body
      body: MyPageContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // user, invite friends, menu
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Connected user détails
                const ProfilePageAvatar(),

                // Spacer
                const SizedBox(height: 20.0),

                // Inviter Button
                const ProfilePageInvitation(),

                // Spacer
                const SizedBox(height: 20.0),

                // menu items
                ProfilePageMenu(items: _getMenuItems(traductions)),
              ],
            ),

            // Logout et version
            /*Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logout Button
                const LogoutBtn(),
                //
                const SizedBox(height: 20),
                // Version
                Center(
                  child: Text(
                    "${traductions.profilePageAppVersion} $appVersion",
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: Themer.neural03Color),
                  ),
                ),
              ],
            ),*/
          ],
        ),
      ),
    );
  }

  List<ProfileItem> _getMenuItems(traductions) {
    return [
      // Compte
      ProfileItem(
        Images.iconsCircleUser,
        traductions.profilePageMenuCompteTitle,
        AppRouter.profileCompte,
      ),
      // Sécurité & Confidentialité
      ProfileItem(
        Images.iconsSecurity,
        traductions.profilePageMenuSecurityTitle,
        AppRouter.profileSecurite,
      ),
      // Paramètres de l'application
      ProfileItem(
        Images.iconsSetting,
        traductions.profilePageMenuParametreTitle,
        AppRouter.profileParametre,
      ),
      // Centre d'Aide
      ProfileItem(
        Images.iconsHelp,
        traductions.profilePageMenuHelpTitle,
        AppRouter.profileHelpCenter,
      ),
      // A propos de nous
      ProfileItem(
        Images.iconsInfo,
        traductions.profilePageMenuAproposTitle,
        AppRouter.profileHelpCenter,
      ),
    ];
  }
}
