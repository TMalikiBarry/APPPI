import 'dart:async';

import 'package:logger/logger.dart';

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
    final ApiResponse response = await Api.get(
      '/souscriptions/$compte',
    );
    return (response.data['data'] as List<dynamic>)
        .map((e) => Subscription.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Modifier une souscription
  Future<Subscription> update(
    String endToEndId,
    SubscriptionCommand command,
  ) async {
    // Schedule transfer
    final ApiResponse response = await Api.put(
      '/souscriptions/$endToEndId',
      data: command.toJson(),
    );
    //
    return Subscription.fromJson(response.data);
  }

  /// Désactiver une souscription
  Future<Subscription> disable(String endToEndId) async {
    // Schedule transfer
    final ApiResponse response = await Api.put(
      '/souscriptions/$endToEndId/desactivations',
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
      '/souscriptions/$endToEndId/reactivations',
    );
    //
    return Subscription.fromJson(response.data);
  }

  /// Supprimer une souscription
  Future<void> delete(String endToEndId) async {
    await Api.delete('/souscriptions/$endToEndId');
  }
}
