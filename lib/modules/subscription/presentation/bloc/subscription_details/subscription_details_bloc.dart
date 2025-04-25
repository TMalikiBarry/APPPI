import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../transactions/domain/models/transaction_send/transaction_send_command_motif.dart';
import '../../../../transactions/ports/input/transaction_input_port.dart';
import '../../../domain/models/subscription.dart';
import '../../../domain/models/subscription_command.dart';
import '../../../ports/input/subscription_input_port.dart';
import 'subscription_details_event.dart';
import 'subscription_details_state.dart';

class SubscriptionDetailsBloc
    extends Bloc<SubscriptionDetailsEvent, SubscriptionDetailsState> {
  //
  final logger = Logger();

  //
  final TransactionInputPort transactionInputPort;
  final SubscriptionInputPort subscriptionInputPort;
  final Subscription subscription;

  SubscriptionDetailsBloc(
    this.transactionInputPort,
    this.subscriptionInputPort,
    this.subscription,
  ) : super(SubscriptionDetailsInitialState(subscription)) {
    // Modifier la catégorie
    on<SubscriptionDetailsCategorieUpdateEvent>(
        _onSubscriptionDetailsCategorieUpdateEvent);

    // Modifier la catégorie
    on<SubscriptionDetailsNoteUpdateEvent>(
        _onSubscriptionDetailsNoteUpdateEvent);
    // Désactiver
    on<SubscriptionDetailsDisableEvent>(_onSubscriptionDetailsDisableEvent);
    // Réactiver
    on<SubscriptionDetailsEnableEvent>(_onSubscriptionDetailsEnableEvent);
    // Supprimer
    on<SubscriptionDetailsDeleteEvent>(_onSubscriptionDetailsDeleteEvent);
  }

  /// Pour mettre à jour la catégorie de souscription
  Future<void> _onSubscriptionDetailsCategorieUpdateEvent(
    SubscriptionDetailsCategorieUpdateEvent event,
    Emitter<SubscriptionDetailsState> emit,
  ) async {
    Subscription tx = await subscriptionInputPort.update(
      event.subscription.endToEndId,
      SubscriptionCommand(categorie: event.categorie.id),
    );
    emit(SubscriptionDetailsInitialState(tx));
  }

  /// Pour mettre à jour la note
  Future<void> _onSubscriptionDetailsNoteUpdateEvent(
    SubscriptionDetailsNoteUpdateEvent event,
    Emitter<SubscriptionDetailsState> emit,
  ) async {
    Subscription tx = await subscriptionInputPort.update(
      state.subscription.endToEndId,
      SubscriptionCommand(
        motif: TransactionSendCommandMotif(value: event.note),
      ),
    );
    emit(SubscriptionDetailsInitialState(tx));
  }

  /// Pour désactiver la souscription
  Future<void> _onSubscriptionDetailsDisableEvent(
    SubscriptionDetailsDisableEvent event,
    Emitter<SubscriptionDetailsState> emit,
  ) async {
    emit(SubscriptionDetailsLoadingState(event.subscription));
    Subscription tx = await subscriptionInputPort.disable(event.subscription);
    emit(SubscriptionDetailsInitialState(tx));
  }

  /// Pour réactiver la souscription
  Future<void> _onSubscriptionDetailsEnableEvent(
    SubscriptionDetailsEnableEvent event,
    Emitter<SubscriptionDetailsState> emit,
  ) async {
    emit(SubscriptionDetailsLoadingState(event.subscription));
    Subscription tx = await subscriptionInputPort.enable(event.subscription);
    emit(SubscriptionDetailsInitialState(tx));
  }

  /// Pour supprimer la souscription
  Future<void> _onSubscriptionDetailsDeleteEvent(
    SubscriptionDetailsDeleteEvent event,
    Emitter<SubscriptionDetailsState> emit,
  ) async {
    emit(SubscriptionDetailsLoadingState(event.subscription));
    await subscriptionInputPort.delete(event.subscription);
    emit(SubscriptionDetailsDeletedState(event.subscription));
  }
}
