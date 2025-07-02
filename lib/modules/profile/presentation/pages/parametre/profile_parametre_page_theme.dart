import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../../config/adapters/ui/bloc/config_event.dart';
import '../../../../config/adapters/ui/bloc/config_state.dart';
import '../../../../config/domain/models/config_keys.dart';

class ProfileParametrePageTheme extends StatelessWidget {
  //
  const ProfileParametrePageTheme({super.key});

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
              ConfigKey.preferedTheme == currentState.updatedKey;
        },
        builder: (context, configState) {
          String? currentTheme =
              configState.configParams.params[ConfigKey.preferedTheme.code];
          return MyPageContainer(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Page title
                  Text(
                    traductions.appSettingPageMenuThemePageTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  //
                  const SizedBox(height: 20),

                  // Thème
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        traductions.appSettingPageMenuThemeTitle,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Wrap(
                              // Space between items horizontally
                              spacing: 10.0,
                              // Space between rows
                              runSpacing: 10.0,
                              // Main axis alignment
                              alignment: WrapAlignment.spaceBetween,
                              children: Themes.list()
                                  .map<Widget>(
                                    (theme) => _widget(
                                      context,
                                      traductions,
                                      currentTheme,
                                      theme,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _widget(
    BuildContext context,
    AppLocalizations traductions,
    String? currentTheme,
    Themes theme,
  ) {
    return InkWell(
      onTap: currentTheme != theme.code
          ? () => context
              .read<ConfigBloc>()
              .add(ConfigChangeEvent(ConfigKey.preferedTheme, theme.code))
          : null,
      child: Column(
        children: [
          Container(
            width: 120,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              image: DecorationImage(
                image: AssetImage(_themeIcon(theme),package: 'common_dependencies'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _themeTitle(traductions, theme),
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 5),
          _checkedDot(context, value: currentTheme == theme.code),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _themeIcon(Themes theme) {
    if (theme == Themes.light) {
      return Images.imageThemeLight;
    } else if (theme == Themes.dark) {
      return Images.imageThemeDark;
    } else if (theme == Themes.yellow) {
      return Images.imageThemeLightYellow;
    } else if (theme == Themes.green) {
      return Images.imageThemeLightGreen;
    } else if (theme == Themes.blue) {
      return Images.imageThemeLightBlue;
    }
    return Images.imageThemeSystem;
  }

  String _themeTitle(AppLocalizations traductions, Themes theme) {
    if (theme == Themes.light) {
      return traductions.appSettingPageMenuThemeLight;
    } else if (theme == Themes.dark) {
      return traductions.appSettingPageMenuThemeDark;
    } else if (theme == Themes.yellow) {
      return traductions.appSettingPageMenuThemeYellow;
    } else if (theme == Themes.green) {
      return traductions.appSettingPageMenuThemeGreen;
    } else if (theme == Themes.blue) {
      return traductions.appSettingPageMenuThemeBlue;
    }
    return traductions.appSettingPageMenuThemeDefault;
  }


  Container _checkedDot(
    context, {
    double dimension = 15,
    double dotDimension = 5,
    bool value = false,
  }) {
    return Container(
      alignment: Alignment.center,
      width: dimension,
      height: dimension,
      decoration: ShapeDecoration(
        color: value ? Theme.of(context).primaryColor : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color:
                value ? Theme.of(context).primaryColor : Themer.neural03Color,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Container(
        width: dotDimension,
        height: dotDimension,
        decoration: ShapeDecoration(
          color: value ? Colors.white : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
