import '../../../domain/models/subscription.dart';

abstract class SubscriptionListState {
  const SubscriptionListState(this.subscriptions, this.compte);

  final List<Subscription> subscriptions;
  final String? compte;
}

final class SubscriptionListLoadingState extends SubscriptionListState {
  const SubscriptionListLoadingState(super.subscriptions, super.compte);
}

class SubscriptionListDisplayState extends SubscriptionListState {
  const SubscriptionListDisplayState(super.subscriptions, super.compte);
}
