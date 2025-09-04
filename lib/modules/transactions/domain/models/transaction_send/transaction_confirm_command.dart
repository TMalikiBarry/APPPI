import 'transaction_send_command_amount.dart';
import 'transaction_send_command_motif.dart';
import 'transaction_send_method.dart';
import 'transaction_verification_result_command_alias.dart';
import 'transaction_verification_result_command_othr.dart';

/// Modele de demande d'envoie d'un transfert
class TransactionConfirmCommand {
  //
  TransactionConfirmCommand({
    required this.endToendId,
    required this.confirmationDate,
    required this.confirmationMethode,
    this.motif,
    this.amount,
    this.latitude,
    this.longitude,
    this.transactionVerificationResultOthr,
    this.transactionVerificationResultAlias,
    this.transactionVerificationResultIban,
    this.channel,
    this.clientAlias,
    this.guID,
  });

  // Transfert
  String endToendId;
  TransactionSendCommandAmount? amount;
  TransactionSendCommandMotif? motif;

  // Position pour les confirmations directs (Ex acceptation RTP)
  double? latitude;
  double? longitude;

  // Confirmation
  String confirmationDate;
  String confirmationMethode;
  String? channel;
  String? clientAlias;
  String? guID;

  // Type d'operations transactionnelles possibles
  static const String actionSendNow = "send_now"; // paiement immediat
  static const String actionSendSchedule =
      "send_schedule"; // paiement programmé
  static const String actionReceiveNow = "receive_now"; // demande de paiement

  // infos supplémentaires
  TransactionVerificationResultAlias? transactionVerificationResultAlias;
  TransactionVerificationResultOthr? transactionVerificationResultOthr;
  TransactionVerificationResultOthr? transactionVerificationResultIban;

  bool isValid() {
    if (amount != null) amount!.isValid();
    if (motif != null) motif!.isValid();
    return (amount != null && amount!.isValid()) &&
        (motif == null || (motif != null && motif!.isValid()));
  }

  /// Convertit un objet TransactionSendCommand en JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'amount': "${amount?.value!.toInt()}",
      'lattitude': latitude,
      'longitude': longitude,
    };

    if (motif != null) {
      json['reason'] = motif?.value;
    }
    if (transactionVerificationResultAlias != null) {
      json['aliasTo'] = transactionVerificationResultAlias!.toJson();
    }
    if (transactionVerificationResultIban != null) {
      json['idVerification'] = transactionVerificationResultIban!.toJsonIban();
    }
    if (transactionVerificationResultOthr != null) {
      json['idVerification'] = transactionVerificationResultOthr!.toJsonOthr();
    }
    return json;
  }
}
