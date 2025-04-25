import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../core/notifications.dart';
import '../../../../shared/models/liste_meta.dart';
import '../../domain/models/notification.dart';
import '../../domain/models/notification_liste.dart';
import '../../domain/models/notification_search_command.dart';
import '../../domain/models/notification_search_filter.dart';
import '../../domain/models/notification_type.dart';
import '../../ports/input/notification_input_port.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  //
  final logger = Logger();

  //
  final NotificationInputPort pNotificationInputPort;
  StreamSubscription? aliasStreamSubscription;

  NotificationBloc(this.pNotificationInputPort)
      : super(
          NotificationInitialState(
            NotificationListe(
              data: [],
              meta: ListeMeta(total: 0, limit: 10),
            ),
            0,
            NotificationSearchCommand(filters: NotificationSearchFilter()),
          ),
        ) //
  {
    // Pour recuperer la liste
    on<NotificationListEvent>(_onNotificationListEvent);

    // Pour compter les notifications non lues
    on<NotificationCountEvent>(_onNotificationCountEvent);

    // Pour compter les notifications non lues
    on<NotificationDisplayEvent>(_onNotificationDisplayEvent);

    // Pour marquer une notification comme lue
    on<NotificationReadEvent>(_onNotificationReadEvent);

    // Pour paginer la liste des notifications
    on<NotificationSearchPaginateEvent>(_onNotificationSearchPaginateEvent);

    // Ecouter les notifications reçues pour les afficher
    on<NotificationInAppEvent>(_onNotificationInAppEvent);
    AppNotifications.eventStreamController.stream.listen((event) {
      if (event.type == NotificationType.rtpRecue.value &&
          event.idObject != null) {
        add(NotificationDisplayEvent(event));
      } else {
        add(NotificationInAppEvent(event));
      }
    });
  }

  Future<void> _onNotificationCountEvent(
    NotificationCountEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final unread = await count(event.compte);
      emit(NotificationInitialState(
        state.notifications,
        unread,
        state.command,
      ));
    } catch (e) {
      logger.e("Count notifications error", error: e);
    }
  }

  Future<void> _onNotificationDisplayEvent(
    NotificationDisplayEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationToDisplayState(
      state.notifications,
      state.count,
      state.command,
      event.event,
    ));
  }

  Future<void> _onNotificationReadEvent(
    NotificationReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await pNotificationInputPort.read(event.notification.id);
    } catch (e) {
      logger.e("Error on notification read", error: e);
    }
  }

  Future<void> _onNotificationInAppEvent(
    NotificationInAppEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationInAppState(
      state.notifications,
      state.count,
      state.command,
      event.event,
    ));
  }

  /// Quand on demande la liste des notifications
  Future<void> _onNotificationListEvent(
    NotificationListEvent event,
    Emitter<NotificationState> emit,
  ) async {
    // En cours de rechargement
    emit(NotificationLoadingState(
        state.notifications, state.count, event.command));

    // Appeler le service pour obtenir la liste
    NotificationSearchCommand command = event.command;

    // Rechercher d'abord en local et afficher
    final donneesLocales = await pNotificationInputPort.list(
      compte: command.compte!,
      limit: command.limit,
      dateDebut: command.filters.dateDebut,
      dateFin: command.filters.dateFin,
      types: command.filters.types,
      keyword: command.keyWord,
    );
    if (donneesLocales.data.isNotEmpty) {
      emit(NotificationInitialState(donneesLocales, state.count, command));
    }

    // On essai de lancer une requette vers le serveur pour mettre à jour la /base local et la vue
    final liste = await pNotificationInputPort.search(
      compte: command.compte!,
      limit: command.limit,
      dateDebut: command.filters.dateDebut,
      dateFin: command.filters.dateFin,
      types: command.filters.types,
      keyword: command.keyWord,
    );
    command.total = liste.meta.total;
    command.index = 0;

    final unread = await count(command.compte!);
    emit(NotificationInitialState(liste, unread, command));
  }

  Future<int> count(String compte) async {
    try {
      return await pNotificationInputPort.count(compte);
    } catch (e) {
      logger.e("Counter error");
      return 0;
    }
  }

  void _onNotificationSearchPaginateEvent(
    NotificationSearchPaginateEvent event,
    Emitter<NotificationState> emit,
  ) async {
    NotificationSearchCommand command = state.command;
    if (command.canLoadMore()) {
      NotificationListe oldListe = state.notifications;
      try {
        // Récupérer les notifications depuis le serveur
        final liste = await pNotificationInputPort.search(
          compte: command.compte!,
          limit: command.limit,
          dateDebut: command.filters.dateDebut,
          dateFin: command.filters.dateFin,
          types: command.filters.types,
          keyword: command.keyWord,
          page: event.index,
        );
        command.total = liste.meta.total;
        command.index = event.index;
        List<Notification> newNotifications = liste.data;

        if (newNotifications.isNotEmpty) {
          List<Notification> oldNotifications = oldListe.data;
          List<Notification> allNotifications = [
            ...oldNotifications,
            ...newNotifications,
          ];
          emit(NotificationInitialState(
            NotificationListe(data: allNotifications, meta: liste.meta),
            state.count,
            command,
          ));
        }
      } catch (e) {
        logger.e("Error on pagination", error: e);
      }
    }
  }
}
