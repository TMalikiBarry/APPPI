class TransactionVerificationResultOthr {
  ///
  TransactionVerificationResultOthr({
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
    this.ibanClient,
    this.numeroIdentification,
    this.systemeIdentification,
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

  final String? ibanClient;
  final String? numeroIdentification;
  final String? systemeIdentification;

  Map<String, dynamic> toJsonIban() {
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
      'typeClient': typeClient,
      'ibanClient': ibanClient,
      'numeroIdentification': numeroIdentification,
      'systemeIdentification': systemeIdentification,
    };
  }

  Map<String, dynamic> toJsonOthr() {
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
      'typeClient': typeClient,
    };
  }

  static TransactionVerificationResultOthr fromJson(
      Map<dynamic, dynamic> json) {
    return TransactionVerificationResultOthr(
      // Champs directs
      msgId: json['msgId'] as String?,
      endToEndId: json['endToEndId'] as String?,
      resultatVerification: json['resultatVerification'] as String?,
      ibanClient: json['ibanClient'] as String?,
      codeMembreParticipant: json['codeMembreParticipant'] as String?,
      typeCompte: json['typeCompte'] as String?,
      nomClient: json['nomClient'] as String?,
      villeClient: json['villeClient'] as String?,
      numeroIdentification: json['numeroIdentification'] as String?,
      systemeIdentification: json['systemeIdentification'] as String?,
      paysResidence: json['paysResidence'] as String?,
      devise: json['devise'] as String?,
      typeClient: json['typeClient'] as String?,
    );
  }
}
