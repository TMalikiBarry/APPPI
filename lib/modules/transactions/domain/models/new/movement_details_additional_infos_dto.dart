class AdditionalInfosMovement {
  final String? clientName;
  final String? payeAlias;
  final String? payePays;
  final String? participant;
  final String? otherClient;
  final String? movementType;
  final String? clientIban;

  AdditionalInfosMovement({
    this.clientName,
    this.payeAlias,
    this.payePays,
    this.participant,
    this.otherClient,
    this.movementType,
    this.clientIban,
  });

  factory AdditionalInfosMovement.fromJson(Map<String, dynamic> json) {
    return AdditionalInfosMovement(
      clientName: json['clientName'] as String?,
      payeAlias: json['payeAlias'] as String?,
      payePays: json['payePays'] as String?,
      participant: json['participant'] as String?,
      otherClient: json['otherClient'] as String?,
      movementType: json['movementType'] as String?,
      clientIban: json['clientIban'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientName': clientName,
      'payeAlias': payeAlias,
      'payePays': payePays,
      'participant': participant,
      'otherClient': otherClient,
      'movementType': movementType,
      'clientIban': clientIban,
    };
  }
}
