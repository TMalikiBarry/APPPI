// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PI';

  @override
  String get welcome => 'Welcome!';

  @override
  String get noFees => 'No fees';

  @override
  String get internetErrorTitle => '😔 Oooops';

  @override
  String get internetErrorSubtitle => 'You don\'t seem to have an internet connection or the server may be offline!';

  @override
  String get serverErrorTitle => '😔 Oooops';

  @override
  String get serverErrorSubtitle => 'An error has occurred, please try again later.';

  @override
  String get erreurInattendue => 'An unexpected error has occurred';

  @override
  String get reessayer => 'Retry';

  @override
  String get errorDialogOk => 'Ok';

  @override
  String get btnTextReject => 'Reject';

  @override
  String get btnTextAccept => 'Accept';

  @override
  String get btnTextConfirm => 'Confirm';

  @override
  String get btnTextCancel => 'Cancel';

  @override
  String get btnTextYes => 'Yes';

  @override
  String get btnTextNo => 'No';

  @override
  String get btnTextContinue => 'Continue';

  @override
  String get btnTextSend => 'Send';

  @override
  String get btnTextAsk => 'Demander';

  @override
  String get btnTextPay => 'Pay now';

  @override
  String get btnTextEdit => 'Edit';

  @override
  String get btnTextDisable => 'Disable';

  @override
  String get btnTextEnable => 'Enable';

  @override
  String get btnTextDelete => 'Delete';

  @override
  String get btnTextSave => 'Save';

  @override
  String get statutLabel => 'Statut';

  @override
  String get statutInitie => 'Pending';

  @override
  String get statutRejete => 'Rejected';

  @override
  String get statutAccepte => 'Accepted';

  @override
  String get statutActive => 'Enabled';

  @override
  String get statutDesactive => 'Disabled';

  @override
  String get introductionLegende => 'Welcome to SPI';

  @override
  String get introductionItem1 => 'Manage expenses with budget allocation';

  @override
  String get introductionItem2 => 'Save gently to realise your dreams';

  @override
  String get introductionItem3 => 'Schedule your payments to free your mind';

  @override
  String get introductionItem4 => 'Free pay and transfers to any account';

  @override
  String get introductionItem5 => 'Save and split expenses with friends';

  @override
  String get introductionItem6 => 'Use aliases for privacy and accuracy';

  @override
  String get introductionLogin => 'Log in';

  @override
  String get introductionFooterTitle => 'Don’t have account?';

  @override
  String get introductionFooterSubtitle => 'Find nearest agency';

  @override
  String get loginPageTitle => 'Login to SPI';

  @override
  String get loginPageSubTitle => 'Use the login you get from your financial institution';

  @override
  String get loginPageFooterIntro => 'By continue, you agree to our ';

  @override
  String get loginPageFooterCGU => 'Terms of use';

  @override
  String get loginPageFooterPC => 'Privacy Policy';

  @override
  String get coordinationEt => 'and';

  @override
  String get loginFormUsernameLabel => 'Your login';

  @override
  String get loginFormUsernameHint => 'Provided by your institution';

  @override
  String get loginUsernameErrorEmpty => 'Mandatory username';

  @override
  String get loginUsernameErrorInvalid => 'Username must have at least 3 chars';

  @override
  String get loginFormPasswordLabel => 'Your password';

  @override
  String get loginFormPasswordHint => 'Provided by your institution';

  @override
  String get loginPasswordErrorEmpty => 'Mandatory password';

  @override
  String get loginPasswordErrorInvalid => 'Invalid password policy';

  @override
  String get loginFormBtnConnexion => 'Continue';

  @override
  String get changePasswordPageTitle => 'Change password';

  @override
  String get changePasswordPageSubTitle => 'Please change your password to improve security';

  @override
  String get changePasswordFormPasswordHint => 'Set a new password';

  @override
  String get changePasswordFormConfirmHint => 'Confirm new password';

  @override
  String get changePasswordFormBtnConnexion => 'Set Password';

  @override
  String get changePasswordErrorEmpty => 'Mandatory new password';

  @override
  String get changePasswordErrorInvalid => 'Password must contains at least one number, one letter and the @ or _ character';

  @override
  String get changePasswordErrorDifferent => 'Passwords are differents';

  @override
  String get createCodePinFormTitle => 'Create passcode';

  @override
  String get createCodePinFormSubTitle => 'It helps protect your confidential information the next time you open the app';

  @override
  String get configureBiometryMethod => 'Biometric auth';

  @override
  String get configureBiometryMethodFace => 'Face ID';

  @override
  String get configureBiometryMethodFingerprint => 'fingerprint auth';

  @override
  String configureBiometryFormTitle(String method) {
    return 'Enable $method for next time? ';
  }

  @override
  String configureBiometryFormSubTitle(String method) {
    return 'Use $method to log in instead of entering PIN';
  }

  @override
  String configureBiometryFormSubmitBtn(String method) {
    return 'Use $method';
  }

  @override
  String get configureBiometryFormNotNowBtn => 'Not Now';

  @override
  String get identificationFormLoginMessage => 'Enter your passcode to log in';

  @override
  String get identificationFormForgotMessage => 'Forgot your passcode?';

  @override
  String identificationHelloUser(String user) {
    return 'Hello, $user';
  }

  @override
  String get identificationErrorPinInvalid => 'Invalid PIN Code';

  @override
  String get permissionNotificationTitle => 'Don\'t miss a beat';

  @override
  String get permissionNotificationSubTitle => 'Get notified about spending, incoming, security, wealth so you\'re always in the know';

  @override
  String get permissionNotificationEnableBtn => 'Enable push notifications';

  @override
  String get permissionNotificationNotNowBtn => 'Not Now';

  @override
  String get permissionContactTitle => 'Find your friends';

  @override
  String get permissionContactSubTitle1 => 'You’re in control! ';

  @override
  String get permissionContactSubTitle2 => 'We never store your phone contacts. ';

  @override
  String get permissionContactEnableBtn => 'Access and update contacts';

  @override
  String get permissionContactNotNowBtn => 'Not now';

  @override
  String get permissionErrorTitle => '😔 Oooops';

  @override
  String get permissionErrorDevice => 'Your device is not supported.';

  @override
  String get permissionErrorToken => 'An error occurs. Please retry again!';

  @override
  String get permissionErrorApi => 'Error communicating with the server. Check your Internet connection or retry again!';

  @override
  String get securityLogoutTitle => 'Are you sure you want to log out?';

  @override
  String get securityLogoutSubTitle => 'If you wish to continue working, click \'Cancel\' and you will be returned to your current state. If you really want to log out, click \'Log Out\'.';

  @override
  String get securityLogoutBtnConfirmer => 'Log Out';

  @override
  String get securityLogoutBtnAnnuler => 'Cancel';

  @override
  String get aliasCreatePageTitle => 'Create account alias';

  @override
  String get aliasCreatePageSubTitle => 'People can send you money by payment address or phone number';

  @override
  String get aliasCreateSHIDTitle => 'Use Payment Address';

  @override
  String get aliasCreateSHIDSubTitle => 'The payment address is created by SPI';

  @override
  String get aliasCreateMBNOTitle => 'Use phone number';

  @override
  String get aliasCreateMBNOSubTitle => 'Will be registered as the alias by SPI';

  @override
  String get aliaSuccessPageTitle => '🤩 Great';

  @override
  String get aliaSuccessPageSubTitle => 'Your alias created';

  @override
  String get aliaSuccessPageDescription => 'You can effortlessly share it with others, enabling them to initiate transfers directly to you.Alias simplifies the process, allowing you to transact with ease while maintaining your privacy.';

  @override
  String get aliaSuccessPageBtnText => 'Continue';

  @override
  String get aliaSuccessClaimPageTitle => 'Claim sent successfully';

  @override
  String get addPhoneNumberPageTitle => 'Add phone number';

  @override
  String get addPhoneNumberPageSubTitle => 'We will send a verification code to this number';

  @override
  String get addPhoneNumberFormHint => 'Mobile phone';

  @override
  String get addPhoneNumberFormErrorEmpty => 'Mandatory field';

  @override
  String get addPhoneNumberFormErrorInvalid => 'Invalid number';

  @override
  String get addPhoneNumberFormBtnContinuer => 'Continue';

  @override
  String get verifyPhoneNumberPageTitle => '6-digit code';

  @override
  String verifyPhoneNumberPageSubTitle(String number) {
    return 'Please enter the code send to $number';
  }

  @override
  String aliaMBNOResendMessage(String delay) {
    return 'Resend code in $delay';
  }

  @override
  String get aliaMBNOResendMessageBtn => 'Resend code';

  @override
  String get aliaMBNOInvalidOtpMessage => 'Otp invalid';

  @override
  String get aliaErrorPageTitle => '😔 Oooops';

  @override
  String get aliaErrorPageSubTitle => 'This alias is taken';

  @override
  String get aliaErrorPageDescription => 'Phone number is already registered as an alias by someone else.';

  @override
  String get aliaErrorPageReclamationBtnText => 'Claim the phone number';

  @override
  String get aliaErrorPageChoisisserBtnText => 'Choose another alias';

  @override
  String get aliaErrorClaimNotExistPageSubTitle => 'Introuvable';

  @override
  String get aliaErrorClaimNotExistPageDescription => 'Cette revendication n\'est plus disponible. Elle est terminée, clôturée ou archivée !';

  @override
  String get aliaErrorClaimLockedPageSubTitle => 'Another claim is already registered';

  @override
  String get aliaErrorClaimNotFoundPageSubTitle => 'Alias deleted by the owner';

  @override
  String get aliasClaimDetailsHeadTitle => 'Alias claim';

  @override
  String get aliasClaimDetailsHeadSubTitle => 'Requested phone number';

  @override
  String get aliasClaimDetailsBtnConfirmer => 'Accept';

  @override
  String get aliasClaimDetailsDateDemande => 'Request date';

  @override
  String get aliasClaimDetailsDateAcceptation => 'Accepted date';

  @override
  String get aliasClaimDetailsDateRefus => 'Rejected date';

  @override
  String aliasClaimDetailsAlert(String dateVerrouillage, String dateCloture) {
    return 'If you do not successfully reject this request by $dateVerrouillage, you will no longer be able to make transactions with this alias. If the request is still pending on $dateCloture, the alias will be deleted.';
  }

  @override
  String get aliasClaimAcceptDialogTitle => 'Are you sure you want to accept the claim?';

  @override
  String aliasClaimAcceptDialogMessage(String alias) {
    return 'Upon acceptance, your alias $alias will be deleted, and this action will be irreversible. You will no longer be able to receive payments with this alias.';
  }

  @override
  String get aliasClaimAcceptSuccessTitle => 'Claim accepted';

  @override
  String aliasClaimAcceptSuccessDescription(String alias) {
    return 'Your alias $alias has been deleted.';
  }

  @override
  String get aliasClaimRejectSuccessTitle => 'Claim rejected';

  @override
  String aliasClaimRejectSuccessDescription(String alias) {
    return 'Your alias $alias has been retained.';
  }

  @override
  String get aliasClaimDetailsRefusPageSubTitile => 'The rejection can only be accepted if you prove that the phone number belongs to you by entering the OTP code.';

  @override
  String get aliasClaimConfirmError => 'Confirmation failed. Please try again.';

  @override
  String get aliasClaimConfirmSuccessRejectTitle => 'Alias retained';

  @override
  String get aliasClaimConfirmSuccessAcceptTitle => 'Alias deleted';

  @override
  String get aliasFormLabel => 'Alias';

  @override
  String get aliasFormHint => 'Payment address or phone number';

  @override
  String get aliasFormEmpty => 'Required';

  @override
  String get aliasFormInvalid => 'Must be a 36-character payment address or a phone number with the country code';

  @override
  String get aliasFormNotFound => 'The beneficiary\'s alias does not exist in PI';

  @override
  String get contactActionsTitle => 'Contact';

  @override
  String get contactWithNoPhoneNumber => 'This contact does not have a phone number';

  @override
  String get contactTransferTitle => 'Transfer by contact';

  @override
  String contactPhoneAsAccountAlias(String phoneNumber) {
    return '$phoneNumber is an account alias';
  }

  @override
  String contactPhoneAsAccountNumber(String phoneNumber) {
    return '$phoneNumber is an account number';
  }

  @override
  String get contactCreateTitle => 'Add a contact';

  @override
  String get contactCreateSubtitle => 'Save a contact with their alias';

  @override
  String get contactCreateNameLabel => 'First and last name';

  @override
  String get contactCreateNameErrorEmpty => 'Name is required';

  @override
  String get contactBtnSave => 'Save and continue';

  @override
  String get homePageToolbarTabbarCompte => 'Account';

  @override
  String get homePageToolbarTabbarAbonnement => 'Subscriptions';

  @override
  String get homePageToolbarTabbarEconomie => 'Savings';

  @override
  String get homeSolde => 'Balance';

  @override
  String get homeActionSend => 'Send';

  @override
  String get homeActionRequest => 'Receive';

  @override
  String get homeActionMore => 'More';

  @override
  String get homeTransactions => 'Transactions';

  @override
  String get homeTransactionsRecent => 'Recent Transactions';

  @override
  String get transactionsNoRecent => 'No recent transactions';

  @override
  String get transactionsNoRecentSubtitle => 'Your recent transactions will appear here';

  @override
  String get transactionsErrorLoading => 'Error loading transactions';

  @override
  String get retry => 'Try Again';

  @override
  String get homeTransactionsRecentsNombreTitle => 'Last transactions';

  @override
  String get homeTransactionsRecentsNombreSubTitle => 'Choose how many transactions you want to see in your widget';

  @override
  String get homeTransactionsRecentsNombreBtnSave => 'Save';

  @override
  String get homeActionMoreSheetProgrammerTitle => 'Schedule a transfer';

  @override
  String get homeActionMoreSheetProgrammerSubTitle => 'Create new transfer';

  @override
  String get homeActionMoreSheetAbonnementTitle => 'Find a subscription';

  @override
  String get homeActionMoreSheetAbonnementSubTitle => 'Convert past payment in to subscription';

  @override
  String get homeActionMoreSheetPartagerTitle => 'Split payments';

  @override
  String get homeActionMoreSheetPartagerSubTitle => 'Split payment from your spending';

  @override
  String get homeActionMoreSheetTirelireTitle => 'Open saving box';

  @override
  String get homeActionMoreSheetTirelireSubTitle => 'Split payment from your spending';

  @override
  String get homeActionMoreSheetBudgetTitle => 'Set budgets';

  @override
  String get homeActionMoreSheetBudgetSubTitle => 'Create your budget for spending';

  @override
  String get homeActionMoreSheetWidgetTitle => 'Add Widget';

  @override
  String get homeActionMoreSheetAWidgetSubTitle => 'Manage widgets for home';

  @override
  String get transactionsSeeAll => 'See All';

  @override
  String get transactionsSendInputHint => 'Name, Alias';

  @override
  String get transactionsSendOptionAliasTitle => 'Use Alias';

  @override
  String get transactionsSendOptionAliasSubtitle => 'Payment address';

  @override
  String get transactionsSendOptionIbanTitle => 'Use IBAN';

  @override
  String get transactionsSendOptionIbanSubtitle => 'Recipient bank account';

  @override
  String get transactionsSendOptionOthrTitle => 'Use Other Account number';

  @override
  String get transactionsSendOptionOthrSubtitle => 'Microfinance or Mobile money account';

  @override
  String get transactionsSendOptionNewContactTitle => 'New contact';

  @override
  String get transactionsSendOptionNewContactSubtitle => 'Add a contact using alias';

  @override
  String get transactionsSendRecentItemYouSend => 'You send ';

  @override
  String get transactionsSendRecentItemYouReceive => 'You receive ';

  @override
  String get transactionsSendTitleTransfert => 'Transfer';

  @override
  String get transactionsSendTitleRecents => 'Recents transfers';

  @override
  String get transactionsSendTitleContacts => 'From your contacts';

  @override
  String get transactionsSendTitleRequest2Pay => 'Request to pay';

  @override
  String get transactionsSendTitleRequest2PayRecents => 'Recents requests';

  @override
  String get transactionsSendScheduleTitle => 'Qui payer';

  @override
  String get transactionsSendFormAliasTitle => 'Transfer by Alias';

  @override
  String get transactionsSendFormAliasSubtitle => 'Use the phone number or Payment address alias';

  @override
  String get transactionsSendFormOthrTitle => 'Transfer by Account number';

  @override
  String get transactionsSendFormOthrSubtitle => 'Account number with a microfinance institution or electronic money issuer';

  @override
  String get transactionsSendFormIbanTitle => 'Transfer by IBAN';

  @override
  String get transactionsSendFormIbanSubtitle => 'Use the IBAN number of the payee';

  @override
  String get transactionsSendFormQrCodeTitleTransfer => 'QR Code transfer';

  @override
  String get transactionsSendFormQrCodeTitlePayment => 'QR Code payment';

  @override
  String get transactionsSendFormQrCodeSubtitle => 'Enter the amount';

  @override
  String get transactionsSendSuccessBtnVoir => 'Show details';

  @override
  String get transactionsSendSuccessBtnReessayer => 'Retry';

  @override
  String get transactionsSendErrorTitle => '😔 Oooops';

  @override
  String get transactionsSendErrorDescription => 'Transaction failed';

  @override
  String get transactionsSendErrorBtn => 'Continue';

  @override
  String get transactionFormAmountHint => 'Amount';

  @override
  String get transactionFormAmountEmpty => 'Mandatory';

  @override
  String get transactionFormAmountInvalid => 'Insufficient balance';

  @override
  String get transactionFormAmountLow => 'Minimum amount 5 XOF';

  @override
  String get transactionFormMotifHint => 'Add note';

  @override
  String get transactionFormMotifLabel => 'Note';

  @override
  String get transactionFormMotifInvalid => 'No more than 104 characters';

  @override
  String get transactionFormFactureLabel => 'Facture';

  @override
  String get transactionFormIbanLabel => 'IBAN';

  @override
  String get transactionFormIbanHint => 'Recipient IBAN';

  @override
  String get transactionFormIbanEmpty => 'Mandatory';

  @override
  String get transactionFormIbanInvalid => 'Invalid IBAN format';

  @override
  String get transactionFormIbanPaysLabel => 'Country of recipient’s bank';

  @override
  String get transactionFormIbanNomLabel => 'Name of recipient’s bank';

  @override
  String get transactionFormOthrLabel => 'Account number';

  @override
  String get transactionFormOthrHint => 'Recipient account number';

  @override
  String get transactionFormOthrEmpty => 'Mandatory';

  @override
  String get transactionFormOthrPaysLabel => 'Country of recipient’s institution';

  @override
  String get transactionFormOthrNomLabel => 'Name of recipient’s institution';

  @override
  String get transactionFormContinueBtn => 'Continue';

  @override
  String get transactionFormSaveContactBtn => 'Save and make transfer';

  @override
  String get transactionFormVerificationTitle => 'Verification';

  @override
  String get transactionFormVerificationSubtitle => 'Please check the information about the recipient before confirming';

  @override
  String get transactionFormVerificationTypeLabel => 'Type';

  @override
  String get transactionFormVerificationTypeIBAN => 'Transfer by IBAN';

  @override
  String get transactionFormVerificationTypeOTHR => 'Transfer by Account number';

  @override
  String get transactionFormVerificationClientName => 'Name';

  @override
  String get transactionFormVerificationBtnConfirm => 'Confirm';

  @override
  String get transactionFormVerificationBtnReject => 'Reject';

  @override
  String get transactionFormScheduleTitle => 'Schedule';

  @override
  String get transactionFormScheduleSubtitle => 'Your payment will be made on the selected date';

  @override
  String get transactionFormScheduleDateLabel => 'Date';

  @override
  String get transactionFormScheduleDateRangeLabel => 'Start Date - End Date';

  @override
  String get transactionFormScheduleDateSelectTitle => 'Select a date';

  @override
  String get transactionFormScheduleDateRangeSelectTitle => 'Select a date range';

  @override
  String get transactionFormScheduleFrequenceLabel => 'Frequency';

  @override
  String get transactionFormScheduleFrequenceUnefois => 'One time';

  @override
  String get transactionFormScheduleFrequenceQuotidienne => 'Daily';

  @override
  String get transactionFormScheduleFrequenceHebdomadaire => 'Weekly';

  @override
  String get transactionFormScheduleFrequenceMensuelle => 'Monthly';

  @override
  String get transactionFormScheduleFrequenceAnnuelle => 'Yearly';

  @override
  String get transactionFormScheduleFrequenceSurMesure => 'Custom';

  @override
  String get transactionFormSchedulePeriodiciteLabel => 'Periodicity';

  @override
  String transactionFormScheduleFrequenceSelected(String periodicite, String frequence) {
    return 'Every $periodicite $frequence';
  }

  @override
  String transactionFormScheduleDateRange(String start, String end) {
    return 'from $start to $end';
  }

  @override
  String transactionFormScheduleDateSelected(String start) {
    return 'Starting from $start';
  }

  @override
  String transactionFormScheduleSuccessMessage(String montant, String payee) {
    return 'You have scheduled $montant FCFA for $payee';
  }

  @override
  String get transactionFormScheduleSuccessBtn => 'View subscription';

  @override
  String transactionsSendSuccessBtnTitle(String payee) {
    return 'You sent money to $payee';
  }

  @override
  String get subscriptionEmptyTitle => 'Upcoming transactions';

  @override
  String get subscriptionEmptySubTitle => 'Manage your subscriptions and scheduled payments in one place';

  @override
  String get subscriptionListOnceTitle => 'Scheduled payments';

  @override
  String get subscriptionEmptyBtnCreate => 'New';

  @override
  String get subscriptionListFrequenceTitle => 'Subscriptions';

  @override
  String get subscriptionMenuScheduleTitle => 'Schedule a payment';

  @override
  String get subscriptionMenuScheduleSubtitle => 'Transfer to be executed at a future date';

  @override
  String get subscriptionMenuSubscribeTitle => 'Create a subscription';

  @override
  String get subscriptionMenuSubscribeSubtitle => 'Convert a payment into a subscription';

  @override
  String get subscriptionMenuSubscribeSubtitle2 => 'Search in your transactions and select a recurring payment';

  @override
  String get subscriptionDateScheduledForTitle => 'Scheduled for';

  @override
  String subscriptionDateScheduledFor(String date) {
    return 'Scheduled for $date';
  }

  @override
  String get subscriptionDateNextPaymentTitle => 'Next payment';

  @override
  String subscriptionDateNextPayment(String date) {
    return 'Next payment on $date';
  }

  @override
  String subscriptionDateEndsSince(String date) {
    return 'Ended since $date';
  }

  @override
  String get subscriptionDateToday => 'Payment for today';

  @override
  String get subscriptionDisabled => 'Subscription disabled';

  @override
  String get subscriptionPaymentTo => 'Payment to';

  @override
  String get subscriptionStartDate => 'Start date';

  @override
  String get subscriptionEditNoteBtn => 'Edit note';

  @override
  String transactionsRtpSuccessBtnTitle(String payee) {
    return 'You have sent a payment request to $payee';
  }

  @override
  String get transactionsRtpSuccessBtnVoir => 'View request';

  @override
  String transactionRtpDetailsTitleInitiee(String payeur) {
    return 'You requested from $payeur';
  }

  @override
  String transactionRtpDetailsTitleRecue(String paye) {
    return 'You owe $paye';
  }

  @override
  String get transactionRtpDetailsEcheanceDate => 'Due date';

  @override
  String get transactionRtpDetailsRemiseTitle => 'Immediate Payment';

  @override
  String get transactionRtpDetailsRemiseLabel => 'Discount';

  @override
  String transactionRtpDetailsRemiseHint(String dateReponse) {
    return 'valid until $dateReponse';
  }

  @override
  String get transactionRtpDetailsSplitPaymentTitle => 'Split Payment';

  @override
  String get transactionRtpDetailsSplitPaymentTo => 'Payment to';

  @override
  String get transactionRtpDetailsPICOTitle => 'Withdrawal with PICO purchase';

  @override
  String get transactionRtpDetailsPICASHTitle => 'PICASh Withdrawal';

  @override
  String get transactionRtpDetailsAmtAchatTitle => 'Purchase';

  @override
  String get transactionRtpDetailsAmtRetraitTitle => 'Withdrawal';

  @override
  String get transactionRtpDetailsAmtFraisTitle => 'Fees';

  @override
  String get transactionRtpDetailsDiffereTitle => 'Deferred Debit';

  @override
  String get transactionRtpDetailsDiffereSubtitle => 'Buy now, Pay later';

  @override
  String get transactionRtpDetailsDiffereDescription => 'Your account will be debited at the end of the month';

  @override
  String transactionRtpDetailsDifferePayFrequence(int occurence, String frequence) {
    return 'Pay in $occurence $frequence';
  }

  @override
  String transactionRtpDetailsDifferePayAmt(String montant, String frequence) {
    return '$montant per $frequence';
  }

  @override
  String transactionRtpRejectTitle(String paye) {
    return 'Reject request from $paye';
  }

  @override
  String transactionRtpRejectSubtitle(String montant, String paye) {
    return '$montant for $paye';
  }

  @override
  String get transactionRtpRejectRsnDemandeur => 'Unknown requester';

  @override
  String get transactionRtpRejectRsnMontant => 'Incorrect amount';

  @override
  String get transactionRtpRejectRsnRemittance => 'Incorrect invoice';

  @override
  String get transactionRtpRejectMessage => 'The payment request has been successfully rejected';

  @override
  String get transactionDetailsFrequenceMois => 'months';

  @override
  String get transactionDetailsFrequenceSemaine => 'weeks';

  @override
  String get transactionDetailsFrequenceJour => 'days';

  @override
  String get transactionDetailsRetourner => 'Return';

  @override
  String get transactionDetailsAnnuler => 'Cancel';

  @override
  String get transactionDetailsRecevoir => 'Receive';

  @override
  String get transactionDetailsPartager => 'Split';

  @override
  String get transactionDetailsPlanifier => 'Schedule';

  @override
  String get transactionDetailsMotifCredit => 'Received without note';

  @override
  String get transactionDetailsMotifDebit => 'Sent without note';

  @override
  String get transactionDetailsReference => 'Reference';

  @override
  String get transactionDetailsPays => 'Country';

  @override
  String get transactionDetailsPayeLabel => 'Payment to';

  @override
  String get transactionDetailsPayeurLabel => 'Received from';

  @override
  String get transactionDetailsDateLabel => 'Received at';

  @override
  String get transactionDetailsTelecharger => 'Download';

  @override
  String get transactionDetailsRecuPaiement => 'Statement';

  @override
  String get transactionDetailsAlias => 'Alias';

  @override
  String get transactionDetailsCategorie => 'Category';

  @override
  String get transactionDetailsTicket => 'Receipt';

  @override
  String get transactionDetailsAnalytique => 'Exclude from Analytics';

  @override
  String get transactionDetailsQuestion => 'Select an issue';

  @override
  String get transactionDetailsTeleverser => 'Upload';

  @override
  String get transactionDetailsRecuPaiementPDF => 'Transaction Statement';

  @override
  String get transactionDetailsRecuPaiementPDFSousTitre => 'You can download or share the PDF file';

  @override
  String get transactionDetailsTicketCaisse => 'Transaction Statement';

  @override
  String get transactionDetailsTicketCaisseSubtitle => 'You can share the receipt';

  @override
  String get transactionDetailsCompte => 'Account';

  @override
  String get transactionDetailsInstitution => 'Institution';

  @override
  String get transactionDetailsReturnTitle => 'Are you sure you want to return the funds ?';

  @override
  String get transactionDetailsReturnSuccessMessage => 'You have successfully returned funds';

  @override
  String get transactionDetailsRetourDateLabel => 'Returned on';

  @override
  String get transactionDetailsCancelTitle => 'Cancellation request';

  @override
  String get transactionDetailsCancelSubTitle => 'What is the reason for the request ?';

  @override
  String get transactionDetailsCancelRsnDestinataire => 'Recipient error';

  @override
  String get transactionDetailsCancelRsnMontant => 'Error on the amount';

  @override
  String get transactionDetailsCancelRsnService => 'Service not delivered';

  @override
  String get transactionDetailsCancelRsnFraud => 'Fraud attempted ';

  @override
  String get transactionDetailsCancelRsnDuplicate => 'Already paid';

  @override
  String get transactionDetailsCancelBtnSend => 'Request cancellation';

  @override
  String get transactionDetailsCancelSuccessMessage => 'Request cancellation sent';

  @override
  String get transactionDetailsCancelSuccessDescription => 'The request is pending processing.\n You will be notified as soon as the beneficiary responds.';

  @override
  String get transactionDetailsCancelDemandeLabel => 'Requested on';

  @override
  String get transactionDetailsCancelDateLabel => 'Cancelled on';

  @override
  String transactionDetailsCancelHeadSubtitle(String montant) {
    return '$montant received';
  }

  @override
  String get transactionDetailsCancelReasonLabel => 'Reason';

  @override
  String get transactionDetailsCancelRejectMessage => 'The cancellation request has been successfully rejected';

  @override
  String get transactionDetailsRecuTitle => 'Transaction Statement';

  @override
  String get transactionDetailsRecuSubTitle => 'You can download or share the PDF file';

  @override
  String get transactionDetailsRecuInfoIdentifiant => 'Identifier';

  @override
  String get transactionDetailsRecuInfoReference => 'Reference';

  @override
  String get transactionDetailsRecuInfoFrais => 'Fees';

  @override
  String get transactionDetailsRecuInfoFraisDefault => 'Free';

  @override
  String get transactionDetailsRecuInfoPayeLabel => 'Payment to';

  @override
  String get transactionDetailsRecuInfoPayeurLabel => 'Received from';

  @override
  String get transactionDetailsRecuInfoClientAlias => 'Alias';

  @override
  String get transactionDetailsRecuInfoClientCompte => 'Compte Number';

  @override
  String get transactionDetailsRecuInfoClientInstitution => 'Institution';

  @override
  String get transactionDetailsRecuInfoDateReception => 'Reception date';

  @override
  String get transactionDetailsRecuInfoDateEnvoi => 'Send date';

  @override
  String get transactionDetailsRecuInfoMontant => 'Amount';

  @override
  String get transactionDetailsTicketSaveTitle => 'Save the transaction receipt';

  @override
  String get transactionDetailsTicketSaveGallery => 'Open the gallery';

  @override
  String get transactionSplitTitle => 'Split with';

  @override
  String get transactionSplitRepartitionTitle => 'Split payment';

  @override
  String get transactionSplitRepartitionSubtitle1 => 'Selected payment';

  @override
  String transactionSplitRepartitionSubtitle2(int nombre) {
    return 'Split between - $nombre';
  }

  @override
  String get transactionSplitRepartitionParMontant => 'By amount';

  @override
  String get transactionSplitRepartitionSelf => 'Me';

  @override
  String get transactionSplitRepartitionPartRegle => 'Part paid';

  @override
  String get transactionSplitRepartitionPartDoit => 'Own you';

  @override
  String get transactionSplitRepartitionSuccessMessage => 'Payment requests sent';

  @override
  String get transactionErrorSoldeInsuffisant => 'Insufficient balance';

  @override
  String get transactionErrorDejaRetourne => 'Transaction has already been returned';

  @override
  String get transactionErrorDelaiDepasse => 'Deadline has passed';

  @override
  String get transactionErrorDestinataireIndisponible => 'Institution of the recipient temporarily unavailable';

  @override
  String get transactionErrorUnknow => 'Your request cannot be processed at the moment. \nPlease try again later.';

  @override
  String get transactionSearchTitle => 'Transactions';

  @override
  String get transactionSearchInputSearchHint => 'Search';

  @override
  String get transactionSearchInputFilterTitle => 'Filter';

  @override
  String get transactionSearchInputFilterDateTitle => 'Date range';

  @override
  String get transactionSearchInputFilterDateSubTitle => 'Select the dates';

  @override
  String transactionSearchInputFilterDateRange(String debut, String fin) {
    return 'Dates From $debut - To $fin';
  }

  @override
  String get transactionSearchInputFilterDateSelectTitle => 'Select the date range';

  @override
  String get transactionSearchInputFilterCategoriesTitle => 'Category';

  @override
  String get transactionSearchInputFilterCategoriesSensRecus => 'Received';

  @override
  String get transactionSearchInputFilterCategoriesSensPayes => 'Paid';

  @override
  String get transactionSearchInputFilterBtnAppliquer => 'Apply';

  @override
  String get qrcodePageBtnScan => 'Scan';

  @override
  String get qrcodePageBtnMonCode => 'QR Code';

  @override
  String get qrcodePagePartageTitle => 'Share your contact';

  @override
  String get qrcodePagePartageQrCodeTitle => 'Share the qr code';

  @override
  String get qrcodePagePartageQrCodeSubTitle => 'Share as picture';

  @override
  String get qrcodePagePartageAliasTitle => 'Share the alias';

  @override
  String get qrcodePagePartageAliasSubTitle => 'Copy alias to clipboard';

  @override
  String get qrcodeScanPageMessage => 'Point your camera at the QR code.\nScanning will be automatic';

  @override
  String get qrcodeEncodeErrorMsg => 'Error displaying your QR Code!';

  @override
  String get qrcodeDecodeErrorNotQrImage => 'QR Code image invalid';

  @override
  String get qrcodeDecodeErrorInvalideAlias => 'Alias in the QR Code is invalid';

  @override
  String get qrcodeDecodeErrorInvalideFormat => 'Invalid QR Code format';

  @override
  String get popupSelectDateBtnValider => 'Set';

  @override
  String get profilePageBtnInviter => 'Invite friends';

  @override
  String get profilePageMenuCompteTitle => 'Account';

  @override
  String get profilePageMenuSecurityTitle => 'Security & privacy';

  @override
  String get profilePageMenuParametreTitle => 'App settings';

  @override
  String get profilePageMenuHelpTitle => 'Help Center';

  @override
  String get profilePageMenuAproposTitle => 'About us';

  @override
  String get profilePageBtnDeconnexion => 'Log out';

  @override
  String get profilePageAppVersion => 'App version';

  @override
  String get profileSecuritePageTitle => 'Security & Privacy';

  @override
  String get profileSecuriteMenuSecuriteTitle => 'Security';

  @override
  String get profileSecuriteMenuItemPinTitle => 'Change Passcode';

  @override
  String get profileSecuriteMenuItemTrustedTitle => 'Trusted Parties';

  @override
  String get profileSecuriteMenuItemBlacklistTitle => 'Blacklisted Parties';

  @override
  String get profileSecuriteMenuItemAppareilsTitle => 'Devices';

  @override
  String get profileSecuriteMenuItemBiometryTitle => 'Enable Biometrics';

  @override
  String get profileSecuriteMenuItemMontantTitle => 'Hide Balances';

  @override
  String get profileSecuriteMenuItemMontantSubTitle => 'Flip your device screen down to quickly hide and show balances. You can change it in the app settings later.';

  @override
  String get profileSecuriteMenuConfidentialiteTitle => 'Privacy';

  @override
  String get profileSecuriteMenuItemShakeToPayTitle => 'Make Me Discoverable';

  @override
  String get profileSecuriteMenuItemShakeToPaySubTitle => 'When I shake the phone';

  @override
  String get profileSecuriteMontantPopupTitle => 'Hide Balances';

  @override
  String get profileSecuriteMontantPopupSubTitle => 'Flip your device screen down to quickly hide and show balances.';

  @override
  String get comptePageTitle => 'Account';

  @override
  String get comptePageListeInfosTitle => 'Personal details';

  @override
  String get comptePageListeDetailsTitle => 'Account details';

  @override
  String get comptePageBtnFermer => 'Close account';

  @override
  String get comptePersonnelPageTitle => 'Personal details';

  @override
  String get comptePersonnelPageListeNomTitle => 'Full name';

  @override
  String get comptePersonnelPageListeTelephoneTitle => 'Phone';

  @override
  String get comptePersonnelPageListePaysTitle => 'Country of residence';

  @override
  String get comptePersonnelPageListeAdresseTitle => 'Address';

  @override
  String get compteDetailsPageTitle => 'Account details';

  @override
  String get compteDetailsPageListeTypeComTitle => 'Beneficiary';

  @override
  String get compteDetailsPageListeNumCompTitle => 'Account number';

  @override
  String get compteDetailsPageListeAliasTitle => 'Alias';

  @override
  String get compteDetailsPageBtnSupprimer => 'Delete my alias';

  @override
  String get compteDetailsPagePopupDeleteAliasTitle => 'Are you sure you want to delete your alias?';

  @override
  String get compteDetailsPagePopupDeleteAliasSubTitle => 'If you confirm the deletion of your alias, this action will be irreversible. Your alias will be completely removed from our system, and other users will no longer be able to make payments to you or find you using this alias.\nPlease note that you will also lose all associated data with the alias, including payment history and related information records.';

  @override
  String get compteDetailsPagePopupDeleteAliasBtnConfirmer => 'Delete Alias';

  @override
  String get compteDetailsPagePopupDeleteAliasBtnAnnuler => 'Cancel';

  @override
  String get compteDetailsPagePopupDeleteAliasErrorMsg => 'Deleting your alias failed. Please try again later.';

  @override
  String get appSettingPageTitle => 'Application settings';

  @override
  String get appSettingPageMenuLanguageTitle => 'Language';

  @override
  String get appSettingPageMenuLanguageFr => 'French';

  @override
  String get appSettingPageMenuLanguageEn => 'English';

  @override
  String get appSettingPageMenuLanguagePt => 'Portuguese';

  @override
  String get appSettingPageMenuLanguageSelectTitle => 'We use the same language set for your device. but you can set specific for using the application';

  @override
  String get appSettingPageMenuThemeTitle => 'Theme';

  @override
  String get appSettingPageMenuThemeDark => 'Dark';

  @override
  String get appSettingPageMenuThemeLight => 'Light';

  @override
  String get appSettingPageMenuThemeYellow => 'Yellow';

  @override
  String get appSettingPageMenuThemeGreen => 'Green';

  @override
  String get appSettingPageMenuThemeBlue => 'Blue';

  @override
  String get appSettingPageMenuThemeDefault => 'System';

  @override
  String get appSettingPageMenuThemePageTitle => 'Apparence';

  @override
  String get appSettingPageMenuQrCodeTitle => 'My QR code by default';

  @override
  String get appSettingPageMenuQrCodeSelectTitle => 'Enable to display your QR Code by default';

  @override
  String get appSettingPageMenuQrCodeDeselectTitle => 'Disable to display the camera by default';

  @override
  String get appSettingPageMenuNotificationTitle => 'In App Notifications';

  @override
  String get appSettingPageMenuNotificationStyleTitle => 'Alert Style';

  @override
  String get appSettingPageMenuNotificationStyleSnackBar => 'Banners';

  @override
  String get appSettingPageMenuNotificationStyleDialog => 'Alerts';

  @override
  String get appSettingPageMenuNotificationStyleDialogDesc => 'Alerts require an action before continuing. Banners appear at the top of the screen and disappear automatically';

  @override
  String get appSettingPageMenuNotificationStyleNone => 'Aucun';

  @override
  String get appSettingPageMenuNotificationSonTitle => 'Sound';

  @override
  String get appSettingPageMenuNotificationSonPageTitle => 'Sound Notification';

  @override
  String get appSettingPageMenuNotificationSonDefault => 'Default';

  @override
  String get appSettingPageMenuNotificationVibrTitle => 'Vibrations';

  @override
  String get appSettingPageMenuNotificationVibrSubtitle => 'Vibrations for notifications';

  @override
  String get categorieDefaultTitle => 'Default categories';

  @override
  String get categorieCustomTitle => 'Custom categories';

  @override
  String get categorieCustomAdd => 'Add category';

  @override
  String get categorieCustomEdit => 'Edit';

  @override
  String get categorieFormNameLabel => 'Name your category';

  @override
  String get categorieFormCreateBtn => 'Add';

  @override
  String get categorieFormNameInvalid => 'Name too long, don\'t exceed 25 chars';

  @override
  String get categorieFormNameAlready => 'Category already exist';

  @override
  String get categorieEditBtn => 'Edit';

  @override
  String get categorieFormSaveBtn => 'Save';

  @override
  String get categorieFormIconSheetTitle => 'Set cover image';

  @override
  String get categorieFormIconSheetEmojiTitle => 'Use Emoji';

  @override
  String get categorieFormIconSheetGalleryTitle => 'Select from your gallery';

  @override
  String get categorieFormIconSheetPhotoTitle => 'Take a photo';

  @override
  String get notificationPageTitle => 'Notification';

  @override
  String get notificationPageListeEmptyTitle => 'You’re all caught up';

  @override
  String get notificationPageListeEmptySubTitle => 'Check back later for informations and recommendations to keep your account up to date';

  @override
  String get notificationPageClaimTitle => 'Alias claim';

  @override
  String notificationPageClaimSubtitle(String alias) {
    return 'You have received a claim on your alias $alias';
  }

  @override
  String get notificationPageAnnulationRequestTitle => 'Cancellation';

  @override
  String notificationPageAnnulationRequestSubtitle(String payeur) {
    return 'Requested by $payeur';
  }

  @override
  String notificationPageRtpInitieeSubtitle(String payeur) {
    return 'Requested from $payeur';
  }

  @override
  String notificationPageRtpRecueSubtitle(String payeur) {
    return 'Requested by $payeur';
  }
}
