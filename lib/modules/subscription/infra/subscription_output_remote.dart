import 'dart:async';

import 'package:logger/logger.dart';
import 'package:pi_mobile_app/modules/security/domain/models/connected_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api.dart';
import '../domain/models/subscription.dart';
import '../domain/models/subscription_command.dart';

/// Online repository
class SubscriptionOutputRemote {
  ///
  SubscriptionOutputRemote();

  ///
  final logger = Logger();

  /// Lister les souscriptions
  Future<List<Subscription>> list({required String compte}) async {
    final pref = await SharedPreferences.getInstance();
    final phone_number = pref.getString('phone_number') ?? '';
    var alias = ConnectedUser.current?.alias;
    if (alias != null){
      alias = ConnectedUser.current?.alias;
    } else {
      alias = phone_number;
    }
    final now    = DateTime.now();
    final start  = now.subtract(const Duration(days: 2000));
    final finish = now.add(const Duration(days: 1));

    final qs = {
      'startDate': start.toIso8601String().split('T').first,
      'endDate'  : finish.toIso8601String().split('T').first,
    };
    logger.i('/movement/schedule/history');
    logger.i(qs);

    try {
      final ApiResponse response = await Api.get(
        '/movement/schedule/history',
        queryParameters: qs,
      );
      List<Subscription> subscriptions = (response.data['response'] as List<dynamic>)
          .map((e) => Subscription.fromJson(e as Map<String, dynamic>))
          .toList();

      return subscriptions;
    }
    on ApiException catch (e) {
      logger.i("${e.statusCode} ${e.message} ${e.name} ${e.error} ${e.problem}");
      throw ApiException(error: e.error, statusCode: e.statusCode);
    }
    catch (e) {
      logger.i(e.toString());
      // Handle empty response appropriately
      throw ApiException(error: ApiError.internalServerError, statusCode: 500);
    }
  }

  /// Modifier une souscription
  Future<Subscription> update(
    String endToEndId,
    SubscriptionCommand command,
  ) async {
    // Schedule transfer
    final ApiResponse response = await Api.put(
      '/movement/schedule/$endToEndId',
      data: command.toJson(),
    );
    //
    return Subscription.fromJson(response.data);
  }

  /// Désactiver une souscription
  Future<Subscription> disable(String endToEndId) async {
    // Schedule transfer
    final ApiResponse response = await Api.put(
      '/movement/schedule/$endToEndId/desactivations',
    );
    //
    return Subscription.fromJson(response.data);
  }

  /// Réactiver une souscription
  Future<Subscription> enable(
    String endToEndId,
  ) async {
    // Schedule transfer
    final ApiResponse response = await Api.put(
      '/movement/schedule/$endToEndId/reactivations',
    );
    //
    return Subscription.fromJson(response.data);
  }

  /// Supprimer une souscription
  Future<void> delete(String endToEndId) async {
    try {
      await Api.delete('/movement/schedule/$endToEndId');
    } catch (e) {
      //logger.i("delete souscription");
      //logger.i(e.toString());
    }
  }
}
