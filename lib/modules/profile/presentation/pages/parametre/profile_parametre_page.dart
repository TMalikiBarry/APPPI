import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/languages.dart';
import '../../../../../core/router.dart';
import '../../../../../core/sounds.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/loading_page.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../../config/adapters/ui/bloc/config_state.dart';
import '../../../../config/domain/models/config_keys.dart';
import '../../../../config/domain/models/config_params.dart';
import '../profile_menu.dart';
import 'profile_parametre_page_language.dart';
import 'profile_parametre_page_qrcode.dart';

class ProfileParametrePage extends StatelessWidget {
  //
  const ProfileParametrePage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return Scaffold(
      // Pour avoir le bouton de retour
      appBar: AppBar(),

      // Body
      body: BlocBuilder<ConfigBloc, ConfigState>(
        buildWhen: (previousState, currentState) {
          return currentState is ConfigLoadedState &&
              currentState.updatedKey != null &&
              currentState.updatedKey == ConfigKey.showQRcode;
        },
        builder: (context, configState) {
          if (configState is! ConfigLoadedState) {
            return LoadingPage();
          }

          return MyPageContainer(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Page title
                  Text(
                    traductions.appSettingPageTitle,
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
                    items: _getMenuParametreItems(
                      context,
                      traductions,
                      configState.configParams,
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

  List<ProfileItem> _getMenuParametreItems(
    BuildContext context,
    AppLocalizations traductions,
    ConfigParams configParams,
  ) {
    // QR Code
    String? showQRcodeParam = configParams.params[ConfigKey.showQRcode.code];
    bool showQRcode = showQRcodeParam != null && showQRcodeParam == "1";

    // Language
    String? language = configParams.params[ConfigKey.preferedLanguage.code];
    Languages? lang = Languages.fromCode(language ?? Languages.fr.code);

    // Theme
    String? themeCode = configParams.params[ConfigKey.preferedTheme.code];
    Themes? theme = Themes.fromCode(themeCode ?? Themes.light.code);

    // Notifications dans l'application
    String? notifParam = configParams.params[ConfigKey.notificationStatus.code];
    String notifStatus = notifParam == null || notifParam == "enabled"
        ? traductions.statutActive
        : traductions.statutDesactive;

    // Son
    String? sonParam =
        configParams.params[ConfigKey.notificationAlertSound.code];
    String sonStatus = sonParam != null && sonParam != "NONE"
        ? SoundManager.nameFromPath(sonParam)
        : traductions.appSettingPageMenuNotificationSonDefault;
    return [
      // Langue
      ProfileItem(
        Images.iconsLanguage,
        traductions.appSettingPageMenuLanguageTitle,
        null,
        subtitle: lang?.label ?? Languages.fr.label,
        sheet: const ProfileParametrePageLanguage(),
      ),

      // Thème
      ProfileItem(
        Images.iconsTheme,
        traductions.appSettingPageMenuThemeTitle,
        AppRouter.profileParametreTheme,
        subtitle: theme.label(traductions),
      ),

      // Notifications dans l'application
      ProfileItem(
        Images.iconsCloche,
        traductions.appSettingPageMenuNotificationTitle,
        AppRouter.profileParametreNotifications,
        subtitle: notifStatus == traductions.statutActive
            ? "$notifStatus - $sonStatus"
            : notifStatus,
      ),

      // Mon QRcode par defaut
      ProfileItem(
        Images.homeFooterQrcode,
        traductions.appSettingPageMenuQrCodeTitle,
        null,
        subtitle:
            showQRcode ? traductions.statutActive : traductions.statutDesactive,
        sheet: const ProfileParametrePageQRcode(),
      ),
    ];
  }
}
