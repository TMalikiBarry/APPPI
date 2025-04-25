enum TransactionSens { debit, credit }

class TransactionSendResponse {
  ///
  TransactionSendResponse({
    required this.endToEndId,
    required this.statut,
    this.dateIrrevocabilite,
    this.codeRejet,
  });

  final String endToEndId;
  final String statut;
  final DateTime? dateIrrevocabilite; // Date d'irrévocabilité
  final String? codeRejet;

  factory TransactionSendResponse.fromJson(Map<dynamic, dynamic> json) {
    return TransactionSendResponse(
      endToEndId: json['endToEndId'] as String,
      statut: json['statut'] as String,
      codeRejet: json['codeRejet'] as String?,
      dateIrrevocabilite: json['dateIrrevocabilite'] != null
          ? DateTime.parse(json['dateIrrevocabilite'] as String)
          : null,
    );
  }
}
