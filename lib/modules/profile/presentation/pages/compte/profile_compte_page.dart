import 'package:flutter/material.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

import '../../../../../../core/assets.dart';
import '../../../../../../core/router.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../profile_menu.dart';

class ProfileComptePage extends StatelessWidget {
  //
  const ProfileComptePage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return Scaffold(
      // Pour avoir le bouton de retour
      appBar: AppBar(),
      // Contenu de la page de connexion
      body: MyPageContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              traductions.comptePageTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),

            //
            const SizedBox(height: 24),

            //
            ProfilePageMenu(
              items: [
                // Compte personnelle
                ProfileItem(
                  Images.iconsCircleUser,
                  traductions.comptePageListeInfosTitle,
                  AppRouter.profileComptePersonnel,
                ),
                // Details compte
                ProfileItem(
                  Images.iconsDetailsCompte,
                  traductions.comptePageListeDetailsTitle,
                  AppRouter.profileCompteDetails,
                ),
              ],
            ),
          ],
        ),
      ),

      //
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: ElevatedButton(
          onPressed: null,
          child: Row(
            children: [
              const Icon(Icons.close, size: 24),
              const SizedBox(width: 16),
              Text(traductions.comptePageBtnFermer),
            ],
          ),
        ),
      ),
    );
  }
}
