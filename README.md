# Application Mobile 
```sh
flutter pub get
```

# Internationalisation
L'app propose actuellement deux langues le français et l'anglais.
La comande suivante permet de convertir les fichiers .arb (dans le dossier `lib/l10n/``):
```sh
flutter gen-l10n
```

`lib/l10n/` contient les fichiers de traductions des languges supportées par l'application.

Veuillez noter que vous ne devez pas modifier ces fichiers manuellement car ils seront recompilés à chaque fois que la commande flutter gen-l10n sera exécutée. 

# Exemple d'env de développement
```sh
{
  "ENV": "dev",
  "MODE": "demo",
  "FIREBASE_API_KEY_ANDROID": "AIzaSyAqvGLykXlruT9Z8dBVLQsnI9FU7RVBLRs",
  "FIREBASE_APP_ID_ANDROID": "1:909112733465:android:3a2bb0936e62a5c3515f88",
  "FIREBASE_MESSAGING_SENDER_ID": "909112733465",
  "FIREBASE_PROJECT_ID": "pi-mobile-app-dev",
  "FIREBASE_STORAGE_BUCKET": "pi-mobile-app-dev.appspot.com",
  "FIREBASE_API_KEY_IOS": "AIzaSyC7S3du5zm1KNDlWikPVUnnl8Z01HEekWw",
  "FIREBASE_APP_ID_IOS": "1:909112733465:ios:9427a3ff9fd97ae7515f88",
  "FIREBASE_IOS_BUNDLE_ID": "com.example.piMobileApp",
  "LOG_LEVEL": "info",
  "API_URL_LO": "https://xyz.com",
  "API_URL": "https://xyz.com",
  "VERSION": "0.0.1",
  "KEYCLOAK_AUTHORIZATION_ENDPOINT": "",
  "KEYCLOAK_TOKEN_ENDPOINT": "",
  "KEYCLOAK_REDIRECT_URI": "myapp://login",
  "KEYCLOAK_LOGOUT_ENDPOINT": "",
  "KEYCLOAK_REVOCATION_ENDPOINT": "",
  "KEYCLOAK_USER_INFO_ENDPOINT": ""
}
```

L'application peut être exécutée selon différents paramètres:
  - Le mode "demo" permet de tester l'application avec un faux backend.
  - le mode "normal" permet de tester l'application avec un réel backend par API


# Tests

## Pour lancer les tests
```sh
flutter test --coverage
```

## Pour visualiser les résultats
```sh
genhtml coverage/lcov.info -o coverage/html
```

## Démarrer le projet
Spécifier le chemin vers le fichier contenant les variables d'environnement
```sh
flutter run --dart-define-from-file=chemin_vers_fichier_env/env.json
```

### Lancer sur un emulateur IOS
```sh
cd ios
rm Podfile.lock
pod install --repo-update

Ouvrir xcode 

```


## Configurations
### Notifications PUSH
Fichier lib/core/notifications.dart contient la configuration pour la reception des notifications PUSH.
Firebase FCM est utilisé