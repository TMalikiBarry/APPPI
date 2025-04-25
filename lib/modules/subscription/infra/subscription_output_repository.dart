import 'package:logger/logger.dart';

import '../domain/models/subscription.dart';
import '../domain/models/subscription_command.dart';
import '../ports/output/subscription_output_port.dart';
import 'subscription_output_local.dart';
import 'subscription_output_remote.dart';

/// Subscription repository
class SubscriptionOutputRepository implements SubscriptionOutputPort {
  ///
  SubscriptionOutputRepository();

  ///
  final logger = Logger();
  final SubscriptionOutputRemote repoRemote = SubscriptionOutputRemote();
  final SubscriptionOutputLocal repoLocal = const SubscriptionOutputLocal();

  @override
  Future<List<Subscription>> list({required String compte}) async {
    List<Subscription> subscriptions = await repoRemote.list(compte: compte);
    for (var tx in subscriptions) {
      repoLocal.patch(tx);
    }
    return subscriptions;
  }

  @override
  Future<Subscription> update(String id, SubscriptionCommand command) async {
    if (command.categorie != null) {
      await repoLocal.add(id, command.toJson());
      return await repoLocal.get(id);
    } else {
      Subscription tx = await repoRemote.update(id, command);
      repoLocal.patch(tx);
      return tx;
    }
  }

  @override
  Future<Subscription> disable(String id) async {
    Subscription transaction = await repoRemote.disable(id);
    await repoLocal.save(transaction);
    return transaction;
  }

  @override
  Future<Subscription> enable(String id) async {
    Subscription transaction = await repoRemote.enable(id);
    await repoLocal.save(transaction);
    return transaction;
  }

  @override
  Future<void> delete(String id) async {
    await repoRemote.delete(id);
    repoLocal.delete(id);
  }
}
