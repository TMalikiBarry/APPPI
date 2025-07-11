import '../../ports/input/notification_input_port.dart';
import '../../ports/output/notification_output_port.dart';
import '../models/notification.dart';
import '../models/notificationDTO.dart';
import '../models/notification_liste.dart';

class NotificationService implements NotificationInputPort {
  //
  final NotificationOutputPort notificationOutputPort;

  ///
  NotificationService(this.notificationOutputPort);

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
    return await notificationOutputPort.list(
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
    return notificationOutputPort.fetchNotifications();
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
  }) {
    return notificationOutputPort.search(
      compte: compte,
      limit: limit,
      sortBy: sortBy,
      fields: fields,
      dateDebut: dateDebut,
      dateFin: dateFin,
      types: types,
      page: page,
      keyword: keyword,
    );
  }

  @override
  Future<Notification> read(String id) async {
    return await notificationOutputPort.read(id);
  }

  /// Compter le nombre de notification non lue
  @override
  Future<int> count(String compte) async{
    return await notificationOutputPort.count(compte);
  }
}
