class TransactionVerificationResult {
  ///
  TransactionVerificationResult({
    this.msgId,
    this.endToEndId,
    this.resultatVerification,
    this.codeMembreParticipant,
    this.typeCompte,
    this.nomClient,
    this.villeClient,
    this.paysResidence,
    this.devise,
    this.typeClient,
  });

  /// Compte du client
  final String? msgId;
  final String? endToEndId;
  final String? resultatVerification;
  final String? codeMembreParticipant;
  final String? typeCompte;
  final String? nomClient;
  final String? villeClient;
  final String? paysResidence;
  final String? devise;
  final String? typeClient;

  Map<String, dynamic> toJson() {
    return {
      'msgId': msgId,
      'endToEndId': endToEndId,
      'resultatVerification': resultatVerification,
      'codeMembreParticipant': codeMembreParticipant,
      'typeCompte': typeCompte,
      'nomClient': nomClient,
      'villeClient': villeClient,
      'paysResidence': paysResidence,
      'devise': devise,
      'typeClient': typeClient
    };
  }

  static TransactionVerificationResult fromJson(Map<dynamic, dynamic> json) {

    return TransactionVerificationResult(
      // Champs directs
      msgId: json['msgId'] as String?,
      endToEndId: json['endToEndId'] as String?,
      resultatVerification: json['resultatVerification'] as String?,
      codeMembreParticipant: json['codeMembreParticipant'] as String?,
      typeCompte: json['typeCompte'] as String?,
      nomClient: json['nomClient'] as String?,
      villeClient: json['villeClient'] as String?,
      paysResidence: json['paysResidence'] as String?,
      devise: json['devise'] as String?,
      typeClient: json['typeClient'] as String?,
    );
  }
}