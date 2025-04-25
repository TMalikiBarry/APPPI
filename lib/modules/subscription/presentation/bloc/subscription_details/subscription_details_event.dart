import '../../../../categorie/domain/models/categorie.dart';
import '../../../domain/models/subscription.dart';

abstract class SubscriptionDetailsEvent {
  const SubscriptionDetailsEvent();
}

class SubscriptionDetailsFetchEvent extends SubscriptionDetailsEvent {
  final Subscription subscription;
  const SubscriptionDetailsFetchEvent(this.subscription);
}

class SubscriptionDetailsCategorieUpdateEvent extends SubscriptionDetailsEvent {
  final Subscription subscription;
  final Categorie categorie;
  const SubscriptionDetailsCategorieUpdateEvent(
    this.subscription,
    this.categorie,
  );
}

class SubscriptionDetailsNoteUpdateEvent extends SubscriptionDetailsEvent {
  final String note;
  const SubscriptionDetailsNoteUpdateEvent(this.note);
}

class SubscriptionDetailsDisableEvent extends SubscriptionDetailsEvent {
  final Subscription subscription;
  const SubscriptionDetailsDisableEvent(this.subscription);
}

class SubscriptionDetailsEnableEvent extends SubscriptionDetailsEvent {
  final Subscription subscription;
  const SubscriptionDetailsEnableEvent(this.subscription);
}

class SubscriptionDetailsDeleteEvent extends SubscriptionDetailsEvent {
  final Subscription subscription;
  const SubscriptionDetailsDeleteEvent(this.subscription);
}
