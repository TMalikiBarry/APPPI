import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/router.dart';
import '../../../../../core/sounds.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../../config/adapters/ui/bloc/config_event.dart';
import '../../../../config/adapters/ui/bloc/config_state.dart';
import '../../../../config/domain/models/config_keys.dart';

class ProfileParametrePageNotificationsSon extends StatefulWidget {
  const ProfileParametrePageNotificationsSon({super.key});
  @override
  State<ProfileParametrePageNotificationsSon> createState() =>
      _ProfileParametrePageNotificationsSonState();
}

class _ProfileParametrePageNotificationsSonState
    extends State<ProfileParametrePageNotificationsSon> {
  late String? selectedSound;

  @override
  void initState() {
    super.initState();
    String? currentSound = context
        .read<ConfigBloc>()
        .state
        .configParams
        .params[ConfigKey.notificationAlertSound.code];
    selectedSound = currentSound;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return BlocBuilder<ConfigBloc, ConfigState>(
      buildWhen: (previousState, currentState) =>
          currentState is ConfigLoadedState &&
          currentState.updatedKey != null &&
          currentState.updatedKey == ConfigKey.notificationAlertSound,
      builder: (context, configState) {
        // Récupérer les paramètres de son
        bool enabled = selectedSound == null || selectedSound != "NONE";

        return MyPageContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back btn
                  BackButton(
                    onPressed: () {
                      AppRouter.pop(context);
                    },
                  ),
                  // Save Btn
                  TextButton(
                    onPressed: () {
                      if (selectedSound != null) {
                        context.read<ConfigBloc>().add(
                              ConfigChangeEvent(
                                ConfigKey.notificationAlertSound,
                                selectedSound!,
                              ),
                            );
                        AppRouter.pop(context);
                      }
                    },
                    child: Text(traductions.btnTextSave),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 0, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page title
                        Text(
                          traductions
                              .appSettingPageMenuNotificationSonPageTitle,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        //
                        const SizedBox(height: 20),

                        // Notifications toggle
                        _notificationsToggle(context, traductions, enabled),

                        // Liste des sons disponibles
                        const SizedBox(height: 20),
                        Text(
                          traductions.appSettingPageMenuNotificationSonTitle,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // None
                              ListTile(
                                title: Text(traductions
                                    .appSettingPageMenuNotificationStyleNone),
                                onTap: () {
                                  setState(() {
                                    selectedSound = "NONE";
                                  });
                                },
                                trailing: selectedSound == null ||
                                        selectedSound == "NONE"
                                    ? const Icon(Icons.check, size: 18)
                                    : null,
                              ),
                              // Liste des sons disponibles
                              ...SoundManager.liste.map(
                                (sound) => ListTile(
                                  title: Text(sound.name),
                                  onTap: () {
                                    SoundManager.playSound(sound.path);
                                    setState(() {
                                      selectedSound = sound.path;
                                    });
                                  },
                                  trailing: selectedSound == sound.path
                                      ? const Icon(Icons.check, size: 18)
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Notifications toggle Btn Enable / Disable
  Widget _notificationsToggle(
    BuildContext context,
    AppLocalizations traductions,
    bool enabled,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(14.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ImageIcon(
                AssetImage(Images.iconsCloche),
                color: Theme.of(context).colorScheme.onSurface,
                size: 30,
              ),
            ),
          ),
          title: Text(
            traductions.notificationPageTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          trailing: Switch(
            value: enabled,
            onChanged: (value) =>
                context.read<ConfigBloc>().add(ConfigChangeEvent(
                      ConfigKey.notificationStatus,
                      enabled ? "disabled" : "enabled",
                    )),
          ),
        ),
      ),
    );
  }
}
