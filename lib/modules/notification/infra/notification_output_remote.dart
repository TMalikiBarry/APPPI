import 'dart:async';

import 'package:logger/logger.dart';
import 'package:pi_mobile_app/modules/security/domain/models/connected_user.dart';
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
    var alias = ConnectedUser.current?.alias;
    if (alias != null){
      alias = ConnectedUser.current?.alias;
    } else {
      alias = phone_number;
    }
    logger.i('← notifications() status=/notification/$alias?type=ALIAS');

    // 2. Appel API sans queryParameters
    final resp = ConnectedUser.current?.shid != null
        ? await Api.get('/notification/$alias?type=ALIAS&shid=${ConnectedUser.current?.shid}')
        : await Api.get('/notification/$alias?type=ALIAS');
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

    int xlimit = (limit== null || limit <2 ) ? 2: limit;

    int xpage = page ?? 0;
    final now    = DateTime.now();
    final start  = dateDebut ?? now.subtract(const Duration(days: 1000));
    final finish = dateFin   ?? now.add(const Duration(days: 1));
    final Map<String, dynamic> queryParameters = {
      'page': xpage,
      'size': xlimit,
      /*if (sortBy != null) 'sortBy': sortBy,
      if (fields != null) 'fields': fields,
      if (dateDebut != null) 'dateDebut': start.toIso8601String(),
      if (dateFin != null) 'dateFin': finish.toIso8601String(),
      if (keyword != null) 'keyword': keyword,
      if (types.isNotEmpty) 'type[in]': types.join(','),*/
    };

    final pref = await SharedPreferences.getInstance();
    final phone_number = pref.getString('phone_number') ?? '';
    var alias = ConnectedUser.current?.alias;
    if (alias != null){
      alias = ConnectedUser.current?.alias;
    } else {
      alias = phone_number;
    }
    var url = ConnectedUser.current?.shid != null
      ? '/notification/$alias?type=ALIAS&shid=${ConnectedUser.current?.shid}'
      : '/notification/$alias?type=ALIAS';
    logger.i('← notifications() url : $url');

    final ApiResponse response = await Api.get(
      url,
      queryParameters: queryParameters,
    );

    // 2) Log pour debug
    logger.w('← notifications() queryParameters= ${queryParameters.toString()}');
    logger.w('← notifications() le response= ${response.toString()}');
    logger.w('← notifications() status=${response.statusCode}');
    logger.i('← notifications() data=${response.data}');

    // logger.i("#### this is the value of accountNumber $issuerAccount");
    logger.i("#### this is the value of phoneNumber ${pref.getString("phoneNumber")}");
    logger.i("#### this is the value of phone_number ${pref.getString("phone_number")}");
    var liste = NotificationListe.fromJson(response.data);
    // Sort by the most recents
    liste.data.sort((a, b) {
      // Cas 1 : comparer sur dateAction si dispo
      if (a.dateAction != null && b.dateAction != null) {
        return b.dateAction!.compareTo(a.dateAction!); // tri décroissant
      }
      if (a.dateAction != null) return -1; // a avant b
      if (b.dateAction != null) return 1;  // b avant a

      // Cas 2 : si pas de dateAction, comparer sur timestamp
      if (a.timestamp != null && b.timestamp != null) {
        return b.timestamp!.compareTo(a.timestamp!); // tri décroissant
      }
      if (a.timestamp != null) return -1; // a avant b
      if (b.timestamp != null) return 1;  // b avant a

      // Cas 3 : égalité si rien
      return 0;
    });

    return liste;
  }

  /// Marquer Comme Lu la notification
  Future<Notification> read(String id) async {
    final ApiResponse response = await Api.put(
      '/notification/$id',
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
