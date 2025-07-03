import '../new/movement_details_dto.dart';
import '../transaction.dart';

extension MovementDetailsMapper on MovementDetailsDTO {
  Transaction toTransaction() {
    // Choix du compte : soit accountNumber, soit issuerAccount, sinon chaîne vide
    final compte =  accountNumber ?? issuerPhoneNumber ?? ' ----- ';

    // Mapping du sens à partir de flowCode (exemple, à adapter si besoin)
/*    final sens = (flowCode.toLowerCase() == 'debit')
        ? TransactionSens.debit
        : TransactionSens.credit;*/



    // Mapping du statut à partir de statusCode
    final statut = _mapStatusCode(statusCode);

    return Transaction(
      compte: compte,
      acquirerPhoneNumber: acquirerPhoneNumber ?? ' --- ',
      acquirerAccountLabel: acquirerAccountLabel ?? 'FirstName LastName',
      alias: null,
      montant: amount,
      montantFrais: globalFees,
      sens: TransactionSens.debit,
      motif: message ?? '',
      canal: serviceTypeCode,
      // on stocke serviceTypeCode dans canal
      clientNom: issuerAccountLabel ?? 'FirstName LastName',
      clientPays: countryISOCode ?? '',
      clientPSP: null,
      clientPSPNom: null,
      clientPhoto: null,
      clientCompte: issuerAccount ?? ' --- ',
      // on stocke ici l’issuerAccount
      clientAlias: null,
      endToEndId: guID,
      dateOperation: impactDate,
      statut: statut,
      issuerPhoneNumber: issuerPhoneNumber,
      statutRaison: null,
      categorie: serviceTypeCode,
      facture: null,
      dateExpiration: null,
      txId: guID,
      dateDebut: null,
      dateFin: null,
      frequence: null,
      periodicite: null,
      retourDate: null,
      retourStatut: null,
      retourStatutRaison: null,
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
      bankCode: bankCode,
      productCode: productCode,
      clientId: clientId,
      globalCommission: globalCommission,
      legalEntityCode: legalEntityCode,
      partnerDistId: partnerDistId,
      partnerID: partnerID,
      slipNumber: slipNumber,
      userLogin: userLogin,
      acquirerAccount: acquirerAccount ?? ' --- ',
    );
  }
}

  TransactionStatut? _mapStatusCode(String? code) {
    if (code == null) return null;
    switch (code.toLowerCase()) {
      case 'successful':
      case 'success':
        return TransactionStatut.irrevocable;
      case 'rejected':
      case 'rejete':
        return TransactionStatut.rejete;
      case 'initie':
        return TransactionStatut.initie;
      case 'desactive':
        return TransactionStatut.desactive;
      default:
        return null;
    }
  }