import 'package:common_dependencies/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/notification_dialog.dart';
import '../../../contacts/presentation/bloc/contact_bloc.dart';
import '../../domain/models/notification.dart' as notif;
import '../../domain/models/notification_type.dart' as notifType;
import '../../domain/models/notification_liste.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import 'notification_page_liste_empty.dart';
import 'notification_page_liste_item.dart';
import 'notification_page_liste_loading.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class NotificationPageListe extends StatefulWidget {
  ///
  const NotificationPageListe({
    super.key,
  });
  @override
  State<NotificationPageListe> createState() => _NotificationPageListeState();
}

class _NotificationPageListeState extends State<NotificationPageListe> {
  late ScrollController scrollController;
  late int index;

  @override
  void initState() {
    super.initState();
    // Pour la pagination
    scrollController = ScrollController();
    index = 0;
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        index++;
        context
            .read<NotificationBloc>()
            .add(NotificationSearchPaginateEvent(index));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            // Récupérer la liste des notifications
            NotificationListe liste = state.notifications;
            List<notif.Notification> notifications = liste.data;
            if (notifications.isNotEmpty) {
              // Liste groupé par jour
              List<NotificationGroup> notificationsGroupList =
                  groupNotifications(notifications, context);
              return ListView.builder(
                controller: scrollController,
                itemCount: notificationsGroupList.length,
                itemBuilder: (context, index) {
                  final notificationsGroup = notificationsGroupList[index];
                  return _buildNotificationGroupSection(
                    context,
                    notificationsGroup,
                  );
                },
              );
            }
            //
            else {
              if (state is NotificationLoadingState) {
                return const NotificationPageListeLoading();
              } //
              else if (state is NotificationEmptyState) {
                return const NotificationPageListeEmpty();
              } else if ( state is NotificationErrorState) {
                return NotificationDialog(
                  type: NotificationType.error,
                  message: AppLocalizations.of(context)!.serverErrorSubtitle, // ou state.error
                  description: state.error,
                  btnText: AppLocalizations.of(context)!.retry,
                  btnColor: Themer.amberColor,
                  btnAction: () {
                    Navigator.of(context).pop();  // ferme le dialog
                    context.read<NotificationBloc>()
                        .add(NotificationSearchPaginateEvent(index)); // retry
                  },
                );
              } else {
                return const NotificationPageListeEmpty();
              }
            }
          },
        ),
      ),
    );
  }

  // Regrouper les notifications par jour

  Widget _buildNotificationGroupSection(BuildContext context,
      NotificationGroup notificationGroup,){
    String locale = Localizations.localeOf(context).toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En‑tête de date
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            DateFormat('d MMMM', locale).format(
              DateTime.parse(notificationGroup.jour),
            ),
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)
          ),
        ),

        // Liste du jour
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            // color: Theme.of(context).colorScheme.surface,
            color: Themer.whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(1, 2),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notificationGroup.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 5),
            itemBuilder: (ctx, idx) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: NotificationPageListeItem(
                    notification: notificationGroup.notifications[idx],
                  ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  /*Widget _buildNotificationGroupSection(
    BuildContext context,
    NotificationGroup notificationGroup,
  ) {
    String locale = Localizations.localeOf(context).toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Jours
            Text(
              DateFormat('d MMMM', locale).format(
                DateTime.parse(notificationGroup.jour),
              ),
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Themer.neural03Color),
            ),
          ],
        ),

        //
        const SizedBox(height: 8),

        // Liste de notification par jour
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notificationGroup.notifications.length,
              itemBuilder: (context, index) {
                final notification = notificationGroup.notifications[index];
                return NotificationPageListeItem(notification: notification);
              },
            ),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }*/
}

// Ce model represente une sous groupe de notification
class NotificationGroup {
  NotificationGroup({
    // Jour
    required this.jour,
    // Liste des notifications
    required this.notifications,
  });

  final String jour;
  final List<notif.Notification> notifications;
}

// Cette  fonction convertie une liste de notification
// en liste en liste de sous groupe de notification
// Les notifications sont donc regroupées  poar jour
// avec le bilan (somme de credits - somme des débits)

String _dayKey(notif.Notification n) {
  final dt = n.dateAction ?? n.timestamp; // timestamp n’est jamais null
  return DateFormat('yyyy-MM-dd').format(dt!);
}

List<NotificationGroup> groupNotifications(
    List<notif.Notification> notifications,
    BuildContext context,
) {
  final Map<String, List<notif.Notification>> grouped = {};
  final List<Contact> contacts =
      (context.read<ContactBloc>().state).contacts ?? [];
  for (var n in notifications) {
    final key = _dayKey(n);

    // Ajoute la notification si elle passe le filtre
    grouped.putIfAbsent(key, () => []).add(n);
  }
  return grouped.entries
      .map((e) => NotificationGroup(jour: e.key, notifications: e.value))
      .toList();
}

/*List<NotificationGroup> groupNotifications(
    List<notif.Notification> notifications) {
  Map<String, List<notif.Notification>> groupedNotifications = {};

  // Regrouper les notification par jour
  for (var notification in notifications) {
    String jour = notification.dateAction!.toIso8601String().split('T')[0];
    groupedNotifications[jour] = groupedNotifications[jour] ?? [];
    groupedNotifications[jour]!.add(notification);
  }

  List<NotificationGroup> result = [];
  for (var entry in groupedNotifications.entries) {
    result.add(NotificationGroup(
      jour: entry.key,
      notifications: entry.value,
    ));
  }
  return result;
}*/
