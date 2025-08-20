import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di.dart';
import '../../../../core/notifications.dart';
import '../../../../core/assets.dart';
import '../../../../core/router.dart';
import '../../../../core/sounds.dart';
import '../../../../core/theme.dart';
import '../../../alias/domain/models/alias.dart';
import '../../../alias/presentation/bloc/alias_bloc.dart';
import '../../../alias/presentation/bloc/alias_state.dart';
import '../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../config/domain/models/config_keys.dart';
import '../../../config/domain/models/config_params.dart';
import '../../domain/models/notification_type.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';

class NotificationBtnOpenWidget extends StatefulWidget {
  ///
  const NotificationBtnOpenWidget({super.key});

  @override
  State<NotificationBtnOpenWidget> createState() =>
      _NotificationBtnOpenWidgetState();
}

class _NotificationBtnOpenWidgetState extends State<NotificationBtnOpenWidget> {
  late NotificationBloc notificationBloc;

  @override
  void initState() {
    super.initState();
    Alias alias = (context.read<AliasBloc>().state as AliasExistState).alias;

    /*
    notificationBloc = NotificationBloc(
      Di.getNotificationInputPort(),
    )..add(NotificationCountEvent(alias.compte));
     */
    notificationBloc = NotificationBloc(
      Di.getNotificationInputPort(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>.value(
      value: notificationBloc,
      child: BlocConsumer<NotificationBloc, NotificationState>(
        listenWhen: (previous, current) =>
            current is NotificationToDisplayState ||
            current is NotificationInAppState,
        listener: (context, state) async {
          if (state is NotificationToDisplayState) {
            _handleNotificationToDisplay(state);
          }
          if (state is NotificationInAppState) {
            _handleInAppNotification(state.event);
          }
        },
        builder: (context, state) => Stack(
          children: [
            IconButton(
              // icon: SvgPicture.asset(
              //   Images.iconNotificationHeaderHP,
              //   package: 'common_dependencies',
              //   height: 24,
              //   width: 24,
              //   colorFilter: ColorFilter.mode(
              //     Theme.of(context).colorScheme.onSurface,
              //     BlendMode.srcIn,
              //   ),
              // ),
              icon: ImageIcon(
                const AssetImage(Images.iconNotificationHeaderHP, package: 'common_dependencies'),
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
              onPressed: () {
                // Aller sur la page notifications
                AppRouter.push(
                  context,
                  AppRouter.notifications,
                  params: notificationBloc,
                );
              },
            ),
            if (state.count != 0) ...[
              Positioned(
                right: 8,
                top: 5,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.error,
                    shape: CircleBorder(
                      side: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.surface),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "${state.count}",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Themer.whiteColor,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _handleNotificationToDisplay(NotificationToDisplayState state) {
    // POP UP RTP RECUE
    if (state.event.type == NotificationType.rtpRecue.value) {
      AppRouter.push(
        context,
        AppRouter.transactionReceiveDetails
            .replaceFirst(':id', state.event.idObject!),
      );
    }
  }

  _handleInAppNotification(NotificationExternalEvent event) {
    ConfigParams configParams = context.read<ConfigBloc>().state.configParams;
    if (configParams.params[ConfigKey.notificationStatus.code] == null ||
        configParams.params[ConfigKey.notificationStatus.code] == "enabled") {
      // play sound
      var soundSelected =
          configParams.params[ConfigKey.notificationAlertSound.code];
      if (soundSelected != null && soundSelected != "NONE") {
        SoundManager.playSound(soundSelected);
      }
      // Vibration
      if (configParams.params[ConfigKey.notificationAlertVibration.code] !=
              null &&
          configParams.params[ConfigKey.notificationAlertVibration.code] ==
              "enabled") {
        HapticFeedback.vibrate();
      }
      // Display Style
      if (configParams.params[ConfigKey.notificationStyle.code] == null ||
          configParams.params[ConfigKey.notificationStyle.code] ==
              NotificationExternalEvent.notificationStyleSnackBar) {
        _displaySnackBar(event);
      } else {
        _displayDialog(event);
      }
    }
  }

  /// Affiche une bannière (SnackBar)
  _displaySnackBar(NotificationExternalEvent event) {
    // Afficher une bannière (SnackBar)
    final snackBar = SnackBar(
      duration: Duration(milliseconds: 3000),
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 150,
        left: 10,
        right: 10,
      ),
      content: Text(
        event.title ?? 'Notification',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
      ),
      backgroundColor: Themer.neural02Color,
      action: SnackBarAction(
        label: '',
        onPressed: () {
          // Code à exécuter lorsque l'utilisateur appuie sur le bouton
        },
      ),
    );

    // Utiliser le contexte de l'application pour afficher le SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Afficher une boite de dialogue
  _displayDialog(NotificationExternalEvent event) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(event.title ?? 'Notification'),
        content: Text(event.body ?? 'Notification'),
        actions: [
          TextButton(
            onPressed: () {
              // Code à exécuter lorsque l'utilisateur appuie sur le bouton
              AppRouter.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
