/// Définit les paramètres de configurations de l'application
enum ConfigKey {
  //
  all("ALL"), // keyword to say all config params

  // l'utilisateur a passé l'introduction
  introductionPassed("INTRODUCTION_PASSED"),

  // l'utilisateur a passé l'introduction
  piQrcode("PI_QRCODE"),

  // theme de l'utilisateur
  preferedTheme("PREFERED_THEME"),
  // Langue préférée
  preferedLanguage("PREFERED_LANGUAGE"),

  // Permission notification
  permissionNotification("PERMISSION_NOTIFICATION"),
  // Permission contact autorisée ou pas
  permissionContact("PERMISSION_CONTACT"),

  // Permet de controller l'affichage du montant
  displayAmount("DISPLAY_AMOUNT"),
  // Permet d'afficher l'oeil et d'ecouter sur le basculement du telephone
  hideEye("HIDE_EYE"),

  // Permet d'afficher le qr code par défaut
  showQRcode("SHOW_QRCODE"),

  // Notifications dans l'application
  notificationStatus("NOTIFICATION_STATUS"),
  notificationStyle("NOTIFICATION_STYLE"),
  notificationAlertSound("NOTIFICATION_ALERT_SOUND"),
  notificationAlertVibration("NOTIFICATION_ALERT_VIBRATION"),
  notificationAlertTransfer("NOTIFICATION_ALERT_TRANSFER"),

  // Nombre d'élements affichés sur la liste des dernières transactions
  transactionsRecentNbItems("TRANSACTIONS_RECENTS_NB");

  // Codification du paramètre
  final String code;

  const ConfigKey(this.code);
}
