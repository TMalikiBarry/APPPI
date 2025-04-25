import '../../../core/storage.dart';
import '../domain/models/subscription.dart';

class SubscriptionOutputLocal {
  ///
  const SubscriptionOutputLocal();

  ///
  static const String collectionId = "subscriptions";

  /// Lister les subscriptions à partir des données en local
  Future<List<Subscription>> list({
    required String compte,
    int? page,
    int? limit,
    DateTime? dateDebut,
    DateTime? dateFin,
    List<String> types = const [],
    String? keyword,
    String? sortBy,
    String? fields,
  }) async {
    return await AppStorage.list<Subscription>(
      collectionId,
      (json) => Subscription.fromJson(json),
    );
  }

  /// Ecoute sur les changements de la liste
  Future<Stream<List<Subscription>>> stream() async {
    return await AppStorage.streamList(
      collectionId,
      Subscription.fromJson,
    );
  }

  /// Enregistre une subscription dans la base locale
  Future<void> save(Subscription subscription) async {
    await AppStorage.save(
      collectionId,
      subscription.endToEndId,
      subscription.toJson(),
    );
  }

  /// MAJ une subscription dans la base locale
  Future<void> patch(Subscription subscription) async {
    await AppStorage.patch(
      collectionId,
      subscription.endToEndId,
      subscription.toJson(),
    );
  }

  /// Recuperer une subscription
  Future<Subscription> get(String reference) async {
    return await AppStorage.get(collectionId, reference, Subscription.fromJson);
  }

  /// Ajouter des données à une subscription
  Future<void> add(String id, Map<String, dynamic> datas) async {
    await AppStorage.patch(collectionId, id, datas);
  }

  /// Supprimer des données en local
  Future<void> delete(String id) async {
    await AppStorage.delete(collectionId, id);
  }
}
