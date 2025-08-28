import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pi_mobile_app/core/storage.dart';
import 'package:pi_mobile_app/shared/widgets/loading_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_options.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../modules/alias/presentation/bloc/alias_bloc.dart';
import '../modules/categorie/presentation/bloc/categorie_bloc.dart';
import '../modules/categorie/presentation/bloc/categorie_event.dart';
import '../modules/config/adapters/ui/bloc/config_bloc.dart';
import '../modules/config/adapters/ui/bloc/config_state.dart';
import '../modules/config/domain/models/config_keys.dart';
import '../modules/contacts/presentation/bloc/contact_bloc.dart';
import '../modules/pi_app_events.dart';
import '../modules/profile/presentation/bloc/hide_amount/hide_amount_bloc.dart';
import '../modules/security/domain/models/connected_user.dart';
import '../modules/security/infra/connexion_output_authpkce.dart';
import '../modules/security/ports/input/connexion_input_port.dart';
import '../modules/security/presentation/bloc/identification/identification_bloc.dart';
import '../modules/security/presentation/bloc/login/login_bloc.dart';
import '../modules/transactions/presentation/bloc/transaction_send/transaction_send_bloc.dart';
import 'api.dart';
import 'di.dart';
import 'languages.dart';
import 'logger.dart';
import 'notifications.dart';
import 'observer.dart';
import 'router.dart';
import 'theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// Premier widget Application lancée par le main
class App extends StatefulWidget {
  //
  /// Constructeur de l'app
  App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static const keyIdToken = "ID_TOKEN";
  static const accesToken = "ACCESS_TOKEN";

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? idToken;
  SharedPreferences? prefs;
  bool _isLoading = true;
  ConfigBloc? configBloc;
  CategorieBloc? categorieBloc;
  bool isFirstTime = true;

  // Couleurs pour le loader (à adapter selon votre thème)
  final Color primaryColor = const Color(0xFF6366F1); // Indigo
  final Color secondaryColor = const Color(0xFF8B5CF6); // Violet

  Future<void> _decodeIdToken(idToken) async {
    if (idToken == null || !idToken.contains('.')) {
      throw Exception('Token JWT invalide ou null');
    }

    final parts = idToken.split('.');
    if (parts.length != 3) throw Exception('JWT mal formé');

    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final Map<String, dynamic> json = jsonDecode(payload);

    ConnectedUser.current = ConnectedUser(
      id: json["sub"],
      username: json["preferred_username"],
      firstName: json["given_name"],
      lastName: json["family_name"],
      country: json["address"]?["country"] ?? "SN",
      address: json["address"]?["locality"] ?? "DK",
      telephone: json["phone_number"],
      email: json["email"],
      alias: json["alias"],
      shid: json["shid"],
      avatar: null,
    );

    print("ConnectedUser.current1");
    print(ConnectedUser.current);
    print(ConnectedUser.current!.alias);
    //print(ConnectedUser.current!.shid);
  }

  Future<void> _config() async {
    try {
      print("ConnectedUser.currentg1");

      _decodeIdToken(idToken);

      // Temporairement à cause du certificat autosigné
      // utilisé sur keycloak dans l'env de test
      HttpOverrides.global = MyHttpOverrides();

      // Initialisation de firebase: Système de journalisation, de notification
      //await Firebase.initializeApp(
      //  options: DefaultFirebaseOptions.currentPlatform,
      //);

      // Avant toute chose initialiser le système de journalisation
      await AppLogger.config();

      // Créer une instance de stockage sécurisée
      // Keychain pour IOS et keystore pour android

      // Créer une instance de SharedPreferences
      //final prefs = await SharedPreferences.getInstance();

      // Initaliser le client API
      Api.initClient(secureStorage);

      // Initialize the caching service
      await AppStorage.init(secureStorage);

      // Observer les bloc
      Bloc.observer = AppObserver(); // Ajoutez un observer personnalisé

      // Initialisation du système de gestion des notifications
      await AppNotifications.init(prefs!);

      // Initialiser les blocs
      configBloc = ConfigBloc(Di.getConfigInputPort());
      categorieBloc = CategorieBloc(
        Di.getCategorieInputPort(),
      )..add(CategorieListEvent());

      // Configuration terminée
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors de la configuration: $e');
      // En cas d'erreur, on peut soit afficher une page d'erreur
      // soit continuer avec _isLoading = false
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isLoading) {
      // Récupération des arguments seulement si on est en train de charger
      final args = ModalRoute.of(context)!.settings.arguments as BceaoPiAppEvent;
      print("args.user");
      print(args.user);
      idToken = args.user;
      prefs = args.prefs;

      // Initialise le système d'injection des dépendances
      Di.init(prefs!, secureStorage);

      // Sauvegarde des tokens
      secureStorage.write(key: keyIdToken, value: args.user);
      secureStorage.write(key: accesToken, value: args.user);

      // Lancer la configuration
      _config();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitialPage();
  }

  Future<void> getInitialPage() async {
    final isFirstTimeInPi = await secureStorage.read(key: "isFirstTimeInPi");

    if (isFirstTimeInPi == null || isFirstTimeInPi == "false") {
      isFirstTime = true;
    } else {
      isFirstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    //WidgetsFlutterBinding.ensureInitialized();

    // Afficher la page de chargement
    if (_isLoading) {
      return LoadingPage(
        bgColor: Theme.of(context).colorScheme.surface,
      );
    }

    // Afficher l'application principale une fois la configuration terminée
    return MultiBlocProvider(
      providers: [
        // Configuration
        BlocProvider<ConfigBloc>(create: (BuildContext context) => configBloc!),
        // Security - Login
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(
            Di.getConnexionInputPort(),
          ),
        ),
        // Security - Identification
        BlocProvider<IdentificationBloc>(
          create: (BuildContext context) => IdentificationBloc(
            Di.getIdentificationInputPort(),
          ),
        ),
        // Alias
        BlocProvider<AliasBloc>(
          create: (BuildContext context) => AliasBloc(
            Di.getAliasInputPort(),
          ),
        ),
        // Categories
        BlocProvider<CategorieBloc>(
          create: (BuildContext context) => categorieBloc!,
        ),
        // Contacts list
        BlocProvider(
          create: (BuildContext context) => ContactBloc(),
        ),
        // Listener to phone movement to hide / show amount
        BlocProvider(
          create: (BuildContext context) => ParametreHideAmountBloc(
            configBloc!,
          ),
        ),
        // Transactions
        BlocProvider(
          create: (BuildContext context) => TransactionSendBloc(
            Di.getTransactionInputPort(),
            Di.getCompteInputPort(),
            Di.getParticipantInputPort(),
            Di.getPermissionInputPort(),
          ),
        ),
      ],
      child: BlocBuilder<ConfigBloc, ConfigState>(
        bloc: configBloc,
        buildWhen: (previous, current) =>
        current is ConfigLoadedState &&
            (current.updatedKey == ConfigKey.preferedTheme ||
                current.updatedKey == ConfigKey.preferedLanguage),
        builder: (context, state) =>
            _appLayout(configBloc!.state as ConfigLoadedState),
      ),
    );
  }

  /// Affiche l'application selon le theme de l'utilisateur
  /// Détermine la page initiale de l'application
  /// Affiche la première page à afficher
  MaterialApp _appLayout(ConfigLoadedState configState) {
    // Bloc orientation application
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Récuperer les paramètres de démarrage
    Map<String, String?> params = configState.configParams.params;

    // Déterminer le theme à utiliser
    ThemeData theme = params[ConfigKey.preferedTheme.code] != null
        ? Themer.get(params[ConfigKey.preferedTheme.code]!)
        : Themer.get(Themes.light.code);

    // Déterminer la langue à utiliser
    Languages? lang = params[ConfigKey.preferedLanguage.code] != null
        ? Languages.fromCode(params[ConfigKey.preferedLanguage.code]!)
        : Languages.fr;
    Locale language = lang != null ? Locale(lang.name) : Locale('fr');


    // Afficher la page principale
    String pageInitiale = (
        params[ConfigKey.introductionPassed.code] == null
        && isFirstTime
    )
        ? AppRouter.introduction
        : AppRouter.home;

    // Passer également la configuration pour le routage dans l'Application
    return MaterialApp.router(
      theme: theme,
      locale: language,
      routerConfig: AppRouter.routes(pageInitiale),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        // provides localized strings and other values
        // for the Material Components library.
        GlobalMaterialLocalizations.delegate,
        // defines the default text direction,
        // either left-to-right or right-to-left, for the widgets library.
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // Custom translation
        AppLocalizations.delegate,
      ],
      supportedLocales: Languages.supportedLocales(),
      // Recupération du locale de l'utilisateur
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (locale.languageCode == deviceLocale!.languageCode) {
            // Configure DateFormat avec le locale par défaut
            Intl.defaultLocale = locale.languageCode;
            return deviceLocale;
          }
        }
        return supportedLocales.first;
      },
      // Scollbehavior
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: PointerDeviceKind.values.toSet(),
      ),
    );
  }
}
