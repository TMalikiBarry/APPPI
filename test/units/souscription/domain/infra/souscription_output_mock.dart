import 'package:pi_mobile_app/modules/subscription/domain/models/subscription.dart';
import 'package:pi_mobile_app/modules/subscription/domain/models/subscription_command.dart';
import 'package:pi_mobile_app/modules/subscription/ports/output/subscription_output_port.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction.dart';

class MockSouscriptionOutputPort implements SubscriptionOutputPort {

  @override
  Future<void> delete(String id) async {
    
  }

  @override
  Future<Subscription> disable(String id) async {
    return Subscription(
      endToEndId: "Esnfbg566",
      clientNom: "Mariam",
      clientPays: "SN",
      montant: 100,
      sens: TransactionSens.credit,
      compte: 'C2345454'
      );
  }

  @override
  Future<Subscription> enable(String id) async {
    return Subscription(
      endToEndId: "Esnfbg566",
      clientNom: "Mariam",
      clientPays: "SN",
      montant: 100,
      sens: TransactionSens.credit,
      compte: 'C2345454'
      );
  }
  @override
  Future<List<Subscription>> list({required String compte}) async {
    return [
      Subscription(
      endToEndId: "Esnfbg566",
      clientNom: "Mariam",
      clientPays: "SN",
      montant: 100,
      sens: TransactionSens.credit, 
      compte: 'C2345454'
      ),
      Subscription(
      endToEndId: "Esnfbg000",
      clientNom: "SORO",
      clientPays: "CI",
      montant: 100,
      sens: TransactionSens.debit,
      compte: 'C20000454'
      )
    ];
  }

  @override
  Future<Subscription> update(String id, SubscriptionCommand command) async {
    return Subscription(
      endToEndId: "Esnfbg566",
      clientNom: "Mariam",
      clientPays: "SN",
      montant: 100,
      sens: TransactionSens.credit,
      compte: 'C2345454'
      );
  }
  
}
