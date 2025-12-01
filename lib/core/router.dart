import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:base_app/presenter/home.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:pi_mobile_app/modules/transactions/presentation/pages/transaction_cancel/transaction_cancel_page_transfer.dart';
import 'package:pi_mobile_app/modules/transactions/presentation/pages/transaction_split/transaction_split_page.dart';
import 'package:pi_mobile_app/modules/transactions/presentation/pages/transaction_split/transaction_split_page_repartition.dart';

import '../modules/alias/presentation/bloc/alias_bloc.dart';
import '../modules/alias/presentation/bloc/alias_event.dart';
import '../modules/alias/presentation/bloc/alias_state.dart';
import '../modules/alias/presentation/pages/alias_page.dart';
import '../modules/alias/presentation/pages/alias_page_claim.dart';
import '../modules/categorie/presentation/pages/categorie_add_page.dart';
import '../modules/categorie/presentation/pages/categorie_edit_page.dart';
import '../modules/categorie/presentation/pages/categorie_select_page.dart';
import '../modules/contacts/domain/contact_pi.dart';
import '../modules/contacts/presentation/pages/create/contact_create_page.dart';
import '../modules/home/presentation/pages/home_page_2.dart';
import '../modules/introduction/adapters/presentation/pages/introduction.dart';
import '../modules/notification/presentation/bloc/notification_bloc.dart';
import '../modules/notification/presentation/pages/notification_page.dart';
import '../modules/profile/presentation/pages/compte/profile_compte_client_page.dart';
import '../modules/profile/presentation/pages/compte/profile_compte_details_page.dart';
import '../modules/profile/presentation/pages/compte/profile_compte_page.dart';
import '../modules/profile/presentation/pages/parametre/profile_parametre_page.dart';
import '../modules/profile/presentation/pages/parametre/profile_parametre_page_notifications.dart';
import '../modules/profile/presentation/pages/parametre/profile_parametre_page_notifications_son.dart';
import '../modules/profile/presentation/pages/parametre/profile_parametre_page_theme.dart';
import '../modules/profile/presentation/pages/profile_page.dart';
import '../modules/profile/presentation/pages/securite/profile_securite_page.dart';
import '../modules/qrcode/domain/models/qrcode_data.dart';
import '../modules/qrcode/presentation/pages/qrcode_alias_page.dart';
import '../modules/qrcode/presentation/pages/qrcode_scan_page.dart';
import '../modules/security/domain/models/connected_user.dart';
import '../modules/security/presentation/bloc/login/login_bloc.dart';
import '../modules/security/presentation/pages/cgu/cgu.dart';
import '../modules/security/presentation/pages/change_password/change_password_page.dart';
import '../modules/security/presentation/pages/identification/identification_page.dart';
import '../modules/security/presentation/pages/login/login_page.dart';
import '../modules/security/presentation/pages/permissions/permissions_page.dart';
import '../modules/security/presentation/pages/poc/poc.dart';
import '../modules/subscription/domain/models/subscription.dart';
import '../modules/subscription/presentation/pages/subscription_create/subscription_create_page.dart';
import '../modules/subscription/presentation/pages/subscription_details/subscription_details_page.dart';
import '../modules/transactions/domain/models/transaction.dart';
import '../modules/transactions/domain/models/transaction_canal.dart';
import '../modules/transactions/domain/models/transaction_send/transaction_send_command.dart';
import '../modules/transactions/domain/models/transaction_send/transaction_send_command_alias.dart';
import '../modules/transactions/domain/models/transaction_send/transaction_send_command_amount.dart';
import '../modules/transactions/domain/models/transaction_send/transaction_send_method.dart';
import '../modules/transactions/presentation/bloc/transaction_search/transaction_search_bloc.dart';
import '../modules/transactions/presentation/pages/transaction_cancel/transaction_cancel_page.dart';
import '../modules/transactions/presentation/pages/transaction_details/transaction_details_notification_page.dart';
import '../modules/transactions/presentation/pages/transaction_details/transaction_details_page.dart';
import '../modules/transactions/presentation/pages/transaction_form/transaction_form_page.dart';
import '../modules/transactions/presentation/pages/transaction_form/transaction_form_page_qrcode.dart';
import '../modules/transactions/presentation/pages/transaction_form/transaction_form_page_schedule.dart';
import '../modules/transactions/presentation/pages/transaction_form/transaction_form_page_verification.dart';
import '../modules/transactions/presentation/pages/transaction_rtp/transaction_rtp_page.dart';
import '../modules/transactions/presentation/pages/transaction_search/transaction_search_page.dart';
import '../modules/transactions/presentation/pages/transaction_search/transaction_search_page_filters.dart';
import '../modules/transactions/presentation/pages/transaction_send/transaction_send_page.dart';
import 'package:pi_mobile_app/modules/notification/domain/models/notification.dart' as my_notif;
import 'package:common_dependencies/components/fireBaseApi.dart';

/// Définit la logique de routage / navigation entre les différentes pages de l'application
class AppRouter {
  //
  static final logger = Logger();

  /// Liste des routes de l'application
  static const introduction = "/introduction";

  static const homePage = "/";

  static const login = "/login";
  static const loginCgu = "/login/cgu";
  static const loginPoc = "/login/poc";
  static const loginChangePassword = "/login/change-password";

  static const identificationInitial = "/identification/initial";
  static const identificationCheck = "/identification/check";

  // Alias
  static const alias = "/alias";
  static const aliasMBNOcreate = "/alias/mbno";
  static const aliasMBNOconfirm = "/alias/mbno/confirm";
  static const aliasClaimDetails = "/alias/revendications/:id";

  // Permissions
  static const permissions = "/permissions";

  // Home
  static const home = "/home";

  // Contacts
  static const contactCreate = "/contact";

  // Transactions
  static const transactionSend = "/transaction/send_now";
  static const transactionSendDetails = "/transaction/send_now/details";
  static const transactionSendDetailsCategorie =
      "/transaction/send_now/details/categorie";
  static const transactionReceive = "/transaction/receive_now";
  static const transactionReceiveDetails = "/transaction/receive_now-rtp";
  static const transactionFormPage = "/transaction-form-fields";
  static const transactionFormVerification = "/transaction-form-verification";
  static const transactionFormSchedule = "/transaction-form-schedule";
  static const transactionSearch = "/transaction-search";
  static const transactionSearchFilters = "/transaction-search/filters";
  static const transactionCancel = "/transaction/cancel/:id";
  static const transactionCancelTransfer = "/transaction/cancel-transfer";
  static const transactionDetailsNotification = "/transaction/details-notification";
  static const transactionSplitPayment = "/transaction/split-payment";
  static const transactionSplitPaymentRepartition =
      "/transaction/split-payment/repartition";

  // Subscriptions
  static const subscriptionList = "/subscriptions/list";
  static const subscriptionDetails = "/subscriptions/details";
  static const subscriptionSchedule = "/transaction/schedule";
  static const subscriptionSubscribe = "/subscriptions/create";

  // QR Code
  static const qrcodeScan = "/qrcode/scan";
  static const qrcodeShow = "/qrcode/show";
  static const qrcodeTransactionSend = "/qrcode/send";
  static const qrcodeTransactionSendTp = "/qrcode/sendtp";
  static const qrcodeTransactionReceive = "/qrcode/scan/receive";

  // Categories
  static const categories = "/categories";
  static const categoriesSelect = "/categories/select";
  static const categoriesAdd = "/categories/add";
  static const categoriesEdit = "/categories/edit";

  // Profile
  static const profile = "/profile";
  static const profileCompte = "/profile/compte";
  static const profileComptePersonnel = "/profile/compte/personnel";
  static const profileCompteDetails = "/profile/compte/details";
  static const profileSecurite = "/profile/securite";
  static const profileParametre = "/profile/parametre";
  static const profileParametreTheme = "/profile/parametre/theme";
  static const profileParametreNotifications =
      "/profile/parametre/notifications";
  static const profileParametreNotificationsSon =
      "/profile/parametre/notifications/son";
  static const profileHelpCenter = "/profile/help-center";

  static const inviteFriends = "/invitations";

  // Notifications
  static const notifications = "/notifications";

  /// private constructor which prevents the class from being instantiated.
  AppRouter._();

  /// Méthode qui retourne la configuration des routes
  static GoRouter routes(String initial, QrcodeData? qrcodeData) {
    //
    logger.i('Route initiale $initial');
    return GoRouter(
      initialLocation: initial,
      routes: [
        // Page onboarding / introduction (videos)
        GoRoute(
          path: introduction,
          builder: (context, state) => const IntroductionPage(),
        ),

        // Page de connexion
        ..._securityRoutes(),

        // Alias
        ..._aliasRoutes(),

        // Page d'accueil
        ..._homeRoute(),

        // QR Code
        ..._qrCodeRoutes(qrcodeData),

        // Transactions
        ..._transactionRoutes(),

        ..._subscriptionRoutes(),

        // Categories
        ..._categorieRoutes(),

        // Contacts
        ..._contactRoutes(),

        // Profile / Paramètres
        ..._profilRoutes(),

        // NOTIFICATIONS
        ..._notificationsRoute(),
      ],
      // The errorPageBuilder is used to display a custom error page
      // if the user navigates to a page that does not exist
      errorPageBuilder: (context, state) => const MaterialPage(
        child: NotFoundPage(),
      ),
    );
  }

  ///  LOGIN IDENTIFICATION PERMISSIONS
  static List<RouteBase> _securityRoutes() {
    return [
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
        routes: [
          // Pages enfants dans login
          GoRoute(
            path: 'cgu', // NOTE: Pas besoin de mettre "/"
            pageBuilder: (context, state) => DialogPage(
              builder: (_) => const CguPage(),
            ),
          ),
          GoRoute(
            path: 'poc', // accessible via /login/poc
            pageBuilder: (context, state) => DialogPage(
              builder: (_) => const PocPage(),
            ),
          ),
          // Changer mot de passe
          GoRoute(
            path:
                'change-password/:username', // accessible via /login/change-password
            builder: (context, state) {
              final username = state.pathParameters['username'];
              return ChangePasswordPage(username: username!);
            },
          ),
        ],
      ),
      // Identification
      GoRoute(
        path: identificationInitial,
        builder: (context, state) {
          return const IdentificationPage(action: 'initial');
        },
      ),
      GoRoute(
          path: homePage,
          builder: (context, state) {
            return const CustomerApp();
          }
      ),
      GoRoute(
        path: identificationCheck,
        builder: (context, state) {
          return const IdentificationPage(action: 'check');
        },
      ),

      // Permissions
      GoRoute(
        path: permissions,
        builder: (context, state) => const PermissionsPage(),
      ),
    ];
  }

  ///  ALIAS
  static List<RouteBase> _aliasRoutes() {
    return [
      GoRoute(
        path: alias,
        builder: (context, state) => const AliasPage(),
        routes: [],
      ),
      GoRoute(
        path: aliasClaimDetails,
        pageBuilder: (context, state) {
          final String id = state.pathParameters['id'] as String;
          return DialogPage(
            builder: (_) => AliasPageClaim(id: id),
          );
        },
      ),
    ];
  }

  ///  HOME
  static List<RouteBase> _homeRoute() {
    return [
      GoRoute(
        path: home,
        builder: (context, state) {
          final int? tab = state.extra as int?;
          return HomePage(selectedTab: tab);
        },
        redirect: (context, state) async {
          // Vérifier si la problème a un alias ou pas avant
          AliasBloc aliasBloc = context.read<AliasBloc>();
          AliasState aliasState;
          if (aliasBloc.state is AliasExistState) {
            aliasState = aliasBloc.state;
          } else {
            //
            final loginBloc = context.read<LoginBloc>();
            ConnectedUser user = loginBloc.getConnectedUser()!;
            FirebaseApi.addNotifForMe();
            //
            if(user.paymentAddress() != null) {
              aliasBloc.add(FetchAliasEvent(user.paymentAddress()!));
            } else {
              aliasBloc.add(FetchAliasEvent("+${user.reference()}"));
            }
            //
            final completer = Completer<AliasState>();
            final listener = aliasBloc.stream.listen((aliasState) {
              completer.complete(aliasState);
            });
            aliasState = await completer.future;
            await listener.cancel(); // Cancel the listener
          }

          if (aliasState is! AliasExistState) {
            return alias;
          } else {
            return null;
          }
        },
      ),
    ];
  }

  ///  NOTIFICATIONS
  static List<RouteBase> _notificationsRoute() {
    return [
      GoRoute(
        path: notifications,
        pageBuilder: (context, state) => DialogPage(
          builder: (_) => BlocProvider<NotificationBloc>.value(
            value: state.extra! as NotificationBloc,
            child: const NotificationPage(),
          ),
        ),
        routes: [
          // Page de filtres
          // GoRoute(
          //   path: 'filters',
          //   pageBuilder: (context, state) => DialogPage(
          //     builder: (_) => BlocProvider<NotificationSearchBloc>.value(
          //       value: state.extra! as NotificationSearchBloc,
          //       child: const NotificationSearchPageFilters(),
          //     ),
          //   ),
          // ),
        ],
      ),
    ];
  }

  ///  TRANSACTIONS
  static List<RouteBase> _transactionRoutes() {
    return [
      // Transaction - Send
      GoRoute(
        path: transactionSend,
        pageBuilder: (context, state) {
          return DialogPage(
            builder: (context) => const TransactionSendPage(
              action: "send_now",
            ),
          );
        },
      ),
      // Transaction - Receive
      GoRoute(
        path: transactionReceive,
        pageBuilder: (context, state) {
          return DialogPage(
            builder: (context) => const TransactionSendPage(
              action: "receive_now",
            ),
          );
        },
      ),
      // Transaction - form
      GoRoute(
        path: transactionFormPage,
        builder: (context, state) {
          return const TransactionFormPage();
        },
      ),
      // Transaction - verification
      GoRoute(
        path: transactionFormVerification,
        builder: (context, state) {
          return const TransactionVerificationPage();
        },
      ),
      // Transaction - schedule
      GoRoute(
        path: transactionFormSchedule,
        builder: (context, state) {
          return const TransactionFormPageSchedule();
        },
      ),
      // Transaction - Transferts - details
      GoRoute(
        path: transactionSendDetails,
        pageBuilder: (context, state) {
          final Map<String, dynamic> params =
              (state.extra!) as Map<String, dynamic>;
          final Transaction tx = params["tx"] as Transaction;
          return DialogPage(
            builder: (_) => TransactionDetailsPage(
              transaction: tx,
              detailsBackRoute: params["route"],
            ),
          );
        },
      ),
      // Transaction - Receive RTP -details
      GoRoute(
        path: transactionReceiveDetails,
        pageBuilder: (context, state) {
          final Map<String, dynamic> params = (state.extra!) as Map<String, dynamic>;
          final tx = params["tx"] as Transaction;
          return DialogPage(builder: (_) => TransactionRtpPage(tx: tx));
        },
      ),
      // Transaction - Demande d'annulation - details -
      GoRoute(
        path: transactionCancel,
        pageBuilder: (context, state) {
          final String id = state.pathParameters['id'] as String;
          return DialogPage(builder: (_) => TransactionCancelPage(id: id));
        },
      ),
      // Transaction - Demande d'annulation transfer - details -
      GoRoute(
        path: transactionCancelTransfer,
        pageBuilder: (context, state) {
          final params = state.extra! as Map<String, Object?>;
          final tx = params["tx"] as Transaction;

          return DialogPage(
            builder: (_) => TransactionCancelPageTransfer(tx: tx),
          );
        },
      ),

      GoRoute(
        path: transactionDetailsNotification,
        pageBuilder: (context, state) {
          final params = state.extra! as Map<String, Object?>;
          final notification = params["notification"] as my_notif.Notification;

          return DialogPage(
            builder: (_) => TransactionDetailsNotificationPage(notification: notification),
          );
        },
      ),
      // Transaction -transferts -list
      GoRoute(
        path: transactionSearch,
        builder: (context, state) => const TransactionSearchPage(),
        routes: [
          // Page de filtres
          GoRoute(
            path: 'filters',
            pageBuilder: (context, state) => DialogPage(
              builder: (_) => BlocProvider<TransactionSearchBloc>.value(
                value: state.extra! as TransactionSearchBloc,
                child: const TransactionSearchPageFilters(),
              ),
            ),
          ),
        ],
      ),
      // Transaction - Split payment
      GoRoute(
        path: transactionSplitPayment,
        builder: (context, state) {
          final Map<String, dynamic> params =
              (state.extra!) as Map<String, dynamic>;
          final Transaction tx = params["tx"] as Transaction;
          return TransactionSplitPage(transaction: tx);
        },
        routes: [
          // Page de repartition
          GoRoute(
            path: 'repartition',
            builder: (context, state) {
              final Map<String, dynamic> params =
                  (state.extra!) as Map<String, dynamic>;
              final Transaction tx = params["tx"] as Transaction;
              final List<Contact> contacts =
                  params["contacts"] as List<Contact>;
              return TransactionSplitPageRepartition(
                transaction: tx,
                contacts: contacts,
              );
            },
          ),
        ],
      ),
    ];
  }

  ///  SUBSCRIPTIONS
  static List<RouteBase> _subscriptionRoutes() {
    return [
      // Subscription - Schedule once transaction
      GoRoute(
        path: subscriptionSchedule,
        pageBuilder: (context, state) {
          return DialogPage(
            builder: (context) => const TransactionSendPage(
              action: "send_schedule",
            ),
          );
        },
      ),
      // Subscription - Schedule abonnement
      GoRoute(
        path: subscriptionSubscribe,
        builder: (context, state) {
          return const SubscriptionCreatePage();
        },
      ),
      // List
      GoRoute(
        path: subscriptionList,
        builder: (context, state) {
          return HomePage(selectedTab: 2);
        },
      ),
      // Subscription - Details
      GoRoute(
        path: subscriptionDetails,
        pageBuilder: (context, state) {
          final Map<String, dynamic> params =
              (state.extra!) as Map<String, dynamic>;
          final Transaction tx = params["tx"] as Transaction;
          return DialogPage(
            builder: (_) => SubscriptionDetailsPage(
              subscription: Subscription.fromTransaction(tx),
              detailsBackRoute: params["route"],
            ),
          );
        },
      ),
    ];
  }

  ///  CATEGORIES
  static List<RouteBase> _categorieRoutes() {
    return [
      GoRoute(
        path: categoriesSelect,
        pageBuilder: (context, state) => DialogPage(
          builder: (_) => const CategorieSelectPage(),
        ),
      ),
      GoRoute(
        path: categoriesAdd,
        pageBuilder: (context, state) => DialogPage(
          builder: (_) => const CategorieAddPage(),
        ),
      ),
      GoRoute(
        path: categoriesEdit,
        pageBuilder: (context, state) => DialogPage(
          builder: (_) => const CategorieEditPage(),
        ),
      ),
    ];
  }

  ///  CONTACTS
  static List<RouteBase> _contactRoutes() {
    return [
      GoRoute(
        path: contactCreate,
        builder: (context, state) {
          final Map<String, dynamic> params =
              (state.extra!) as Map<String, dynamic>;
          final Function(ContactPI contact) afterCreate =
              params["afterCreate"] as Function(ContactPI contact);
          return ContactCreatePage(
            afterCreate: afterCreate,
          );
        },
      ),
    ];
  }

  ///  PROFIL & PARAMETRAGE
  static List<RouteBase> _profilRoutes() {
    return [
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfilePage(),
        routes: [
          // Sécurite et confidentialité
          GoRoute(
            path: 'securite',
            builder: (context, state) => const ProfileSecuritePage(),
          ),
          GoRoute(
            path: 'compte',
            builder: (context, state) => const ProfileComptePage(),
            routes: [
              GoRoute(
                path: 'personnel',
                builder: (context, state) => const ProfileCompteClientPage(),
              ),
              GoRoute(
                path: 'details',
                builder: (context, state) => const ProfileCompteDetailsPage(),
              ),
            ],
          ),
          // Parametre de l'app
          GoRoute(
              path: 'parametre',
              builder: (context, state) => const ProfileParametrePage(),
              routes: [
                // Theme
                GoRoute(
                  path: 'theme',
                  builder: (context, state) =>
                      const ProfileParametrePageTheme(),
                ),
                // Notifications
                GoRoute(
                  path: 'notifications',
                  pageBuilder: (context, state) {
                    return DialogPage(
                      builder: (context) =>
                          const ProfileParametrePageNotifications(),
                    );
                  },
                  routes: [
                    // Son
                    GoRoute(
                      path: 'son',
                      pageBuilder: (context, state) {
                        return DialogPage(
                          builder: (context) =>
                              const ProfileParametrePageNotificationsSon(),
                        );
                      },
                    ),
                  ],
                ),
              ]),
        ],
      ),
    ];
  }

  ///  QR CODE
  static List<RouteBase> _qrCodeRoutes(QrcodeData? qrData) {
    return [
      // Scan QR Code
      GoRoute(
        path: qrcodeScan,
        builder: (context, state) => QrcodeScanPage(
          action: state.extra as String?,
        ),
      ),
      // Show my qr code
      GoRoute(
        path: qrcodeShow,
        builder: (context, state) => const QrCodeAliasPage(),
      ),
      // Send by QR Code
      GoRoute(
          path: qrcodeTransactionSend,
          builder: (context, state) {
            // Compte du client payeur
            final aliasBloc = context.read<AliasBloc>();
            final AliasExistState aliasState =
                aliasBloc.state as AliasExistState;
            // Page de transfert par qrcode
            final QrcodeData qrcodeData = state.extra! as QrcodeData;
            final String? action = state.uri.queryParameters['action'];
            return TransactionFormPageQrcode(
              command: TransactionSendCommand(
                compte: aliasState.alias.compte,
                action: action ?? TransactionSendCommand.actionSendNow,
                method: action == "receive_now"
                  ? TransactionSendMethod.aliasRtb
                  : TransactionSendMethod.qrcode,
                alias: TransactionSendCommandAlias(value: qrcodeData.alias),
                canal: action == TransactionSendCommand.actionReceiveNow
                    ? TransactionCanal.transfertParRequestToPay.code
                    : qrcodeData.channel,
                amount: qrcodeData.montant != null
                    ? TransactionSendCommandAmount(value: qrcodeData.montant!)
                    : null,
                txId: qrcodeData.txId,
              ),
            );
          }),
      GoRoute(
        path: qrcodeTransactionSendTp,
        builder: (context, state) {
          final QrcodeData qrcodeData = state.extra != null
              ? state.extra as QrcodeData
              : qrData as QrcodeData;
          final String? action = state.uri.queryParameters['action'];
          logger.i("je suis dans transfert: $qrData");
          return TransactionFormPageQrcode(
            command: TransactionSendCommand(
              compte:ConnectedUser.current?.alias ?? ConnectedUser.current!.shid ?? "",
              //compte: aliasState.alias.compte,
              action: action ?? TransactionSendCommand.actionSendNow,
              method: TransactionSendMethod.qrcode,
              alias: TransactionSendCommandAlias(value: qrcodeData.alias),
              canal: action == TransactionSendCommand.actionReceiveNow
                  ? TransactionCanal.transfertParRequestToPay.code
                  : qrcodeData.channel,
              amount: qrcodeData.montant != null
                  ? TransactionSendCommandAmount(value: qrcodeData.montant!)
                  : null,
              txId: qrcodeData.txId,
            ),
            ctx: context,
          );
        },
        redirect: (context, state) async {
          // Vérifier si la problème a un alias ou pas avant
          AliasBloc aliasBloc = context.read<AliasBloc>();
          AliasState aliasState;
          if (aliasBloc.state is AliasExistState) {
            aliasState = aliasBloc.state;
          } else {
            //
            final loginBloc = context.read<LoginBloc>();
            ConnectedUser user = loginBloc.getConnectedUser()!;
            //
            if(user.paymentAddress() != null) {
              aliasBloc.add(FetchAliasEvent(user.paymentAddress()!, true));
            } else {
              aliasBloc.add(FetchAliasEvent("+${user.reference()}", true));
            }
            //
            final completer = Completer<AliasState>();
            final listener = aliasBloc.stream.listen((aliasState) {
              completer.complete(aliasState);
            });
            aliasState = await completer.future;
            await listener.cancel(); // Cancel the listener
          }

          if (aliasState is! AliasExistState) {
            return qrcodeTransactionSendTp;
          } else {
            return null;
          }
        },
      ),
    ];
  }

  /// Permet de naviguer entre les pages
  static void go(
    BuildContext context,
    String route, {
    Object? params,
  }) async {
    await context.push(route, extra: params);
  }

  /// Permet de naviguer entre les pages
  static Future<T?> push<T>(
    BuildContext context,
    String route, {
    Object? params,
  }) async {
    return await context.push(route, extra: params);
  }

  /// Permet de naviguer entre les pages
  static void pushReplacement(
    BuildContext context,
    String route, {
    Object? params,
  }) async {
    context.pushReplacement(route, extra: params);
  }

  /// Fermer un dialogue
  static void pop(BuildContext context, {Object? value}) {
    context.pop(value);
  }
}

/// Page affichée si aucune page trouvée
class NotFoundPage extends StatelessWidget {
  //
  const NotFoundPage({super.key});

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Pour avoir le bouton de retour
      appBar: AppBar(),
      body: const Center(child: Text("A venir")),
    );
  }
}

/// Page contenant pour afficher des dialogues
/// En utilisant le systeme de routage go-router
class DialogPage<T> extends Page<T> {
  //
  /// Permet de savoir si le dialog doit être fermé
  /// lorsqu'on clique sur la barrière
  final bool barrierDismissible;

  /// Ce padding permet de gérer la marge entre le contenu du dialog
  /// et cotés(bas/haut/gauche/droite) du devise
  final EdgeInsets insetPadding;

  /// Avec se shape nous pouvons agir sur le style de la bordure
  final ShapeBorder shape;

  /// Positionner du dialog
  final AlignmentGeometry alignment;

  /// Contenu du dialog
  /// Ce contenu ne doit pas etre dans un Scafold(body),
  /// vous pouvez directement dans page retourner le widget à afficher.
  final WidgetBuilder builder;

  /// Constructeur
  const DialogPage({
    required this.builder,
    this.barrierDismissible = true,
    this.insetPadding = const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 00.0),
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(15.0),
        topLeft: Radius.circular(15.0),
      ),
    ),
    this.alignment = Alignment.bottomCenter,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    //
    return DialogRoute<T>(
      context: context,
      settings: this,
      builder: (context) => Dialog(
        // Dialog padding
        insetPadding: insetPadding,
        //
        alignment: alignment,
        //
        shape: shape,
        //
        child: builder(context),
      ),
      barrierDismissible: barrierDismissible,
    );
  }
}
