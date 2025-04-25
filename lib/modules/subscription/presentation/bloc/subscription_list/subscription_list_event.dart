import '../../../domain/models/subscription.dart';

abstract class SubscriptionListEvent {
  const SubscriptionListEvent();
}

class SubscriptionListFetchEvent extends SubscriptionListEvent {
  const SubscriptionListFetchEvent(this.compte);
  final String compte;
}

class SubscriptionListRefreshEvent extends SubscriptionListEvent {
  const SubscriptionListRefreshEvent(this.compte, this.liste);
  final String compte;
  final List<Subscription> liste;
}
