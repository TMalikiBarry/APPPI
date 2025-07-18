import 'dart:async';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api.dart';
import '../domain/models/notification.dart';
import '../domain/models/notificationDTO.dart';
import '../domain/models/notification_liste.dart';

/// Online repository
class NotificationOutputRemote {
  ///
  NotificationOutputRemote();

  ///
  final logger = Logger();

  Future<List<NotificationModel>> fetchNotifications() async {
    // 1. Récupération du phoneNumber en local
    final pref = await SharedPreferences.getInstance();
    final phone_number = pref.getString('phone_number') ?? '';
    if (phone_number.isEmpty) {
      throw Exception('Aucun phoneNumber en SharedPreferences');
    }

    // 2. Appel API sans queryParameters
    final resp = await Api.get('/notification/$phone_number');
    logger.i('← notifications() status=${resp.statusCode}');

    // 3. Extraction du tableau JSON
    final raw = resp.data['response'] as List<dynamic>?;
    if (raw == null) {
      throw Exception('notifications() retourné invalide: ${resp.data}');
    }

    // 4. Désérialisation et mapping
    final dtos = raw
        .cast<Map<String, dynamic>>()
        .map(NotificationDTO.fromJson)
        .toList();

    return dtos.map((dto) => dto.toModel()).toList();
  }

  /// Lister les notifications
  Future<NotificationListe> list({
    required String compte,
    int? page,
    int? limit,
    DateTime? dateDebut,
    DateTime? dateFin,
    required List<String> types,
    String? keyword,
    String? sortBy,
    String? fields,
  }) async {

    int xlimit = (limit== null || limit <25 ) ? 25: limit;

    int xpage = page ?? 0;
    final now    = DateTime.now();
    final start  = dateDebut ?? now.subtract(const Duration(days: 1000));
    final finish = dateFin   ?? now.add(const Duration(days: 1));
    final Map<String, dynamic> queryParameters = {
      if (page != null) 'page': xpage,
      'size': xlimit,
      if (sortBy != null) 'sortBy': sortBy,
      if (fields != null) 'fields': fields,
      if (dateDebut != null) 'dateDebut': start.toIso8601String(),
      if (dateFin != null) 'dateFin': finish.toIso8601String(),
      if (keyword != null) 'keyword': keyword,
      if (types.isNotEmpty) 'type[in]': types.join(','),
    };

    final pref = await SharedPreferences.getInstance();
    final phone_number = pref.getString('phone_number') ?? '';

    if (phone_number.isEmpty) {
      throw Exception('Aucun phoneNumber en SharedPreferences');
    }

    final ApiResponse response = await Api.get(
      '/notification/$phone_number',
      queryParameters: queryParameters,
    );
    var liste = NotificationListe.fromJson(response.data);
    // Sort by the most recents
    liste.data.sort((a, b) => b.dateAction!.compareTo(a.dateAction!));

    return liste;
  }

  /// Marquer Comme Lu la notification
  Future<Notification> read(String id) async {
    final ApiResponse response = await Api.put(
      '/notifications/$id',
      data: {
        "dateLecture": DateTime.now().toIso8601String(),
      },
    );
    return Notification.fromJson(response.data);
  }

  /// Compter le nombre de notifications non lues
  Future<int> count(String compte) async {
    final ApiResponse response = await Api.get(
      '/notifications/$compte/non-lues',
    );
    return int.parse(response.data["total"].toString());
  }
}
