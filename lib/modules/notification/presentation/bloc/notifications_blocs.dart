// events.dart
import '../../domain/models/notificationDTO.dart';

abstract class NotificationEvent {
  const NotificationEvent();
}

class NotificationListRequest extends NotificationEvent {
  final String phoneNumber;
  const NotificationListRequest(this.phoneNumber);
}

// states.dart
abstract class NotificationState {
  const NotificationState();
}
class NotificationInitial   extends NotificationState {}
class NotificationLoading   extends NotificationState {}
class NotificationLoaded    extends NotificationState {
  final List<NotificationModel> notifications;
  const NotificationLoaded(this.notifications);
}
class NotificationEmpty     extends NotificationState {}

class NotificationError     extends NotificationState {
  final String message;
  const NotificationError(this.message);
}