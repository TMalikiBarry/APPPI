/// it is a good practice to keep all the Image assets in a single dart file.
/// This makes debugging a lot easier and faster.
/// Advantages of using this way -
/// - Any error is caught by the IDE and is easy to fix.
/// - Debugging becomes a breeze since all the Images are in one file and
///  fixing any spelling mistakes or changing any Image variable is very easy.
/// - Bugfixes require a single commit as all the Images are available
/// in a single file, thus reducing the chances of merge conflicts.
class Images {
  //
  /// private constructor which prevents the class from being instantiated.
  Images._();

  /// Logo Spi Dark
  static const String logo = 'assets/images/logo.png';
  static const String logoDark = 'assets/images/spi-150.png';
  static const String logoSpiLight = 'assets/images/logo_spi_light.png';
  static const String logoSpiDark = 'assets/images/logo_spi_dark.png';

  /// Chemin vers les vidéos d'introduction
  static const String introductionVideo1 = 'assets/videos/onboarding_fr_1.mp4';
  static const String introductionVideo2 = 'assets/videos/onboarding_fr_2.mp4';
  static const String introductionVideo3 = 'assets/videos/onboarding_fr_3.mp4';
  static const String introductionVideo4 = 'assets/videos/onboarding_fr_4.mp4';
  static const String introductionVideo5 = 'assets/videos/onboarding_fr_5.mp4';
  static const String introductionVideo6 = 'assets/videos/onboarding_fr_6.mp4';

  /// Chemin vers les vidéos d'introduction en anglais
  static const String introductionVideo1En =
      'assets/videos/onboarding_en_1.mp4';
  static const String introductionVideo2En =
      'assets/videos/onboarding_en_2.mp4';
  static const String introductionVideo3En =
      'assets/videos/onboarding_en_3.mp4';
  static const String introductionVideo4En =
      'assets/videos/onboarding_en_4.mp4';
  static const String introductionVideo5En =
      'assets/videos/onboarding_en_5.mp4';
  static const String introductionVideo6En =
      'assets/videos/onboarding_en_6.mp4';

  /// Keyboard icons
  static const String virtualKeyboardIconsFace = 'assets/icons/face.png';
  // face.png utilisé aussi pour Autoriser Biométrie

  /// Permissions application
  static const Map<String, String> identificationPermissions = {
    'fingerprint': 'assets/images/permission_fingerprint.png',
    'face': 'assets/images/permission_face.png',
    'all': 'assets/images/permission_fingerprint.png',
  };
  static const String permissionNotification =
      'assets/images/permission_notification.png';
  static const String permissionContact =
      'assets/images/permission_contact.png';

  /// Alias
  static const String aliasIconUser = 'assets/icons/user.png';
  static const String aliasIconPhone = 'assets/icons/phone.png';
  static const String iconBf = 'assets/icons/bf.png';
  static const String iconBj = 'assets/icons/bj.png';
  static const String iconCi = 'assets/icons/ci.png';
  static const String iconGw = 'assets/icons/gw.png';
  static const String iconMa = 'assets/icons/ma.png';
  static const String iconNe = 'assets/icons/ne.png';
  static const String iconSn = 'assets/icons/sn.png';
  static const String iconTg = 'assets/icons/tg.png';
  static const String aliasIcon = 'assets/icons/arobase_alias.png';

  /// Loading - Validation
  static const String gifDone = 'assets/gif/done.gif';
  static const String gifError = 'assets/gif/error.gif';
  static const String gifLogoLoading = 'assets/gif/logo.gif';

  /// Loading - Validation - Customer
  static const String alert = 'assets/images/error_icon.png';
  static const String error = 'assets/images/error_icon.png';
  static const String info = 'assets/images/error_icon.png';
  static const String success = 'assets/images/success_icon.png';

  // Home page
  static const String iconAnalytique = 'assets/icons/analytique.png';
  static const String arrowUp = 'assets/icons/arrow_up.png';
  static const String arrowDown = 'assets/icons/arrow_down.png';
  static const String homeFooterHome = 'assets/icons/home_outline.svg';
  static const String homeFooterHome2 = 'assets/icons/home-22.svg';
  static const String homeFooterQrcode = 'assets/icons/qrcode.png';
  static const String homeFooterTransfer = 'assets/icons/transfer.png';
  static const String iconEdit = 'assets/icons/edit.png';
  static const String iconDelete = 'assets/icons/delete.png';

  static const String iconSearchHeaderHP = 'assets/images/figma_hp_search-normal.png';
  static const String iconNotificationHeaderHP = 'assets/images/figma_hp_notification_0.png';
  static const String iconDefaultUserHeaderHP = 'assets/images/figma_hp_default_user.png';
  static const String iconMoneyReceiveHeaderHP = 'assets/images/figma_hp_money_receive.png';
  static const String iconMoneySendHeaderHP = 'assets/images/figma_hp_money_send.png';
  static const String iconMoreActionHeaderHP = 'assets/images/figma_hp_more_actions.png';
  static const String iconMoneySendHeaderHPHomePage = 'assets/images/envoi_pi.png';
  static const String iconMoneyReceiveHeaderHPHomePage = 'assets/images/recevoir_pi.png';
  static const String iconMoreActionHeaderHPHomePage = 'assets/images/plus_pi.png';

  // Home page - More menu
  static const String homeMoreFindSubscription =
      'assets/icons/find_subscription.png';
  static const String homeMoreSplitPayments = 'assets/icons/split_payments.png';
  static const String homeMoreSavingBox = 'assets/icons/saving_box.png';
  static const String homeMoreSetBudgets = 'assets/icons/set_budgets.png';
  static const String homeMoreAddWidget = 'assets/icons/add_widget.png';

  // Profile page
  static const String iconsAddUser = 'assets/icons/user_add.png';
  // user_circle.png est utilisé aussi pour personnes de confiance
  // dans Sécurité et confidentialité
  static const String iconsCircleUser = 'assets/icons/user_circle.png';
  static const String iconsHelp = 'assets/icons/help.png';
  static const String iconsInfo = 'assets/icons/info.png';
  static const String iconsSecurity = 'assets/icons/security.png';
  static const String iconsSetting = 'assets/icons/setting.png';
  static const String iconsLogout = 'assets/icons/logout.png';
  static const String iconsDetailsCompte = 'assets/icons/compte.png';

  // Profile Securité et confidentialité page
  static const String iconsLock = 'assets/icons/lock.png';
  static const String iconsBlacklist = 'assets/icons/user_delete.png';
  static const String iconsAppareils = 'assets/icons/mobile.png';
  static const String iconsBiometry = 'assets/icons/user.png';
  static const String iconsEyeOff = 'assets/icons/eye_off.png';
  static const String iconsMobileShake = 'assets/icons/mobile_shake.png';

  static const String imagesEyeOffIllustration =
      'assets/images/illustration_hide_amount.png';

  // Transactions
  static const String transactionAvatar = 'assets/images/avatar.png';
  static const String iconTransactionSendByAlias = 'assets/icons/alias.png';
  static const String iconTransactionSendByIban = 'assets/icons/bank.png';
  static const String iconTransactionSendByOthr =
      'assets/icons/other_account.png';
  static const String iconTransactionSendByNewContact =
      'assets/icons/person.png';
  static const String iconsPiBadge = 'assets/icons/pi_badge.png';
  static const String ticketCaisse = 'assets/images/ticket_caisse.png';

  // Transactions Forms
  static const String iconTransactionPasteAlias =
      'assets/icons/paste-alias.png';

  // Transaction Details
  static const String transactionPartager = 'assets/icons/partager.png';
  static const String transactionPlanifier = 'assets/icons/planifier.png';
  static const String transactionCancel = 'assets/icons/x-mark.png';

  // QR Code
  static const String iconsPiOctogone = 'assets/icons/pi_octogone.png';
  static const String iconsPiOctogone2 = 'assets/icons/pi_octogone2.png';
  // TODO change image
  static const String iconFlashOn = 'assets/icons/flash.png';
  static const String IconFlashOff = 'assets/icons/flash.png';
  static const String iconsGalerie = 'assets/icons/galerie.png';

  // Categorie
  static const String categorie = 'assets/icons/categories/categorie.png';
  static const String categorieImageSelect =
      'assets/icons/categories/categorie-edit-image.png';
  static const String iconsFacture = 'assets/icons/categories/facture.png';
  static const String iconsCash = 'assets/icons/categories/cash.png';
  static const String iconsRestaurant =
      'assets/icons/categories/restaurant.png';
  static const String iconsShopping = 'assets/icons/categories/shopping.png';
  static const String iconsLoisir = 'assets/icons/categories/loisir.png';
  static const String iconsAlimentation =
      'assets/icons/categories/alimentation.png';
  static const String iconsSante = 'assets/icons/categories/sante.png';
  static const String iconsLogement = 'assets/icons/categories/logement.png';
  static const String iconsTransfert = 'assets/icons/categories/transfert.png';
  static const String iconsTransaction =
      'assets/icons/categories/transaction.png';
  static const String iconsSoinspersonnel = 'assets/icons/categories/soins.png';
  static const String iconsBudget = 'assets/icons/categories/budget.png';
  static const String iconsEconomie = 'assets/icons/categories/economie.png';
  static const String iconsTransport = 'assets/icons/categories/transport.png';
  static const String iconsVoyage = 'assets/icons/categories/voyage.png';
  static const String iconsDepensereligieuse =
      'assets/icons/categories/depensereligieuse.png';
  static const String iconsDon = 'assets/icons/categories/don.png';
  static const String iconsEducation = 'assets/icons/categories/education.png';
  static const String iconsAutre = 'assets/icons/categories/autre.png';

  static const String iconsCafe = 'assets/icons/categories/cafe.png';
  static const String iconsSport = 'assets/icons/categories/running.png';
  static const String iconsCadeau = 'assets/icons/categories/gift.png';
  static const String iconsBeaute = 'assets/icons/categories/beaute.png';
  static const String iconsBoissons = 'assets/icons/categories/boissons.png';
  static const String iconsDonation = 'assets/icons/categories/donation.png';
  static const String categorieIconEmoji = 'assets/icons/categories/emoji.png';
  static const String categorieIconImage = 'assets/icons/categories/image.png';
  static const String categorieIconPhoto = 'assets/icons/categories/photo.png';

  // Notification
  static const String notificationCloche =
      "assets/images/notification_cloche.png";
  static const String notificationAliasClaim = 'assets/icons/arobase_alias.png';
  static const String notificationAnnulation =
      'assets/icons/demande-annulation.png';

  // Subscription
  static const String subscriptionCalendar = "assets/images/subscription.png";
  static const String iconRepeat = 'assets/icons/repeat.png';

  // Profile Paramètres de l’application page
  static const String iconsLanguage = 'assets/icons/language.png';
  static const String iconsLanguageFr = 'assets/icons/language_fr.png';
  static const String iconsLanguageEn = 'assets/icons/language_en.png';
  static const String iconsLanguagePt = 'assets/icons/language_pt.png';
  static const String iconsTheme = 'assets/icons/theme.png';
  static const String iconsCloche = 'assets/icons/cloche.png';
  static const String imageNotifStyleDialog =
      'assets/images/notif_style_dialog.png';
  static const String imageNotifStyleNone =
      'assets/images/notif_style_none.png';
  static const String imageNotifStyleSnackbar =
      'assets/images/notif_style_snackbar.png';

  static const String imageThemeSystem = 'assets/images/theme_system.png';
  static const String imageThemeLight = 'assets/images/theme_light.png';
  static const String imageThemeLightBlue =
      'assets/images/theme_light_blue.png';
  static const String imageThemeLightGreen =
      'assets/images/theme_light_green.png';
  static const String imageThemeLightYellow =
      'assets/images/theme_light_yellow.png';
  static const String imageThemeDark = 'assets/images/theme_dark.png';
}
