import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/notifications.dart';
import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/menu_actions_widget.dart';
import '../../../../../shared/widgets/my_page_container.dart';
import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../../config/adapters/ui/bloc/config_event.dart';
import '../../../../config/adapters/ui/bloc/config_state.dart';
import '../../../../config/domain/models/config_keys.dart';

class ProfileParametrePageNotifications extends StatelessWidget {
  //
  const ProfileParametrePageNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    //
    AppLocalizations traductions = AppLocalizations.of(context)!;

    return BlocBuilder<ConfigBloc, ConfigState>(
      buildWhen: (previousState, currentState) {
        return currentState is ConfigLoadedState &&
            (currentState.updatedKey != null &&
                [
                  ConfigKey.notificationStatus,
                  ConfigKey.notificationStyle,
                  ConfigKey.notificationAlertVibration,
                  ConfigKey.notificationAlertSound,
                  ConfigKey.notificationAlertTransfer
                ].contains(currentState.updatedKey));
      },
      builder: (context, configState) {
        // Notification activation status
        String? currentValue =
            configState.configParams.params[ConfigKey.notificationStatus.code];
        bool enabled = currentValue == null || currentValue == "enabled";
        // Notification style
        String? currentStyle =
            configState.configParams.params[ConfigKey.notificationStyle.code];
        // Notification Son
        String? currentSound = configState
            .configParams.params[ConfigKey.notificationAlertSound.code];
        bool sonEnabled = currentSound == null || currentSound != "NONE";
        // Vibration activation status
        String? vibrationValue = configState
            .configParams.params[ConfigKey.notificationAlertVibration.code];
        bool vibrationEnabled =
            vibrationValue != null && vibrationValue == "enabled";
        return MyPageContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButton(
                    onPressed: () {
                      AppRouter.pop(context);
                    },
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
                          traductions.appSettingPageMenuNotificationTitle,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        //
                        const SizedBox(height: 20),

                        // Notifications toggle
                        _notificationsToggle(
                          context,
                          traductions,
                          enabled,
                        ),

                        // Style de notification
                        const SizedBox(height: 10),
                        Text(
                          traductions.appSettingPageMenuNotificationStyleTitle,
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
                                children: _notificationStyles(
                                  context,
                                  traductions,
                                  enabled,
                                  currentStyle,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Description des styles de notification
                        const SizedBox(height: 10),
                        Text(
                          traductions
                              .appSettingPageMenuNotificationStyleDialogDesc,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(color: Themer.neural04Color),
                        ),

                        // Son de notification
                        const SizedBox(height: 20),
                        Text(
                          traductions.appSettingPageMenuNotificationSonTitle,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        MenuActionsWiget(
                          items: [
                            // Son des notifications
                            MenuActionItem(
                              iconSize: 20,
                              Images.iconsCloche,
                              traductions.notificationPageTitle,
                              sonEnabled
                                  ? traductions.statutActive
                                  : traductions.statutDesactive,
                              () => AppRouter.push(
                                context,
                                AppRouter.profileParametreNotificationsSon,
                              ),
                            ),
                          ],
                        ),

                        // Vibration de notification
                        const SizedBox(height: 20),
                        Text(
                          traductions.appSettingPageMenuNotificationVibrTitle,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        _vibrationToggle(
                          context,
                          traductions,
                          vibrationEnabled,
                        ),
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

  // To build notification styles
  List<Widget> _notificationStyles(
    BuildContext context,
    AppLocalizations traductions,
    bool enabled,
    String? currentStyle,
  ) {
    return [
      // None
      _style(
        context,
        traductions,
        enabled,
        currentStyle,
        null,
        Images.imageNotifStyleNone,
        traductions.appSettingPageMenuNotificationStyleNone,
      ),
      // SnackBar
      _style(
        context,
        traductions,
        enabled,
        currentStyle,
        NotificationExternalEvent.notificationStyleSnackBar,
        Images.imageNotifStyleSnackbar,
        traductions.appSettingPageMenuNotificationStyleSnackBar,
      ),
      // Dialog
      _style(
        context,
        traductions,
        enabled,
        currentStyle,
        NotificationExternalEvent.notificationStyleDialog,
        Images.imageNotifStyleDialog,
        traductions.appSettingPageMenuNotificationStyleDialog,
      ),
    ];
  }

  /// Notification style item
  Widget _style(
    BuildContext context,
    AppLocalizations traductions,
    bool enabled,
    String? selectedStyle,
    String? style,
    String icon,
    String title,
  ) {
    return InkWell(
      onTap: enabled &&
              style != null &&
              (selectedStyle == null || selectedStyle != style)
          ? () => context
              .read<ConfigBloc>()
              .add(ConfigChangeEvent(ConfigKey.notificationStyle, style))
          : null,
      child: Column(
        children: [
          // Image
          Container(
            width: 60,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              image: DecorationImage(
                image: AssetImage(icon),
                fit: BoxFit.cover,
                colorFilter:
                    (!enabled && style == null) || selectedStyle == style
                        ? ColorFilter.mode(
                            Colors.black.withValues(),
                            BlendMode.srcATop, // Mode de fusion
                          )
                        : null,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Label
          Badge(
            label: Text(
              title,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: (!enabled && style == null) || selectedStyle == style
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.onSecondary,
                  ),
            ),
            backgroundColor:
                (!enabled && style == null) || selectedStyle == style
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.secondary,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          ),
        ],
      ),
    );
  }

  /// Vibrations toggle Btn Enable / Disable
  Widget _vibrationToggle(
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
            traductions.appSettingPageMenuNotificationVibrTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          subtitle: Text(
            traductions.appSettingPageMenuNotificationVibrSubtitle,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          trailing: Switch(
            value: enabled,
            onChanged: (value) =>
                context.read<ConfigBloc>().add(ConfigChangeEvent(
                      ConfigKey.notificationAlertVibration,
                      enabled ? "disabled" : "enabled",
                    )),
          ),
        ),
      ),
    );
  }
}
