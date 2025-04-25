import '../../../../core/notifications.dart';
import '../../domain/models/notification.dart';
import '../../domain/models/notification_search_command.dart';

abstract class NotificationEvent {
  const NotificationEvent();
}

class NotificationListEvent extends NotificationEvent {
  const NotificationListEvent(this.command);
  final NotificationSearchCommand command;
}

class NotificationSearchPaginateEvent extends NotificationEvent {
  NotificationSearchPaginateEvent(this.index);

  /// Index local de pagination
  final int index;
}

class NotificationReadEvent extends NotificationEvent {
  NotificationReadEvent({
    required this.notification,
  });
  Notification notification;
}

class NotificationCountEvent extends NotificationEvent {
  NotificationCountEvent(this.compte);
  final String compte;
}

class NotificationDisplayEvent extends NotificationEvent {
  const NotificationDisplayEvent(this.event);
  final NotificationExternalEvent event;
}

class NotificationInAppEvent extends NotificationEvent {
  const NotificationInAppEvent(this.event);
  final NotificationExternalEvent event;
}
