
import '../../../../shared/models/frequence_command.dart';
import 'transaction_canal.dart';
import 'transaction_cancel_reason.dart';

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
    this.differeFrequence,
    this.differeOccurence,
    this.differeMontant,
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
    return Transaction(
      compte: json['compte'],
      acquirerPhoneNumber: json['acquirerPhoneNumber'],
      acquirerAccountLabel: json['acquirerAccountLabel'],
      alias: json['alias'] as String?,
      montant: double.parse(json['montant'].toString()),
      montantFrais: json['montantFrais'] != null
          ? double.parse(json['montantFrais'].toString())
          : null,
      sens: json['sens'],
      motif: json['motif'] as String?,
      canal: json['canal'] as String?,
      clientNom: json['clientNom'] as String,
      clientPays: json['clientPays'] as String,
      clientPhoto: json['clientPhoto'] as String?,
      clientPSP: json['clientPSP'] as String?,
      issuerPhoneNumber: json['issuerPhoneNumber'] as String?,
      clientCompte: json['clientCompte'] as String?,
      clientAlias: json['clientAlias'] as String?,
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
      acquirerAccount: json['acquirerAccount'] as String?,
      endToEndId: json['endToEndId'] as String,
      dateOperation: json['dateOperation'] != null
          ? DateTime.parse(json['dateOperation'] as String)
          : null,
      statut: _getStatut(json['statut']),
      statutRaison: json['statutRaison'] as String?,
      categorie: json['categorie'] as String?,
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
    );
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

}
