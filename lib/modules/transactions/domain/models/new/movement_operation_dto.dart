class MovementOperationDTO {
  final String accountNumber;
  final int amount;
  final int balanceAfter;
  final int balanceBefore;
  final int globalCommission;
  final int globalFees;
  final String guID;
  final String impactRuleCode;
  final String legalEntityCode;
  final DateTime opDate;
  final String operationDirection;
  final String productCode;

  MovementOperationDTO({
    required this.accountNumber,
    required this.amount,
    required this.balanceAfter,
    required this.balanceBefore,
    required this.globalCommission,
    required this.globalFees,
    required this.guID,
    required this.impactRuleCode,
    required this.legalEntityCode,
    required this.opDate,
    required this.operationDirection,
    required this.productCode,
  });

  factory MovementOperationDTO.fromJson(Map<String, dynamic> json) {
    return MovementOperationDTO(
      accountNumber: json['accountNumber'] as String,
      amount: json['amount'] as int,
      balanceAfter: json['balanceAfter'] as int,
      balanceBefore: json['balanceBefore'] as int,
      globalCommission: json['globalCommission'] as int,
      globalFees: json['globalFees'] as int,
      guID: json['guID'] as String,
      impactRuleCode: json['impactRuleCode'] as String,
      legalEntityCode: json['legalEntityCode'] as String,
      opDate: DateTime.parse(json['opDate'] as String),
      operationDirection: json['operationDirection'] as String,
      productCode: json['productCode'] as String,
    );
  }
}