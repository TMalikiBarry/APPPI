import 'package:logger/logger.dart';
import '../domain/models/notificationDTO.dart';
import 'notification_output_local.dart';

import '../domain/models/notification.dart';
import '../domain/models/notification_liste.dart';
import '../ports/output/notification_output_port.dart';
import 'notification_output_remote.dart';

/// Online repository
class NotificationOutputRepository implements NotificationOutputPort {
  ///
  NotificationOutputRepository();

  ///
  final logger = Logger();

  final NotificationOutputRemote repoRemote = NotificationOutputRemote();

  /// Pour enregistrer les données localement
  /// Si c'était une base firestore qui est utilisée et non une API
  /// On n'aurez pas besoin de gérer le mode Offline nous même
  final NotificationOutputLocal repoLocal = const NotificationOutputLocal();

  @override
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
    return await repoLocal.list(
        compte: compte,
        page: page,
        limit: limit,
        dateDebut: dateDebut,
        dateFin: dateFin,
        types: types,
        keyword: keyword,
        sortBy: sortBy,
        fields: fields);
  }

  @override
  Future<List<NotificationModel>> fetchNotifications() async {
    return repoRemote.fetchNotifications();
  }

  @override
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
  }) async {
    NotificationListe result = await repoRemote.list(
        compte: compte,
        page: page,
        limit: limit,
        sortBy: sortBy,
        fields: fields,
        types: types,
        dateDebut: dateDebut,
        dateFin: dateFin,
        keyword: keyword);

    _updateLocal(result.data);

    return result;
  }

  /// Récupère les données à distance et MAJ la base locale
  void _updateLocal(List<Notification> notifications) {
    for (var tx in notifications) {
      repoLocal.patch(tx);
    }
  }

  @override
  Future<Notification> read(String id) async {
    final reponse = await repoRemote.read(id);
    repoLocal.patch(reponse);
    return reponse;
  }

  @override
  Future<int> count(String compte) async{
    return await repoRemote.count(compte);
  }
}
