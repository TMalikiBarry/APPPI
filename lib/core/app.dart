import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pi_mobile_app/core/storage.dart';
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
import '../modules/profile/presentation/bloc/hide_amount/hide_amount_bloc.dart';
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

/// Premier widget Application lancée par le main
class App extends StatelessWidget {
  //
  /// Constructeur de l'app
  const App({super.key});

  ///
  ///
  config() async {
    // It’s worth noting that calling ensureInitialized()
    // more than once will throw an exception,
    // so it’s important to make sure that this method
    // is only called once per app execution.
    // https://api.flutter.dev/flutter/widgets/WidgetsFlutterBinding/ensureInitialized.html
    WidgetsFlutterBinding.ensureInitialized();

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
    const secureStorage = FlutterSecureStorage();

    // Créer une instance de SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Initaliser le client API
    Api.initClient(secureStorage);

    // Initialize the caching service
    await AppStorage.init(secureStorage);

    // Initialise le système d'injection des dépendances
    Di.init(prefs, secureStorage);

    // Observer les bloc
    Bloc.observer = AppObserver(); // Ajoutez un observer personnalisé

    // Initialisation du système de gestion des notifications
    await AppNotifications.init(prefs);

    // Run the app
    runApp(const App());
  }

  @override
  Widget build(BuildContext context) {

    config();
    // Alors afficher maintenant l'application
    // En considérant les données de configuration

    // Blocs
    ConfigBloc configBloc = ConfigBloc(Di.getConfigInputPort());
    CategorieBloc categorieBloc = CategorieBloc(
      Di.getCategorieInputPort(),
    )..add(CategorieListEvent());

    return MultiBlocProvider(
      providers: [
        // Configuration
        BlocProvider<ConfigBloc>(create: (BuildContext context) => configBloc),
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
          create: (BuildContext context) => categorieBloc,
        ),
        // Contacts list
        BlocProvider(
          create: (BuildContext context) => ContactBloc(),
        ),
        // Listener to phone movement to hide / show amount
        BlocProvider(
          create: (BuildContext context) => ParametreHideAmountBloc(
            configBloc,
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
            _appLayout(configBloc.state as ConfigLoadedState),
      ),
      //_appLayout(configBloc.state as ConfigLoadedState),
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
    String pageInitiale = params[ConfigKey.introductionPassed.code] == null
        ? AppRouter.introduction
        : AppRouter.login;

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
