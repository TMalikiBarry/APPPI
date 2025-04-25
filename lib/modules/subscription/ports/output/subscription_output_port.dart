import '../../domain/models/subscription.dart';
import '../../domain/models/subscription_command.dart';

/// Interagir avec le système de sauvegarde des paiements programmés
abstract class SubscriptionOutputPort {
  //
  /// Lister des paiements programmés
  Future<List<Subscription>> list({required String compte});

  /// Modifier la souscription
  Future<Subscription> update(String id, SubscriptionCommand command);

  /// Désactiver la souscription
  Future<Subscription> disable(String id);

  /// Réactiver la souscription
  Future<Subscription> enable(String id);

  /// Supprimer la souscription
  Future<void> delete(String id);
}
