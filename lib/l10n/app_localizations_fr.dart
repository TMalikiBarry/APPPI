// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'PI';

  @override
  String get welcome => 'Bienvenue!';

  @override
  String get noFees => 'Gratuit';

  @override
  String get internetErrorTitle => '😔 Oooops';

  @override
  String get internetErrorSubtitle => 'Il semble que vous n\'ayez pas de connexion internet ou que le serveur ne soit pas disponible!';

  @override
  String get serverErrorTitle => '😔 Oooops';

  @override
  String get serverErrorSubtitle => 'Une erreur s\'est produite, réessayez ultérieurement.';

  @override
  String get erreurInattendue => 'Une erreur inattendue s\'est produite';

  @override
  String get reessayer => 'Réessayez';

  @override
  String get errorDialogOk => 'Compris';

  @override
  String get btnTextReject => 'Rejeter';

  @override
  String get btnTextAccept => 'Accepter';

  @override
  String get btnTextConfirm => 'Confirmer';

  @override
  String get btnTextCancel => 'Annuler';

  @override
  String get btnTextYes => 'Oui';

  @override
  String get btnTextNo => 'Non';

  @override
  String get btnTextContinue => 'Continuer';

  @override
  String get btnTextSend => 'Envoyer';

  @override
  String get btnTextAsk => 'Demander';

  @override
  String get btnTextPay => 'Payer';

  @override
  String get btnTextEdit => 'Editer';

  @override
  String get btnTextDisable => 'Désactiver';

  @override
  String get btnTextEnable => 'Réactiver';

  @override
  String get btnTextDelete => 'Supprimer';

  @override
  String get btnTextSave => 'Enregistrer';

  @override
  String get statutLabel => 'Statut';

  @override
  String get statutInitie => 'En attente';

  @override
  String get statutRejete => 'Rejetée';

  @override
  String get statutAccepte => 'Acceptée';

  @override
  String get statutActive => 'Activé';

  @override
  String get statutDesactive => 'Désactivé';

  @override
  String get introductionLegende => 'Bienvenue sur SPI';

  @override
  String get introductionItem1 => 'Gérez vos dépenses en allouant des budgets';

  @override
  String get introductionItem2 => 'Économisez pour réaliser vos rêves';

  @override
  String get introductionItem3 => 'Planifiez vos paiements pour vous libérer l\'esprit';

  @override
  String get introductionItem4 => 'Payez et transférez gratuitement vers n’importe quel compte';

  @override
  String get introductionItem5 => 'Économisez et partagez des dépenses entre amis';

  @override
  String get introductionItem6 => 'Utilisez l’alias pour la confidentialité et la précision';

  @override
  String get introductionLogin => 'Connexion';

  @override
  String get introductionGotIt => 'J\'ai compris';

  @override
  String get introductionFooterTitle => 'Vous n\'avez pas de compte';

  @override
  String get introductionFooterSubtitle => 'Trouvez une agence proche';

  @override
  String get loginPageTitle => 'Connexion';

  @override
  String get loginPageSubTitle => 'Utilisez l’identifiant obtenu de votre institution financière';

  @override
  String get loginPageFooterIntro => 'En continuant, vous acceptez ';

  @override
  String get loginPageFooterCGU => 'nos Conditions d\'utilisation';

  @override
  String get loginPageFooterPC => 'notre Politique de Confidentialité';

  @override
  String get coordinationEt => 'et';

  @override
  String get loginFormUsernameLabel => 'Identifiant';

  @override
  String get loginFormUsernameHint => 'Fourni par l\'institution';

  @override
  String get loginUsernameErrorEmpty => 'Identifiant obligatoire';

  @override
  String get loginUsernameErrorInvalid => 'Identifiant invalide';

  @override
  String get loginFormPasswordLabel => 'Mot de passe';

  @override
  String get loginFormPasswordHint => 'Mot de passe';

  @override
  String get loginPasswordErrorEmpty => 'Mot de passe obligatoire';

  @override
  String get loginPasswordErrorInvalid => 'Mot de passe invalide';

  @override
  String get loginFormBtnConnexion => 'Continuer';

  @override
  String get changePasswordPageTitle => 'Changer mot de passe';

  @override
  String get changePasswordPageSubTitle => 'Veuillez changer votre mot de passe pour la sécurité';

  @override
  String get changePasswordFormPasswordHint => 'Définir un nouveau mot de passe';

  @override
  String get changePasswordFormConfirmHint => 'Confirmez le nouveau mot de passe';

  @override
  String get changePasswordFormBtnConnexion => 'Valider';

  @override
  String get changePasswordErrorEmpty => 'Nouveau mot de passe obligatoire';

  @override
  String get changePasswordErrorInvalid => 'Doit contenir au moins un chiffre, une lettre et le caractère  @ ou _';

  @override
  String get changePasswordErrorDifferent => 'Les deux codes secrets ne sont pas identiques';

  @override
  String get createCodePinFormTitle => 'Créez votre code pin';

  @override
  String get createCodePinFormSubTitle => 'Il contribue à protéger vos informations confidentielles la prochaine fois que vous ouvrez l’app';

  @override
  String get configureBiometryMethod => 'la biométrie';

  @override
  String get configureBiometryMethodFace => 'Face ID';

  @override
  String get configureBiometryMethodFingerprint => 'l\'empreinte';

  @override
  String configureBiometryFormTitle(String method) {
    return 'Activez $method pour la prochaine fois ?';
  }

  @override
  String configureBiometryFormSubTitle(String method) {
    return 'Utilisez $method plûtot que le code PIN';
  }

  @override
  String configureBiometryFormSubmitBtn(String method) {
    return 'Utiliser $method';
  }

  @override
  String get configureBiometryFormNotNowBtn => 'Pas maintenant';

  @override
  String get identificationFormLoginMessage => 'Saisissez votre code PIN';

  @override
  String get identificationFormForgotMessage => 'Code PIN oublié?';

  @override
  String identificationHelloUser(String user) {
    return 'Bonjour, $user';
  }

  @override
  String get identificationErrorPinInvalid => 'Le code PIN est invalide';

  @override
  String get biometric_auth => 'Biometric authentication';

  @override
  String get biometric_auth_required => 'Use your fingerprint or facial recognition';

  @override
  String get biometric_use_pwd => 'Use a secret code';

  @override
  String get biometric_use_fingerprint => 'Verify identity';

  @override
  String get biometric_echec_biometric => 'Biometric failure. Try again';

  @override
  String get biometric_error => 'Biometric error';

  @override
  String get biometric_success_authentification => 'Successful authentication';

  @override
  String get biometric_success_setting => 'Settings';

  @override
  String get biometric_activation_setting => 'Activate biometrics in your settings';

  @override
  String get biometric_tmp_later => 'Biometrics temporarily disabled. Try again later';

  @override
  String get upgrade_profile_tier1 => 'Niveau 1';

  @override
  String get upgrade_profile_tier2 => 'Niveau 2';

  @override
  String get upgrade_profile_step1 => 'Étape 1';

  @override
  String get upgrade_profile_step2 => 'Étape 2';

  @override
  String get permissionNotificationTitle => 'Ne ratez rien';

  @override
  String get permissionNotificationSubTitle => 'Recevez des notifications sur les dépenses, la sécurité et vos économies afin d\'être toujours au courant';

  @override
  String get permissionNotificationEnableBtn => 'Activer les notifications';

  @override
  String get permissionNotificationNotNowBtn => 'Pas maintenant';

  @override
  String get permissionContactTitle => 'Trouvez vos amis';

  @override
  String get permissionContactSubTitle1 => 'Vous gardez le contrôle! ';

  @override
  String get permissionContactSubTitle2 => 'Nous ne conservons jamais vos contacts téléphoniques.';

  @override
  String get permissionContactEnableBtn => 'Accès et mise à jour des contacts';

  @override
  String get permissionContactNotNowBtn => 'Pas maintenant';

  @override
  String get permissionErrorTitle => '😔 Oooops';

  @override
  String get permissionErrorDevice => 'Votre appareil n\'est pas supporté.';

  @override
  String get permissionErrorToken => 'Une erreur est survenue. Réessayer à nouveau';

  @override
  String get permissionErrorApi => 'Erreur de communication - Vérifier votre connexion internet ou réessayer plus tard!';

  @override
  String get securityLogoutTitle => 'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get securityLogoutSubTitle => 'Si vous souhaitez continuer à travailler, cliquez sur « Annuler » et vous reviendrez à votre état actuel. Si vous souhaitez vraiment vous déconnecter, cliquez sur « Déconnecter ».';

  @override
  String get securityLogoutBtnConfirmer => 'Déconnecter';

  @override
  String get securityLogoutBtnAnnuler => 'Annuler';

  @override
  String get aliasCreatePageTitle => 'Créer un alias';

  @override
  String get aliasCreatePageSubTitle => 'Les gens peuvent vous envoyer de l\'argent à partir de votre alias';

  @override
  String get aliasCreateSHIDTitle => 'Choisir l’adresse de paiement';

  @override
  String get aliasCreateSHIDSubTitle => 'L’adresse de paiement est créé par SPI';

  @override
  String get aliasCreateMBNOTitle => 'Choisir le numéro de téléphone';

  @override
  String get aliasCreateMBNOSubTitle => 'Sera enregistré comme alias par SPI';

  @override
  String get aliaSuccessPageTitle => '🤩 Bravo';

  @override
  String get aliaSuccessPageSubTitle => 'Votre alias est créé';

  @override
  String get aliaSuccessPageDescription => 'Vous pouvez le partager avec d\'autres personnes, ce qui leur permet d\'effectuer des transferts sur votre compte. L’alias simplifie le processus et vous permet d\'effectuer des transactions en toute simplicité tout en préservant votre vie privée';

  @override
  String get aliaSuccessPageBtnText => 'Continuez';

  @override
  String get aliaSuccessClaimPageTitle => 'Demande de revendication envoyée avec succès';

  @override
  String get addPhoneNumberPageTitle => 'Numéro de téléphone';

  @override
  String get addPhoneNumberPageSubTitle => 'Un code de vérification sera envoyé sur ce numéro';

  @override
  String get addPhoneNumberFormHint => 'Téléphone mobile';

  @override
  String get addPhoneNumberFormErrorEmpty => 'Champ obligatoire';

  @override
  String get addPhoneNumberFormErrorInvalid => 'Numero invalide';

  @override
  String get addPhoneNumberFormBtnContinuer => 'Continuer';

  @override
  String get verifyPhoneNumberPageTitle => 'Code de vérification';

  @override
  String verifyPhoneNumberPageSubTitle(String number) {
    return 'Saisissez le code envoyé au $number';
  }

  @override
  String aliaMBNOResendMessage(String delay) {
    return 'Renvoyer le code dans $delay';
  }

  @override
  String get aliaMBNOResendMessageBtn => 'Renvoyer le code';

  @override
  String get aliaMBNOInvalidOtpMessage => 'Code otp invalide';

  @override
  String get aliasInvalidOtpResend => 'Renvoyer';

  @override
  String get aliaErrorPageTitle => '😔 Oooops';

  @override
  String get aliaErrorPageSubTitle => 'Cet alias est pris';

  @override
  String get aliaErrorPageDescription => 'Le numéro de téléphone est déjà enregistré comme alias sur un autre compte';

  @override
  String get aliaErrorPageReclamationBtnText => 'Revendiquer l\'alias';

  @override
  String get aliaErrorPageChoisisserBtnText => 'Choisissez un autre alias';

  @override
  String get aliaErrorClaimNotExistPageSubTitle => 'Revendication introuvable';

  @override
  String get aliaErrorClaimNotExistPageDescription => 'Cette revendication n\'est plus disponible. Elle est terminée, clôturée ou archivée !';

  @override
  String get aliaErrorClaimLockedPageSubTitle => 'Une revendication est en cours sur cet alias';

  @override
  String get aliaErrorClaimNotFoundPageSubTitle => 'L\'alias a été supprimé par son détenteur';

  @override
  String get aliasClaimDetailsHeadTitle => 'Revendication d\'alias';

  @override
  String get aliasClaimDetailsHeadSubTitle => 'Numéro de téléphone réclamé';

  @override
  String get aliasClaimDetailsBtnConfirmer => 'Accepter';

  @override
  String get aliasClaimDetailsDateDemande => 'Date demande';

  @override
  String get aliasClaimDetailsDateAcceptation => 'Date d\'acceptation';

  @override
  String get aliasClaimDetailsDateRefus => 'Date de rejet';

  @override
  String aliasClaimDetailsAlert(String dateVerrouillage, String dateCloture) {
    return 'Si vous ne rejetez pas cette demande avec succès d\'ici le $dateVerrouillage, vous ne pourrez plus faire de transactions avec cet alias. Si à la date du $dateCloture la demande est toujours en attente, l\'alias sera supprimé.';
  }

  @override
  String get aliasClaimAcceptDialogTitle => 'Etes-vous sûr(e) de vouloir accepter la revendication ?';

  @override
  String aliasClaimAcceptDialogMessage(String alias) {
    return 'A l\'acceptation, votre alias $alias sera supprimé, cette action sera irréversible. Vous ne pourrez plus recevoir de paiement avec cet alias. Cependant vous pourrez toujours utiliser l\'adresse de paiement associée.';
  }

  @override
  String get aliasClaimAcceptSuccessTitle => 'Revendication acceptée';

  @override
  String aliasClaimAcceptSuccessDescription(String alias) {
    return 'Votre alias $alias est supprimé';
  }

  @override
  String get aliasClaimRejectSuccessTitle => 'Revendication refusée';

  @override
  String aliasClaimRejectSuccessDescription(String alias) {
    return 'Votre alias $alias est conservé';
  }

  @override
  String get aliasClaimDetailsRefusPageSubTitile => 'Le refus ne peut être accepter que si vous prouvez que le numèro de téléphone vous appartient en renseignant le code OTP';

  @override
  String get aliasClaimConfirmError => 'La confirmation a échouée veuillez réessayer svp';

  @override
  String get aliasClaimConfirmSuccessRejectTitle => 'Alias conservé';

  @override
  String get aliasClaimConfirmSuccessAcceptTitle => 'Alias supprimé';

  @override
  String get aliasFormLabel => 'Alias';

  @override
  String get aliasFormHint => 'Adresse de paiement ou n° de téléphone';

  @override
  String get aliasFormEmpty => 'Obligatoire';

  @override
  String get aliasFormInvalid => 'Doit être une adresse de paiement de 36 caractères ou un numéro de téléphone avec l\'indicatif';

  @override
  String get aliasFormNotFound => 'L’alias du bénéficiaire n’existe pas dans PI';

  @override
  String get contactActionsTitle => 'Contact';

  @override
  String get contactWithNoPhoneNumber => 'Ce contact ne dispose pas de numéro de téléphone';

  @override
  String get contactTransferTitle => 'Transfert par contact';

  @override
  String contactPhoneAsAccountAlias(String phoneNumber) {
    return '$phoneNumber est un alias de compte';
  }

  @override
  String contactPhoneAsAccountNumber(String phoneNumber) {
    return '$phoneNumber est un numéro de compte';
  }

  @override
  String get contactCreateTitle => 'Ajouter un contact';

  @override
  String get contactCreateSubtitle => 'Enregistrer un contact avec son alias';

  @override
  String get contactCreateNameLabel => 'Prénoms et nom';

  @override
  String get contactCreateNameErrorEmpty => 'Nom obligatoire';

  @override
  String get contactBtnSave => 'Enregistrer et continuer';

  @override
  String get homePageToolbarTabbarCompte => 'Compte';

  @override
  String get homePageToolbarTabbarAbonnement => 'Abonnements';

  @override
  String get homePageToolbarTabbarEconomie => 'Economies';

  @override
  String get homeSolde => 'Solde';

  @override
  String get homeActionSend => 'Envoyer';

  @override
  String get homeActionRequest => 'Recevoir';

  @override
  String get homeActionMore => 'Plus';

  @override
  String get homeTransactions => 'Transactions';

  @override
  String get homeTransactionsRecent => 'Transactions récentes';

  @override
  String get transactionsNoRecent => 'Aucune transaction récente';

  @override
  String get transactionsNoRecentSubtitle => 'Vos transactions récentes apparaîtront ici';

  @override
  String get transactionsErrorLoading => 'Erreur de chargement des transactions';

  @override
  String get retry => 'Réessayer';

  @override
  String get homeTransactionsRecentsNombreTitle => 'Dernières transactions';

  @override
  String get homeTransactionsRecentsNombreSubTitle => 'Choisissez le nombre de transactions que vous souhaitez voir apparaître dans votre widget';

  @override
  String get homeTransactionsRecentsNombreBtnSave => 'Enregistrer';

  @override
  String get homeActionMoreSheetProgrammerTitle => 'Programmer un paiement';

  @override
  String get homeActionMoreSheetProgrammerSubTitle => 'Créer un nouveau transfert';

  @override
  String get homeActionMoreSheetAbonnementTitle => 'Trouver un abonnement';

  @override
  String get homeActionMoreSheetAbonnementSubTitle => 'Convertir un paiement passé en abonnement';

  @override
  String get homeActionMoreSheetPartagerTitle => 'Partager un paiement';

  @override
  String get homeActionMoreSheetPartagerSubTitle => 'Répartir un paiement entre amis';

  @override
  String get homeActionMoreSheetTirelireTitle => 'Nouvelle tirelire';

  @override
  String get homeActionMoreSheetTirelireSubTitle => 'Ajouter une tirelire pour un besoin';

  @override
  String get homeActionMoreSheetBudgetTitle => 'Définir un budget';

  @override
  String get homeActionMoreSheetBudgetSubTitle => 'Créer un budget pour ses dépenses';

  @override
  String get homeActionMoreSheetWidgetTitle => 'Ajouter un widget';

  @override
  String get homeActionMoreSheetAWidgetSubTitle => 'Gérer les widgets de l’écran principal';

  @override
  String get transactionsSeeAll => 'Tout afficher';

  @override
  String get transactionsSendInputHint => 'Nom, Alias';

  @override
  String get transactionsSendOptionAliasTitle => 'Par alias';

  @override
  String get transactionsSendOptionAliasSubtitle => 'Alias du bénéficiaire';

  @override
  String get transactionsSendOptionIbanTitle => 'Par IBAN';

  @override
  String get transactionsSendOptionIbanSubtitle => 'Numéro du compte bancaire';

  @override
  String get transactionsSendOptionOthrTitle => 'Par autre compte';

  @override
  String get transactionsSendOptionOthrSubtitle => 'Numéro de compte SFD / EME';

  @override
  String get transactionsSendOptionNewContactTitle => 'Nouveau contact';

  @override
  String get transactionsSendOptionNewContactSubtitle => 'Ajouter un contact avec son alias';

  @override
  String get transactionsSendRecentItemYouSend => 'Vous avez envoyé ';

  @override
  String get transactionsSendRecentItemYouReceive => 'Vous avez reçu ';

  @override
  String get transactionsSendTitleTransfert => 'Transfert';

  @override
  String get transactionsSendTitleRecents => 'Transferts récents';

  @override
  String get transactionsSendTitleContacts => 'Contacts';

  @override
  String get transactionsSendTitleRequest2Pay => 'Demande de paiement';

  @override
  String get transactionsSendTitleRequest2PayRecents => 'Demande récentes';

  @override
  String get transactionsSendScheduleTitle => 'Qui payer';

  @override
  String get transactionsSendFormAliasTitle => 'Transfert par Alias';

  @override
  String get transactionsSendFormAliasSubtitle => 'Coller ou saisissez l’alias';

  @override
  String get transactionsSendFormOthrTitle => 'Transfert par autre compte';

  @override
  String get transactionsSendFormOthrSubtitle => 'Numéro de compte d’un SFD ou d’un EME';

  @override
  String get transactionsSendFormIbanTitle => 'Transfert par IBAN';

  @override
  String get transactionsSendFormIbanSubtitle => 'Coller ou saisissez l\'IBAN';

  @override
  String get transactionsSendFormQrCodeTitleTransfer => 'Transfert par QR Code';

  @override
  String get transactionsSendFormQrCodeTitlePayment => 'Paiement par QR Code';

  @override
  String get transactionsSendFormQrCodeSubtitle => 'Saisissez le montant';

  @override
  String get transactionsSendSuccessBtnVoir => 'Voir le paiement';

  @override
  String get transactionsSendSuccessBtnReessayer => 'Rééssayer';

  @override
  String get transactionsSendErrorTitle => '😔 Oooops';

  @override
  String get transactionsSendErrorDescription => 'La transaction a échouée.';

  @override
  String get transactionsSendErrorBtn => 'Continuer';

  @override
  String get transactionFormAmountHint => 'Montant';

  @override
  String get transactionFormAmountEmpty => 'Obligatoire';

  @override
  String get transactionFormAmountInvalid => 'Solde insuffisant';

  @override
  String get transactionFormAmountLow => 'Montant minimum 5 frcs';

  @override
  String get transactionFormMotifHint => 'Ajouter une note';

  @override
  String get transactionFormMotifLabel => 'Note';

  @override
  String get transactionFormMotifInvalid => 'Pas plus de 104 caractères';

  @override
  String get transactionFormFactureLabel => 'Facture';

  @override
  String get transactionFormIbanLabel => 'IBAN';

  @override
  String get transactionFormIbanHint => 'IBAN du bénéficiaire';

  @override
  String get transactionFormIbanEmpty => 'Obligatoire';

  @override
  String get transactionFormIbanInvalid => 'Format de l\'IBAN invalide';

  @override
  String get transactionFormIbanPaysLabel => 'Pays de la banque';

  @override
  String get transactionFormIbanNomLabel => 'Nom de la banque';

  @override
  String get transactionFormOthrLabel => 'Numéro de compte';

  @override
  String get transactionFormOthrHint => 'Numéro de compte du bénéficiaire';

  @override
  String get transactionFormOthrEmpty => 'Obligatoire';

  @override
  String get transactionFormOthrPaysLabel => 'Pays de l\'intitution financière';

  @override
  String get transactionFormOthrNomLabel => 'Nom de l\'institution financière ';

  @override
  String get transactionFormContinueBtn => 'Continuer';

  @override
  String get transactionFormSaveContactBtn => 'Enregistrer et faire un transfert';

  @override
  String get transactionFormVerificationTitle => 'Vérification';

  @override
  String get transactionFormVerificationSubtitle => 'Voulez-vous vraiment effectuer un transfert au profit de ce bénéficiaire ?';

  @override
  String get transactionFormVerificationTypeLabel => 'Type';

  @override
  String get transactionFormVerificationTypeIBAN => 'Transfert par IBAN';

  @override
  String get transactionFormVerificationTypeOTHR => 'Transfert par autre compte';

  @override
  String get transactionFormVerificationClientName => 'Nom du client';

  @override
  String get transactionFormVerificationBtnConfirm => 'Confirmer';

  @override
  String get transactionFormVerificationBtnReject => 'Annuler';

  @override
  String get transactionFormScheduleTitle => 'Programmer';

  @override
  String get transactionFormScheduleSubtitle => 'Votre paiement sera effectué à la date choisie';

  @override
  String get transactionFormScheduleDateLabel => 'Date';

  @override
  String get transactionFormScheduleDateRangeLabel => 'Date de début - Date de fin';

  @override
  String get transactionFormScheduleDateSelectTitle => 'Selectionner une date';

  @override
  String get transactionFormScheduleDateRangeSelectTitle => 'Selectionner une plage de dates';

  @override
  String get transactionFormScheduleFrequenceLabel => 'Fréquence';

  @override
  String get transactionFormScheduleFrequenceUnefois => 'Une seule fois';

  @override
  String get transactionFormScheduleFrequenceQuotidienne => 'Quotidienne';

  @override
  String get transactionFormScheduleFrequenceHebdomadaire => 'Hebdomadaire';

  @override
  String get transactionFormScheduleFrequenceMensuelle => 'Mensuelle';

  @override
  String get transactionFormScheduleFrequenceAnnuelle => 'Annuelle';

  @override
  String get transactionFormScheduleFrequenceSurMesure => 'Sur mesure';

  @override
  String get transactionFormSchedulePeriodiciteLabel => 'Périodicité';

  @override
  String transactionFormScheduleFrequenceSelected(String periodicite, String frequence) {
    return 'Tous les $periodicite $frequence';
  }

  @override
  String transactionFormScheduleDateRange(String start, String end) {
    return 'du $start au $end';
  }

  @override
  String transactionFormScheduleDateSelected(String start) {
    return 'A partir du $start';
  }

  @override
  String transactionFormScheduleSuccessMessage(String montant, String payee) {
    return 'Vous avez programmé $montant FCFA pour $payee';
  }

  @override
  String get transactionFormScheduleSuccessBtn => 'Voir l\'abonnement';

  @override
  String transactionsSendSuccessBtnTitle(String payee) {
    return 'Vous avez envoyé de l\'argent à $payee';
  }

  @override
  String get subscriptionEmptyTitle => 'Transactions à venir';

  @override
  String get subscriptionEmptySubTitle => 'Gérer vos abonnements et vos paiements programmés en un seul endroit';

  @override
  String get subscriptionListOnceTitle => 'Paiements programmés';

  @override
  String get subscriptionEmptyBtnCreate => 'Nouveau';

  @override
  String get subscriptionListFrequenceTitle => 'Abonnements';

  @override
  String get subscriptionMenuScheduleTitle => 'Programmer un paiement';

  @override
  String get subscriptionMenuScheduleSubtitle => 'Executer un paiement à une date donnée';

  @override
  String get subscriptionMenuSubscribeTitle => 'Créer un abonnement';

  @override
  String get subscriptionMenuSubscribeSubtitle => 'Convertir un paiement en un abonnement';

  @override
  String get subscriptionMenuSubscribeSubtitle2 => 'Recherchez dans vos transactions et sélectionnez un paiement récurrent';

  @override
  String get subscriptionDateScheduledForTitle => 'Programmé pour';

  @override
  String subscriptionDateScheduledFor(String date) {
    return 'Programmé pour le $date';
  }

  @override
  String get subscriptionDateNextPaymentTitle => 'Prochain paiement';

  @override
  String subscriptionDateNextPayment(String date) {
    return 'Prochain paiement le $date';
  }

  @override
  String subscriptionDateEndsSince(String date) {
    return 'Terminé depuis le $date';
  }

  @override
  String get subscriptionDateToday => 'Paiement pour aujourd\'hui';

  @override
  String get subscriptionDisabled => 'Abonnement désactivé';

  @override
  String get subscriptionPaymentTo => 'Paiement à';

  @override
  String get subscriptionStartDate => 'Date de début';

  @override
  String get subscriptionEditNoteBtn => 'Modifier la note';

  @override
  String transactionsRtpSuccessBtnTitle(String payee) {
    return 'Vous avez envoyé une demande de paiement à $payee';
  }

  @override
  String get transactionsRtpSuccessBtnVoir => 'Voir la demande';

  @override
  String transactionRtpDetailsTitleInitiee(String payeur) {
    return 'Vous avez demandé à $payeur';
  }

  @override
  String transactionRtpDetailsTitleRecue(String paye) {
    return 'Vous devez à $paye';
  }

  @override
  String get transactionRtpDetailsEcheanceDate => 'Date d\'échéance';

  @override
  String get transactionRtpDetailsRemiseTitle => 'Paiement immédiat';

  @override
  String get transactionRtpDetailsRemiseLabel => 'Remise';

  @override
  String transactionRtpDetailsRemiseHint(String dateReponse) {
    return 'valable jusqu’au $dateReponse';
  }

  @override
  String get transactionRtpDetailsSplitPaymentTitle => 'Paiement partagé';

  @override
  String get transactionRtpDetailsSplitPaymentTo => 'Payé à';

  @override
  String get transactionRtpDetailsPICOTitle => 'Retrait avec achat PICO';

  @override
  String get transactionRtpDetailsPICASHTitle => 'Retrait PICASH';

  @override
  String get transactionRtpDetailsAmtAchatTitle => 'Achat';

  @override
  String get transactionRtpDetailsAmtRetraitTitle => 'Retrait';

  @override
  String get transactionRtpDetailsAmtFraisTitle => 'Frais';

  @override
  String get transactionRtpDetailsDiffereTitle => 'Débit différé';

  @override
  String get transactionRtpDetailsDiffereSubtitle => 'Achetez maintenant, Payez plus tard!';

  @override
  String get transactionRtpDetailsDiffereDescription => 'Votre compte sera débité à la fin du mois';

  @override
  String transactionRtpDetailsDifferePayFrequence(int occurence, String frequence) {
    return 'Payer en $occurence $frequence';
  }

  @override
  String transactionRtpDetailsDifferePayAmt(String montant, String frequence) {
    return '$montant par $frequence';
  }

  @override
  String transactionRtpRejectTitle(String paye) {
    return 'Rejeter la demande de $paye';
  }

  @override
  String transactionRtpRejectSubtitle(String montant, String paye) {
    return '$montant pour $paye';
  }

  @override
  String get transactionRtpRejectRsnDemandeur => 'Demandeur inconnu';

  @override
  String get transactionRtpRejectRsnMontant => 'Montant incorrect';

  @override
  String get transactionRtpRejectRsnRemittance => 'Facture incorrecte';

  @override
  String get transactionRtpRejectMessage => 'La demande de paiement est rejetée avec succès';

  @override
  String get transactionDetailsMessage => 'Message';

  @override
  String get transactionDetailsFrequenceMois => 'mois';

  @override
  String get transactionDetailsFrequenceSemaine => 'semaines';

  @override
  String get transactionDetailsFrequenceJour => 'jours';

  @override
  String get transactionDetailsRetourner => 'Retourner';

  @override
  String get transactionDetailsAnnuler => 'Annuler';

  @override
  String get transactionDetailsRecevoir => 'Recevoir';

  @override
  String get transactionDetailsPartager => 'Partager';

  @override
  String get transactionDetailsPlanifier => 'Planifier';

  @override
  String get transactionDetailsMotifCredit => 'Reçu sans note';

  @override
  String get transactionDetailsMotifDebit => 'Envoyé sans note';

  @override
  String get transactionDetailsReference => 'Référence';

  @override
  String get transactionDetailsPays => 'Pays';

  @override
  String get transactionDetailsPayeLabel => 'Payé à';

  @override
  String get transactionDetailsPayeurLabel => 'Reçu de';

  @override
  String get transactionDetailsDateLabel => 'Reçu à';

  @override
  String get transactionDetailsTelecharger => 'Télécharger';

  @override
  String get transactionDetailsRecuPaiement => 'Reçu du paiement';

  @override
  String get transactionDetailsAlias => 'Alias';

  @override
  String get transactionDetailsCategorie => 'Catégorie';

  @override
  String get transactionDetailsTicket => 'Ticket de caisse';

  @override
  String get transactionDetailsAnalytique => 'Exclure de l’analytique';

  @override
  String get transactionDetailsQuestion => 'Sélectionner une question';

  @override
  String get transactionDetailsTeleverser => 'Téléverser';

  @override
  String get transactionDetailsRecuPaiementPDF => 'Reçu du paiement';

  @override
  String get transactionDetailsRecuPaiementPDFSousTitre => 'Vous pouvez partager ou télécharger le PDF';

  @override
  String get transactionDetailsTicketCaisse => 'Reçu réglé';

  @override
  String get transactionDetailsTicketCaisseSubtitle => 'Vous pouvez partager le ticket de caisse';

  @override
  String get transactionDetailsCompte => 'Compte';

  @override
  String get transactionDetailsInstitution => 'Institution';

  @override
  String get transactionDetailsReturnTitle => 'Êtes-vous sûr de vouloir retourner les fonds ?';

  @override
  String get transactionDetailsReturnSuccessMessage => 'Vous avez retourné les fonds avec succès';

  @override
  String get transactionDetailsRetourDateLabel => 'Retourné le';

  @override
  String get transactionDetailsCancelTitle => 'Demande d\'annulation';

  @override
  String get transactionDetailsCancelSubTitle => 'Quelle est la raison de la demande ?';

  @override
  String get transactionDetailsCancelRsnDestinataire => 'Erreur sur le destinataire';

  @override
  String get transactionDetailsCancelRsnMontant => 'Erreur sur le montant';

  @override
  String get transactionDetailsCancelRsnService => 'Service non rendu';

  @override
  String get transactionDetailsCancelRsnFraud => 'Tentative de fraude';

  @override
  String get transactionDetailsCancelRsnDuplicate => 'Déjà payé';

  @override
  String get transactionDetailsCancelBtnSend => 'Demander l\'annulation';

  @override
  String get transactionDetailsCancelSuccessMessage => 'Demande d’annulation envoyée';

  @override
  String get transactionDetailsCancelSuccessDescription => 'La demande est en attente de traitement. \n Vous serez notifié dès que le bénéficiaire aura répondu.';

  @override
  String get transactionDetailsCancelSuccessDescriptionNotification => 'Vous serez notifié dès que le bénéficiaire aura répondu.';

  @override
  String get transactionDetailsCancelDemandeLabel => 'Demandé le';

  @override
  String get transactionDetailsCancelDateLabel => 'Demande d\'annulation';

  @override
  String transactionDetailsCancelHeadSubtitle(String montant) {
    return '$montant reçu';
  }

  @override
  String get transactionDetailsCancelReasonLabel => 'Raison';

  @override
  String get transactionDetailsCancelRejectMessage => 'La demande d’annulation est rejetée avec succès';

  @override
  String get transactionDetailsRecuTitlePage => 'Paiement effectué';

  @override
  String get transactionDetailsRecuTitle => 'Reçu du paiement';

  @override
  String get transactionDetailsRecuSubTitle => 'Vous pouvez partager ou télécharger le PDF';

  @override
  String get transactionDetailsRecuInfoIdentifiant => 'Identifiant';

  @override
  String get transactionDetailsRecuInfoReference => 'Référence';

  @override
  String get transactionDetailsRecuInfoFrais => 'Frais';

  @override
  String get transactionDetailsRecuInfoFraisDefault => 'Gratuit';

  @override
  String get transactionDetailsRecuInfoPayeLabel => 'Envoyé à';

  @override
  String get transactionDetailsRecuInfoPayeurLabel => 'Reçu de';

  @override
  String get transactionDetailsRecuInfoClientAlias => 'Alias';

  @override
  String get transactionDetailsRecuInfoPayeurID => 'Expéditaire ID';

  @override
  String get transactionDetailsRecuInfoPayeID => 'Bénéficiaire ID';

  @override
  String get transactionDetailsRecuInfoClientCompte => 'Numéro de compte';

  @override
  String get transactionDetailsRecuInfoClientInstitution => 'Institution';

  @override
  String get transactionDetailsRecuInfoDateReception => 'Date reception';

  @override
  String get transactionDetailsRecuInfoDateEnvoi => 'Date envoi';

  @override
  String get transactionDetailsRecuInfoMontant => 'Montant';

  @override
  String get transactionDetailsTicketSaveTitle => 'Enregistrer le ticket de caisse';

  @override
  String get transactionDetailsTicketSaveGallery => 'Ouvrir la galerie';

  @override
  String get transactionSplitTitle => 'Partager avec';

  @override
  String get transactionSplitRepartitionTitle => 'Partager le paiement';

  @override
  String get transactionSplitRepartitionSubtitle1 => 'Paiement partagé';

  @override
  String transactionSplitRepartitionSubtitle2(int nombre) {
    return 'Répartir entre - $nombre';
  }

  @override
  String get transactionSplitRepartitionParMontant => 'Par montant';

  @override
  String get transactionSplitRepartitionSelf => 'Moi';

  @override
  String get transactionSplitRepartitionPartRegle => 'Part réglée';

  @override
  String get transactionSplitRepartitionPartDoit => 'Vous doit';

  @override
  String get transactionSplitRepartitionSuccessMessage => 'Demandes de paiement envoyées';

  @override
  String get transactionErrorSoldeInsuffisant => 'Solde insuffisant';

  @override
  String get transactionErrorDejaRetourne => 'Transaction déja retournée';

  @override
  String get transactionErrorDelaiDepasse => 'La date limite est dépassée';

  @override
  String get transactionErrorDestinataireIndisponible => 'Institution du bénéficiaire momentanément indisponible';

  @override
  String get transactionErrorUnknow => 'Votre demande ne peut pas être traitée pour le moment. Veuillez réessayez ultérieurement';

  @override
  String get transactionSearchTitle => 'Transactions';

  @override
  String get transactionSearchEmptySubtitle => 'Aucune transaction ne correspond à votre recherche';

  @override
  String get transactionSearchEmptyTitle => 'Aucun résultat';

  @override
  String get loadMore => 'Charger Plus';

  @override
  String get transactionSearchInputSearchHint => 'Recherche';

  @override
  String get transactionSearchInputFilterTitle => 'Filtrer';

  @override
  String get transactionSearchInputFilterDateTitle => 'Plage de dates';

  @override
  String get transactionSearchInputFilterDateSubTitle => 'Sélectionner la plage';

  @override
  String transactionSearchInputFilterDateRange(String debut, String fin) {
    return 'Dates de $debut - à $fin';
  }

  @override
  String get transactionSearchInputFilterDateSelectTitle => 'Sélectionner une plage de dates';

  @override
  String get transactionSearchInputFilterCategoriesTitle => 'Categories';

  @override
  String get transactionSearchInputFilterCategoriesSensRecus => 'Reçus';

  @override
  String get transactionSearchInputFilterCategoriesSensPayes => 'Payés';

  @override
  String get transactionSearchInputFilterBtnAppliquer => 'Appliquer';

  @override
  String get qrcodePageBtnScan => 'Scan';

  @override
  String get qrcodePageBtnMonCode => 'Mon Code';

  @override
  String get qrcodePagePartageTitle => 'Partager';

  @override
  String get qrcodePagePartageQrCodeTitle => 'Votre QR Code';

  @override
  String get qrcodePagePartageQrCodeSubTitle => 'Partage de l’image';

  @override
  String get qrcodePagePartageAliasTitle => 'Votre alias';

  @override
  String get qrcodePagePartageAliasSubTitle => 'Copie l’alias dans le presse-papiers';

  @override
  String get qrcodeScanPageMessage => 'Pointez votre appareil photo sur le QR code.\nLe scan se fait automatiquement';

  @override
  String get qrcodeEncodeErrorMsg => 'Erreur d\'affichage de votre QR Code !';

  @override
  String get qrcodeDecodeErrorNotQrImage => 'Image du QR Code invalide';

  @override
  String get qrcodeDecodeErrorInvalideAlias => 'Alias contenu dans le QR Code est invalide';

  @override
  String get qrcodeDecodeErrorInvalideFormat => 'Format du QR Code invalide';

  @override
  String get popupSelectDateBtnValider => 'Valider';

  @override
  String get profilePageBtnInviter => 'Inviter vos amis';

  @override
  String get profilePageMenuCompteTitle => 'Compte';

  @override
  String get profilePageMenuSecurityTitle => 'Sécurité & Confidentialité';

  @override
  String get profilePageMenuParametreTitle => 'Paramètres de l\'application';

  @override
  String get profilePageMenuHelpTitle => 'Centre d\'Aide';

  @override
  String get profilePageMenuAproposTitle => 'A propos de nous';

  @override
  String get profilePageBtnDeconnexion => 'Déconnexion';

  @override
  String get profilePageAppVersion => 'App version';

  @override
  String get profileSecuritePageTitle => 'Sécurité & Confidentialité';

  @override
  String get profileSecuriteMenuSecuriteTitle => 'Sécurité';

  @override
  String get profileSecuriteMenuItemPinTitle => 'Modifier le code PIN';

  @override
  String get profileSecuriteMenuItemTrustedTitle => 'Personnes de confiance';

  @override
  String get profileSecuriteMenuItemBlacklistTitle => 'Liste noire';

  @override
  String get profileSecuriteMenuItemAppareilsTitle => 'Appareils';

  @override
  String get profileSecuriteMenuItemBiometryTitle => 'Autoriser biométrie';

  @override
  String get profileSecuriteMenuItemMontantTitle => 'Cacher les montants';

  @override
  String get profileSecuriteMenuItemMontantSubTitle => 'Basculez l\'écran de votre appareil vers le bas pour masquer et afficher rapidement les montants';

  @override
  String get profileSecuriteMenuConfidentialiteTitle => 'Confidentialité';

  @override
  String get profileSecuriteMenuItemShakeToPayTitle => 'Rendez-moi découvrable';

  @override
  String get profileSecuriteMenuItemShakeToPaySubTitle => 'Lorsque je secoue le téléphone';

  @override
  String get profileSecuriteMontantPopupTitle => 'Affichage des montants';

  @override
  String get profileSecuriteMontantPopupSubTitle => 'Basculez l\'écran de votre appareil vers le bas pour masquer et afficher les soldes.';

  @override
  String get comptePageTitle => 'Compte';

  @override
  String get comptePageListeInfosTitle => 'Informations personnelles';

  @override
  String get comptePageListeDetailsTitle => 'Détails du compte';

  @override
  String get comptePageBtnFermer => 'Fermer le compte';

  @override
  String get comptePersonnelPageTitle => 'Informations personnelles';

  @override
  String get comptePersonnelPageListeNomTitle => 'Prénom et Nom';

  @override
  String get comptePersonnelPageListeTelephoneTitle => 'Numéro de téléphone';

  @override
  String get comptePersonnelPageListePaysTitle => 'Pays de résidence';

  @override
  String get comptePersonnelPageListeAdresseTitle => 'Adresse';

  @override
  String get compteDetailsPageTitle => 'Détails du compte';

  @override
  String get compteDetailsPageListeTypeComTitle => 'Type de compte';

  @override
  String get compteDetailsPageListeNumCompTitle => 'Numéro de compte';

  @override
  String get compteDetailsPageListeAliasTitle => 'Alias';

  @override
  String get compteDetailsPageBtnSupprimer => 'Supprimer mon alias';

  @override
  String get compteDetailsPagePopupDeleteAliasTitle => 'Êtes-vous sûr de vouloir supprimer votre alias ?';

  @override
  String get compteDetailsPagePopupDeleteAliasSubTitle => 'Si vous confirmez la suppression de votre alias, cette action sera irréversible. Votre alias sera complètement supprimé de notre système et les autres utilisateurs ne pourront plus effectuer de paiements en votre faveur ou vous trouver à l\'aide de cet alias. Veuillez noter que vous perdrez également toutes les données associées à l\'alias, y compris l\'historique des paiements et les enregistrements d\'informations connexes.';

  @override
  String get compteDetailsPagePopupDeleteAliasBtnConfirmer => 'Supprimer l\'alias';

  @override
  String get compteDetailsPagePopupDeleteAliasBtnAnnuler => 'Annuler';

  @override
  String get compteDetailsPagePopupDeleteAliasErrorMsg => 'La suppression de votre alias à échoué, veuillez réessayer ultérieurement';

  @override
  String get appSettingPageTitle => 'Paramètres de l’application';

  @override
  String get appSettingPageMenuLanguageTitle => 'Langue';

  @override
  String get appSettingPageMenuLanguageFr => 'Français';

  @override
  String get appSettingPageMenuLanguageEn => 'Anglais';

  @override
  String get appSettingPageMenuLanguagePt => 'Portugais';

  @override
  String get appSettingPageMenuLanguageSelectTitle => 'Choisissez la langue pour l\'application';

  @override
  String get appSettingPageMenuThemeTitle => 'Thème';

  @override
  String get appSettingPageMenuThemeDark => 'Sombre';

  @override
  String get appSettingPageMenuThemeLight => 'Clair';

  @override
  String get appSettingPageMenuThemeYellow => 'Jaune';

  @override
  String get appSettingPageMenuThemeGreen => 'Vert';

  @override
  String get appSettingPageMenuThemeBlue => 'Bleu';

  @override
  String get appSettingPageMenuThemeDefault => 'Système';

  @override
  String get appSettingPageMenuThemePageTitle => 'Apparence';

  @override
  String get appSettingPageMenuQrCodeTitle => 'Mon QR code par défaut';

  @override
  String get appSettingPageMenuQrCodeSelectTitle => 'Activer pour afficher votre QR Code par défaut';

  @override
  String get appSettingPageMenuQrCodeDeselectTitle => 'Désactiver pour afficher la caméra par défaut';

  @override
  String get appSettingPageMenuNotificationTitle => 'Notifications dans l\'app';

  @override
  String get appSettingPageMenuNotificationStyleTitle => 'Style d\'alerte';

  @override
  String get appSettingPageMenuNotificationStyleSnackBar => 'Bannières';

  @override
  String get appSettingPageMenuNotificationStyleDialog => 'Alertes';

  @override
  String get appSettingPageMenuNotificationStyleDialogDesc => 'Les alertes requièrent une action avant de poursuivre. Les bannières apparaissent en haut de l\'écran et disparaissent automatiquement';

  @override
  String get appSettingPageMenuNotificationStyleNone => 'Aucun';

  @override
  String get appSettingPageMenuNotificationSonTitle => 'Son';

  @override
  String get appSettingPageMenuNotificationSonPageTitle => 'Notification Sonore';

  @override
  String get appSettingPageMenuNotificationSonDefault => 'Par défaut';

  @override
  String get appSettingPageMenuNotificationVibrTitle => 'Vibreur';

  @override
  String get appSettingPageMenuNotificationVibrSubtitle => 'Vibrations pour notification';

  @override
  String get categorieDefaultTitle => 'Catégories par défault';

  @override
  String get categorieCustomTitle => 'Catégories personnalisées';

  @override
  String get categorieCustomAdd => 'Ajouter une catégorie';

  @override
  String get categorieCustomEdit => 'Modifier';

  @override
  String get categorieFormNameLabel => 'Nom de la catégorie';

  @override
  String get categorieFormCreateBtn => 'Créer';

  @override
  String get categorieFormNameInvalid => 'Le nom ne doit pas avoir plus de 25 caractères';

  @override
  String get categorieFormNameAlready => 'Cette catégorie existe déjà';

  @override
  String get categorieEditBtn => 'Modifier';

  @override
  String get categorieFormSaveBtn => 'Enregistrer';

  @override
  String get categorieFormIconSheetTitle => 'Définir l\'image de couverture';

  @override
  String get categorieFormIconSheetEmojiTitle => 'Utiliser les Emoji';

  @override
  String get categorieFormIconSheetGalleryTitle => 'Sélectionnez dans la galerie';

  @override
  String get categorieFormIconSheetPhotoTitle => 'Prendre une photo';

  @override
  String get notificationPageTitle => 'Notification';

  @override
  String get notificationPageListeEmptyTitle => 'Vous êtes au courant de tout';

  @override
  String get notificationPageListeEmptySubTitle => 'Revenez plus tard pour obtenir des informations et des recommandations afin de maintenir votre compte à jour';

  @override
  String get notificationPageClaimTitle => 'Revendication d\'alias';

  @override
  String notificationPageClaimSubtitle(String alias) {
    return 'Vous avez reçu une revendication sur votre alias $alias';
  }

  @override
  String get notificationPageAnnulationRequestTitle => 'Annulation';

  @override
  String notificationPageAnnulationRequestSubtitle(String payeur) {
    return 'Demandée par $payeur';
  }

  @override
  String notificationPageRtpInitieeSubtitle(String payeur) {
    return 'Demandée à $payeur';
  }

  @override
  String notificationPageRtpRecueSubtitle(String payeur) {
    return 'Demandée par $payeur';
  }

  @override
  String get ignore => 'Ignorer';

  @override
  String get externalCustomer => 'Client externe';

  @override
  String get coming_soon => 'Disponible bientôt ...';

  @override
  String get alias_copied => 'Alias copié !';

  @override
  String get bottom_bar_home => 'Accueil';

  @override
  String get bottom_bar_transaction => 'Transactions';
}
