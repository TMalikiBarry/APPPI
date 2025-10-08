import 'package:common_dependencies/utils/utils.dart';

import '../transaction.dart';
import '../transaction_canal.dart';
import 'transaction_send_command_alias.dart';
import 'transaction_send_command_amount.dart';
import 'transaction_send_command_contact.dart';
import 'transaction_send_command_iban.dart';
import 'transaction_send_command_motif.dart';
import 'transaction_send_command_othr.dart';
import 'transaction_send_command_schedule.dart';
import 'transaction_send_method.dart';

/// Modele de demande d'envoie d'un transfert
class TransactionSendCommand {
  //
  TransactionSendCommand({
    required this.compte,
    required this.action,
    required this.method,
    this.canal,
    this.txId,
    this.solde,
    this.alias,
    this.iban,
    this.othr,
    this.contact,
    this.amount,
    this.issuerPhoneNumber,
    this.motif,
    this.pspCode,
    this.pspPays,
    this.pspNom,
    this.schedule,
  });

  // Envoie, Demande
  String action;
  // Methode d'envoie
  TransactionSendMethod method;
  // Solde du client
  double? solde;
  // Canal de communication
  String? canal;

  // TxId
  String? txId;

  TransactionSendCommandAlias? alias;
  TransactionSendCommandIban? iban;
  TransactionSendCommandOthr? othr;
  TransactionSendCommandContact? contact;
  TransactionSendCommandAmount? amount;
  TransactionSendCommandMotif? motif;
  TransactionSendCommandSchedule? schedule;

  String? issuerPhoneNumber;
  // Participant payé Code
  String? pspCode;
  // Participant payé Pays
  String? pspPays;
  // Participant payé Nom
  String? pspNom;

  // Position
  double? latitude;
  double? longitude;

  // Compte payeur
  String compte;

  // Type d'operations transactionnelles possibles
  // paiement immediat
  static const String actionSendNow = "send_now";
  // paiement programmé
  static const String actionSendSchedule = "send_schedule";
  // demande de paiement
  static const String actionReceiveNow = "receive_now";

  bool isValid() {
    if (alias != null && action == actionReceiveNow) {
      alias!.isValidRtp();
    } else if (alias != null) {
      alias!.isValid();
    }
    if (amount != null) amount!.isValid();
    if (motif != null) motif!.isValid();
    if (iban != null) iban!.isValid();
    if (othr != null) othr!.isValid();
    if (schedule != null) schedule!.isValid();
    return (
        (alias != null && action == actionReceiveNow && alias!.isValidRtp()) ||
        (alias != null && action != actionReceiveNow && alias!.isValid()) ||
            (iban != null && iban!.isValid() &&
                pspNom != null) ||
            (othr != null && othr!.isValid())) &&
        (amount != null && amount!.isValid()) &&
        (schedule == null || (schedule != null && schedule!.isValid())) &&
        (motif == null || (motif != null && motif!.isValid()));
  }

  /// Convertit un objet TransactionSendCommand en JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'amount': "${amount?.value!.toInt()}",
      'lattitude': "$latitude",
      'longitude': "$longitude",
    };
    if (txId != null) {
      json['txId'] = txId;
    }

    if(issuerPhoneNumber != null) {
      json['issuerPhoneNumber'] = issuerPhoneNumber;
    }
    if (motif != null) {
      json['reason'] = motif?.value;
    }
    if (schedule != null) {
      json['dateDebut'] = schedule!.dateDebut!;
      if (schedule!.frequence != null) {
        json['frequence'] = schedule!.frequence!.value!.code;
        if (schedule!.frequence!.periodicite != null) {
          json['periodicite'] = schedule!.frequence!.periodicite!;
        }
        if (schedule!.dateFin != null) {
          json['dateFin'] = schedule!.dateFin!;
        }
      }
    }
    // Add properties based on the selected method
    switch (method) {
      case TransactionSendMethod.alias || TransactionSendMethod.aliasRtb ||
          TransactionSendMethod.rtpAcceptPay:
        json['alias'] = alias?.value;
        break;
      case TransactionSendMethod.qrcode:
        json['alias'] = alias?.value;
        json['channel'] = canal;
        break;
      case TransactionSendMethod.iban:
        json['iban'] = iban?.value;
        //json['payePSP'] = pspCode;
        json['bankName'] = pspNom;
        break;
      case TransactionSendMethod.othr:
        json['otherClient'] = othr?.value;
        json['participantMemberCode'] = pspCode;
        break;
      case TransactionSendMethod.contact:
        json['alias'] = alias?.value;
        break;
    }
    return json;
  }

  factory TransactionSendCommand.fromTransaction(Transaction transaction) {
    logger.i("transaction.sens");
    logger.i(transaction.sens);

    return TransactionSendCommand(
      action: TransactionSendCommand.actionSendNow,
      method: transaction.clientAlias != null
          ? TransactionSendMethod.alias
          : transaction.additionalInformations != null && transaction.additionalInformations!.movementType == TransactionSendMethod.iban.code
            ? TransactionSendMethod.iban
            : TransactionSendMethod.othr,
      compte: transaction.compte,
      canal: TransactionCanal.defaultCanal.code,
      iban: transaction.additionalInformations != null && transaction.additionalInformations!.movementType == TransactionSendMethod.iban.code
          ? TransactionSendCommandIban(value: transaction.additionalInformations!.clientIban)
          : null,
      alias: transaction.sens == TransactionSens.credit ? TransactionSendCommandAlias(value : transaction.clientId )
          : transaction.clientAlias != null ? TransactionSendCommandAlias(value: transaction.clientAlias)
          : TransactionSendCommandAlias(value: transaction.additionalInformations?.payeAlias),
      othr: transaction.clientAlias == null && transaction.userLogin != null
          ? TransactionSendCommandOthr(value: transaction.userLogin)
          : (transaction.clientCompte != null ? TransactionSendCommandOthr(value: transaction.clientCompte): null),
      pspCode: transaction.clientPSP ?? transaction.additionalInformations?.participant,
      pspPays: transaction.additionalInformations != null && (
          transaction.additionalInformations!.movementType == TransactionSendMethod.iban.code ||
          transaction.additionalInformations!.movementType == TransactionSendMethod.othr.code
        )
          ? transaction.additionalInformations!.payePays
          : transaction.clientPays,
      pspNom: transaction.clientPSPNom,
      amount: TransactionSendCommandAmount(value: transaction.montant),
    );
  }
}
