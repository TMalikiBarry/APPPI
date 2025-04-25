import '../../domain/models/subscription.dart';
import '../../domain/models/subscription_command.dart';

/// Expose les services offerts dans la gestion des subscriptions
abstract class SubscriptionInputPort {
  //

  /// Rechercher les souscriptions
  Future<List<Subscription>> list({required String compte});

  /// Modifier la souscription
  Future<Subscription> update(String id, SubscriptionCommand command);

  /// Désactiver la souscription
  Future<Subscription> disable(Subscription transaction);

  /// Réactiver la souscription
  Future<Subscription> enable(Subscription transaction);

  /// Supprimer la souscription
  Future<void> delete(Subscription transaction);
}
