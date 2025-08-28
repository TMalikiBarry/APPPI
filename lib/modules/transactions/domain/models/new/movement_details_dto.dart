import '../transaction_send/transaction_send_method.dart';
import 'movement_details_additional_infos_dto.dart';
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
  final String? endToEndId;
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
  final String? clientAlias;
  final String? clientPSP;
  final String? clientPays;
  final String? clientCompte;
  final AdditionalInfosMovement? additionalInformations;

  MovementDetailsDTO({
    this.accountNumber,
    required this.amount,
    this.endToEndId,
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
    this.clientAlias,
    this.clientPSP,
    this.clientPays,
    this.clientCompte,
    this.additionalInformations,
  });

  factory MovementDetailsDTO.fromJson(Map<String, dynamic> json) {
    var additionalInformations = json['additionalInformations'] != null
        ?  AdditionalInfosMovement.fromJson(json["additionalInformations"])
        : null;
    String? clientAlias;
    String? clientPSP;
    String? clientPays;
    String? clientCompte;
    String? acquirerAccountLabel;
    if (json['clientAlias'] != null) {
      clientAlias = json['clientAlias'];
    }
    if (json['clientPSP'] != null) {
      clientPSP = json['clientPSP'];
    }
    if (json['clientCompte'] != null) {
      clientCompte = json['clientCompte'];
    }
    if (json['clientPays'] != null) {
      clientCompte = json['clientPays'];
    }
    if (json['acquirerAccountLabel'] != null) {
      acquirerAccountLabel = json['acquirerAccountLabel'];
    }
    if (additionalInformations != null && additionalInformations.payeAlias != null) {
      clientPays = clientPays ?? additionalInformations.payePays;
      acquirerAccountLabel = additionalInformations.clientName ?? additionalInformations.issuerName;

      if (
      additionalInformations.movementType == TransactionSendMethod.alias.code ||
          additionalInformations.movementType == TransactionSendMethod.qrcode.code
      ) {
        clientAlias = clientAlias ?? additionalInformations.payeAlias;
      } else if (additionalInformations.movementType == TransactionSendMethod.iban.code) {
        clientPSP = clientPSP ?? additionalInformations.participant;
      }
      else if (additionalInformations.movementType == TransactionSendMethod.othr.code) {
        clientCompte = clientCompte ?? additionalInformations.otherClient;
      }
    }
    return MovementDetailsDTO(
      accountNumber: json['accountNumber'] as String?,
      amount: (json['amount'] as num).toDouble(),
      bankCode: json['bankCode'] as String?,
      clientId: json['clientId'] as String?,
      countryISOCode: json['countryISOCode'] as String,
      flowCode: json['flowCode'] as String,
      endToEndId: json['endToEndId'] as String? ,
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
      issuerAccountLabel: json['issuerAccountLabel'] ?? additionalInformations?.issuerName,
      acquirerAccountLabel: acquirerAccountLabel,
      clientAlias: clientAlias,
      clientPSP: clientPSP,
      clientPays: clientPays,
      clientCompte: clientCompte,
      additionalInformations: json['additionalInformations'] == null
          ? null
          : AdditionalInfosMovement.fromJson(json['additionalInformations'] as Map<String, dynamic>),
    );
  }
}

