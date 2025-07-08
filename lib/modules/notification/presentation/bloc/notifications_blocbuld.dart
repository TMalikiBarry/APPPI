import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ports/input/notification_input_port.dart';
import 'notifications_blocs.dart';

class NotificationBloc
    extends Bloc<NotificationEvent, NotificationState> {
  final NotificationInputPort interactor;

  NotificationBloc(this.interactor): super(NotificationInitial()) {
    on<NotificationListRequest>(_onListRequest);
  }

  Future<void> _onListRequest(
      NotificationListRequest event,
      Emitter<NotificationState> emit,
      ) async {
    emit(NotificationLoading());
    try {
      final list = await interactor.fetchNotifications();
      if (list.isEmpty) {
        emit(NotificationEmpty());
      } else {
        emit(NotificationLoaded(list));
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
