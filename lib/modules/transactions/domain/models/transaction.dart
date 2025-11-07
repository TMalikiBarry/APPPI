import 'package:common_dependencies/utils/utils.dart';
import 'package:pi_mobile_app/modules/transactions/domain/models/transaction_liste.dart';

import '../../../../shared/models/frequence_command.dart';
import 'new/movement_details_additional_infos_dto.dart';
import 'transaction_canal.dart';
import 'transaction_cancel_reason.dart';
import 'transaction_send/transaction_send_method.dart';
import 'transaction_send/transaction_verification_result_command_alias.dart';
import 'transaction_send/transaction_verification_result_command_othr.dart';

enum TransactionSens { debit, credit }

enum TransactionStatut { irrevocable, rejete, initie, desactive }

class Transaction {
  ///
  Transaction({
    required this.compte,
    this.acquirerPhoneNumber,
    this.alias,
    required this.montant,
    this.montantFrais,
    this.sens,
    this.motif,
    this.canal,
    this.guID,
    this.clientPhoneNumber,
    this.issuerPhoneNumber,
    required this.clientNom,
    this.acquirerAccountLabel,
    required this.clientPays,
    this.clientPSP,
    this.clientPSPNom,
    this.clientPhoto,
    this.clientCompte,
    this.clientAlias,
    this.bankCode,
    this.productCode,
    this.clientId,
    this.globalCommission,
    this.legalEntityCode,
    this.partnerDistId,
    this.partnerID,
    this.slipNumber,
    this.userLogin,
    this.acquirerAccount,
    required this.endToEndId,
    this.dateOperation,
    this.statut,
    this.statutRaison,
    this.categorie,
    this.facture,
    this.txId,
    this.dateDebut,
    this.dateFin,
    this.subscriptionId,
    this.frequence,
    this.periodicite,
    this.retourDate,
    this.retourStatut,
    this.retourStatutRaison,
    this.annulationRaison,
    this.annulationDate,
    this.annulationStatut,
    this.annulationStatutRaison,
    this.dateDemande,
    this.dateReponse,
    this.dateExpiration,
    this.remise,
    this.retraitAchat,
    this.retraitMontant,
    this.retraitFrais,
    this.differe,
    this.serviceCode,
    this.differeFrequence,
    this.differeOccurence,
    this.differeMontant,
    this.transactionVerificationResultAlias,
    this.transactionVerificationResultIban,
    this.transactionVerificationResultOthr,
    this.additionalInformations,
    this.codeMembreParticipantPayeur,
    this.codeMembreParticipantPayer,
  });

  /// Compte du client
  final String compte;
  final String? acquirerPhoneNumber;
  final String? alias;
  //
  final double montant;
  final double? montantFrais;
  TransactionSens? sens;
  String? motif;
  final String? canal;
  // Si sens c'est débit , le client c'est le payeur
  // Si sens c'est crédit, le client c'est la payé
  final String clientNom;
  final String? acquirerAccountLabel;

  final String clientPays;
  final String? clientPSP; // PSP du client payé si iban ou other
  // Nom du PSP du client payé
  final String? clientPSPNom;
  // IBAN ou Other
  final String? clientCompte;
  // Alias du client
  final String? clientAlias;
  //
  final String endToEndId;
  // Aprés recherche d'alias on a l'info normalement si c'est défini
  final String? clientPhoto;

  final String? bankCode;
  final String? productCode;
  final String? clientId;
  final double? globalCommission;
  final String? legalEntityCode;
  final String? partnerDistId;
  final String? partnerID;
  final String? slipNumber;
  final String? userLogin;
  final String? guID;
  final String? clientPhoneNumber;
  final String? serviceCode;
  final String? acquirerAccount;
  // Date d'irrévocabilité
  DateTime? dateOperation;
  // Statut de la transaction
  TransactionStatut? statut;
  String? statutRaison;

  final String? issuerPhoneNumber;

  /// Date de la première execution du paiement programmé
  DateTime? dateDebut;

  /// Date de la derniere execution du paiement programmé
  DateTime? dateFin;

  /// Frequence de paiement défini par le client
  Frequence? frequence;

  /// Périodicité du paiement >= 2
  int? periodicite;

  // Categorie
  String? categorie;

  //  Facture
  String? facture;
  // Date d'expiration de la demande ou date limite de retour ou annulation
  DateTime? dateExpiration;

  // la référence du payé qui correspond au TxId
  final String? txId;
  //
  final String? subscriptionId;
  // Retour de fonds
  DateTime? retourDate;
  TransactionStatut? retourStatut;
  String? retourStatutRaison;

  // Demande d'annulation
  DateTime? annulationDate;
  TransactionStatut? annulationStatut;
  String? annulationStatutRaison;
  TransactionCancelReason? annulationRaison;

  // Demande de paiement
  // Date demande
  DateTime? dateDemande;
  // Date limite de réponse au RTP
  DateTime? dateReponse;
  // Remise appliquee
  double? remise;
  // Retrait PICO ou PICASH
  double? retraitAchat;
  double? retraitMontant;
  double? retraitFrais;
  // Débit différé
  bool? differe;
  // Frequence de paiement proposé
  Frequence? differeFrequence;
  int? differeOccurence;
  double? differeMontant;

  TransactionVerificationResultAlias? transactionVerificationResultAlias;
  TransactionVerificationResultOthr? transactionVerificationResultIban;
  TransactionVerificationResultOthr? transactionVerificationResultOthr;

  final AdditionalInfosMovement? additionalInformations;

  final String? codeMembreParticipantPayeur;
  final String? codeMembreParticipantPayer;

  /// Est ce que c'est une demande de paiement
  bool isRTP() {
    return canal != null &&
        [
          TransactionCanal.transfertParRequestToPay.code,
          TransactionCanal.paiementParRequestToPaySite.code,
          TransactionCanal.paiementParRequestToPayEcommerceImmediat.code,
          TransactionCanal.paiementParRequestToPayEcommerceLivraison.code,
          TransactionCanal.paiementParRequestToPayAutresFactures.code,
        ].contains(canal);
  }

  /// Est ce que c'est une transaction liée à un split payment
  bool isSplit() {
    return canal != null &&
        canal == TransactionCanal.transfertParRequestToPay.code &&
        motif != null &&
        motif!.startsWith("@SPLIT");
  }

  /// Est ce qu'on peut programmer
  bool canSchedule() {
    return canal == null ||
        [
          TransactionCanal.transfertParRequestToPay.code,
          TransactionCanal.paiementParRequestToPayEcommerceLivraison.code,
          TransactionCanal.paiementParRequestToPayAutresFactures.code,
        ].contains(canal);
  }

  /// Est ce que c'est une transaction de type retrait avec achat
  bool isPICO() {
    return retraitAchat != null && retraitAchat! > 0;
  }

  /// Est ce que c'est une transaction de type retrait
  bool isPICASH() {
    return retraitAchat == null || retraitAchat! == 0;
  }

  static Transaction fromJson(Map<dynamic, dynamic> json) {
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
      acquirerAccountLabel = acquirerAccountLabel ?? additionalInformations.clientName;

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

    return Transaction(
      compte: json['compte'],
      acquirerPhoneNumber: json['acquirerPhoneNumber'],
      acquirerAccountLabel: acquirerAccountLabel,
      alias: json['alias'] as String?,
      montant: double.parse(json['amount'].toString()),
      montantFrais: json['montantFrais'] != null
          ? double.parse(json['montantFrais'].toString())
          : null,
      sens: json['sens'],
      motif: json['motif'] as String?,
      canal: json['canal'] as String?,
      clientNom: json['clientName'] as String,
      clientPays: json['country'] as String,
      clientPhoto: json['clientPhoto'] as String?,
      clientPSP: clientPSP,
      issuerPhoneNumber: json['issuerPhoneNumber'] as String?,
      clientCompte: clientCompte,
      clientAlias: clientAlias,
      bankCode: json['bankCode'] as String?,
      productCode: json['productCode'] as String?,
      clientId: json['clientId'] as String?,
      globalCommission: json['globalCommission'] != null
          ? double.parse(json['globalCommission'].toString())
          : null,
      legalEntityCode: json['legalEntityCode'] as String?,
      partnerDistId: json['partnerDistId'] as String?,
      partnerID: json['partnerID'] as String?,
      slipNumber: json['slipNumber'] as String?,
      userLogin: json['userLogin'] as String?,
      guID: json['guID'] as String?,
      acquirerAccount: json['acquirerAccount'] as String?,
      endToEndId: additionalInformations?.endToEndId ?? "",
      dateOperation: json['dateOperation'] != null
          ? DateTime.parse(json['dateOperation'] as String)
          : null,
      statut: _getStatut(json['statut']),
      statutRaison: json['statutRaison'] as String?,
      categorie: json['clientCategory'] as String?,
      facture: json['facture'] as String?,
      txId: json['txId'] as String?,
      dateExpiration: json['dateExpiration'] != null
          ? DateTime.parse(json['dateExpiration'] as String)
          : null,
      // Programmation
      dateDebut: json['dateDebut'] != null
          ? DateTime.parse(json['dateDebut'] as String)
          : null,
      dateFin: json['dateFin'] != null
          ? DateTime.parse(json['dateFin'] as String)
          : null,
      subscriptionId: json['subscriptionId'] as String?,
      frequence: json['frequence'] != null
          ? Frequence.values.firstWhere(
              (element) => element.code == json['frequence'] as String)
          : null,
      periodicite: json['periodicite'] != null
          ? int.parse(json['periodicite'].toString())
          : null,

      // Annulation et retour de fond
      retourDate: json['retourDate'] != null
          ? DateTime.parse(json['retourDate'] as String)
          : null,
      retourStatut: _getStatut(json['retourStatut']),
      retourStatutRaison: json['retourStatutRaison'] as String?,
      annulationRaison: json['annulationRaison'] != null
          ? TransactionCancelReason.values.firstWhere(
              (element) => element.code == json['annulationRaison'] as String)
          : null,
      annulationDate: json['annulationDate'] != null
          ? DateTime.parse(json['annulationDate'] as String)
          : null,
      annulationStatut: _getStatut(json['annulationStatut']),
      annulationStatutRaison: json['annulationStatutRaison'] as String?,

      // Demande de paiement
      dateDemande: json['dateDemande'] != null
          ? DateTime.parse(json['dateDemande'] as String)
          : null,
      dateReponse: json['dateReponse'] != null
          ? DateTime.parse(json['dateReponse'] as String)
          : null,
      remise: json['remise'] != null
          ? double.parse(json['remise'].toString())
          : null,
      retraitAchat: json['retraitAchat'] != null
          ? double.parse(json['retraitAchat'].toString())
          : null,
      retraitMontant: json['retraitMontant'] != null
          ? double.parse(json['retraitMontant'].toString())
          : null,
      retraitFrais: json['retraitFrais'] != null
          ? double.parse(json['retraitFrais'].toString())
          : null,
      differe: json['differe'] != null
          ? bool.parse(json['differe'].toString())
          : null,
      differeFrequence: json['differeFrequence'] != null
          ? Frequence.values.firstWhere(
              (element) => element.code == json['differeFrequence'] as String)
          : null,
      differeOccurence: json['differeOccurence'] != null
          ? int.parse(json['differeOccurence'].toString())
          : null,
      differeMontant: json['differeMontant'] != null
          ? double.parse(json['differeMontant'].toString())
          : null,
      additionalInformations: additionalInformations,
      codeMembreParticipantPayeur: json['codeMembreParticipantPayeur'] as String?,
      codeMembreParticipantPayer: json['codeMembreParticipantPayer'] as String?,
    );
  }

  /*
  static Transaction fromJsonSearch(Map<dynamic, dynamic> json) {
    // Extraction des détails de réponse si présents
    final responseDetails = json['responseDetails'] as Map<String, dynamic>?;
    final status = responseDetails?['status'] as String?;
    final message = responseDetails?['message'] as String?;

    return Transaction(
      // Champs directs
      acquirerPhoneNumber: json['acquirerPhoneNumber'] as String?,
      acquirerAccountLabel: json['acquirerAccountLabel'] ?? json['clientName'],
      compte: json['compte'] as String? ?? '',
      clientPhoneNumber: json['clientPhoneNumber'],
      alias: json['alias'] as String?,
      montant: double.parse(json['amount'].toString()),

      // Champs dérivés
      sens: _determineTransactionSens(json),
      motif: message ?? json['motif'] as String? ?? '',
      canal: json['serviceCode'] as String? ?? 'TRANSFER_PI',
      serviceCode: json['serviceCode'] as String? ?? 'TRANSFER_PI',

      // Informations client
      clientNom: json['clientName'] as String? ?? '',
      clientPays: json['clientResidenceCountry'] as String? ?? 'SN',
      clientPhoto: json['clientPhoto'] as String?,

      // Identifiants techniques
      guID: json['guID'] as String?,
      endToEndId: additionalInformations?.endToEndId ?? "",
      legalEntityCode: json['legalEntityCode'] as String?,

      // Statut et dates
      dateOperation: DateTime.now(), // Date courante par défaut
      statut: _mapTechnicalStatus(status),
      statutRaison: message,
      dateExpiration: _parseDateTime(json['dateExpiration']),

      // Champs optionnels avec valeurs par défaut
      montantFrais: json['globalFees'] != null
          ? double.parse(json['globalFees'].toString())
          : null,
      issuerPhoneNumber: json['clientPhoneNumber'] as String?,
      bankCode: json['bankCode'] as String?,
      productCode: json['serviceCode'] as String?,

      // Initialisation des champs non fournis à null
      clientPSP: null,
      clientCompte: null,
      clientAlias: null,
      clientId: null,
      globalCommission: null,
      partnerDistId: null,
      partnerID: null,
      slipNumber: null,
      userLogin: null,
      acquirerAccount: null,
      categorie: null,
      facture: null,
      txId: null,
      dateDebut: null,
      dateFin: null,
      frequence: null,
      periodicite: null,
      retourDate: null,
      retourStatut: null,
      retourStatutRaison: null,
      annulationRaison: null,
      annulationDate: null,
      annulationStatut: null,
      annulationStatutRaison: null,
      dateDemande: null,
      dateReponse: null,
      remise: null,
      retraitAchat: null,
      retraitMontant: null,
      retraitFrais: null,
      differe: null,
      differeFrequence: null,
      differeOccurence: null,
      differeMontant: null,
    );
  }
  */

  static Transaction fromJsonTransfer(Map<dynamic, dynamic> json, {bool isRtpOrSchedule = false}) {
    // Extraction des détails de réponse si présents
    final responseDetails = json['responseDetails'] as Map<String, dynamic>?;
    final status = responseDetails?['status'] as String?;
    final message = responseDetails?['message'] as String?;

    if (!isRtpOrSchedule) {
      return Transaction(
        // Champs directs
        acquirerPhoneNumber: json['acquirerPhoneNumber'] as String?,
        acquirerAccountLabel: json['acquirerAccountLabel'] ?? json['clientName'] ?? json['nomClientPayeur'],
        compte: json['clientPhoneNumber'] ?? json['aliasClientPayeur'] ?? '',
        clientPhoneNumber: json['clientPhoneNumber'],
        alias: json['alias'] as String?,
        montant: json['amount'] != null
            ? double.parse(json['amount'])
            : json['montant'] != null
              ? double.parse(json['montant'])
              : 0.0,

        // Champs dérivés
        sens: _determineTransactionSens(json, fromTransfer: true),
        motif: message ?? json['motif'] as String? ?? '',
        canal: json['serviceCode'] ?? json['canalCommunication'] ?? 'TRANSFER_PI',
        serviceCode: json['serviceCode'] as String? ?? 'TRANSFER_PI',

        // Informations client
        clientNom: json['acquirerAccountLabel'] ?? json['clientName'] ?? json['nomClientPayeur'] ?? "",
        clientPays: json['clientResidenceCountry'] ?? json['paysClientPaye'] ?? 'SN',

        // Identifiants techniques
        guID: json['guID'] as String?,
        endToEndId: json['endToEndId'] as String? ?? '',
        legalEntityCode: json['legalEntityCode'] as String?,

        // Statut et dates
        dateOperation: DateTime.now(), // Date courante par défaut
        statut: _mapTechnicalStatus(status),
        statutRaison: message,
        dateExpiration: _parseDateTime(json['dateExpiration']),

        // Champs optionnels avec valeurs par défaut
        montantFrais: json['globalFees'] != null
            ? double.parse(json['globalFees'].toString())
            : null,
        issuerPhoneNumber: json['clientPhoneNumber'] as String?,
        bankCode: json['bankCode'] as String?,
        productCode: json['serviceCode'] as String?,
      );
    } else {
      return Transaction(
        compte: json['aliasClientPayeur'] ?? "",
        montant: json['montant'] != null ? double.parse(json['montant']) : 0.0,
        clientNom: json['nomClientPayeur'] ?? "",
        clientPays: json['paysClientPayeur'] ?? "SN",
        endToEndId: json['endToEndId'] ?? "",
        canal: json['canalCommunication'],
        statut: TransactionStatut.initie,
        dateDebut: json['dateDebut'] ?? DateTime.now()
      );
    }
  }

  static Transaction fromJsonTransactionVerificationSearchAlias(
      Map<dynamic, dynamic> json) {
    return Transaction(
      // Champs directs
        compte: json['clientPhoneNumber'] as String? ?? '',
        montant: json['amount'] != null ? double.parse(json['amount']) : 0.0,
        clientNom: json['clientName'],
        clientPays: json['clientResidenceCountry'],
        endToEndId: json['endToEndId'],
        acquirerAccountLabel: json['clientName'],
        transactionVerificationResultAlias: TransactionVerificationResultAlias.fromJson(json));
  }

  static Transaction fromJsonTransactionVerificationSearchIban(
      Map<dynamic, dynamic> json) {
    return Transaction(
      // Champs directs
      compte: json['ibanClient'] as String? ?? '',
      montant: json['amount'] != null ? double.parse(json['amount']) : 0.0,
      clientNom: json['nomClient'],
      clientPays: json['paysResidence'],
      endToEndId: json['endToEndId'],
      acquirerAccountLabel: json['nomClient'],
      transactionVerificationResultIban: TransactionVerificationResultOthr.fromJson(json));
  }

  static Transaction fromJsonTransactionVerificationSearchOthr(
      Map<dynamic, dynamic> json) {
    return Transaction(
      // Champs directs
        compte: json['otherClient'] as String? ?? '',
        montant: json['amount'] != null ? double.parse(json['amount']) : 0.0,
        clientNom: json['nomClient'] as String? ?? '',
        clientPays: json['paysResidence'] as String? ?? '',
        endToEndId: json['endToEndId']  as String? ?? '',
        acquirerAccountLabel: json['nomClient'] as String?,
        transactionVerificationResultOthr: TransactionVerificationResultOthr.fromJson(json));
  }

// Helpers supplémentaires
  static DateTime? _parseDateTime(dynamic value) {
    return value != null ? DateTime.tryParse(value.toString()) : null;
  }

  static TransactionStatut? _mapTechnicalStatus(String? status) {
    if (status == null) return null;
    switch (status) {
      case 'SUCCESSFUL':
      case 'success':
        return TransactionStatut.irrevocable;
      case 'PART_SUCCESSFUL':
        return TransactionStatut.initie;
      case 'REJECTED':
      case 'rejete':
        return TransactionStatut.rejete;
      case 'DESACTIVE':
        return TransactionStatut.desactive;
      default:
        return null;
    }
  }

  static TransactionSens? _determineTransactionSens(
      Map<dynamic, dynamic> json, {bool fromTransfer = false}) {
    final issuer = json['issuerPhoneNumber']?.toString() ?? '';
    final acquirer = json['acquirerPhoneNumber']?.toString() ?? '';
    final currentAccount = json['clientPhoneNumber']?.toString() ?? '';

    return (currentAccount == issuer || fromTransfer)
        ? TransactionSens.debit
        : TransactionSens.credit;
  }

  static TransactionStatut? _getStatut(String? statut) {
    if (statut != null && statut == 'irrevocable') {
      return TransactionStatut.irrevocable;
    } else if (statut != null && statut == 'rejete') {
      return TransactionStatut.rejete;
    } else if (statut != null && statut == 'initie') {
      return TransactionStatut.initie;
    } else if (statut != null && statut == 'desactive') {
      return TransactionStatut.desactive;
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'compte': compte,
      'acquirerPhoneNumber': acquirerPhoneNumber,
      'acquirerAccountLabel': acquirerAccountLabel,
      'alias': alias,
      'montant': montant.toString(),
      'montantFrais': montantFrais?.toString(),
      // 'sens': sens == TransactionSens.debit ? 'debit' : 'credit',
      'sens': sens,
      'motif': motif,
      'clientNom': clientNom,
      'clientPays': clientPays,
      'clientPSP': clientPSP,
      'clientPSPNom': clientPSPNom,
      'clientCompte': clientCompte,
      'clientAlias': clientAlias,
      'bankCode': bankCode,
      'productCode': productCode,
      'clientId': clientId,
      'globalCommission': globalCommission?.toString(),
      'legalEntityCode': legalEntityCode,
      'partnerDistId': partnerDistId,
      'partnerID': partnerID,
      'slipNumber': slipNumber,
      'userLogin': userLogin,
      'issuerPhoneNumber': issuerPhoneNumber,
      'acquirerAccount': acquirerAccount,
      'endToEndId': endToEndId,
      'guID': guID,
      'canal': canal,
      'dateOperation': dateOperation?.toIso8601String(),
      'statut': statut?.name,
      'categorie': categorie,
      'facture': facture,
      'txId': txId,
      'dateExpiration': dateExpiration?.toIso8601String(),
      'dateDebut': dateDebut?.toIso8601String(),
      'dateFin': dateFin?.toIso8601String(),
      'subscriptionId': subscriptionId,
      'frequence': frequence?.code,
      'periodicite': periodicite?.toString(),
      'retourDate': retourDate?.toIso8601String(),
      'retourStatut': retourStatut?.name,
      'retourStatutRaison': retourStatutRaison,
      'annulationRaison': annulationRaison?.code,
      'annulationDate': annulationDate?.toIso8601String(),
      'annulationStatut': annulationStatut?.name,
      'annulationStatutRaison': annulationStatutRaison,
      'dateReponse': dateReponse?.toIso8601String(),
      'remise': remise?.toString(),
      'retraitAchat': retraitAchat?.toString(),
      'retraitMontant': retraitMontant?.toString(),
      'retraitFrais': retraitFrais?.toString(),
      'differe': differe,
      'differeFrequence': differeFrequence?.code,
      'differeOccurence': differeOccurence?.toString(),
      'differeMontant': differeMontant?.toString(),
    };
  }

  @override
  String toString() {
    return 'Transaction {'
        ' compte: $compte,'
        ' acquirerPhoneNumber: $acquirerPhoneNumber'
        ' acquirerAccountLabel: $acquirerAccountLabel'
        'issuerPhoneNumber: $issuerPhoneNumber'
        ' alias: $alias,'
        ' montant: $montant,'
        ' sens: $sens,'
        ' motif: $motif,'
        ' canal: $canal,'
        ' clientNom: $clientNom,'
        ' clientPays: $clientPays,'
        ' clientPSP: $clientPSP,'
        ' clientPSPNom: $clientPSPNom,'
        ' clientPhoto: $clientPhoto,'
        ' clientCompte: $clientCompte,'
        ' clientAlias: $clientAlias,'
        ' bankCode: $bankCode,'
        ' productCode: $productCode,'
        ' clientId: $clientId,'
        ' globalCommission: $globalCommission,'
        ' legalEntityCode: $legalEntityCode,'
        ' partnerDistId: $partnerDistId,'
        ' partnerID: $partnerID,'
        ' slipNumber: $slipNumber,'
        ' userLogin: $userLogin,'
        ' acquirerAccount: $acquirerAccount,'
        ' endToEndId: $endToEndId,'
        ' guID: $guID,'
        ' dateOperation: $dateOperation,'
        ' statut: $statut,'
        ' statutRaison: $statutRaison,'
        ' categorie: $categorie,'
        ' facture: $facture,'
        ' dateDebut: $dateDebut,'
        ' dateFin: $dateFin,'
        ' frequence: $frequence,'
        ' periodicite: $periodicite,'
        ' retourDate: $retourDate,'
        ' retourStatut: $retourStatut,'
        ' retourStatutRaison: $retourStatutRaison'
        ' annulationDate: $annulationDate,'
        ' annulationRaison: $annulationRaison,'
        ' annulationStatut: $annulationStatut,'
        ' annulationStatutRaison: $annulationStatutRaison,'
        ' dateExpiration: $dateExpiration,'
        ' dateReponse: $dateReponse,'
        ' remise: $remise,'
        ' retraitAchat: $retraitAchat,'
        ' retraitMontant: $retraitMontant,'
        ' retraitFrais: $retraitFrais,'
        ' differe: $differe,'
        ' differeFrequence: $differeFrequence,'
        ' differeOccurence: $differeOccurence,'
        ' differeMontant: $differeMontant'
        ' }';
  }

  static Transaction fromJsonCancel(Map<dynamic, dynamic> json, Transaction transaction) {
    // Extraction des détails de réponse si présents
    final responseDetails = json['responseDetails'] as Map<String, dynamic>?;

    return Transaction(
      compte: json['compte'] as String? ?? transaction.compte,
      clientPhoneNumber: json['clientPhoneNumber'] ?? transaction.clientPhoneNumber,
      alias: json['alias'] as String? ?? transaction.alias,
      montant: json['amount'] != null ? double.parse(json['amount'].toString()) : transaction.montant,
      clientNom: json['clientName'] ?? transaction.clientNom,
      clientPays: json['country'] ?? transaction.clientPays,
      endToEndId: json['endToEndId'] ?? transaction.endToEndId,
      // Annulation et retour de fond
      retourDate: json['retourDate'] != null
          ? DateTime.parse(json['retourDate'] as String)
          : null,
      retourStatut: _getStatut(json['retourStatut']),
      retourStatutRaison: json['retourStatutRaison'] as String?,
      annulationRaison: json['annulationRaison'] != null
          ? TransactionCancelReason.values.firstWhere(
              (element) => element.code == json['annulationRaison'] as String)
          : null,
      annulationDate: json['annulationDate'] != null
          ? DateTime.parse(json['annulationDate'] as String)
          : null,
      annulationStatut: _getStatut(json['annulationStatut']),
      annulationStatutRaison: json['annulationStatutRaison'] as String?,
      codeMembreParticipantPayeur: json['codeMembreParticipantPayeur'] as String?,
      codeMembreParticipantPayer: json['codeMembreParticipantPayer'] as String?,
    );
  }

  static Transaction fromJsonSupcription(Map<dynamic, dynamic> json) {
    String dateDebutSchedul;
    if (json['nextExecutionTime'] != null){
      dateDebutSchedul=json['nextExecutionTime'];
    } else {
      int parseInt(dynamic value) => value is int ? value : int.tryParse(value.toString()) ?? 0;

      final day = parseInt(json['dayOfMonth']).toString().padLeft(2, '0');
      final month = parseInt(json['month']).toString().padLeft(2, '0');
      final year = parseInt(json['year']);

      dateDebutSchedul = "$year-$month-${day}T00:00:00";
    }
    logger.i("dateDebutSchedul");
    logger.i(dateDebutSchedul);
    return Transaction(
      // Champs directs
      compte: json['id'].toString(),
      montant: json['amount'] != null ? double.parse(json['amount'].toString()) : 0.0,
      clientNom: json['clientName'] as String? ?? '',
      clientPays: json['country'] as String? ?? 'SN',
      endToEndId: json['id'].toString(),
      acquirerAccountLabel: json['clientName'] as String? ?? '',
      statut: TransactionStatut.initie,
      dateDebut: DateTime.parse(dateDebutSchedul),
      frequence:  json['frequence'] != null
          ? Frequence.values.firstWhere(
              (element) => element.code == json['frequence'] as String)
          : null,
      alias: json['aliasDestinataire'] as String?,
      clientAlias: json['aliasDestinataire'] as String?,
    );
  }
}


extension TransactionCopyWith on Transaction {
  Transaction copyWith({
    String? compte,
    String? acquirerPhoneNumber,
    String? alias,
    double? montant,
    double? montantFrais,
    TransactionSens? sens,
    String? motif,
    String? canal,
    String? clientNom,
    String? acquirerAccountLabel,
    String? clientPays,
    String? clientPSP,
    String? clientPSPNom,
    String? clientCompte,
    String? clientAlias,
    String? endToEndId,
    String? clientPhoto,
    String? bankCode,
    String? productCode,
    String? clientId,
    double? globalCommission,
    String? legalEntityCode,
    String? partnerDistId,
    String? partnerID,
    String? slipNumber,
    String? userLogin,
    String? guID,
    String? clientPhoneNumber,
    String? serviceCode,
    String? acquirerAccount,
    DateTime? dateOperation,
    TransactionStatut? statut,
    String? statutRaison,
    String? issuerPhoneNumber,
    DateTime? dateDebut,
    DateTime? dateFin,
    Frequence? frequence,
    int? periodicite,
    String? categorie,
    String? facture,
    DateTime? dateExpiration,
    String? txId,
    String? subscriptionId,
    DateTime? retourDate,
    TransactionStatut? retourStatut,
    String? retourStatutRaison,
    DateTime? annulationDate,
    TransactionStatut? annulationStatut,
    String? annulationStatutRaison,
    TransactionCancelReason? annulationRaison,
    DateTime? dateDemande,
    DateTime? dateReponse,
    double? remise,
    double? retraitAchat,
    double? retraitMontant,
    double? retraitFrais,
    bool? differe,
    Frequence? differeFrequence,
    int? differeOccurence,
    double? differeMontant,
    TransactionVerificationResultAlias? transactionVerificationResultAlias,
    TransactionVerificationResultOthr? transactionVerificationResultIban,
    TransactionVerificationResultOthr? transactionVerificationResultOthr,
    AdditionalInfosMovement? additionalInformations,
    String? codeMembreParticipantPayeur,
    String? codeMembreParticipantPayer,
  }) {
    return Transaction(
      compte: compte ?? this.compte,
      acquirerPhoneNumber: acquirerPhoneNumber ?? this.acquirerPhoneNumber,
      alias: alias ?? this.alias,
      montant: montant ?? this.montant,
      montantFrais: montantFrais ?? this.montantFrais,
      sens: sens ?? this.sens,
      motif: motif ?? this.motif,
      canal: canal ?? this.canal,
      clientNom: clientNom ?? this.clientNom,
      acquirerAccountLabel: acquirerAccountLabel ?? this.acquirerAccountLabel,
      clientPays: clientPays ?? this.clientPays,
      clientPSP: clientPSP ?? this.clientPSP,
      clientPSPNom: clientPSPNom ?? this.clientPSPNom,
      clientCompte: clientCompte ?? this.clientCompte,
      clientAlias: clientAlias ?? this.clientAlias,
      endToEndId: endToEndId ?? this.endToEndId,
      clientPhoto: clientPhoto ?? this.clientPhoto,
      bankCode: bankCode ?? this.bankCode,
      productCode: productCode ?? this.productCode,
      clientId: clientId ?? this.clientId,
      globalCommission: globalCommission ?? this.globalCommission,
      legalEntityCode: legalEntityCode ?? this.legalEntityCode,
      partnerDistId: partnerDistId ?? this.partnerDistId,
      partnerID: partnerID ?? this.partnerID,
      slipNumber: slipNumber ?? this.slipNumber,
      userLogin: userLogin ?? this.userLogin,
      guID: guID ?? this.guID,
      clientPhoneNumber: clientPhoneNumber ?? this.clientPhoneNumber,
      serviceCode: serviceCode ?? this.serviceCode,
      acquirerAccount: acquirerAccount ?? this.acquirerAccount,
      dateOperation: dateOperation ?? this.dateOperation,
      statut: statut ?? this.statut,
      statutRaison: statutRaison ?? this.statutRaison,
      issuerPhoneNumber: issuerPhoneNumber ?? this.issuerPhoneNumber,
      dateDebut: dateDebut ?? this.dateDebut,
      dateFin: dateFin ?? this.dateFin,
      frequence: frequence ?? this.frequence,
      periodicite: periodicite ?? this.periodicite,
      categorie: categorie ?? this.categorie,
      facture: facture ?? this.facture,
      dateExpiration: dateExpiration ?? this.dateExpiration,
      txId: txId ?? this.txId,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      retourDate: retourDate ?? this.retourDate,
      retourStatut: retourStatut ?? this.retourStatut,
      retourStatutRaison: retourStatutRaison ?? this.retourStatutRaison,
      annulationDate: annulationDate ?? this.annulationDate,
      annulationStatut: annulationStatut ?? this.annulationStatut,
      annulationStatutRaison:
      annulationStatutRaison ?? this.annulationStatutRaison,
      annulationRaison: annulationRaison ?? this.annulationRaison,
      dateDemande: dateDemande ?? this.dateDemande,
      dateReponse: dateReponse ?? this.dateReponse,
      remise: remise ?? this.remise,
      retraitAchat: retraitAchat ?? this.retraitAchat,
      retraitMontant: retraitMontant ?? this.retraitMontant,
      retraitFrais: retraitFrais ?? this.retraitFrais,
      differe: differe ?? this.differe,
      differeFrequence: differeFrequence ?? this.differeFrequence,
      differeOccurence: differeOccurence ?? this.differeOccurence,
      differeMontant: differeMontant ?? this.differeMontant,
      transactionVerificationResultAlias: transactionVerificationResultAlias ??
          this.transactionVerificationResultAlias,
      transactionVerificationResultIban:
      transactionVerificationResultIban ?? this.transactionVerificationResultIban,
      transactionVerificationResultOthr:
      transactionVerificationResultOthr ?? this.transactionVerificationResultOthr,
      additionalInformations:
      additionalInformations ?? this.additionalInformations,
      codeMembreParticipantPayeur:
      codeMembreParticipantPayeur ?? this.codeMembreParticipantPayeur,
      codeMembreParticipantPayer :
        codeMembreParticipantPayer ?? this.codeMembreParticipantPayer,
    );
  }
}
