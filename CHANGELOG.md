# Changelog
Tous les changements notables apportés à ce projet seront documentés dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Economies
  - Tirelire personnelle
  - Tirelire de groupe
  - Gestion des tontines
- Shake to pay

## [1.2.1] - 2025-04-18
### Fixed
- Thème - Adaptation du code par rapport au thème sombre

## [1.2.0] - 2025-04-17
### Added
- Langue
  -  Ajout de la langue portugais (fichier intl_pt.arb)
- Transactions
  -  Transactions recentes - Possibilité de modifier le nombre de transactions récentes 
  -  Liste des transactions - Pagination de la liste lorsque l'utilisateur scrolle vers le bas
  -  Details d'une transaction 
    -  Planifier le paiement
    -  Partager le paiement - Répartit par montant
    -  Téléverser le ticket de caisse 
    -  Visualiser le ticket de caisse
    -  Supprimer le ticket de caisse
  -  Contact avec alias - Enregistrement de l'alias dans les contacts lorsque le client selectionne l'option "le numéro est un alias de compte"
- Notifications
  -  Pagination de la liste lorsque l'utilisateur scrolle vers le bas
  -  Marquer une notification comme lue
- Paramètres
  -  Personnalisation de la langue
  -  Mon Qr Code par défaut
  -  Personnalisation du thème
  -  Notifications dans l'application (Affichage, Son, Style)

### Changed
- Configuration
  - ConfigBloc - Ajout d'un paramètre `updatedKey`qui indique la configuration modifiée 
- Categorie
  -  Refactoring pour ne pas appeler context.read<CategorieBloc>() dans le build method
  -  Utilisation de la liste des categories depuis le state du bloc
- Transactions
  -  Refactoring pour passer le numéro de compte dans les params à l endpoint `/transferts`
  -  Details d'une transaction -  Bouton Envoyer à nouveau disponible pour un transfert reçu

### Removed
- Compte
  -  Suppression du bloc ConfigBloc dans le bloc CompteSoldeBloc

### Fixed
- API MOCK
  - Changement du participant PSP123 en SNB000
- Alias - MBNO
  -  Supprimer le code mort sur le bouton pour renvoyer le code de vérification
  -  Refactoring pour ne pas appeler context.read<AliasBloc>() dans le build method
-  Contact 
  -  Supprimer le champ "Label" non utilisé
-  Paramètres
   -  Details du compte - Affichage de l'alias SHID lié au MBNO
- Correction de certaines traductions en anglais dans le fichier intl_en.arb sur les notifications
- Demandes de paiement
  - Formulaire d'envoi - Cacher les contacts qui n'ont pas d'alias de compte
  

## [1.1.0] - 2025-04-11
### Added
- Theme - Theme du système / téléphone du client en plus de Light et Dark
- App - Langue - utilisation de la langue locale de l'utilisateur par défaut pour les dates
- App - Affichage - Empecher l'affichage de l'application en mode paysage 
- Notifications Push - Ajout de la logique dans lib/core/notifications.dart
- Notifications Push - Configuration à l'acceptation de la permission de notification
- Introduction - Présentation de l'application - Boutons transparents pour naviguer
- Alias - Revendications 
  - Revendiquer un alias
  - Details d'une revendication
  - Accepter une revendication
  - Rejeter une revendication
- Transfert - Envoi
  - Envoyer à un nouveau contact / enregistrer un alias dans les contacts
  - Envoyer à partir d'un transfert récent 
  - Rechercher dans ses contacts  - Envoi par alias ou par autre compte
  - Programmer le transfert pour une seule exécution
  - Programmer le transfert pour un abonnement
  - Confirmation - Ajout de la méthode d'authentification du client (biometry ou pin) dans les données envoyées au backend
- Transfert - Details 
  - Envoyer un transfert au client payé et avec le même montant
  - Annuler - Envoi de la demande d'annulation 
  - Recevoir - Envoi d'une demande de paiement au client payeur
  - Retourner - Retourner les fonds d'un transfert reçu
- Demandes de paiement
  - Envoi - Envoyer par alias
  - Envoi - Envoyer à un nouveau contact
  - Envoi - Envoyer à un transfert récent
- Souscriptions 
  - Créer un paiement programmé
  - Créer un abonnement
  - Details - Affichage de la prochaine date d'éxécution
  - Details - Modifier la souscription
  - Details - Modifier la catégorie
  - Details - Modifier la note
  - Details - Désactiver/Réactiver la souscription
  - Details - Supprimer la souscription
  - Liste - Trier la liste par type (Programmé ou Abonnement)
- Notifications 
  - Affichage de la liste des notifications
  - Affichage du nombre de notifications non lues
  - Détails d'une notification de demande de paiement envoyée avec succès
  - Détails d'une notification de demande de paiement reçue d'un particulier (canal 631)
  - Détails d'une notification de demande d'annulation envoyée
  - Détails d'une notification de demande d'annulation reçue


### Changed
- Versions - Android et Gradle versions
- Versions - IOS 15.5 
- Environnement - Variable FIREBASE_APP_ID remplacé par FIREBASE_APP_ID_ANDROID et FIREBASE_APP_ID_IOS, 
- Alias - MBNO - Formulaire de création - Internationalisation des messages d'erreur
- Permissions - Contact - Titre et description de l'action
- Permissions - Notification - Acceptation obligatoire pour utiliser l'application
- NotificationDialog : size dynamic Deprecated Height param 
- Transfert 
  - Canal 333 corrigé selon les spécifications du pacs.008 en 633
  - Package scan utilisé pour scanner les qr code remplacé par le package `mobile_scanner`
  - Details - Annuler - Texte du Bouton pour demander l'annulation d'un transfert `Recevoir` devient `Annuler`

### Removed
- Theme - Propriétés dépréciées: background => surface, onBackground => onSurface
- Alias - MBNO - Création - Explication "pourquoi un numéro de téléphone"
- Alias - MBNO - Page Pourquoi Numéro de téléphone
- Transfert - Envoi - Formulaire - Champ de recherche - Bouton permettant de scanner un QR Code 

### Fixed
- Dépendences obsolètes mise à jour
- Dart use_super_parameters 
- Api.dart
  - Gestion des erreurs - Mise à jour de ErrorInterceptor pour retourner la bonne erreur en fonction du statut HTTP
  - Capture des erreurs d'expiration du token code 401 au lieu de 403
- Alias - Création - Ne pas enregistrer en local la réponse à la création d'alias de type MBNO


## [1.0.0] - 2023-12-14
### Added
- Onboarding - Présentation des fonctionnalités de l'application
- Connexion 
  - Configuration des paramètres de connexion à l'application
  - Identification du client / Double authentification
- Permissions 
  - Biométrie
  - Notification
  - Contact
- Alias 
  - Création d'alias de type SHID
  - Création d'alias de type MBNO
- Accueil 
  - afficher / cacher le solde bouton et detection de mouvement
  - affichage des transactions récentes 
  - scanner qrcode pour envoyer transaction
- QRcode
  - QRcode - scanner un qrcode avec l'appareil photo
  - QRcode - scanner une image qrcode importée depuis la galerie
  - QRcode Scanner - afficher qrcode
  - QRcode Afficher - afficher le qrcode du compte connecté
  - QRcode Afficher - partager le qrcode du compte connecté
  - QRcode Afficher - copier l'alias
  - QRcode Afficher - scanner qrcode
- Transfert
  - Envoyer Transaction - par alias
  - Envoyer Transaction - par iban
  - Envoyer Transaction - par autre compte
  - Details Transaction - afficher les details d'une transaction 
  - Liste Transaction - afficher la liste des transactions stockées localement
- Profil 
  - Se déconnecter
  - Compte - afficher les informations personnelle de l'utilisateur
  - Compte - afficher les details du compte / supprimer l'alias
  - Sécurité & Confidentialité - activer ou désactiver l'autorisation biometrie
  - Sécurité & Confidentialité - activer ou désactiver l'option cacher les montants par basculement du téléphone
