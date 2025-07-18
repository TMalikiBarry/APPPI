import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/modules/notification/presentation/bloc/notification_event.dart';

import '../../../../core/assets.dart';
import '../../../../core/router.dart';
import '../../../../core/theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/amount_widget.dart';
import '../../../../shared/widgets/custom_progressbar.dart';
import '../../domain/models/notification.dart' as my_notif;
import '../../domain/models/notification_type.dart';
import '../bloc/notification_bloc.dart';

class NotificationPageListeItem extends StatelessWidget {
  ///
  const NotificationPageListeItem({
    super.key,
    required this.notification,
  });

  /// Liste des notifications à afficher
  final my_notif.Notification notification;

  @override
  Widget build(BuildContext context) {
    context.read<NotificationBloc>();
    AppLocalizations traductions = AppLocalizations.of(context)!;
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        leading: _buildIcon(context, notification),
        title: _buildTitle(context, traductions, notification),
        subtitle: _buildSubtitle(context, traductions, notification),
        onTap: () => _handleNotification(context, notification));
  }

  /// ICON DE LA NOTIFICATION
  Widget? _buildIcon(
    BuildContext context,
    my_notif.Notification notification,
  ) {
    String icon = Images.iconsTransfert;
    if (notification.type == NotificationType.revendicationInitiee) {
      icon = Images.notificationAliasClaim;
    } else if (notification.type == NotificationType.annulationDemandee) {
      icon = Images.notificationAnnulation;
    } else if (notification.type == NotificationType.rtpInitiee ||
        notification.type == NotificationType.rtpRecue) {
      icon = Images.arrowDown;
    }

    Widget leading = Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(45 / 2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ImageIcon(
          AssetImage(icon,package: 'common_dependencies'),
          color: Theme.of(context).colorScheme.onSurface,
          size: 40,
        ),
      ),
    );
    return notification.dateLecture == null
        ? CustomCircularProgressBar(
            size: 46,
            progressValue: 1.0,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            progressColor: Theme.of(context).colorScheme.secondary,
            child: leading,
          )
        : leading;
  }

  /// TITRE DE LA NOTIFICATION
  Widget _buildTitle(
    BuildContext context,
    AppLocalizations traductions,
    my_notif.Notification notification,
  ) {
    String title = ' --- ';
    if (notification.title != null && notification.title!.isNotEmpty) {
      title =  notification.title!;
    } else if(notification.type != null) {
      title = notification.type!.name;
    }

    if (notification.type == NotificationType.revendicationInitiee) {
      title = traductions.notificationPageClaimTitle;
    } else if (notification.type == NotificationType.annulationDemandee) {
      title = traductions.notificationPageAnnulationRequestTitle;
    } else if (notification.type == NotificationType.rtpInitiee ||
        notification.type == NotificationType.rtpRecue) {
      title = traductions.transactionsSendTitleRequest2Pay;
    }

    double? montant;
    if (notification.details?['montant'] != null) {
      montant = double.parse(notification.details!['montant'].toString());
    } else {
      montant = extractAmountFromBody(notification.body);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Montant
        if (montant != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: AmountWidget(
              montant: montant,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ],
        /*if (notification.details != null &&
            notification.details!["montant"] != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: AmountWidget(
              montant:
                  double.parse(notification.details!["montant"].toString()),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ],*/
      ],
    );
  }

  /// SOUS TITRE DE LA NOTIFICATION
  Widget _buildSubtitle(
    BuildContext context,
    AppLocalizations traductions,
    my_notif.Notification notification,
  ) {
    String subtitle;

    switch (notification.type) {
      case NotificationType.revendicationInitiee:
        subtitle = traductions.notificationPageClaimSubtitle(
          notification.details!["alias"] as String,
        );
        break;
      case NotificationType.annulationDemandee:
        subtitle = traductions.notificationPageAnnulationRequestSubtitle(
          notification.details!["clientNom"] as String,
        );
        break;
      case NotificationType.rtpInitiee:
        subtitle = traductions.notificationPageRtpInitieeSubtitle(
          notification.details!["clientNom"] as String,
        );
        break;
      case NotificationType.rtpRecue:
        subtitle = traductions.notificationPageRtpRecueSubtitle(
          notification.details!["clientNom"] as String,
        );
        break;
      default:
        subtitle = notification.body?.isNotEmpty == true ? notification.body! :
                             ( notification.type !=null ? notification.type!.name : ' --- ');
    }
    return Text(
      subtitle,
      style: Theme.of(context)
          .textTheme
          .displaySmall!
          .copyWith(color: Themer.neural04Color),
    );
  }

  /// Action quand on clique sur Notifications
  _handleNotification(
    BuildContext context,
    my_notif.Notification notification,
  ) {
    // Marquer comme lu
    if (notification.dateLecture == null) {
      context.read<NotificationBloc>().add(
            NotificationReadEvent(
              notification: notification,
            ),
          );
    }

    // Afficher la notification
    String route;
    if (notification.type == NotificationType.revendicationInitiee) {
      route = "/alias/revendications/${notification.idObject}";
    } else if (notification.type == NotificationType.annulationDemandee) {
      route = "/transaction/cancel/${notification.idObject}";
    } else if (notification.type == NotificationType.rtpInitiee ||
        notification.type == NotificationType.rtpRecue) {
      route = "/transaction/receive_now/${notification.idObject}";
    } else {
      route = "/notifications/${notification.idObject}";
    }
    AppRouter.push(context, route, params: notification);
  }
}

double? extractAmountFromBody(String? body) {
  if (body == null) return null;
  final regex = RegExp(r"(\d+(?:[.,]\d+)?)\s*(?:FCFA|F)\b");
  final match = regex.firstMatch(body);
  if (match != null) {
    return double.tryParse(match.group(1)!.replaceAll(',', '.'));
  }
  return null;
}