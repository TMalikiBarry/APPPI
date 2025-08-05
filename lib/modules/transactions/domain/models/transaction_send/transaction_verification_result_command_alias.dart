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
    this.aliasCreationId,
    this.clientNationality,
    this.companyCategory,
    this.companyName,
    this.taxIdentification,
    this.corporateName,
    this.rccmIdentification,
    this.clientEmail,
    this.clientAddress,
    this.clientPostalCode,
    this.modifiedPostalCode,
    this.nationalIdentification,
    this.aliasValue,
    this.clientBirthDate,
    this.passportNumber,
    this.clientGender,
    this.clientBirthCountry,
    this.clientBirthCity,
    this.clientCity,
    this.motherName,
    this.activityCode,
    this.iban,
    this.accountOpeningDate,
    this.clientPhoto,
    this.deletionReason,
    this.status,
    this.rejectionReason,
    this.additionalInformation,
    this.shid,
    this.type,
    this.modifiedAliasBody,
    this.callbackURL,
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



  final String? aliasCreationId;
  final String? clientNationality;
  final String? companyName;
  final String? corporateName;
  final String? taxIdentification;
  final String? rccmIdentification;
  final String? clientEmail;
  final String? clientAddress;
  final String? clientPostalCode;
  final String? modifiedPostalCode;
  final String? nationalIdentification;
  final String? passportNumber;
  final String? clientGender;
  final String? clientBirthDate;
  final String? clientBirthCountry;
  final String? clientBirthCity;
  final String? clientCity;
  final String? motherName;
  final String? companyCategory;
  final String? activityCode;
  final String? iban;
  final String? accountOpeningDate;
  final String? aliasValue;
  final String? clientPhoto;
  final String? deletionReason;
  final String? status;
  final String? rejectionReason;
  final String? additionalInformation;
  final String? shid;
  final String? type;
  final String? modifiedAliasBody;
  final String? callbackURL;

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
      'aliasCreationId': aliasCreationId,
      'clientNationality': clientNationality,
      'companyName': companyName,
      'corporateName': corporateName,
      'taxIdentification': taxIdentification,
      'rccmIdentification': rccmIdentification,
      'clientEmail': clientEmail,
      'clientAddress': clientAddress,
      'clientPostalCode': clientPostalCode,
      'modifiedPostalCode': modifiedPostalCode,
      'nationalIdentification': nationalIdentification,
      'passportNumber': passportNumber,
      'clientGender': clientGender,
      'clientBirthDate': clientBirthDate,
      'clientBirthCountry': clientBirthCountry,
      'clientBirthCity': clientBirthCity,
      'clientCity': clientCity,
      'motherName': motherName,
      'companyCategory': companyCategory,
      'activityCode': activityCode,
      'iban': iban,
      'accountOpeningDate': accountOpeningDate,
      'aliasValue': aliasValue,
      'clientPhoto': clientPhoto,
      'deletionReason': deletionReason,
      'status': status,
      'rejectionReason': rejectionReason,
      'additionalInformation': additionalInformation,
      'shid': shid,
      'type': type,
      'modifiedAliasBody': modifiedAliasBody,
      'callbackURL': callbackURL,
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
      aliasCreationId: json['aliasCreationId'] as String?,
      clientNationality: json['clientNationality'] as String?,
      companyName: json['companyName'] as String?,
      corporateName: json['corporateName'] as String?,
      taxIdentification: json['taxIdentification'] as String?,
      rccmIdentification: json['rccmIdentification'] as String?,
      clientEmail: json['clientEmail'] as String?,
      clientAddress: json['clientAddress'] as String?,
      clientPostalCode: json['clientPostalCode'] as String?,
      modifiedPostalCode: json['modifiedPostalCode'] as String?,
      nationalIdentification: json['nationalIdentification'] as String?,
      passportNumber: json['passportNumber'] as String?,
      clientGender: json['clientGender'] as String?,
      clientBirthDate: json['clientBirthDate'] as String?,
      clientBirthCountry: json['clientBirthCountry'] as String?,
      clientBirthCity: json['clientBirthCity'] as String?,
      clientCity: json['clientCity'] as String?,
      motherName: json['motherName'] as String?,
      companyCategory: json['companyCategory'] as String?,
      activityCode: json['activityCode'] as String?,
      iban: json['iban'] as String?,
      accountOpeningDate: json['accountOpeningDate'] as String?,
      aliasValue: json['aliasValue'] as String?,
      clientPhoto: json['clientPhoto'] as String?,
      deletionReason: json['deletionReason'] as String?,
      status: json['status'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      additionalInformation: json['additionalInformation'] as String?,
      shid: json['shid'] as String?,
      type: json['type'] as String?,
      modifiedAliasBody: json['modifiedAliasBody'] as String?,
      callbackURL: json['callbackURL'] as String?,

    );
  }
}
