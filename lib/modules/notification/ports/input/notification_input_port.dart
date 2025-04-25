import '../../domain/models/notification.dart';
import '../../domain/models/notification_liste.dart';

/// Expose les services offerts dans la gestion des notifications
abstract class NotificationInputPort {
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
