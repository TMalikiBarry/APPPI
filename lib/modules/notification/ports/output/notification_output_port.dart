import '../../domain/models/notification.dart';
import '../../domain/models/notificationDTO.dart';
import '../../domain/models/notification_liste.dart';

/// Interagir avec le système de sauvegarde des notification
abstract class NotificationOutputPort {
  /// Rechercher des notifications depuis la base de donnés local
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
  });

  Future<List<NotificationModel>> fetchNotifications();

  /// Rechercher des notifications depuis le serveur
  Future<NotificationListe> search({
    required String compte,
    int? page,
    int? limit,
    DateTime? dateDebut,
    DateTime? dateFin,
    List<String> types = const [],
    String? keyword,
    String? sortBy,
    String? fields,
  });

  /// Accuser reception de la notification
  Future<Notification> read(String id);

  /// Compter le nombre de notification non lue
  Future<int> count(String compte);
}
