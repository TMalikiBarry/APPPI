import 'transaction_send_command_amount.dart';
import 'transaction_send_command_motif.dart';
import 'transaction_verification_result_command.dart';

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
    this.transactionVerificationResult,
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

  // Type d'operations transactionnelles possibles
  static const String actionSendNow = "send_now"; // paiement immediat
  static const String actionSendSchedule =
      "send_schedule"; // paiement programmé
  static const String actionReceiveNow = "receive_now"; // demande de paiement

  // infos supplémentaires
  TransactionVerificationResult? transactionVerificationResult;

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
      //'confirmationDate': confirmationDate,
      //'confirmationMethode': confirmationMethode,
    };

    if (motif != null) {
      json['reason'] = motif?.value;
    }
    if (latitude != null) {
      json['lattitude'] = latitude;
    }
    if (longitude != null) {
      json['longitude'] = longitude;
    }
    if (transactionVerificationResult != null){
      json['idVerification'] = transactionVerificationResult!.toJson();
    }
    return json;
  }
}
