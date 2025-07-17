import '../../../core/storage.dart';
import '../../../shared/models/liste_meta.dart';
import '../domain/models/notification.dart';
import '../domain/models/notification_liste.dart';

class NotificationOutputLocal {
  ///
  const NotificationOutputLocal();

  ///
  static const String collectionId = "notifications";

  /// Lister les notifications à partir des données en local
  Future<NotificationListe> list({
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
    //
    // Retrieve collection
    List<Notification> notifications = await AppStorage.list<Notification>(
      collectionId,
      (json) => Notification.fromJson(json),
    );

    // Trier du plus récent au plus ancien
    notifications.sort((a, b) => b.dateAction!.compareTo(a.dateAction!));

    // Filter by type
    if (types.isNotEmpty) {
      notifications =
          notifications.where((notif) => types.contains(notif.type)).toList();
    }

    // Filter by date
    if (dateDebut != null) {
      notifications = notifications
          .where((tx) => tx.dateAction!.compareTo(dateDebut) >= 0)
          .toList();
    }
    if (dateFin != null) {
      notifications = notifications
          .where((tx) => tx.dateAction!.compareTo(dateFin) <= 0)
          .toList();
    }

    // Filter by keyword
    if (keyword != null && keyword.trim().isNotEmpty) {
      notifications = notifications
          .where((tx) =>
              tx.toString().toLowerCase().indexOf(keyword.toLowerCase()) > 0)
          .toList();
    }

    // Return nb items requested
    if (limit != null && limit < notifications.length) {
      List<Notification> donnees = notifications.take(limit).toList();
      return NotificationListe(
        data: donnees,
        meta: ListeMeta(total: notifications.length, limit: limit),
      );
    } //
    else {
      return NotificationListe(
        data: notifications,
        meta: ListeMeta(
          total: notifications.length,
          limit: notifications.length,
        ),
      );
    }
  }

  /// Enregistre une notification dans la base locale
  Future<void> save(Notification notification) async {
    await AppStorage.save(
      collectionId,
      notification.id!,
      notification.toJson(),
    );
  }

  /// MAJ une transaction dans la base locale
  Future<void> patch(Notification notification) async {
    await AppStorage.patch(
      collectionId,
      notification.id!,
      notification.toJson(),
    );
  }
}
