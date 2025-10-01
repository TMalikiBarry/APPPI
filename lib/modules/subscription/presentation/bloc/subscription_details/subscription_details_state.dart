import '../../../domain/models/subscription.dart';

abstract class SubscriptionDetailsState {
  final Subscription subscription;
  const SubscriptionDetailsState(this.subscription);
}

class SubscriptionDetailsInitialState extends SubscriptionDetailsState {
  const SubscriptionDetailsInitialState(super.subscription);
}

class SubscriptionDetailsLoadingState extends SubscriptionDetailsState {
  const SubscriptionDetailsLoadingState(super.subscription);
}

class SubscriptionDetailsDeletedState extends SubscriptionDetailsState {
  const SubscriptionDetailsDeletedState(super.subscription);
}

/// Subcription action échouée
class SubcriptionActionState extends SubscriptionDetailsState {
  final String action;
  SubcriptionActionState(super.subscription, this.action);
}