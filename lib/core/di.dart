import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pi_mobile_app/modules/subscription/domain/services/subscription_service.dart';
import 'package:pi_mobile_app/modules/subscription/infra/subscription_output_repository.dart';
import 'package:pi_mobile_app/modules/subscription/ports/input/subscription_input_port.dart';
import 'package:pi_mobile_app/modules/subscription/ports/output/subscription_output_port.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/alias/domain/services/alias_service.dart';
import '../modules/alias/infra/alias_output_repository.dart';
import '../modules/alias/ports/input/alias_input_port.dart';
import '../modules/alias/ports/output/alias_output_port.dart';
import '../modules/categorie/domain/services/categorie_service.dart';
import '../modules/categorie/infra/categorie_output_repository.dart';
import '../modules/categorie/ports/input/categorie_input_port.dart';
import '../modules/categorie/ports/output/categorie_output_port.dart';
import '../modules/compte/domain/services/compte_service.dart';
import '../modules/compte/infra/compte_output_repository.dart';
import '../modules/compte/ports/input/compte_input_port.dart';
import '../modules/compte/ports/output/compte_output_port.dart';
import '../modules/config/adapters/infra/config_output_prefs.dart';
import '../modules/config/domain/services/config_service.dart';
import '../modules/config/ports/input/config_input_port.dart';
import '../modules/notification/domain/services/notification_service.dart';
import '../modules/notification/infra/notification_output_repository.dart';
import '../modules/notification/ports/input/notification_input_port.dart';
import '../modules/notification/ports/output/notification_output_port.dart';
import '../modules/qrcode/domain/services/qrcode_service.dart';
import '../modules/qrcode/ports/input/qrcode_input_port.dart';
import '../modules/security/domain/services/connexion_service.dart';
import '../modules/security/domain/services/identification_service.dart';
import '../modules/security/domain/services/permission_service.dart';
import '../modules/security/infra/connexion_output_authpkce.dart';
import '../modules/security/infra/connexion_output_remote.dart';
import '../modules/security/infra/identification_biometric_output_local.dart';
import '../modules/security/infra/indentification_pin_output_local.dart';
import '../modules/security/infra/permissions_output_local.dart';
import '../modules/security/ports/input/connexion_input_port.dart';
import '../modules/security/ports/input/identification_input_port.dart';
import '../modules/security/ports/input/permission_input_port.dart';
import '../modules/security/ports/output/connexion_output_port.dart';
import '../modules/security/ports/output/identification_biometric_output_port.dart';
import '../modules/security/ports/output/indentification_pin_output_port.dart';
import '../modules/security/ports/output/permission_output_port.dart';
import '../modules/transactions/domain/services/participant_service.dart';
import '../modules/transactions/domain/services/transaction_service.dart';
import '../modules/transactions/infra/participant_output_repository.dart';
import '../modules/transactions/infra/transaction_output_repository.dart';
import '../modules/transactions/ports/input/participant_input_port.dart';
import '../modules/transactions/ports/input/transaction_input_port.dart';
import '../modules/transactions/ports/output/participant_output_port.dart';
import '../modules/transactions/ports/output/transaction_output_port.dart';
import 'env.dart';

/// For dependency injection of input and output port implementations
class Di {
  //
  static late SharedPreferences sharedPreferences;
  static late FlutterSecureStorage secureStorage;

  /// Configuration - paramètres - préférences utilisateur
  static ConfigInputPort? pConfigInputPort;

  /// gestion  de la connexion / déconnexion de l'utilisateur
  static ConnexionInputPort? pConnexionInputPort;

  /// Initialise le système de gestion de l'identification utilisateur
  static IdentificationInputPort? pIdentificationInputPort;

  /// Initialise le système de gestion des permissions
  static PermissionInputPort? pPermissionInputPort;

  /// Gestion du compte
  static CompteInputPort? pCompteInputPort;

  /// Alias
  static AliasInputPort? pAliasInputPort;

  /// Gestion des PSPs
  static ParticipantInputPort? pParticipantInputPort;

  /// Gestion des categories
  static CategorieInputPort? pCategorieInputPort;

  /// Gestion des transactions
  static TransactionInputPort? pTransactionInputPort;

  /// Gestion des subscriptions
  static SubscriptionInputPort? pSubscriptionInputPort;

  /// Gestion des QR Code
  static QrcodeInputPort? pQrcodeInputPort;

  /// Gestion des notifications
  static NotificationInputPort? pNotificationInputPort;

  /// Init
  static void init(
    SharedPreferences sharedPreferences,
    FlutterSecureStorage secureStorage,
  ) {
    print("sharedPreferences");
    print(sharedPreferences);
    Di.sharedPreferences = sharedPreferences;
    Di.secureStorage = secureStorage;
  }

  /// Retourne l'implementation de transaction Input Port
  static ConfigInputPort getConfigInputPort() {
    if (pConfigInputPort != null) {
      return pConfigInputPort!;
    } else {
      ConfigService configService =
          ConfigService(ConfigOutputPrefs(sharedPreferences));
      pConfigInputPort = configService;
      return configService;
    }
  }
  static ConfigInputPort getConfigInputPort2(sharedPreferences) {
    if (pConfigInputPort != null) {
      return pConfigInputPort!;
    } else {
      ConfigService configService =
      ConfigService(ConfigOutputPrefs(sharedPreferences));
      pConfigInputPort = configService;
      return configService;
    }
  }

   initSP() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Retourne l'implementation de ConnexionInputPort
  static ConnexionInputPort getConnexionInputPort() {
    if (pConnexionInputPort != null) {
      return pConnexionInputPort!;
    } else {
      // - En mode demo utiliser la page de connexion dans l'app (Demo Only)
      ConnexionOutputPort connexionOutputMock =
          ConnexionOutputRemote(secureStorage);
      // - Utilisation de keycloak comme infra de sécurité pour les connexions
      ConnexionOutputPort connexionOutputAuthServer =
          ConnexionOutputAuthpkce(secureStorage);
      ConnexionInputPort connexionService = ConnexionService(
          AppEnv.mode == "demo"
              ? connexionOutputMock
              : connexionOutputAuthServer);
      pConnexionInputPort = connexionService;
      return connexionService;
    }
  }

  /// Retourne l'implementation de IdentificationInputPort
  static IdentificationInputPort getIdentificationInputPort() {
    if (pIdentificationInputPort != null) {
      return pIdentificationInputPort!;
    } else {
      // - Utilisation du mode local pour l'identification par biometrie
      IdentificationBiometricOutputPort biometricOutputPort =
          IdentificationBiometricOutputLocal(secureStorage);
      // - Utilisation du mode local pour l'identification par codpine
      IdentificationPinOutputPort codePinOutputPort =
          IdentificationPinOutputLocal(secureStorage);
      // Passer au service d'identification le port d'acces
      // pour le codePin et le port d'accès pour la biométrie
      IdentificationInputPort identificationService =
          IdentificationService(biometricOutputPort, codePinOutputPort);
      pIdentificationInputPort = identificationService;
      return identificationService;
    }
  }

  /// Retourne l'implementation de permission input port
  static PermissionInputPort getPermissionInputPort() {
    if (pPermissionInputPort != null) {
      return pPermissionInputPort!;
    } else {
      PermissionOutputPort permissionOutputPort = PermissionOutputLocal();
      PermissionInputPort service = PermissionService(permissionOutputPort);
      pPermissionInputPort = service;
      return service;
    }
  }

  /// Retourne l'implementation de alias input port
  static AliasInputPort getAliasInputPort() {
    if (pAliasInputPort != null) {
      return pAliasInputPort!;
    } else {
      // Vous pouvez changer l'infra par rapport à votre système
      // de stockage des alias: AliasOutputFirestore par exemple
      AliasOutputPort outputStorage = AliasOutputRepository();
      AliasInputPort service = AliasService(outputStorage);
      pAliasInputPort = service;
      return service;
    }
  }

  /// Retourne l'implementation de compte input port
  static CompteInputPort getCompteInputPort() {
    if (pCompteInputPort != null) {
      return pCompteInputPort!;
    } else {
      CompteOutputPort compteOutputPort = CompteOutputRepository();
      CompteInputPort service = CompteService(compteOutputPort);
      pCompteInputPort = service;
      return service;
    }
  }

  /// Retourne l'implementation de participant input port
  static ParticipantInputPort getParticipantInputPort() {
    if (pParticipantInputPort != null) {
      return pParticipantInputPort!;
    } else {
      ParticipantOutputPort participantOutputPort =
          ParticipantOutputRepository();
      ParticipantInputPort service = ParticipantService(participantOutputPort);
      pParticipantInputPort = service;
      return service;
    }
  }

  /// Retourne l'implementation de categorie Input Port
  static CategorieInputPort getCategorieInputPort() {
    if (pCategorieInputPort != null) {
      return pCategorieInputPort!;
    } else {
      CategorieOutputPort pCategorieOutputPort = CategorieOutputRepository();
      CategorieInputPort service = CategorieService(pCategorieOutputPort);
      pCategorieInputPort = service;
      return service;
    }
  }

  /// Retourne l'implementation de transaction Input Port
  static TransactionInputPort getTransactionInputPort() {
    if (pTransactionInputPort != null) {
      return pTransactionInputPort!;
    } else {
      TransactionOutputPort transactionsOutputPort =
          TransactionOutputRepository();
      TransactionInputPort service = TransactionService(transactionsOutputPort);
      pTransactionInputPort = service;
      return service;
    }
  }

  /// Retourne l'implementation de subscription Input Port
  static SubscriptionInputPort getSubscriptionInputPort() {
    if (pSubscriptionInputPort != null) {
      return pSubscriptionInputPort!;
    } else {
      SubscriptionOutputPort transactionsOutputPort =
          SubscriptionOutputRepository();
      SubscriptionInputPort service =
          SubscriptionService(transactionsOutputPort);
      pSubscriptionInputPort = service;
      return service;
    }
  }

  /// Retourne l'implementation des QR Code
  static QrcodeInputPort getQrcodeInputPort() {
    if (pQrcodeInputPort != null) {
      return pQrcodeInputPort!;
    } else {
      QrcodeInputPort service = QrcodeService();
      pQrcodeInputPort = service;
      return service;
    }
  }

  /// Retourne l'implementation de notifications Input Port
  static NotificationInputPort getNotificationInputPort() {
    if (pNotificationInputPort != null) {
      return pNotificationInputPort!;
    } else {
      NotificationOutputPort notificationsOutputPort =
          NotificationOutputRepository();
      NotificationInputPort service =
          NotificationService(notificationsOutputPort);
      pNotificationInputPort = service;
      return service;
    }
  }
}
