import '../../../../shared/models/liste_meta.dart';
import 'transaction.dart';

class TransactionListe {
  final List<Transaction> data;
  final ListeMeta meta;

  /// NOUVEAU : pour piloter l’affichage d’erreur en UI
  final int? httpStatusCode;
  final String? httpMessage;
  final int? httpStatus;

  TransactionListe({
    required this.data,
    required this.meta,
    this.httpStatusCode,
    this.httpMessage,
    this.httpStatus,
  });

  factory TransactionListe.fromJson(Map<String, dynamic> json, {
    int? httpStatusCode,
    String? httpMessage,
    int? httpStatus,
  }) {
    return TransactionListe(
      data: (json['data'] as List)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: ListeMeta.fromJson(json['meta'] as Map<String, dynamic>),
      httpStatusCode: httpStatusCode,
      httpMessage: httpMessage,
      httpStatus: httpStatus,
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.map((e) => e.toJson()).toList(),
    'meta': meta.toJson(),
    // les champs http* ne sont pas renvoyés au serveur
  };

  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => data.isNotEmpty;

  void addTransactions(List<Transaction> transactions) {
    data.addAll(transactions);
  }
}
