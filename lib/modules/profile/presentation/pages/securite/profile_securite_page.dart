import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../../config/adapters/ui/bloc/config_state.dart';
import '../../../../config/domain/models/config_keys.dart';
import '../../bloc/hide_amount/hide_amount_bloc.dart';
import '../../bloc/hide_amount/hide_amount_event.dart';
import '../hide_amount/hide_amount_illustration.dart';
import '../profile_menu.dart';

class ProfileSecuritePage extends StatelessWidget {
  //
  const ProfileSecuritePage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    ConfigBloc configBloc = context.read<ConfigBloc>();

    return Scaffold(
      // Pour avoir le bouton de retour
      appBar: AppBar(),

      // Body
      body: BlocBuilder<ConfigBloc, ConfigState>(
        bloc: configBloc,
        buildWhen: (previousState, currentState) {
          return currentState is ConfigLoadedState;
        },
        builder: (context, configState) {
          return MyPageContainer(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Page title
                  Text(
                    traductions.profileSecuritePageTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),

                  // Spacer
                  const SizedBox(height: 24),

                  // Sécurité Menu
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 12),
                    child: Text(
                      traductions.profileSecuriteMenuSecuriteTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  ProfilePageMenu(
                      items: _getMenuSecuriteItems(
                    context,
                    traductions,
                    configBloc,
                    configState,
                  )),

                  // Spacer
                  const SizedBox(height: 20.0),

                  // Confidentialité Menu
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 12),
                    child: Text(
                      traductions.profileSecuriteMenuConfidentialiteTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),

                  ProfilePageMenu(
                    items: _getMenuConfidentialiteItems(
                      context,
                      traductions,
                      configBloc,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<ProfileItem> _getMenuSecuriteItems(
    BuildContext context,
    AppLocalizations traductions,
    ConfigBloc configBloc,
    ConfigState configState,
  ) {
    // Paramètre d'affichage du montant
    String? hideEye = configState.configParams.params[ConfigKey.hideEye.code];

    // Liste des Menu items
    return [
      // // Personnes de confiance
      // ProfileItem(
      //   Images.iconsCircleUser,
      //   traductions.profileSecuriteMenuItemTrustedTitle,
      //   AppRouter.profileSecurite,
      // ),
      // // Liste noire
      // ProfileItem(
      //   Images.iconsBlacklist,
      //   traductions.profileSecuriteMenuItemBlacklistTitle,
      //   AppRouter.profileParametre,
      // ),
      // Appareils
      ProfileItem(
        Images.iconsAppareils,
        traductions.profileSecuriteMenuItemAppareilsTitle,
        AppRouter.profileParametre,
      ),
      // Modifier le code PIN
      ProfileItem(
        Images.iconsLock,
        traductions.profileSecuriteMenuItemPinTitle,
        AppRouter.profileCompte,
      ),
      // Autoriser biométrie
      ProfileItem(
        Images.iconsBiometry,
        traductions.profileSecuriteMenuItemBiometryTitle,
        AppRouter.profileParametre,
        value: true,
        action: (p0) {
          // Todo call identification bloc to activate
        },
      ),

      // Cacher les montants
      ProfileItem(
        Images.iconsEyeOff,
        traductions.profileSecuriteMenuItemMontantTitle,
        subtitle: traductions.profileSecuriteMenuItemMontantSubTitle,
        null,
        sheet: const HideAmountIllustrationSheet(),
        value: hideEye == null || hideEye == "0" ? false : true,
        action: (p0) {
          ParametreHideAmountBloc hideAmountBloc =
              context.read<ParametreHideAmountBloc>();
          if (p0) {
            hideAmountBloc.add(const ParametreHideAmountStartEvent());
          } else {
            hideAmountBloc.add(const ParametreHideAmountStopEvent());
          }
        },
      ),
    ];
  }

  List<ProfileItem> _getMenuConfidentialiteItems(
    BuildContext context,
    AppLocalizations traductions,
    ConfigBloc configBloc,
  ) {
    return [
      // Rendez-moi découvrable
      ProfileItem(
        Images.iconsMobileShake,
        traductions.profileSecuriteMenuItemShakeToPayTitle,
        AppRouter.profileCompte,
        subtitle: traductions.profileSecuriteMenuItemShakeToPaySubTitle,
      ),
    ];
  }
}
