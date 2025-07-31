import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('pt')
  ];

  /// PI-SPI
  ///
  /// In en, this message translates to:
  /// **'PI'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @noFees.
  ///
  /// In en, this message translates to:
  /// **'No fees'**
  String get noFees;

  /// No description provided for @internetErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'😔 Oooops'**
  String get internetErrorTitle;

  /// No description provided for @internetErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You don\'t seem to have an internet connection or the server may be offline!'**
  String get internetErrorSubtitle;

  /// No description provided for @serverErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'😔 Oooops'**
  String get serverErrorTitle;

  /// No description provided for @serverErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred, please try again later.'**
  String get serverErrorSubtitle;

  /// No description provided for @erreurInattendue.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error has occurred'**
  String get erreurInattendue;

  /// No description provided for @reessayer.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get reessayer;

  /// No description provided for @errorDialogOk.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get errorDialogOk;

  /// No description provided for @btnTextReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get btnTextReject;

  /// No description provided for @btnTextAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get btnTextAccept;

  /// No description provided for @btnTextConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get btnTextConfirm;

  /// No description provided for @btnTextCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btnTextCancel;

  /// No description provided for @btnTextYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get btnTextYes;

  /// No description provided for @btnTextNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get btnTextNo;

  /// No description provided for @btnTextContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get btnTextContinue;

  /// No description provided for @btnTextSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get btnTextSend;

  /// No description provided for @btnTextAsk.
  ///
  /// In en, this message translates to:
  /// **'Demander'**
  String get btnTextAsk;

  /// No description provided for @btnTextPay.
  ///
  /// In en, this message translates to:
  /// **'Pay now'**
  String get btnTextPay;

  /// No description provided for @btnTextEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get btnTextEdit;

  /// No description provided for @btnTextDisable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get btnTextDisable;

  /// No description provided for @btnTextEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get btnTextEnable;

  /// No description provided for @btnTextDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get btnTextDelete;

  /// No description provided for @btnTextSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get btnTextSave;

  /// No description provided for @statutLabel.
  ///
  /// In en, this message translates to:
  /// **'Statut'**
  String get statutLabel;

  /// No description provided for @statutInitie.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statutInitie;

  /// No description provided for @statutRejete.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statutRejete;

  /// No description provided for @statutAccepte.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get statutAccepte;

  /// No description provided for @statutActive.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get statutActive;

  /// No description provided for @statutDesactive.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get statutDesactive;

  /// No description provided for @introductionLegende.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SPI'**
  String get introductionLegende;

  /// No description provided for @introductionItem1.
  ///
  /// In en, this message translates to:
  /// **'Manage expenses with budget allocation'**
  String get introductionItem1;

  /// No description provided for @introductionItem2.
  ///
  /// In en, this message translates to:
  /// **'Save gently to realise your dreams'**
  String get introductionItem2;

  /// No description provided for @introductionItem3.
  ///
  /// In en, this message translates to:
  /// **'Schedule your payments to free your mind'**
  String get introductionItem3;

  /// No description provided for @introductionItem4.
  ///
  /// In en, this message translates to:
  /// **'Free pay and transfers to any account'**
  String get introductionItem4;

  /// No description provided for @introductionItem5.
  ///
  /// In en, this message translates to:
  /// **'Save and split expenses with friends'**
  String get introductionItem5;

  /// No description provided for @introductionItem6.
  ///
  /// In en, this message translates to:
  /// **'Use aliases for privacy and accuracy'**
  String get introductionItem6;

  /// No description provided for @introductionLogin.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get introductionLogin;

  /// No description provided for @introductionGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get introductionGotIt;

  /// No description provided for @introductionFooterTitle.
  ///
  /// In en, this message translates to:
  /// **'Don’t have account?'**
  String get introductionFooterTitle;

  /// No description provided for @introductionFooterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find nearest agency'**
  String get introductionFooterSubtitle;

  /// No description provided for @loginPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Login to SPI'**
  String get loginPageTitle;

  /// No description provided for @loginPageSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Use the login you get from your financial institution'**
  String get loginPageSubTitle;

  /// No description provided for @loginPageFooterIntro.
  ///
  /// In en, this message translates to:
  /// **'By continue, you agree to our '**
  String get loginPageFooterIntro;

  /// No description provided for @loginPageFooterCGU.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get loginPageFooterCGU;

  /// No description provided for @loginPageFooterPC.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get loginPageFooterPC;

  /// No description provided for @coordinationEt.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get coordinationEt;

  /// No description provided for @loginFormUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your login'**
  String get loginFormUsernameLabel;

  /// No description provided for @loginFormUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Provided by your institution'**
  String get loginFormUsernameHint;

  /// No description provided for @loginUsernameErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Mandatory username'**
  String get loginUsernameErrorEmpty;

  /// No description provided for @loginUsernameErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Username must have at least 3 chars'**
  String get loginUsernameErrorInvalid;

  /// No description provided for @loginFormPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get loginFormPasswordLabel;

  /// No description provided for @loginFormPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Provided by your institution'**
  String get loginFormPasswordHint;

  /// No description provided for @loginPasswordErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Mandatory password'**
  String get loginPasswordErrorEmpty;

  /// No description provided for @loginPasswordErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid password policy'**
  String get loginPasswordErrorInvalid;

  /// No description provided for @loginFormBtnConnexion.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get loginFormBtnConnexion;

  /// No description provided for @changePasswordPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordPageTitle;

  /// No description provided for @changePasswordPageSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Please change your password to improve security'**
  String get changePasswordPageSubTitle;

  /// No description provided for @changePasswordFormPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Set a new password'**
  String get changePasswordFormPasswordHint;

  /// No description provided for @changePasswordFormConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get changePasswordFormConfirmHint;

  /// No description provided for @changePasswordFormBtnConnexion.
  ///
  /// In en, this message translates to:
  /// **'Set Password'**
  String get changePasswordFormBtnConnexion;

  /// No description provided for @changePasswordErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Mandatory new password'**
  String get changePasswordErrorEmpty;

  /// No description provided for @changePasswordErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Password must contains at least one number, one letter and the @ or _ character'**
  String get changePasswordErrorInvalid;

  /// No description provided for @changePasswordErrorDifferent.
  ///
  /// In en, this message translates to:
  /// **'Passwords are differents'**
  String get changePasswordErrorDifferent;

  /// No description provided for @createCodePinFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Create passcode'**
  String get createCodePinFormTitle;

  /// No description provided for @createCodePinFormSubTitle.
  ///
  /// In en, this message translates to:
  /// **'It helps protect your confidential information the next time you open the app'**
  String get createCodePinFormSubTitle;

  /// No description provided for @configureBiometryMethod.
  ///
  /// In en, this message translates to:
  /// **'Biometric auth'**
  String get configureBiometryMethod;

  /// No description provided for @configureBiometryMethodFace.
  ///
  /// In en, this message translates to:
  /// **'Face ID'**
  String get configureBiometryMethodFace;

  /// No description provided for @configureBiometryMethodFingerprint.
  ///
  /// In en, this message translates to:
  /// **'fingerprint auth'**
  String get configureBiometryMethodFingerprint;

  /// No description provided for @configureBiometryFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable {method} for next time? '**
  String configureBiometryFormTitle(String method);

  /// No description provided for @configureBiometryFormSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Use {method} to log in instead of entering PIN'**
  String configureBiometryFormSubTitle(String method);

  /// No description provided for @configureBiometryFormSubmitBtn.
  ///
  /// In en, this message translates to:
  /// **'Use {method}'**
  String configureBiometryFormSubmitBtn(String method);

  /// No description provided for @configureBiometryFormNotNowBtn.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get configureBiometryFormNotNowBtn;

  /// No description provided for @identificationFormLoginMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your passcode to log in'**
  String get identificationFormLoginMessage;

  /// No description provided for @identificationFormForgotMessage.
  ///
  /// In en, this message translates to:
  /// **'Forgot your passcode?'**
  String get identificationFormForgotMessage;

  /// No description provided for @identificationHelloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {user}'**
  String identificationHelloUser(String user);

  /// No description provided for @identificationErrorPinInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid PIN Code'**
  String get identificationErrorPinInvalid;

  /// No description provided for @biometric_auth.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication'**
  String get biometric_auth;

  /// No description provided for @biometric_auth_required.
  ///
  /// In en, this message translates to:
  /// **'Use your fingerprint or facial recognition'**
  String get biometric_auth_required;

  /// No description provided for @biometric_use_pwd.
  ///
  /// In en, this message translates to:
  /// **'Use a secret code'**
  String get biometric_use_pwd;

  /// No description provided for @biometric_use_fingerprint.
  ///
  /// In en, this message translates to:
  /// **'Verify identity'**
  String get biometric_use_fingerprint;

  /// No description provided for @biometric_echec_biometric.
  ///
  /// In en, this message translates to:
  /// **'Biometric failure. Try again'**
  String get biometric_echec_biometric;

  /// No description provided for @biometric_error.
  ///
  /// In en, this message translates to:
  /// **'Biometric error'**
  String get biometric_error;

  /// No description provided for @biometric_success_authentification.
  ///
  /// In en, this message translates to:
  /// **'Successful authentication'**
  String get biometric_success_authentification;

  /// No description provided for @biometric_success_setting.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get biometric_success_setting;

  /// No description provided for @biometric_activation_setting.
  ///
  /// In en, this message translates to:
  /// **'Activate biometrics in your settings'**
  String get biometric_activation_setting;

  /// No description provided for @biometric_tmp_later.
  ///
  /// In en, this message translates to:
  /// **'Biometrics temporarily disabled. Try again later'**
  String get biometric_tmp_later;

  /// No description provided for @upgrade_profile_tier1.
  ///
  /// In en, this message translates to:
  /// **'Tier One'**
  String get upgrade_profile_tier1;

  /// No description provided for @upgrade_profile_tier2.
  ///
  /// In en, this message translates to:
  /// **'Tier Two'**
  String get upgrade_profile_tier2;

  /// No description provided for @upgrade_profile_step1.
  ///
  /// In en, this message translates to:
  /// **'Step 1'**
  String get upgrade_profile_step1;

  /// No description provided for @upgrade_profile_step2.
  ///
  /// In en, this message translates to:
  /// **'Step 2'**
  String get upgrade_profile_step2;

  /// No description provided for @permissionNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t miss a beat'**
  String get permissionNotificationTitle;

  /// No description provided for @permissionNotificationSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified about spending, incoming, security, wealth so you\'re always in the know'**
  String get permissionNotificationSubTitle;

  /// No description provided for @permissionNotificationEnableBtn.
  ///
  /// In en, this message translates to:
  /// **'Enable push notifications'**
  String get permissionNotificationEnableBtn;

  /// No description provided for @permissionNotificationNotNowBtn.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get permissionNotificationNotNowBtn;

  /// No description provided for @permissionContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Find your friends'**
  String get permissionContactTitle;

  /// No description provided for @permissionContactSubTitle1.
  ///
  /// In en, this message translates to:
  /// **'You’re in control! '**
  String get permissionContactSubTitle1;

  /// No description provided for @permissionContactSubTitle2.
  ///
  /// In en, this message translates to:
  /// **'We never store your phone contacts. '**
  String get permissionContactSubTitle2;

  /// No description provided for @permissionContactEnableBtn.
  ///
  /// In en, this message translates to:
  /// **'Access and update contacts'**
  String get permissionContactEnableBtn;

  /// No description provided for @permissionContactNotNowBtn.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get permissionContactNotNowBtn;

  /// No description provided for @permissionErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'😔 Oooops'**
  String get permissionErrorTitle;

  /// No description provided for @permissionErrorDevice.
  ///
  /// In en, this message translates to:
  /// **'Your device is not supported.'**
  String get permissionErrorDevice;

  /// No description provided for @permissionErrorToken.
  ///
  /// In en, this message translates to:
  /// **'An error occurs. Please retry again!'**
  String get permissionErrorToken;

  /// No description provided for @permissionErrorApi.
  ///
  /// In en, this message translates to:
  /// **'Error communicating with the server. Check your Internet connection or retry again!'**
  String get permissionErrorApi;

  /// No description provided for @securityLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get securityLogoutTitle;

  /// No description provided for @securityLogoutSubTitle.
  ///
  /// In en, this message translates to:
  /// **'If you wish to continue working, click \'Cancel\' and you will be returned to your current state. If you really want to log out, click \'Log Out\'.'**
  String get securityLogoutSubTitle;

  /// No description provided for @securityLogoutBtnConfirmer.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get securityLogoutBtnConfirmer;

  /// No description provided for @securityLogoutBtnAnnuler.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get securityLogoutBtnAnnuler;

  /// No description provided for @aliasCreatePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account alias'**
  String get aliasCreatePageTitle;

  /// No description provided for @aliasCreatePageSubTitle.
  ///
  /// In en, this message translates to:
  /// **'People can send you money by payment address or phone number'**
  String get aliasCreatePageSubTitle;

  /// No description provided for @aliasCreateSHIDTitle.
  ///
  /// In en, this message translates to:
  /// **'Use Payment Address'**
  String get aliasCreateSHIDTitle;

  /// No description provided for @aliasCreateSHIDSubTitle.
  ///
  /// In en, this message translates to:
  /// **'The payment address is created by SPI'**
  String get aliasCreateSHIDSubTitle;

  /// No description provided for @aliasCreateMBNOTitle.
  ///
  /// In en, this message translates to:
  /// **'Use phone number'**
  String get aliasCreateMBNOTitle;

  /// No description provided for @aliasCreateMBNOSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Will be registered as the alias by SPI'**
  String get aliasCreateMBNOSubTitle;

  /// No description provided for @aliaSuccessPageTitle.
  ///
  /// In en, this message translates to:
  /// **'🤩 Great'**
  String get aliaSuccessPageTitle;

  /// No description provided for @aliaSuccessPageSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Your alias created'**
  String get aliaSuccessPageSubTitle;

  /// No description provided for @aliaSuccessPageDescription.
  ///
  /// In en, this message translates to:
  /// **'You can effortlessly share it with others, enabling them to initiate transfers directly to you.Alias simplifies the process, allowing you to transact with ease while maintaining your privacy.'**
  String get aliaSuccessPageDescription;

  /// No description provided for @aliaSuccessPageBtnText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get aliaSuccessPageBtnText;

  /// No description provided for @aliaSuccessClaimPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Claim sent successfully'**
  String get aliaSuccessClaimPageTitle;

  /// No description provided for @addPhoneNumberPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Add phone number'**
  String get addPhoneNumberPageTitle;

  /// No description provided for @addPhoneNumberPageSubTitle.
  ///
  /// In en, this message translates to:
  /// **'We will send a verification code to this number'**
  String get addPhoneNumberPageSubTitle;

  /// No description provided for @addPhoneNumberFormHint.
  ///
  /// In en, this message translates to:
  /// **'Mobile phone'**
  String get addPhoneNumberFormHint;

  /// No description provided for @addPhoneNumberFormErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Mandatory field'**
  String get addPhoneNumberFormErrorEmpty;

  /// No description provided for @addPhoneNumberFormErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get addPhoneNumberFormErrorInvalid;

  /// No description provided for @addPhoneNumberFormBtnContinuer.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get addPhoneNumberFormBtnContinuer;

  /// No description provided for @verifyPhoneNumberPageTitle.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get verifyPhoneNumberPageTitle;

  /// No description provided for @verifyPhoneNumberPageSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter the code send to {number}'**
  String verifyPhoneNumberPageSubTitle(String number);

  /// No description provided for @aliaMBNOResendMessage.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {delay}'**
  String aliaMBNOResendMessage(String delay);

  /// No description provided for @aliaMBNOResendMessageBtn.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get aliaMBNOResendMessageBtn;

  /// No description provided for @aliaMBNOInvalidOtpMessage.
  ///
  /// In en, this message translates to:
  /// **'Otp invalid'**
  String get aliaMBNOInvalidOtpMessage;

  /// No description provided for @aliasInvalidOtpResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get aliasInvalidOtpResend;

  /// No description provided for @aliaErrorPageTitle.
  ///
  /// In en, this message translates to:
  /// **'😔 Oooops'**
  String get aliaErrorPageTitle;

  /// No description provided for @aliaErrorPageSubTitle.
  ///
  /// In en, this message translates to:
  /// **'This alias is taken'**
  String get aliaErrorPageSubTitle;

  /// No description provided for @aliaErrorPageDescription.
  ///
  /// In en, this message translates to:
  /// **'Phone number is already registered as an alias by someone else.'**
  String get aliaErrorPageDescription;

  /// No description provided for @aliaErrorPageReclamationBtnText.
  ///
  /// In en, this message translates to:
  /// **'Claim the phone number'**
  String get aliaErrorPageReclamationBtnText;

  /// No description provided for @aliaErrorPageChoisisserBtnText.
  ///
  /// In en, this message translates to:
  /// **'Choose another alias'**
  String get aliaErrorPageChoisisserBtnText;

  /// No description provided for @aliaErrorClaimNotExistPageSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Introuvable'**
  String get aliaErrorClaimNotExistPageSubTitle;

  /// No description provided for @aliaErrorClaimNotExistPageDescription.
  ///
  /// In en, this message translates to:
  /// **'Cette revendication n\'est plus disponible. Elle est terminée, clôturée ou archivée !'**
  String get aliaErrorClaimNotExistPageDescription;

  /// No description provided for @aliaErrorClaimLockedPageSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Another claim is already registered'**
  String get aliaErrorClaimLockedPageSubTitle;

  /// No description provided for @aliaErrorClaimNotFoundPageSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Alias deleted by the owner'**
  String get aliaErrorClaimNotFoundPageSubTitle;

  /// No description provided for @aliasClaimDetailsHeadTitle.
  ///
  /// In en, this message translates to:
  /// **'Alias claim'**
  String get aliasClaimDetailsHeadTitle;

  /// No description provided for @aliasClaimDetailsHeadSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Requested phone number'**
  String get aliasClaimDetailsHeadSubTitle;

  /// No description provided for @aliasClaimDetailsBtnConfirmer.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get aliasClaimDetailsBtnConfirmer;

  /// No description provided for @aliasClaimDetailsDateDemande.
  ///
  /// In en, this message translates to:
  /// **'Request date'**
  String get aliasClaimDetailsDateDemande;

  /// No description provided for @aliasClaimDetailsDateAcceptation.
  ///
  /// In en, this message translates to:
  /// **'Accepted date'**
  String get aliasClaimDetailsDateAcceptation;

  /// No description provided for @aliasClaimDetailsDateRefus.
  ///
  /// In en, this message translates to:
  /// **'Rejected date'**
  String get aliasClaimDetailsDateRefus;

  /// No description provided for @aliasClaimDetailsAlert.
  ///
  /// In en, this message translates to:
  /// **'If you do not successfully reject this request by {dateVerrouillage}, you will no longer be able to make transactions with this alias. If the request is still pending on {dateCloture}, the alias will be deleted.'**
  String aliasClaimDetailsAlert(String dateVerrouillage, String dateCloture);

  /// No description provided for @aliasClaimAcceptDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to accept the claim?'**
  String get aliasClaimAcceptDialogTitle;

  /// No description provided for @aliasClaimAcceptDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Upon acceptance, your alias {alias} will be deleted, and this action will be irreversible. You will no longer be able to receive payments with this alias.'**
  String aliasClaimAcceptDialogMessage(String alias);

  /// No description provided for @aliasClaimAcceptSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Claim accepted'**
  String get aliasClaimAcceptSuccessTitle;

  /// No description provided for @aliasClaimAcceptSuccessDescription.
  ///
  /// In en, this message translates to:
  /// **'Your alias {alias} has been deleted.'**
  String aliasClaimAcceptSuccessDescription(String alias);

  /// No description provided for @aliasClaimRejectSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Claim rejected'**
  String get aliasClaimRejectSuccessTitle;

  /// No description provided for @aliasClaimRejectSuccessDescription.
  ///
  /// In en, this message translates to:
  /// **'Your alias {alias} has been retained.'**
  String aliasClaimRejectSuccessDescription(String alias);

  /// No description provided for @aliasClaimDetailsRefusPageSubTitile.
  ///
  /// In en, this message translates to:
  /// **'The rejection can only be accepted if you prove that the phone number belongs to you by entering the OTP code.'**
  String get aliasClaimDetailsRefusPageSubTitile;

  /// No description provided for @aliasClaimConfirmError.
  ///
  /// In en, this message translates to:
  /// **'Confirmation failed. Please try again.'**
  String get aliasClaimConfirmError;

  /// No description provided for @aliasClaimConfirmSuccessRejectTitle.
  ///
  /// In en, this message translates to:
  /// **'Alias retained'**
  String get aliasClaimConfirmSuccessRejectTitle;

  /// No description provided for @aliasClaimConfirmSuccessAcceptTitle.
  ///
  /// In en, this message translates to:
  /// **'Alias deleted'**
  String get aliasClaimConfirmSuccessAcceptTitle;

  /// No description provided for @aliasFormLabel.
  ///
  /// In en, this message translates to:
  /// **'Alias'**
  String get aliasFormLabel;

  /// No description provided for @aliasFormHint.
  ///
  /// In en, this message translates to:
  /// **'Payment address or phone number'**
  String get aliasFormHint;

  /// No description provided for @aliasFormEmpty.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get aliasFormEmpty;

  /// No description provided for @aliasFormInvalid.
  ///
  /// In en, this message translates to:
  /// **'Must be a 36-character payment address or a phone number with the country code'**
  String get aliasFormInvalid;

  /// No description provided for @aliasFormNotFound.
  ///
  /// In en, this message translates to:
  /// **'The beneficiary\'s alias does not exist in PI'**
  String get aliasFormNotFound;

  /// No description provided for @contactActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactActionsTitle;

  /// No description provided for @contactWithNoPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'This contact does not have a phone number'**
  String get contactWithNoPhoneNumber;

  /// No description provided for @contactTransferTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer by contact'**
  String get contactTransferTitle;

  /// No description provided for @contactPhoneAsAccountAlias.
  ///
  /// In en, this message translates to:
  /// **'{phoneNumber} is an account alias'**
  String contactPhoneAsAccountAlias(String phoneNumber);

  /// No description provided for @contactPhoneAsAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'{phoneNumber} is an account number'**
  String contactPhoneAsAccountNumber(String phoneNumber);

  /// No description provided for @contactCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a contact'**
  String get contactCreateTitle;

  /// No description provided for @contactCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save a contact with their alias'**
  String get contactCreateSubtitle;

  /// No description provided for @contactCreateNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First and last name'**
  String get contactCreateNameLabel;

  /// No description provided for @contactCreateNameErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get contactCreateNameErrorEmpty;

  /// No description provided for @contactBtnSave.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get contactBtnSave;

  /// No description provided for @homePageToolbarTabbarCompte.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get homePageToolbarTabbarCompte;

  /// No description provided for @homePageToolbarTabbarAbonnement.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get homePageToolbarTabbarAbonnement;

  /// No description provided for @homePageToolbarTabbarEconomie.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get homePageToolbarTabbarEconomie;

  /// No description provided for @homeSolde.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get homeSolde;

  /// No description provided for @homeActionSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get homeActionSend;

  /// No description provided for @homeActionRequest.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get homeActionRequest;

  /// No description provided for @homeActionMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get homeActionMore;

  /// No description provided for @homeTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get homeTransactions;

  /// No description provided for @homeTransactionsRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get homeTransactionsRecent;

  /// No description provided for @transactionsNoRecent.
  ///
  /// In en, this message translates to:
  /// **'No recent transactions'**
  String get transactionsNoRecent;

  /// No description provided for @transactionsNoRecentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your recent transactions will appear here'**
  String get transactionsNoRecentSubtitle;

  /// No description provided for @transactionsErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading transactions'**
  String get transactionsErrorLoading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get retry;

  /// No description provided for @homeTransactionsRecentsNombreTitle.
  ///
  /// In en, this message translates to:
  /// **'Last transactions'**
  String get homeTransactionsRecentsNombreTitle;

  /// No description provided for @homeTransactionsRecentsNombreSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how many transactions you want to see in your widget'**
  String get homeTransactionsRecentsNombreSubTitle;

  /// No description provided for @homeTransactionsRecentsNombreBtnSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get homeTransactionsRecentsNombreBtnSave;

  /// No description provided for @homeActionMoreSheetProgrammerTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule a transfer'**
  String get homeActionMoreSheetProgrammerTitle;

  /// No description provided for @homeActionMoreSheetProgrammerSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Create new transfer'**
  String get homeActionMoreSheetProgrammerSubTitle;

  /// No description provided for @homeActionMoreSheetAbonnementTitle.
  ///
  /// In en, this message translates to:
  /// **'Find a subscription'**
  String get homeActionMoreSheetAbonnementTitle;

  /// No description provided for @homeActionMoreSheetAbonnementSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Convert past payment in to subscription'**
  String get homeActionMoreSheetAbonnementSubTitle;

  /// No description provided for @homeActionMoreSheetPartagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Split payments'**
  String get homeActionMoreSheetPartagerTitle;

  /// No description provided for @homeActionMoreSheetPartagerSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Split payment from your spending'**
  String get homeActionMoreSheetPartagerSubTitle;

  /// No description provided for @homeActionMoreSheetTirelireTitle.
  ///
  /// In en, this message translates to:
  /// **'Open saving box'**
  String get homeActionMoreSheetTirelireTitle;

  /// No description provided for @homeActionMoreSheetTirelireSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Split payment from your spending'**
  String get homeActionMoreSheetTirelireSubTitle;

  /// No description provided for @homeActionMoreSheetBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set budgets'**
  String get homeActionMoreSheetBudgetTitle;

  /// No description provided for @homeActionMoreSheetBudgetSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your budget for spending'**
  String get homeActionMoreSheetBudgetSubTitle;

  /// No description provided for @homeActionMoreSheetWidgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Widget'**
  String get homeActionMoreSheetWidgetTitle;

  /// No description provided for @homeActionMoreSheetAWidgetSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage widgets for home'**
  String get homeActionMoreSheetAWidgetSubTitle;

  /// No description provided for @transactionsSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get transactionsSeeAll;

  /// No description provided for @transactionsSendInputHint.
  ///
  /// In en, this message translates to:
  /// **'Name, Alias'**
  String get transactionsSendInputHint;

  /// No description provided for @transactionsSendOptionAliasTitle.
  ///
  /// In en, this message translates to:
  /// **'Use Alias'**
  String get transactionsSendOptionAliasTitle;

  /// No description provided for @transactionsSendOptionAliasSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Payment address'**
  String get transactionsSendOptionAliasSubtitle;

  /// No description provided for @transactionsSendOptionIbanTitle.
  ///
  /// In en, this message translates to:
  /// **'Use IBAN'**
  String get transactionsSendOptionIbanTitle;

  /// No description provided for @transactionsSendOptionIbanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recipient bank account'**
  String get transactionsSendOptionIbanSubtitle;

  /// No description provided for @transactionsSendOptionOthrTitle.
  ///
  /// In en, this message translates to:
  /// **'Use Other Account number'**
  String get transactionsSendOptionOthrTitle;

  /// No description provided for @transactionsSendOptionOthrSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Microfinance or Mobile money account'**
  String get transactionsSendOptionOthrSubtitle;

  /// No description provided for @transactionsSendOptionNewContactTitle.
  ///
  /// In en, this message translates to:
  /// **'New contact'**
  String get transactionsSendOptionNewContactTitle;

  /// No description provided for @transactionsSendOptionNewContactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a contact using alias'**
  String get transactionsSendOptionNewContactSubtitle;

  /// No description provided for @transactionsSendRecentItemYouSend.
  ///
  /// In en, this message translates to:
  /// **'You send '**
  String get transactionsSendRecentItemYouSend;

  /// No description provided for @transactionsSendRecentItemYouReceive.
  ///
  /// In en, this message translates to:
  /// **'You receive '**
  String get transactionsSendRecentItemYouReceive;

  /// No description provided for @transactionsSendTitleTransfert.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transactionsSendTitleTransfert;

  /// No description provided for @transactionsSendTitleRecents.
  ///
  /// In en, this message translates to:
  /// **'Recents transfers'**
  String get transactionsSendTitleRecents;

  /// No description provided for @transactionsSendTitleContacts.
  ///
  /// In en, this message translates to:
  /// **'From your contacts'**
  String get transactionsSendTitleContacts;

  /// No description provided for @transactionsSendTitleRequest2Pay.
  ///
  /// In en, this message translates to:
  /// **'Request to pay'**
  String get transactionsSendTitleRequest2Pay;

  /// No description provided for @transactionsSendTitleRequest2PayRecents.
  ///
  /// In en, this message translates to:
  /// **'Recents requests'**
  String get transactionsSendTitleRequest2PayRecents;

  /// No description provided for @transactionsSendScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Qui payer'**
  String get transactionsSendScheduleTitle;

  /// No description provided for @transactionsSendFormAliasTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer by Alias'**
  String get transactionsSendFormAliasTitle;

  /// No description provided for @transactionsSendFormAliasSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the phone number or Payment address alias'**
  String get transactionsSendFormAliasSubtitle;

  /// No description provided for @transactionsSendFormOthrTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer by Account number'**
  String get transactionsSendFormOthrTitle;

  /// No description provided for @transactionsSendFormOthrSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Account number with a microfinance institution or electronic money issuer'**
  String get transactionsSendFormOthrSubtitle;

  /// No description provided for @transactionsSendFormIbanTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer by IBAN'**
  String get transactionsSendFormIbanTitle;

  /// No description provided for @transactionsSendFormIbanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the IBAN number of the payee'**
  String get transactionsSendFormIbanSubtitle;

  /// No description provided for @transactionsSendFormQrCodeTitleTransfer.
  ///
  /// In en, this message translates to:
  /// **'QR Code transfer'**
  String get transactionsSendFormQrCodeTitleTransfer;

  /// No description provided for @transactionsSendFormQrCodeTitlePayment.
  ///
  /// In en, this message translates to:
  /// **'QR Code payment'**
  String get transactionsSendFormQrCodeTitlePayment;

  /// No description provided for @transactionsSendFormQrCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount'**
  String get transactionsSendFormQrCodeSubtitle;

  /// No description provided for @transactionsSendSuccessBtnVoir.
  ///
  /// In en, this message translates to:
  /// **'Show details'**
  String get transactionsSendSuccessBtnVoir;

  /// No description provided for @transactionsSendSuccessBtnReessayer.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get transactionsSendSuccessBtnReessayer;

  /// No description provided for @transactionsSendErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'😔 Oooops'**
  String get transactionsSendErrorTitle;

  /// No description provided for @transactionsSendErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'Transaction failed'**
  String get transactionsSendErrorDescription;

  /// No description provided for @transactionsSendErrorBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get transactionsSendErrorBtn;

  /// No description provided for @transactionFormAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get transactionFormAmountHint;

  /// No description provided for @transactionFormAmountEmpty.
  ///
  /// In en, this message translates to:
  /// **'Mandatory'**
  String get transactionFormAmountEmpty;

  /// No description provided for @transactionFormAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance'**
  String get transactionFormAmountInvalid;

  /// No description provided for @transactionFormAmountLow.
  ///
  /// In en, this message translates to:
  /// **'Minimum amount 5 XOF'**
  String get transactionFormAmountLow;

  /// No description provided for @transactionFormMotifHint.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get transactionFormMotifHint;

  /// No description provided for @transactionFormMotifLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get transactionFormMotifLabel;

  /// No description provided for @transactionFormMotifInvalid.
  ///
  /// In en, this message translates to:
  /// **'No more than 104 characters'**
  String get transactionFormMotifInvalid;

  /// No description provided for @transactionFormFactureLabel.
  ///
  /// In en, this message translates to:
  /// **'Facture'**
  String get transactionFormFactureLabel;

  /// No description provided for @transactionFormIbanLabel.
  ///
  /// In en, this message translates to:
  /// **'IBAN'**
  String get transactionFormIbanLabel;

  /// No description provided for @transactionFormIbanHint.
  ///
  /// In en, this message translates to:
  /// **'Recipient IBAN'**
  String get transactionFormIbanHint;

  /// No description provided for @transactionFormIbanEmpty.
  ///
  /// In en, this message translates to:
  /// **'Mandatory'**
  String get transactionFormIbanEmpty;

  /// No description provided for @transactionFormIbanInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid IBAN format'**
  String get transactionFormIbanInvalid;

  /// No description provided for @transactionFormIbanPaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Country of recipient’s bank'**
  String get transactionFormIbanPaysLabel;

  /// No description provided for @transactionFormIbanNomLabel.
  ///
  /// In en, this message translates to:
  /// **'Name of recipient’s bank'**
  String get transactionFormIbanNomLabel;

  /// No description provided for @transactionFormOthrLabel.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get transactionFormOthrLabel;

  /// No description provided for @transactionFormOthrHint.
  ///
  /// In en, this message translates to:
  /// **'Recipient account number'**
  String get transactionFormOthrHint;

  /// No description provided for @transactionFormOthrEmpty.
  ///
  /// In en, this message translates to:
  /// **'Mandatory'**
  String get transactionFormOthrEmpty;

  /// No description provided for @transactionFormOthrPaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Country of recipient’s institution'**
  String get transactionFormOthrPaysLabel;

  /// No description provided for @transactionFormOthrNomLabel.
  ///
  /// In en, this message translates to:
  /// **'Name of recipient’s institution'**
  String get transactionFormOthrNomLabel;

  /// No description provided for @transactionFormContinueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get transactionFormContinueBtn;

  /// No description provided for @transactionFormSaveContactBtn.
  ///
  /// In en, this message translates to:
  /// **'Save and make transfer'**
  String get transactionFormSaveContactBtn;

  /// No description provided for @transactionFormVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get transactionFormVerificationTitle;

  /// No description provided for @transactionFormVerificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please check the information about the recipient before confirming'**
  String get transactionFormVerificationSubtitle;

  /// No description provided for @transactionFormVerificationTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get transactionFormVerificationTypeLabel;

  /// No description provided for @transactionFormVerificationTypeIBAN.
  ///
  /// In en, this message translates to:
  /// **'Transfer by IBAN'**
  String get transactionFormVerificationTypeIBAN;

  /// No description provided for @transactionFormVerificationTypeOTHR.
  ///
  /// In en, this message translates to:
  /// **'Transfer by Account number'**
  String get transactionFormVerificationTypeOTHR;

  /// No description provided for @transactionFormVerificationClientName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get transactionFormVerificationClientName;

  /// No description provided for @transactionFormVerificationBtnConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get transactionFormVerificationBtnConfirm;

  /// No description provided for @transactionFormVerificationBtnReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get transactionFormVerificationBtnReject;

  /// No description provided for @transactionFormScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get transactionFormScheduleTitle;

  /// No description provided for @transactionFormScheduleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your payment will be made on the selected date'**
  String get transactionFormScheduleSubtitle;

  /// No description provided for @transactionFormScheduleDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get transactionFormScheduleDateLabel;

  /// No description provided for @transactionFormScheduleDateRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Date - End Date'**
  String get transactionFormScheduleDateRangeLabel;

  /// No description provided for @transactionFormScheduleDateSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get transactionFormScheduleDateSelectTitle;

  /// No description provided for @transactionFormScheduleDateRangeSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a date range'**
  String get transactionFormScheduleDateRangeSelectTitle;

  /// No description provided for @transactionFormScheduleFrequenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get transactionFormScheduleFrequenceLabel;

  /// No description provided for @transactionFormScheduleFrequenceUnefois.
  ///
  /// In en, this message translates to:
  /// **'One time'**
  String get transactionFormScheduleFrequenceUnefois;

  /// No description provided for @transactionFormScheduleFrequenceQuotidienne.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get transactionFormScheduleFrequenceQuotidienne;

  /// No description provided for @transactionFormScheduleFrequenceHebdomadaire.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get transactionFormScheduleFrequenceHebdomadaire;

  /// No description provided for @transactionFormScheduleFrequenceMensuelle.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get transactionFormScheduleFrequenceMensuelle;

  /// No description provided for @transactionFormScheduleFrequenceAnnuelle.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get transactionFormScheduleFrequenceAnnuelle;

  /// No description provided for @transactionFormScheduleFrequenceSurMesure.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get transactionFormScheduleFrequenceSurMesure;

  /// No description provided for @transactionFormSchedulePeriodiciteLabel.
  ///
  /// In en, this message translates to:
  /// **'Periodicity'**
  String get transactionFormSchedulePeriodiciteLabel;

  /// No description provided for @transactionFormScheduleFrequenceSelected.
  ///
  /// In en, this message translates to:
  /// **'Every {periodicite} {frequence}'**
  String transactionFormScheduleFrequenceSelected(String periodicite, String frequence);

  /// No description provided for @transactionFormScheduleDateRange.
  ///
  /// In en, this message translates to:
  /// **'from {start} to {end}'**
  String transactionFormScheduleDateRange(String start, String end);

  /// No description provided for @transactionFormScheduleDateSelected.
  ///
  /// In en, this message translates to:
  /// **'Starting from {start}'**
  String transactionFormScheduleDateSelected(String start);

  /// No description provided for @transactionFormScheduleSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'You have scheduled {montant} FCFA for {payee}'**
  String transactionFormScheduleSuccessMessage(String montant, String payee);

  /// No description provided for @transactionFormScheduleSuccessBtn.
  ///
  /// In en, this message translates to:
  /// **'View subscription'**
  String get transactionFormScheduleSuccessBtn;

  /// No description provided for @transactionsSendSuccessBtnTitle.
  ///
  /// In en, this message translates to:
  /// **'You sent money to {payee}'**
  String transactionsSendSuccessBtnTitle(String payee);

  /// No description provided for @subscriptionEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming transactions'**
  String get subscriptionEmptyTitle;

  /// No description provided for @subscriptionEmptySubTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your subscriptions and scheduled payments in one place'**
  String get subscriptionEmptySubTitle;

  /// No description provided for @subscriptionListOnceTitle.
  ///
  /// In en, this message translates to:
  /// **'Scheduled payments'**
  String get subscriptionListOnceTitle;

  /// No description provided for @subscriptionEmptyBtnCreate.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get subscriptionEmptyBtnCreate;

  /// No description provided for @subscriptionListFrequenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptionListFrequenceTitle;

  /// No description provided for @subscriptionMenuScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule a payment'**
  String get subscriptionMenuScheduleTitle;

  /// No description provided for @subscriptionMenuScheduleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer to be executed at a future date'**
  String get subscriptionMenuScheduleSubtitle;

  /// No description provided for @subscriptionMenuSubscribeTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a subscription'**
  String get subscriptionMenuSubscribeTitle;

  /// No description provided for @subscriptionMenuSubscribeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Convert a payment into a subscription'**
  String get subscriptionMenuSubscribeSubtitle;

  /// No description provided for @subscriptionMenuSubscribeSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Search in your transactions and select a recurring payment'**
  String get subscriptionMenuSubscribeSubtitle2;

  /// No description provided for @subscriptionDateScheduledForTitle.
  ///
  /// In en, this message translates to:
  /// **'Scheduled for'**
  String get subscriptionDateScheduledForTitle;

  /// No description provided for @subscriptionDateScheduledFor.
  ///
  /// In en, this message translates to:
  /// **'Scheduled for {date}'**
  String subscriptionDateScheduledFor(String date);

  /// No description provided for @subscriptionDateNextPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Next payment'**
  String get subscriptionDateNextPaymentTitle;

  /// No description provided for @subscriptionDateNextPayment.
  ///
  /// In en, this message translates to:
  /// **'Next payment on {date}'**
  String subscriptionDateNextPayment(String date);

  /// No description provided for @subscriptionDateEndsSince.
  ///
  /// In en, this message translates to:
  /// **'Ended since {date}'**
  String subscriptionDateEndsSince(String date);

  /// No description provided for @subscriptionDateToday.
  ///
  /// In en, this message translates to:
  /// **'Payment for today'**
  String get subscriptionDateToday;

  /// No description provided for @subscriptionDisabled.
  ///
  /// In en, this message translates to:
  /// **'Subscription disabled'**
  String get subscriptionDisabled;

  /// No description provided for @subscriptionPaymentTo.
  ///
  /// In en, this message translates to:
  /// **'Payment to'**
  String get subscriptionPaymentTo;

  /// No description provided for @subscriptionStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get subscriptionStartDate;

  /// No description provided for @subscriptionEditNoteBtn.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get subscriptionEditNoteBtn;

  /// No description provided for @transactionsRtpSuccessBtnTitle.
  ///
  /// In en, this message translates to:
  /// **'You have sent a payment request to {payee}'**
  String transactionsRtpSuccessBtnTitle(String payee);

  /// No description provided for @transactionsRtpSuccessBtnVoir.
  ///
  /// In en, this message translates to:
  /// **'View request'**
  String get transactionsRtpSuccessBtnVoir;

  /// No description provided for @transactionRtpDetailsTitleInitiee.
  ///
  /// In en, this message translates to:
  /// **'You requested from {payeur}'**
  String transactionRtpDetailsTitleInitiee(String payeur);

  /// No description provided for @transactionRtpDetailsTitleRecue.
  ///
  /// In en, this message translates to:
  /// **'You owe {paye}'**
  String transactionRtpDetailsTitleRecue(String paye);

  /// No description provided for @transactionRtpDetailsEcheanceDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get transactionRtpDetailsEcheanceDate;

  /// No description provided for @transactionRtpDetailsRemiseTitle.
  ///
  /// In en, this message translates to:
  /// **'Immediate Payment'**
  String get transactionRtpDetailsRemiseTitle;

  /// No description provided for @transactionRtpDetailsRemiseLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get transactionRtpDetailsRemiseLabel;

  /// valid until 28/07/2023 at 23:59:59
  ///
  /// In en, this message translates to:
  /// **'valid until {dateReponse}'**
  String transactionRtpDetailsRemiseHint(String dateReponse);

  /// No description provided for @transactionRtpDetailsSplitPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Split Payment'**
  String get transactionRtpDetailsSplitPaymentTitle;

  /// No description provided for @transactionRtpDetailsSplitPaymentTo.
  ///
  /// In en, this message translates to:
  /// **'Payment to'**
  String get transactionRtpDetailsSplitPaymentTo;

  /// No description provided for @transactionRtpDetailsPICOTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal with PICO purchase'**
  String get transactionRtpDetailsPICOTitle;

  /// No description provided for @transactionRtpDetailsPICASHTitle.
  ///
  /// In en, this message translates to:
  /// **'PICASh Withdrawal'**
  String get transactionRtpDetailsPICASHTitle;

  /// No description provided for @transactionRtpDetailsAmtAchatTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get transactionRtpDetailsAmtAchatTitle;

  /// No description provided for @transactionRtpDetailsAmtRetraitTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal'**
  String get transactionRtpDetailsAmtRetraitTitle;

  /// No description provided for @transactionRtpDetailsAmtFraisTitle.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get transactionRtpDetailsAmtFraisTitle;

  /// No description provided for @transactionRtpDetailsDiffereTitle.
  ///
  /// In en, this message translates to:
  /// **'Deferred Debit'**
  String get transactionRtpDetailsDiffereTitle;

  /// No description provided for @transactionRtpDetailsDiffereSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Buy now, Pay later'**
  String get transactionRtpDetailsDiffereSubtitle;

  /// No description provided for @transactionRtpDetailsDiffereDescription.
  ///
  /// In en, this message translates to:
  /// **'Your account will be debited at the end of the month'**
  String get transactionRtpDetailsDiffereDescription;

  /// Pay in 3 installments
  ///
  /// In en, this message translates to:
  /// **'Pay in {occurence} {frequence}'**
  String transactionRtpDetailsDifferePayFrequence(int occurence, String frequence);

  /// 52,000 per month
  ///
  /// In en, this message translates to:
  /// **'{montant} per {frequence}'**
  String transactionRtpDetailsDifferePayAmt(String montant, String frequence);

  /// Reject request from seini
  ///
  /// In en, this message translates to:
  /// **'Reject request from {paye}'**
  String transactionRtpRejectTitle(String paye);

  /// 52,000 per month
  ///
  /// In en, this message translates to:
  /// **'{montant} for {paye}'**
  String transactionRtpRejectSubtitle(String montant, String paye);

  /// No description provided for @transactionRtpRejectRsnDemandeur.
  ///
  /// In en, this message translates to:
  /// **'Unknown requester'**
  String get transactionRtpRejectRsnDemandeur;

  /// No description provided for @transactionRtpRejectRsnMontant.
  ///
  /// In en, this message translates to:
  /// **'Incorrect amount'**
  String get transactionRtpRejectRsnMontant;

  /// No description provided for @transactionRtpRejectRsnRemittance.
  ///
  /// In en, this message translates to:
  /// **'Incorrect invoice'**
  String get transactionRtpRejectRsnRemittance;

  /// No description provided for @transactionRtpRejectMessage.
  ///
  /// In en, this message translates to:
  /// **'The payment request has been successfully rejected'**
  String get transactionRtpRejectMessage;

  /// No description provided for @transactionDetailsFrequenceMois.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get transactionDetailsFrequenceMois;

  /// No description provided for @transactionDetailsFrequenceSemaine.
  ///
  /// In en, this message translates to:
  /// **'weeks'**
  String get transactionDetailsFrequenceSemaine;

  /// No description provided for @transactionDetailsFrequenceJour.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get transactionDetailsFrequenceJour;

  /// No description provided for @transactionDetailsRetourner.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get transactionDetailsRetourner;

  /// No description provided for @transactionDetailsAnnuler.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get transactionDetailsAnnuler;

  /// No description provided for @transactionDetailsRecevoir.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get transactionDetailsRecevoir;

  /// No description provided for @transactionDetailsPartager.
  ///
  /// In en, this message translates to:
  /// **'Split'**
  String get transactionDetailsPartager;

  /// No description provided for @transactionDetailsPlanifier.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get transactionDetailsPlanifier;

  /// No description provided for @transactionDetailsMotifCredit.
  ///
  /// In en, this message translates to:
  /// **'Received without note'**
  String get transactionDetailsMotifCredit;

  /// No description provided for @transactionDetailsMotifDebit.
  ///
  /// In en, this message translates to:
  /// **'Sent without note'**
  String get transactionDetailsMotifDebit;

  /// No description provided for @transactionDetailsReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get transactionDetailsReference;

  /// No description provided for @transactionDetailsPays.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get transactionDetailsPays;

  /// No description provided for @transactionDetailsPayeLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment to'**
  String get transactionDetailsPayeLabel;

  /// No description provided for @transactionDetailsPayeurLabel.
  ///
  /// In en, this message translates to:
  /// **'Received from'**
  String get transactionDetailsPayeurLabel;

  /// No description provided for @transactionDetailsDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Received at'**
  String get transactionDetailsDateLabel;

  /// No description provided for @transactionDetailsTelecharger.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get transactionDetailsTelecharger;

  /// No description provided for @transactionDetailsRecuPaiement.
  ///
  /// In en, this message translates to:
  /// **'Statement'**
  String get transactionDetailsRecuPaiement;

  /// No description provided for @transactionDetailsAlias.
  ///
  /// In en, this message translates to:
  /// **'Alias'**
  String get transactionDetailsAlias;

  /// No description provided for @transactionDetailsCategorie.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get transactionDetailsCategorie;

  /// No description provided for @transactionDetailsTicket.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get transactionDetailsTicket;

  /// No description provided for @transactionDetailsAnalytique.
  ///
  /// In en, this message translates to:
  /// **'Exclude from Analytics'**
  String get transactionDetailsAnalytique;

  /// No description provided for @transactionDetailsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Select an issue'**
  String get transactionDetailsQuestion;

  /// No description provided for @transactionDetailsTeleverser.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get transactionDetailsTeleverser;

  /// No description provided for @transactionDetailsRecuPaiementPDF.
  ///
  /// In en, this message translates to:
  /// **'Transaction Statement'**
  String get transactionDetailsRecuPaiementPDF;

  /// No description provided for @transactionDetailsRecuPaiementPDFSousTitre.
  ///
  /// In en, this message translates to:
  /// **'You can download or share the PDF file'**
  String get transactionDetailsRecuPaiementPDFSousTitre;

  /// No description provided for @transactionDetailsTicketCaisse.
  ///
  /// In en, this message translates to:
  /// **'Transaction Statement'**
  String get transactionDetailsTicketCaisse;

  /// No description provided for @transactionDetailsTicketCaisseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can share the receipt'**
  String get transactionDetailsTicketCaisseSubtitle;

  /// No description provided for @transactionDetailsCompte.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get transactionDetailsCompte;

  /// No description provided for @transactionDetailsInstitution.
  ///
  /// In en, this message translates to:
  /// **'Institution'**
  String get transactionDetailsInstitution;

  /// No description provided for @transactionDetailsReturnTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to return the funds ?'**
  String get transactionDetailsReturnTitle;

  /// No description provided for @transactionDetailsReturnSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'You have successfully returned funds'**
  String get transactionDetailsReturnSuccessMessage;

  /// No description provided for @transactionDetailsRetourDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Returned on'**
  String get transactionDetailsRetourDateLabel;

  /// No description provided for @transactionDetailsCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancellation request'**
  String get transactionDetailsCancelTitle;

  /// No description provided for @transactionDetailsCancelSubTitle.
  ///
  /// In en, this message translates to:
  /// **'What is the reason for the request ?'**
  String get transactionDetailsCancelSubTitle;

  /// No description provided for @transactionDetailsCancelRsnDestinataire.
  ///
  /// In en, this message translates to:
  /// **'Recipient error'**
  String get transactionDetailsCancelRsnDestinataire;

  /// No description provided for @transactionDetailsCancelRsnMontant.
  ///
  /// In en, this message translates to:
  /// **'Error on the amount'**
  String get transactionDetailsCancelRsnMontant;

  /// No description provided for @transactionDetailsCancelRsnService.
  ///
  /// In en, this message translates to:
  /// **'Service not delivered'**
  String get transactionDetailsCancelRsnService;

  /// No description provided for @transactionDetailsCancelRsnFraud.
  ///
  /// In en, this message translates to:
  /// **'Fraud attempted '**
  String get transactionDetailsCancelRsnFraud;

  /// No description provided for @transactionDetailsCancelRsnDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Already paid'**
  String get transactionDetailsCancelRsnDuplicate;

  /// No description provided for @transactionDetailsCancelBtnSend.
  ///
  /// In en, this message translates to:
  /// **'Request cancellation'**
  String get transactionDetailsCancelBtnSend;

  /// No description provided for @transactionDetailsCancelSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Request cancellation sent'**
  String get transactionDetailsCancelSuccessMessage;

  /// No description provided for @transactionDetailsCancelSuccessDescription.
  ///
  /// In en, this message translates to:
  /// **'The request is pending processing.\n You will be notified as soon as the beneficiary responds.'**
  String get transactionDetailsCancelSuccessDescription;

  /// No description provided for @transactionDetailsCancelDemandeLabel.
  ///
  /// In en, this message translates to:
  /// **'Requested on'**
  String get transactionDetailsCancelDemandeLabel;

  /// No description provided for @transactionDetailsCancelDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancelled on'**
  String get transactionDetailsCancelDateLabel;

  /// No description provided for @transactionDetailsCancelHeadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{montant} received'**
  String transactionDetailsCancelHeadSubtitle(String montant);

  /// No description provided for @transactionDetailsCancelReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get transactionDetailsCancelReasonLabel;

  /// No description provided for @transactionDetailsCancelRejectMessage.
  ///
  /// In en, this message translates to:
  /// **'The cancellation request has been successfully rejected'**
  String get transactionDetailsCancelRejectMessage;

  /// No description provided for @transactionDetailsRecuTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction Statement'**
  String get transactionDetailsRecuTitle;

  /// No description provided for @transactionDetailsRecuSubTitle.
  ///
  /// In en, this message translates to:
  /// **'You can download or share the PDF file'**
  String get transactionDetailsRecuSubTitle;

  /// No description provided for @transactionDetailsRecuInfoIdentifiant.
  ///
  /// In en, this message translates to:
  /// **'Identifier'**
  String get transactionDetailsRecuInfoIdentifiant;

  /// No description provided for @transactionDetailsRecuInfoReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get transactionDetailsRecuInfoReference;

  /// No description provided for @transactionDetailsRecuInfoFrais.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get transactionDetailsRecuInfoFrais;

  /// No description provided for @transactionDetailsRecuInfoFraisDefault.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get transactionDetailsRecuInfoFraisDefault;

  /// No description provided for @transactionDetailsRecuInfoPayeLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment to'**
  String get transactionDetailsRecuInfoPayeLabel;

  /// No description provided for @transactionDetailsRecuInfoPayeurLabel.
  ///
  /// In en, this message translates to:
  /// **'Received from'**
  String get transactionDetailsRecuInfoPayeurLabel;

  /// No description provided for @transactionDetailsRecuInfoClientAlias.
  ///
  /// In en, this message translates to:
  /// **'Alias'**
  String get transactionDetailsRecuInfoClientAlias;

  /// No description provided for @transactionDetailsRecuInfoPayeurID.
  ///
  /// In en, this message translates to:
  /// **'Adresser ID'**
  String get transactionDetailsRecuInfoPayeurID;

  /// No description provided for @transactionDetailsRecuInfoPayeID.
  ///
  /// In en, this message translates to:
  /// **'Grantee ID'**
  String get transactionDetailsRecuInfoPayeID;

  /// No description provided for @transactionDetailsRecuInfoClientCompte.
  ///
  /// In en, this message translates to:
  /// **'Compte Number'**
  String get transactionDetailsRecuInfoClientCompte;

  /// No description provided for @transactionDetailsRecuInfoClientInstitution.
  ///
  /// In en, this message translates to:
  /// **'Institution'**
  String get transactionDetailsRecuInfoClientInstitution;

  /// No description provided for @transactionDetailsRecuInfoDateReception.
  ///
  /// In en, this message translates to:
  /// **'Reception date'**
  String get transactionDetailsRecuInfoDateReception;

  /// No description provided for @transactionDetailsRecuInfoDateEnvoi.
  ///
  /// In en, this message translates to:
  /// **'Send date'**
  String get transactionDetailsRecuInfoDateEnvoi;

  /// No description provided for @transactionDetailsRecuInfoMontant.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get transactionDetailsRecuInfoMontant;

  /// No description provided for @transactionDetailsTicketSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save the transaction receipt'**
  String get transactionDetailsTicketSaveTitle;

  /// No description provided for @transactionDetailsTicketSaveGallery.
  ///
  /// In en, this message translates to:
  /// **'Open the gallery'**
  String get transactionDetailsTicketSaveGallery;

  /// No description provided for @transactionSplitTitle.
  ///
  /// In en, this message translates to:
  /// **'Split with'**
  String get transactionSplitTitle;

  /// No description provided for @transactionSplitRepartitionTitle.
  ///
  /// In en, this message translates to:
  /// **'Split payment'**
  String get transactionSplitRepartitionTitle;

  /// No description provided for @transactionSplitRepartitionSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Selected payment'**
  String get transactionSplitRepartitionSubtitle1;

  /// No description provided for @transactionSplitRepartitionSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Split between - {nombre}'**
  String transactionSplitRepartitionSubtitle2(int nombre);

  /// No description provided for @transactionSplitRepartitionParMontant.
  ///
  /// In en, this message translates to:
  /// **'By amount'**
  String get transactionSplitRepartitionParMontant;

  /// No description provided for @transactionSplitRepartitionSelf.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get transactionSplitRepartitionSelf;

  /// No description provided for @transactionSplitRepartitionPartRegle.
  ///
  /// In en, this message translates to:
  /// **'Part paid'**
  String get transactionSplitRepartitionPartRegle;

  /// No description provided for @transactionSplitRepartitionPartDoit.
  ///
  /// In en, this message translates to:
  /// **'Own you'**
  String get transactionSplitRepartitionPartDoit;

  /// No description provided for @transactionSplitRepartitionSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Payment requests sent'**
  String get transactionSplitRepartitionSuccessMessage;

  /// No description provided for @transactionErrorSoldeInsuffisant.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance'**
  String get transactionErrorSoldeInsuffisant;

  /// No description provided for @transactionErrorDejaRetourne.
  ///
  /// In en, this message translates to:
  /// **'Transaction has already been returned'**
  String get transactionErrorDejaRetourne;

  /// No description provided for @transactionErrorDelaiDepasse.
  ///
  /// In en, this message translates to:
  /// **'Deadline has passed'**
  String get transactionErrorDelaiDepasse;

  /// No description provided for @transactionErrorDestinataireIndisponible.
  ///
  /// In en, this message translates to:
  /// **'Institution of the recipient temporarily unavailable'**
  String get transactionErrorDestinataireIndisponible;

  /// No description provided for @transactionErrorUnknow.
  ///
  /// In en, this message translates to:
  /// **'Your request cannot be processed at the moment. \nPlease try again later.'**
  String get transactionErrorUnknow;

  /// No description provided for @transactionSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionSearchTitle;

  /// No description provided for @transactionSearchEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Aucune transaction ne correspond à votre recherche'**
  String get transactionSearchEmptySubtitle;

  /// No description provided for @transactionSearchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No result'**
  String get transactionSearchEmptyTitle;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get loadMore;

  /// No description provided for @transactionSearchInputSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get transactionSearchInputSearchHint;

  /// No description provided for @transactionSearchInputFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get transactionSearchInputFilterTitle;

  /// No description provided for @transactionSearchInputFilterDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get transactionSearchInputFilterDateTitle;

  /// No description provided for @transactionSearchInputFilterDateSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Select the dates'**
  String get transactionSearchInputFilterDateSubTitle;

  /// No description provided for @transactionSearchInputFilterDateRange.
  ///
  /// In en, this message translates to:
  /// **'Dates From {debut} - To {fin}'**
  String transactionSearchInputFilterDateRange(String debut, String fin);

  /// No description provided for @transactionSearchInputFilterDateSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select the date range'**
  String get transactionSearchInputFilterDateSelectTitle;

  /// No description provided for @transactionSearchInputFilterCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get transactionSearchInputFilterCategoriesTitle;

  /// No description provided for @transactionSearchInputFilterCategoriesSensRecus.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get transactionSearchInputFilterCategoriesSensRecus;

  /// No description provided for @transactionSearchInputFilterCategoriesSensPayes.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get transactionSearchInputFilterCategoriesSensPayes;

  /// No description provided for @transactionSearchInputFilterBtnAppliquer.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get transactionSearchInputFilterBtnAppliquer;

  /// No description provided for @qrcodePageBtnScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get qrcodePageBtnScan;

  /// No description provided for @qrcodePageBtnMonCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrcodePageBtnMonCode;

  /// No description provided for @qrcodePagePartageTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your contact'**
  String get qrcodePagePartageTitle;

  /// No description provided for @qrcodePagePartageQrCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Share the qr code'**
  String get qrcodePagePartageQrCodeTitle;

  /// No description provided for @qrcodePagePartageQrCodeSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Share as picture'**
  String get qrcodePagePartageQrCodeSubTitle;

  /// No description provided for @qrcodePagePartageAliasTitle.
  ///
  /// In en, this message translates to:
  /// **'Share the alias'**
  String get qrcodePagePartageAliasTitle;

  /// No description provided for @qrcodePagePartageAliasSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Copy alias to clipboard'**
  String get qrcodePagePartageAliasSubTitle;

  /// No description provided for @qrcodeScanPageMessage.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at the QR code.\nScanning will be automatic'**
  String get qrcodeScanPageMessage;

  /// No description provided for @qrcodeEncodeErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'Error displaying your QR Code!'**
  String get qrcodeEncodeErrorMsg;

  /// No description provided for @qrcodeDecodeErrorNotQrImage.
  ///
  /// In en, this message translates to:
  /// **'QR Code image invalid'**
  String get qrcodeDecodeErrorNotQrImage;

  /// No description provided for @qrcodeDecodeErrorInvalideAlias.
  ///
  /// In en, this message translates to:
  /// **'Alias in the QR Code is invalid'**
  String get qrcodeDecodeErrorInvalideAlias;

  /// No description provided for @qrcodeDecodeErrorInvalideFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR Code format'**
  String get qrcodeDecodeErrorInvalideFormat;

  /// No description provided for @popupSelectDateBtnValider.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get popupSelectDateBtnValider;

  /// No description provided for @profilePageBtnInviter.
  ///
  /// In en, this message translates to:
  /// **'Invite friends'**
  String get profilePageBtnInviter;

  /// No description provided for @profilePageMenuCompteTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profilePageMenuCompteTitle;

  /// No description provided for @profilePageMenuSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security & privacy'**
  String get profilePageMenuSecurityTitle;

  /// No description provided for @profilePageMenuParametreTitle.
  ///
  /// In en, this message translates to:
  /// **'App settings'**
  String get profilePageMenuParametreTitle;

  /// No description provided for @profilePageMenuHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get profilePageMenuHelpTitle;

  /// No description provided for @profilePageMenuAproposTitle.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get profilePageMenuAproposTitle;

  /// No description provided for @profilePageBtnDeconnexion.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profilePageBtnDeconnexion;

  /// No description provided for @profilePageAppVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get profilePageAppVersion;

  /// No description provided for @profileSecuritePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Security & Privacy'**
  String get profileSecuritePageTitle;

  /// No description provided for @profileSecuriteMenuSecuriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get profileSecuriteMenuSecuriteTitle;

  /// No description provided for @profileSecuriteMenuItemPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Passcode'**
  String get profileSecuriteMenuItemPinTitle;

  /// No description provided for @profileSecuriteMenuItemTrustedTitle.
  ///
  /// In en, this message translates to:
  /// **'Trusted Parties'**
  String get profileSecuriteMenuItemTrustedTitle;

  /// No description provided for @profileSecuriteMenuItemBlacklistTitle.
  ///
  /// In en, this message translates to:
  /// **'Blacklisted Parties'**
  String get profileSecuriteMenuItemBlacklistTitle;

  /// No description provided for @profileSecuriteMenuItemAppareilsTitle.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get profileSecuriteMenuItemAppareilsTitle;

  /// No description provided for @profileSecuriteMenuItemBiometryTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Biometrics'**
  String get profileSecuriteMenuItemBiometryTitle;

  /// No description provided for @profileSecuriteMenuItemMontantTitle.
  ///
  /// In en, this message translates to:
  /// **'Hide Balances'**
  String get profileSecuriteMenuItemMontantTitle;

  /// No description provided for @profileSecuriteMenuItemMontantSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Flip your device screen down to quickly hide and show balances. You can change it in the app settings later.'**
  String get profileSecuriteMenuItemMontantSubTitle;

  /// No description provided for @profileSecuriteMenuConfidentialiteTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get profileSecuriteMenuConfidentialiteTitle;

  /// No description provided for @profileSecuriteMenuItemShakeToPayTitle.
  ///
  /// In en, this message translates to:
  /// **'Make Me Discoverable'**
  String get profileSecuriteMenuItemShakeToPayTitle;

  /// No description provided for @profileSecuriteMenuItemShakeToPaySubTitle.
  ///
  /// In en, this message translates to:
  /// **'When I shake the phone'**
  String get profileSecuriteMenuItemShakeToPaySubTitle;

  /// No description provided for @profileSecuriteMontantPopupTitle.
  ///
  /// In en, this message translates to:
  /// **'Hide Balances'**
  String get profileSecuriteMontantPopupTitle;

  /// No description provided for @profileSecuriteMontantPopupSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Flip your device screen down to quickly hide and show balances.'**
  String get profileSecuriteMontantPopupSubTitle;

  /// No description provided for @comptePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get comptePageTitle;

  /// No description provided for @comptePageListeInfosTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal details'**
  String get comptePageListeInfosTitle;

  /// No description provided for @comptePageListeDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account details'**
  String get comptePageListeDetailsTitle;

  /// No description provided for @comptePageBtnFermer.
  ///
  /// In en, this message translates to:
  /// **'Close account'**
  String get comptePageBtnFermer;

  /// No description provided for @comptePersonnelPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal details'**
  String get comptePersonnelPageTitle;

  /// No description provided for @comptePersonnelPageListeNomTitle.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get comptePersonnelPageListeNomTitle;

  /// No description provided for @comptePersonnelPageListeTelephoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get comptePersonnelPageListeTelephoneTitle;

  /// No description provided for @comptePersonnelPageListePaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Country of residence'**
  String get comptePersonnelPageListePaysTitle;

  /// No description provided for @comptePersonnelPageListeAdresseTitle.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get comptePersonnelPageListeAdresseTitle;

  /// No description provided for @compteDetailsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Account details'**
  String get compteDetailsPageTitle;

  /// No description provided for @compteDetailsPageListeTypeComTitle.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary'**
  String get compteDetailsPageListeTypeComTitle;

  /// No description provided for @compteDetailsPageListeNumCompTitle.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get compteDetailsPageListeNumCompTitle;

  /// No description provided for @compteDetailsPageListeAliasTitle.
  ///
  /// In en, this message translates to:
  /// **'Alias'**
  String get compteDetailsPageListeAliasTitle;

  /// No description provided for @compteDetailsPageBtnSupprimer.
  ///
  /// In en, this message translates to:
  /// **'Delete my alias'**
  String get compteDetailsPageBtnSupprimer;

  /// No description provided for @compteDetailsPagePopupDeleteAliasTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your alias?'**
  String get compteDetailsPagePopupDeleteAliasTitle;

  /// No description provided for @compteDetailsPagePopupDeleteAliasSubTitle.
  ///
  /// In en, this message translates to:
  /// **'If you confirm the deletion of your alias, this action will be irreversible. Your alias will be completely removed from our system, and other users will no longer be able to make payments to you or find you using this alias.\nPlease note that you will also lose all associated data with the alias, including payment history and related information records.'**
  String get compteDetailsPagePopupDeleteAliasSubTitle;

  /// No description provided for @compteDetailsPagePopupDeleteAliasBtnConfirmer.
  ///
  /// In en, this message translates to:
  /// **'Delete Alias'**
  String get compteDetailsPagePopupDeleteAliasBtnConfirmer;

  /// No description provided for @compteDetailsPagePopupDeleteAliasBtnAnnuler.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get compteDetailsPagePopupDeleteAliasBtnAnnuler;

  /// No description provided for @compteDetailsPagePopupDeleteAliasErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'Deleting your alias failed. Please try again later.'**
  String get compteDetailsPagePopupDeleteAliasErrorMsg;

  /// No description provided for @appSettingPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Application settings'**
  String get appSettingPageTitle;

  /// No description provided for @appSettingPageMenuLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get appSettingPageMenuLanguageTitle;

  /// No description provided for @appSettingPageMenuLanguageFr.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get appSettingPageMenuLanguageFr;

  /// No description provided for @appSettingPageMenuLanguageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get appSettingPageMenuLanguageEn;

  /// No description provided for @appSettingPageMenuLanguagePt.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get appSettingPageMenuLanguagePt;

  /// No description provided for @appSettingPageMenuLanguageSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'We use the same language set for your device. but you can set specific for using the application'**
  String get appSettingPageMenuLanguageSelectTitle;

  /// No description provided for @appSettingPageMenuThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get appSettingPageMenuThemeTitle;

  /// No description provided for @appSettingPageMenuThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appSettingPageMenuThemeDark;

  /// No description provided for @appSettingPageMenuThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get appSettingPageMenuThemeLight;

  /// No description provided for @appSettingPageMenuThemeYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get appSettingPageMenuThemeYellow;

  /// No description provided for @appSettingPageMenuThemeGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get appSettingPageMenuThemeGreen;

  /// No description provided for @appSettingPageMenuThemeBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get appSettingPageMenuThemeBlue;

  /// No description provided for @appSettingPageMenuThemeDefault.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get appSettingPageMenuThemeDefault;

  /// No description provided for @appSettingPageMenuThemePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Apparence'**
  String get appSettingPageMenuThemePageTitle;

  /// No description provided for @appSettingPageMenuQrCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'My QR code by default'**
  String get appSettingPageMenuQrCodeTitle;

  /// No description provided for @appSettingPageMenuQrCodeSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable to display your QR Code by default'**
  String get appSettingPageMenuQrCodeSelectTitle;

  /// No description provided for @appSettingPageMenuQrCodeDeselectTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable to display the camera by default'**
  String get appSettingPageMenuQrCodeDeselectTitle;

  /// No description provided for @appSettingPageMenuNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'In App Notifications'**
  String get appSettingPageMenuNotificationTitle;

  /// No description provided for @appSettingPageMenuNotificationStyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Alert Style'**
  String get appSettingPageMenuNotificationStyleTitle;

  /// No description provided for @appSettingPageMenuNotificationStyleSnackBar.
  ///
  /// In en, this message translates to:
  /// **'Banners'**
  String get appSettingPageMenuNotificationStyleSnackBar;

  /// No description provided for @appSettingPageMenuNotificationStyleDialog.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get appSettingPageMenuNotificationStyleDialog;

  /// No description provided for @appSettingPageMenuNotificationStyleDialogDesc.
  ///
  /// In en, this message translates to:
  /// **'Alerts require an action before continuing. Banners appear at the top of the screen and disappear automatically'**
  String get appSettingPageMenuNotificationStyleDialogDesc;

  /// No description provided for @appSettingPageMenuNotificationStyleNone.
  ///
  /// In en, this message translates to:
  /// **'Aucun'**
  String get appSettingPageMenuNotificationStyleNone;

  /// No description provided for @appSettingPageMenuNotificationSonTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get appSettingPageMenuNotificationSonTitle;

  /// No description provided for @appSettingPageMenuNotificationSonPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound Notification'**
  String get appSettingPageMenuNotificationSonPageTitle;

  /// No description provided for @appSettingPageMenuNotificationSonDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get appSettingPageMenuNotificationSonDefault;

  /// No description provided for @appSettingPageMenuNotificationVibrTitle.
  ///
  /// In en, this message translates to:
  /// **'Vibrations'**
  String get appSettingPageMenuNotificationVibrTitle;

  /// No description provided for @appSettingPageMenuNotificationVibrSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vibrations for notifications'**
  String get appSettingPageMenuNotificationVibrSubtitle;

  /// No description provided for @categorieDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Default categories'**
  String get categorieDefaultTitle;

  /// No description provided for @categorieCustomTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom categories'**
  String get categorieCustomTitle;

  /// No description provided for @categorieCustomAdd.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get categorieCustomAdd;

  /// No description provided for @categorieCustomEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get categorieCustomEdit;

  /// No description provided for @categorieFormNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name your category'**
  String get categorieFormNameLabel;

  /// No description provided for @categorieFormCreateBtn.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get categorieFormCreateBtn;

  /// No description provided for @categorieFormNameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Name too long, don\'t exceed 25 chars'**
  String get categorieFormNameInvalid;

  /// No description provided for @categorieFormNameAlready.
  ///
  /// In en, this message translates to:
  /// **'Category already exist'**
  String get categorieFormNameAlready;

  /// No description provided for @categorieEditBtn.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get categorieEditBtn;

  /// No description provided for @categorieFormSaveBtn.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get categorieFormSaveBtn;

  /// No description provided for @categorieFormIconSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set cover image'**
  String get categorieFormIconSheetTitle;

  /// No description provided for @categorieFormIconSheetEmojiTitle.
  ///
  /// In en, this message translates to:
  /// **'Use Emoji'**
  String get categorieFormIconSheetEmojiTitle;

  /// No description provided for @categorieFormIconSheetGalleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Select from your gallery'**
  String get categorieFormIconSheetGalleryTitle;

  /// No description provided for @categorieFormIconSheetPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get categorieFormIconSheetPhotoTitle;

  /// No description provided for @notificationPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationPageTitle;

  /// No description provided for @notificationPageListeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'You’re all caught up'**
  String get notificationPageListeEmptyTitle;

  /// No description provided for @notificationPageListeEmptySubTitle.
  ///
  /// In en, this message translates to:
  /// **'Check back later for informations and recommendations to keep your account up to date'**
  String get notificationPageListeEmptySubTitle;

  /// No description provided for @notificationPageClaimTitle.
  ///
  /// In en, this message translates to:
  /// **'Alias claim'**
  String get notificationPageClaimTitle;

  /// No description provided for @notificationPageClaimSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You have received a claim on your alias {alias}'**
  String notificationPageClaimSubtitle(String alias);

  /// No description provided for @notificationPageAnnulationRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancellation'**
  String get notificationPageAnnulationRequestTitle;

  /// No description provided for @notificationPageAnnulationRequestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Requested by {payeur}'**
  String notificationPageAnnulationRequestSubtitle(String payeur);

  /// No description provided for @notificationPageRtpInitieeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Requested from {payeur}'**
  String notificationPageRtpInitieeSubtitle(String payeur);

  /// No description provided for @notificationPageRtpRecueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Requested by {payeur}'**
  String notificationPageRtpRecueSubtitle(String payeur);

  /// No description provided for @ignore.
  ///
  /// In en, this message translates to:
  /// **'Ignore'**
  String get ignore;

  /// No description provided for @externalCustomer.
  ///
  /// In en, this message translates to:
  /// **'External customer'**
  String get externalCustomer;

  /// No description provided for @coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon ...'**
  String get coming_soon;

  /// No description provided for @alias_copied.
  ///
  /// In en, this message translates to:
  /// **'Alias copied !'**
  String get alias_copied;

  /// No description provided for @bottom_bar_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get bottom_bar_home;

  /// No description provided for @bottom_bar_transaction.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get bottom_bar_transaction;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
