import '../../ports/input/subscription_input_port.dart';
import '../../ports/output/subscription_output_port.dart';
import '../models/subscription.dart';
import '../models/subscription_command.dart';

class SubscriptionService implements SubscriptionInputPort {
  //
  final SubscriptionOutputPort subscriptionOutputPort;

  ///
  SubscriptionService(this.subscriptionOutputPort);

  @override
  Future<List<Subscription>> list({required String compte}) async {
    return await subscriptionOutputPort.list(compte: compte);
  }

  @override
  Future<Subscription> update(String id, SubscriptionCommand command) async {
    return await subscriptionOutputPort.update(id, command);
  }

  @override
  Future<void> delete(Subscription transaction) async {
    await subscriptionOutputPort.delete(transaction.endToEndId);
  }

  @override
  Future<Subscription> disable(Subscription transaction) async {
    return await subscriptionOutputPort.disable(transaction.endToEndId);
  }

  @override
  Future<Subscription> enable(Subscription transaction) async {
    return await subscriptionOutputPort.enable(transaction.endToEndId);
  }
}
