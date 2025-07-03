import 'movement_history_dto.dart';
import 'movement_operation_dto.dart';

class MovementDetailsDTO {
  final String? accountNumber;
  final double amount;
  final String? bankCode;
  final String? clientId;
  final String countryISOCode;
  final String flowCode;
  final double globalCommission;
  final double globalFees;
  final String guID;
  final List<MovementHistoryDTO> history;
  final DateTime impactDate;
  final String legalEntityCode;
  final String message;
  final List<MovementOperationDTO> operations;
  final String? partnerDistId;
  final String? partnerID;
  final String productCode;
  final String? rejectReason;
  final String? slipNumber;
  final String statusCode;
  final String? userLogin;
  final String? acquirerAccount;
  final String? issuerAccount;
  final String serviceTypeCode;
  final Map<String, String>? accountRoles;
  final String? issuerPhoneNumber;
  final String? acquirerPhoneNumber;
  final String? issuerAccountLabel;
  final String? acquirerAccountLabel;

  MovementDetailsDTO({
    this.accountNumber,
    required this.amount,
    this.bankCode,
    this.clientId,
    required this.countryISOCode,
    required this.flowCode,
    required this.globalCommission,
    required this.globalFees,
    required this.guID,
    required this.history,
    required this.impactDate,
    required this.legalEntityCode,
    required this.message,
    required this.operations,
    this.partnerDistId,
    this.partnerID,
    required this.productCode,
    this.rejectReason,
    this.slipNumber,
    required this.statusCode,
    this.userLogin,
    this.acquirerAccount,
    required this.issuerAccount,
    required this.serviceTypeCode,
    this.accountRoles,
    this.issuerPhoneNumber,
    this.acquirerPhoneNumber,
    this.issuerAccountLabel,
    this.acquirerAccountLabel,
  });

  factory MovementDetailsDTO.fromJson(Map<String, dynamic> json) {
    return MovementDetailsDTO(
      accountNumber: json['accountNumber'] as String?,
      amount: (json['amount'] as num).toDouble(),
      bankCode: json['bankCode'] as String?,
      clientId: json['clientId'] as String?,
      countryISOCode: json['countryISOCode'] as String,
      flowCode: json['flowCode'] as String,
      globalCommission: (json['globalCommission'] as num).toDouble(),
      globalFees: (json['globalFees'] as num).toDouble(),
      guID: json['guID'] as String,
      history: (json['history'] as List<dynamic>?)
          ?.map((e) => MovementHistoryDTO.fromJson(e as Map<String, dynamic>))
          .toList() ??
          <MovementHistoryDTO>[],
      impactDate: DateTime.parse(json['impactDate'] as String),
      legalEntityCode: json['legalEntityCode'] as String,
      message: json['message'] as String,
      operations: (json['operations'] as List<dynamic>?)
          ?.map((e) => MovementOperationDTO.fromJson(e as Map<String, dynamic>))
          .toList() ??
          <MovementOperationDTO>[],
      partnerDistId: json['partnerDistId'] as String?,
      partnerID: json['partnerID'] as String?,
      productCode: json['productCode'] as String,
      rejectReason: json['rejectReason'] as String?,
      slipNumber: json['slipNumber'] as String?,
      statusCode: json['statusCode'] as String,
      userLogin: json['userLogin'] as String?,
      acquirerAccount: json['acquirerAccount'] as String?,
      issuerAccount: json['issuerAccount'] as String?,
      serviceTypeCode: json['serviceTypeCode'] as String,
      accountRoles: (json['accountRoles'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as String),
      ),
      issuerPhoneNumber: json['issuerPhoneNumber'] as String?,
      acquirerPhoneNumber: json['acquirerPhoneNumber'] as String?,
      issuerAccountLabel: json['issuerAccountLabel'] as String?,
      acquirerAccountLabel: json['acquirerAccountLabel'] as String?,
    );
  }
}
