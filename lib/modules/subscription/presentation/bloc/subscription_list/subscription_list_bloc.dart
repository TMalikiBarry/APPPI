import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../domain/models/subscription.dart';
import '../../../ports/input/subscription_input_port.dart';
import 'subscription_list_event.dart';
import 'subscription_list_state.dart';

class SubscriptionListBloc
    extends Bloc<SubscriptionListEvent, SubscriptionListState> {
  //
  final logger = Logger();

  //
  final SubscriptionInputPort pSubscriptionInputPort;

  SubscriptionListBloc(this.pSubscriptionInputPort)
      : super(const SubscriptionListLoadingState([], null)) {
    // Pour recuperer la liste
    on<SubscriptionListFetchEvent>(_onSubscriptionListFetchEvent);
    // Refresh list
    on<SubscriptionListRefreshEvent>(_onSubscriptionListRefreshEvent);
  }

  /// Quand on demande la liste des transactions
  Future<void> _onSubscriptionListFetchEvent(
    SubscriptionListFetchEvent event,
    Emitter<SubscriptionListState> emit,
  ) async {
    // Récuperer la liste
    List<Subscription> liste = await pSubscriptionInputPort.list(
      compte: event.compte,
    );
    emit(SubscriptionListDisplayState(liste, event.compte));
  }

  /// Quand la liste est mise à jour
  Future<void> _onSubscriptionListRefreshEvent(
    SubscriptionListRefreshEvent event,
    Emitter<SubscriptionListState> emit,
  ) async {
    // Retourner la liste
    emit(SubscriptionListDisplayState(event.liste, event.compte));
  }
}
