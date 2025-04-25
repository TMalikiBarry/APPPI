import '../../../../shared/models/liste_meta.dart';
import 'transaction.dart';

class TransactionListe {
  final List<Transaction> data;
  final ListeMeta meta;

  TransactionListe({
    required this.data,
    required this.meta,
  });

  factory TransactionListe.fromJson(Map<String, dynamic> json) {
    return TransactionListe(
      data: (json['data'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: ListeMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => data.isNotEmpty;

  void addTransactions(List<Transaction> transactions) {
    data.addAll(transactions);
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta.toJson(),
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
