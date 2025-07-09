class TransactionVerificationResultAlias {
  ///
  TransactionVerificationResultAlias({
    this.alias,
    this.endToEndId,
    this.clientCategory,
    this.clientPhoneNumber,
    this.participant,
    this.clientName,
    this.other,
    this.clientResidenceCountry,
    this.accountType,
    this.aliasType,
    this.creationDate,
    this.modificationDate,
    this.preConfirmation = false,
  });

  /// Compte du client
  final String? alias;
  final String? endToEndId;
  final String? clientCategory;
  final String? clientPhoneNumber;
  final String? participant;
  final String? clientName;
  final String? other;
  final String? clientResidenceCountry;
  final String? accountType;
  final String? aliasType;
  final String? creationDate;
  final String? modificationDate;
  final bool preConfirmation;

  Map<String, dynamic> toJson() {
    return {
      'alias': alias,
      'endToEndId': endToEndId,
      'clientCategory': clientCategory,
      'clientPhoneNumber': clientPhoneNumber,
      'participant': participant,
      'clientName': clientName,
      'other': other,
      'clientResidenceCountry': clientResidenceCountry,
      'accountType': accountType,
      'aliasType': aliasType,
      'creationDate': creationDate,
      'modificationDate': modificationDate,
      'preConfirmation': preConfirmation,
    };
  }

  static TransactionVerificationResultAlias fromJson(
      Map<dynamic, dynamic> json) {
    return TransactionVerificationResultAlias(
      // Champs directs
      alias: json['alias'] as String?,
      endToEndId: json['endToEndId'] as String?,
      clientCategory: json['clientCategory'] as String?,
      clientPhoneNumber: json['clientPhoneNumber'] as String?,
      participant: json['participant'] as String?,
      clientName: json['clientName'] as String?,
      other: json['other'] as String?,
      clientResidenceCountry: json['clientResidenceCountry'] as String?,
      accountType: json['accountType'] as String?,
      aliasType: json['aliasType'] as String?,
      creationDate: json['creationDate'] as String?,
      modificationDate: json['modificationDate'] as String?,
      preConfirmation: json['preConfirmation'] as bool,
    );
  }
}
