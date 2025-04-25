import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/languages.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/avatar_circle_widget.dart';
import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../../config/adapters/ui/bloc/config_event.dart';
import '../../../../config/adapters/ui/bloc/config_state.dart';
import '../../../../config/domain/models/config_keys.dart';

class ProfileParametrePageLanguage extends StatelessWidget {
  const ProfileParametrePageLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return BlocBuilder<ConfigBloc, ConfigState>(
      buildWhen: (previousState, currentState) {
        return currentState is ConfigLoadedState &&
            currentState.updatedKey == ConfigKey.preferedLanguage;
      },
      builder: (context, configState) {
        String? current =
            configState.configParams.params[ConfigKey.preferedLanguage.code];
        return ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
              minWidth: MediaQuery.of(context).size.width),
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Text(
                      traductions.appSettingPageMenuLanguageTitle,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    // Séparateur
                    const SizedBox(height: 8.0),

                    // Sous titre de la page
                    Text(
                      traductions.appSettingPageMenuLanguageSelectTitle,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    //
                    const SizedBox(height: 15),

                    //
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        child: Column(
                          children: Languages.list()
                              .map<Widget>(
                                (language) => _widget(
                                  context,
                                  current,
                                  language,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _widget(
    BuildContext context,
    String? current,
    Languages language,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: current == language.code
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Themer.neural01Color)
          : null,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: AvatarCircleWidget(
          nom: language.code,
          rounded: true,
          radius: 20,
          photo: _languageLeading(language),
        ),
        title: Text(
          language.label,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        subtitle: Text(
          _languageSubTitle(language),
          style: Theme.of(context).textTheme.displaySmall,
        ),
        onTap: current == null || current != language.code
            ? () => context.read<ConfigBloc>().add(
                  ConfigChangeEvent(ConfigKey.preferedLanguage, language.code),
                )
            : null,
      ),
    );
  }

  String _languageLeading(Languages language) {
    if (language == Languages.pt) {
      return Images.iconsLanguagePt;
    } else if (language == Languages.en) {
      return Images.iconsLanguageEn;
    }
    return Images.iconsLanguageFr;
  }

  String _languageSubTitle(Languages language) {
    if (language == Languages.pt) {
      return "Utilizar como língua predefinida";
    } else if (language == Languages.en) {
      return "Used for app language";
    }
    return "Utiliser comme langue par défaut";
  }
}
