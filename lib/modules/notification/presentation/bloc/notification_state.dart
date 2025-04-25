import '../../../../core/notifications.dart';
import '../../domain/models/notification_liste.dart';
import '../../domain/models/notification_search_command.dart';

abstract class NotificationState {
  const NotificationState(this.notifications, this.count, this.command);

  final NotificationListe notifications;

  /// nombre de notifications non lues
  final int count;
  final NotificationSearchCommand command;
}

class NotificationInitialState extends NotificationState {
  const NotificationInitialState(
    super.notifications,
    super.count,
    super.command,
  );
}

final class NotificationLoadingState extends NotificationState {
  const NotificationLoadingState(
    super.notifications,
    super.count,
    super.command,
  );
}

final class NotificationToDisplayState extends NotificationState {
  const NotificationToDisplayState(
    super.notifications,
    super.count,
    super.command,
    this.event,
  );

  final NotificationExternalEvent event;
}

final class NotificationInAppState extends NotificationState {
  const NotificationInAppState(
    super.notifications,
    super.count,
    super.command,
    this.event,
  );

  final NotificationExternalEvent event;
}
