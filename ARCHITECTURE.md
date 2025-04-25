# 🏗️ Architecture du projet 

Ce document décrit l'architecture du projet afin de faciliter la navigation, la compréhension du code et l'intégration de nouvelles fonctionnalités.


## 📁 Structure générale
```text
lib/
├── core/                   # Configuration et outils de base
├── l10n/                   # Fichiers de localisation (ARBs + classes)
├── modules/                # Domaines fonctionnels organisés par fonctionnalités
├── shared/                 # Composants/utilitaires réutilisables
├── firebase_options.dart   # Configuration Firebase
└── main.dart               # Point d'entrée de l'application
```

## 🧱 Détails par dossier

### 🔹 `core/`
Contient tous les éléments essentiels transverses à l'application :
- `api.dart` : gestion des appels API
- `api_mock.dart` : mocking de l'API pour les tests
- `app.dart` : configuration générale de l'app
- `assets.dart` : chemins centralisés vers les ressources
- `di.dart` : injection de dépendances
- `env.dart` : variables d'environnement
- `languages.dart` : gestion des langues
- `logger.dart` : utilitaire de logging
- `notifications.dart` : gestion des notifications
- `router.dart` : définition des routes via GoRouter
- `storage.dart` : stockage local avec Hive
- `theme.dart` : thèmes de l'application

### 🌍 `l10n/`
Fichiers liés à la **localisation** :
- `.arb` : fichiers de traduction
- `.dart` : générés automatiquement pour accéder aux strings localisées

### 📦 `modules/`
Chaque fonctionnalité est découpée selon une approche **DDD (Domain-Driven Design)** avec séparation claire :
```text
modules/
└── <feature>/
    ├── domain/        # Modèles métier, exceptions, services abstraits
    ├── infra/         # Implémentations concrètes (API, local, repo)
    ├── ports/         # Interfaces d'entrée (UI) et de sortie (données)
    └── presentation/  # UI (pages, widgets), gestion d'état (bloc)
```

#### Exemple avec `alias/` :
- `domain/`: logique métier (models, services, exceptions)
- `infra/`: implémentations (remote, local, repository)
- `ports/`: input/output abstractions
- `presentation/`: `bloc/` + `pages/` pour la partie UI

### 🔄 `shared/`
Composants réutilisables ou utilitaires globaux à l'app.

## 🧪 Tests

L'application est testée automatiquement selon les trois niveaux de tests recommandés par Flutter :

### ✅ 1. Tests unitaires

> Testent une fonction, méthode ou classe isolée.

Les tests unitaires sont regroupés dans le dossier `test/units/` et ciblent principalement :
- les fonctions utilitaires,
- les services métiers,
- les blocs (state management).

### 🎯 2. Tests de widget

> Testent un seul widget dans un environnement simulé.

Les tests de widgets vérifient le rendu et le comportement de l’interface utilisateur à un niveau isolé (ex. : affichage d’un message d’erreur, changement d’état visuel, navigation, etc).

Ils se trouvent dans `test/widgets/` et s’appuient sur :
- `WidgetTester`
- `pumpWidget`, `pumpAndSettle`
- `find`, `expect`, `tap`

### 🔁 3. Tests d’intégration

> Testent une grande partie de l' application complète 

Prévue dans `test/integration/`, cette couche de test permet de simuler des cas d’usage réels impliquant plusieurs composants.  

Outils : `integration_test` (officiel Flutter), possible extension avec `flutter_driver` ou `Appium` si besoin.

---

### 🧮 Couverture & CI

- **Code coverage**  via :  
  ```bash
  flutter test --coverage
  ```

    Le rapport est disponible dans coverage/lcov.info

## ⚙️ Patterns utilisés

- **State Management** : `Bloc` (dans `presentation/bloc`)
- **Architecture** : DDD inspiré de Clean Architecture
- **Navigation** : Fichier `router.dart` dans `core`
- **Dépendances** : gérées via `di.dart` 
- **Localisation** : prise en charge multi-langue via `intl` et `flutter_localizations`

## 🧠 Conventions

- `snake_case` pour les fichiers
- `UpperCamelCase` pour les classes
- Une `feature` = un dossier sous `modules/` avec une séparation claire `domain / infra / presentation`
- UI séparée de la logique métier via BLoC
