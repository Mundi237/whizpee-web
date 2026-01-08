# Documentation Complète des UI - Super Up App

## 📋 Table des Matières
1. [Architecture Générale](#architecture-générale)
2. [Widgets de Base](#widgets-de-base)
3. [Modules Principaux](#modules-principaux)
4. [Modules d'Authentification](#modules-dauthentification)
5. [Modules de Chat](#modules-de-chat)
6. [Modules d'Annonces](#modules-dannonces)
7. [Modules de Story](#modules-de-story)
8. [Modules de Paramètres](#modules-de-paramètres)
9. [Modules Utilitaires](#modules-utilitaires)

---

## 🏗️ Architecture Générale

L'application `super_up_app` est une application Flutter de messagerie sociale avec système d'annonces. Elle suit une architecture modulaire avec séparation claire entre :
- **Views** : Composants UI (Widgets)
- **Controllers** : Logique métier et gestion d'état
- **Models** : Modèles de données
- **Services** : Services API et données

L'application supporte deux modes d'affichage :
- **Mobile** : Interface avec onglets (CupertinoTabScaffold)
- **Wide** : Interface adaptée aux écrans larges (tablettes, desktop)

---

## 🧩 Widgets de Base

### 📍 `lib/app/core/widgets/`

#### 1. **MainBuilder** (`main_builder.dart`)
- **Utilité** : Widget wrapper principal qui gère le comportement selon la taille d'écran
- **Fonctionnalités** :
  - Détecte si l'écran est "wide" (large)
  - Applique `PointerDownUnFocus` sur mobile pour fermer le clavier
- **Usage** : Enveloppe l'application principale

#### 2. **AppLogo** (`app_logo.dart`)
- **Utilité** : Composant réutilisable pour afficher le logo de l'application
- **Usage** : Utilisé dans les écrans de splash, onboarding, etc.

#### 3. **SAppButton** (`s_app_button.dart`)
- **Utilité** : Bouton personnalisé avec styles cohérents
- **Fonctionnalités** : Styles standardisés pour toute l'application

#### 4. **ReusableTextField** (`reusable_text_field.dart`)
- **Utilité** : Champ de texte réutilisable avec validation et styles cohérents
- **Usage** : Formulaires d'authentification, création de groupes, etc.

#### 5. **ConditionalBuilder** (`conditional_builder.dart`)
- **Utilité** : Widget pour construire conditionnellement des widgets selon l'état
- **Usage** : Affichage conditionnel basé sur les états de chargement/erreur

#### 6. **AnimatedTypingTextWithFade** (`animated_typing_text_with_fade.dart`)
- **Utilité** : Animation de texte avec effet de frappe et fondu
- **Usage** : Messages en cours de frappe, animations de texte

#### 7. **WideConstraints** (`wide_constraints.dart`)
- **Utilité** : Gestion des contraintes pour les écrans larges
- **Usage** : Adaptation de la mise en page pour tablettes/desktop

---

## 🏠 Modules Principaux

### 📍 Module Home (`lib/app/modules/home/`)

#### **HomeView** (`home_controller/views/home_view.dart`)
- **Utilité** : Écran principal de l'application
- **Fonctionnalités** :
  - Navigation par onglets (Mobile) : Annonces, Chats, Créer, Appels, Stories, Paramètres
  - Affichage adaptatif selon la taille d'écran (Mobile/Wide)
  - Compteur de messages non lus
  - Indicateur de mise à jour disponible
- **Onglets** :
  1. **Annonces** : Liste des annonces
  2. **Chats** : Liste des conversations
  3. **Créer** : Création d'annonce
  4. **Appels** : Historique des appels
  5. **Stories** : Stories des utilisateurs
  6. **Paramètres** : Paramètres utilisateur

#### **HomeWideView** (`home_wide_modules/home/view/home_wide_view.dart`)
- **Utilité** : Version adaptée pour écrans larges
- **Fonctionnalités** : Navigation multi-panneaux avec vues côte à côte

#### **RoomsTabView** (`mobile/rooms_tab/views/rooms_tab_view.dart`)
- **Utilité** : Liste des conversations/chat rooms
- **Fonctionnalités** :
  - Affichage de toutes les conversations
  - Indicateur de statut de connexion socket
  - Bouton caméra pour créer une story
  - Navigation vers les messages individuels
- **Intégration** : Utilise `v_chat_room_page` pour l'affichage

#### **CallsTabView** (`mobile/calls_tab/views/calls_tab_view.dart`)
- **Utilité** : Historique des appels (audio/vidéo)
- **Fonctionnalités** :
  - Liste de tous les appels
  - Filtrage par type (entrant/sortant/manqué)
  - Bouton pour effacer l'historique
  - Bannière publicitaire (si activée)
- **Composants** :
  - `CallItem` : Item d'appel individuel

#### **StoryTabView** (`mobile/story_tab/views/story_tab_view.dart`)
- **Utilité** : Affichage des stories des utilisateurs
- **Fonctionnalités** :
  - Liste des stories disponibles
  - Affichage des stories de l'utilisateur et de ses contacts
  - Navigation vers la vue complète d'une story
- **Composants** :
  - `StoryWidget` : Widget pour afficher une story

#### **UsersTabView** (`mobile/users_tab/views/users_tab_view.dart`)
- **Utilité** : Liste des utilisateurs disponibles
- **Fonctionnalités** : Recherche et affichage des utilisateurs

#### **SettingsTabView** (`mobile/settings_tab/views/settings_tab_view.dart`)
- **Utilité** : Paramètres principaux de l'application
- **Fonctionnalités** :
  - Paramètres de compte
  - Paramètres de confidentialité
  - Gestion des appareils
  - Aide et support
  - Langue de l'application
- **Composants** :
  - `SettingsListItemTile` : Item de liste de paramètres
  - `SheetForChooseLanguage` : Sélection de langue
  - `MediaStorageSettings` : Paramètres de stockage média

---

## 🔐 Modules d'Authentification

### 📍 Module Auth (`lib/app/modules/auth/`)

#### **SplashView** (`splash/views/splash_view.dart`)
- **Utilité** : Écran de démarrage de l'application
- **Fonctionnalités** :
  - Affichage du logo
  - Version de l'application
  - Initialisation des services
  - Redirection vers l'écran approprié (onboarding/login/home)

#### **LoginView** (`login/views/login_view.dart`)
- **Utilité** : Connexion utilisateur
- **Fonctionnalités** :
  - Authentification par email/mot de passe
  - Connexion sociale (Google, Apple, etc.)
  - QR Code pour connexion web
- **Composants** :
  - `AuthHeader` : En-tête d'authentification

#### **RegisterView** (`register/views/register_view.dart`)
- **Utilité** : Inscription de nouveaux utilisateurs
- **Fonctionnalités** :
  - Formulaire d'inscription
  - Validation des données
  - Upload de photo de profil

#### **PhoneAuthentication** (`phone_login/phone_authentication.dart`)
- **Utilité** : Authentification par numéro de téléphone
- **Fonctionnalités** :
  - Saisie du numéro de téléphone
  - Sélection du code pays
  - Envoi du code OTP

#### **OTPScreen** (`phone_login/otp_screen.dart`)
- **Utilité** : Vérification du code OTP
- **Fonctionnalités** :
  - Saisie du code à 6 chiffres
  - Vérification automatique
  - Renvoi du code

#### **ContinueGetDataScreen** (`continue_get_data/continue_get_data_screen.dart`)
- **Utilité** : Finalisation du profil après inscription
- **Fonctionnalités** :
  - Complétion des informations utilisateur
  - Upload de photo
  - Configuration initiale

#### **WaitingListPage** (`waiting_list/views/waiting_list_page.dart`)
- **Utilité** : Liste d'attente pour nouveaux utilisateurs
- **Fonctionnalités** : Gestion de l'accès limité à l'application

#### **Onboarding Pages** (`onboarding/screens/`)
- **Utilité** : Introduction à l'application pour nouveaux utilisateurs
- **Pages** :
  - `onboarding_page1.dart` : Première page d'introduction
  - `onboarding_page2.dart` : Deuxième page d'introduction
  - `onboarding_page3.dart` : Troisième page d'introduction

---

## 💬 Modules de Chat

### 📍 Module Chat Settings (`lib/app/modules/chat_settings/`)

#### **SingleRoomSettingsView** (`single_room_settings/views/single_room_settings_view.dart`)
- **Utilité** : Paramètres d'une conversation individuelle
- **Fonctionnalités** :
  - Photo de profil du contact
  - Appel audio/vidéo
  - Messages épinglés
  - Médias, documents, voix partagés
  - Recherche dans la conversation
  - Blocage/déblocage
  - Suppression de la conversation
- **Composants** :
  - `ChatSettingsListSection` : Section de paramètres
  - `ChatSettingsNavigationBar` : Barre de navigation

#### **GroupRoomSettingsView** (`group_room_settings/views/group_room_settings_view.dart`)
- **Utilité** : Paramètres d'un groupe
- **Fonctionnalités** :
  - Gestion des membres
  - Photo du groupe
  - Nom et description
  - Permissions (qui peut envoyer des messages)
  - Ajout/suppression de membres
  - Quitter le groupe
- **Composants** :
  - `SheetForAddMembersToGroup` : Ajout de membres

#### **BroadcastRoomSettingsView** (`broadcast_room_settings/views/broadcast_room_settings_view.dart`)
- **Utilité** : Paramètres d'une diffusion (broadcast)
- **Fonctionnalités** :
  - Gestion des destinataires
  - Nom de la diffusion
  - Ajout/suppression de membres
- **Composants** :
  - `SheetForAddMembersToBroadcast` : Ajout de membres

#### **ChatMediaView** (`chat_media_docs_voice/views/chat_media_view.dart`)
- **Utilité** : Affichage des médias partagés dans une conversation
- **Fonctionnalités** :
  - Galerie de photos/vidéos
  - Liste des documents
  - Enregistrements vocaux
  - Filtrage par type

#### **ChatStarMessagesPage** (`chat_star_messages/views/chat_star_messages_page.dart`)
- **Utilité** : Messages épinglés/favoris
- **Fonctionnalités** :
  - Liste des messages marqués
  - Recherche dans les messages épinglés
  - Retrait de l'épingle

### 📍 Module Create Group (`lib/app/modules/create_group/`)

#### **CreateGroupView** (`views/create_group_view.dart`)
- **Utilité** : Création d'un nouveau groupe
- **Fonctionnalités** :
  - Sélection de photo de groupe
  - Nom du groupe
  - Sélection des membres initiaux
- **Composants** :
  - `SheetForCreateGroup` : Version mobile (bottom sheet)

### 📍 Module Create Broadcast (`lib/app/modules/create_broadcast/`)

#### **CreateBroadcastView** (`views/create_broadcast_view.dart`)
- **Utilité** : Création d'une diffusion (broadcast)
- **Fonctionnalités** :
  - Nom de la diffusion
  - Sélection des destinataires
- **Composants** :
  - `SheetForCreateBroadcast` : Version mobile

### 📍 Module Choose Members (`lib/app/modules/choose_members/`)

#### **ChooseMembersView** (`views/choose_members_view.dart`)
- **Utilité** : Sélection de membres pour groupe/broadcast
- **Fonctionnalités** :
  - Liste des contacts disponibles
  - Recherche de contacts
  - Sélection multiple avec cases à cocher
- **Composants** :
  - `CupertinoCheckboxListTile` : Item avec case à cocher

### 📍 Module Group Members (`lib/app/modules/group_members/`)

#### **GroupMembersView** (`views/group_members_view.dart`)
- **Utilité** : Liste des membres d'un groupe
- **Fonctionnalités** :
  - Affichage de tous les membres
  - Rôles (admin/membre)
  - Actions (promouvoir, retirer)

### 📍 Module Broadcast Members (`lib/app/modules/broadcast_members/`)

#### **BroadcastMembersView** (`views/broadcast_members_view.dart`)
- **Utilité** : Liste des destinataires d'une diffusion
- **Fonctionnalités** : Affichage et gestion des destinataires

### 📍 Module Chats Search (`lib/app/modules/chats_search/`)

#### **ChatsSearchView** (`views/chats_search_view.dart`)
- **Utilité** : Recherche globale dans les conversations
- **Fonctionnalités** :
  - Recherche dans tous les chats
  - Filtrage par type de message
  - Navigation vers les résultats

### 📍 Module Peer Profile (`lib/app/modules/peer_profile/`)

#### **PeerProfileView** (`views/peer_profile_view.dart`)
- **Utilité** : Profil d'un autre utilisateur
- **Fonctionnalités** :
  - Photo de profil
  - Informations utilisateur
  - Actions : Message, Appel, Créer groupe
  - Stories de l'utilisateur
- **Composants** :
  - `PeerProfileChatRow` : Ligne de chat avec cet utilisateur
  - `SheetForCreateGroupFromProfile` : Créer groupe depuis le profil

---

## 📢 Modules d'Annonces

### 📍 Module Annonces (`lib/app/modules/annonces/presentation/`)

#### **AnnouncementsPage** (`announcements_page.dart`)
- **Utilité** : Liste principale des annonces
- **Fonctionnalités** :
  - Affichage de toutes les annonces
  - Recherche d'annonces
  - Filtres par localisation et date
  - Pull-to-refresh
  - Navigation vers les détails
- **Composants** :
  - `AnnoncmentComponent` : Composant d'affichage d'une annonce

#### **AnnouncementDetailPage** (`announcement_detail_page.dart`)
- **Utilité** : Détails d'une annonce spécifique
- **Fonctionnalités** :
  - Affichage complet de l'annonce
  - Images en galerie
  - Informations du vendeur
  - Actions : Contacter, Partager, Signaler

#### **CreateAnnouncementPage** (`create_announcement_page.dart`)
- **Utilité** : Création d'une nouvelle annonce
- **Fonctionnalités** :
  - Formulaire de création
  - Upload de photos multiples
  - Catégorie, prix, localisation
  - Description détaillée

#### **BoostAnnoncement** (`boost_annoncement.dart`)
- **Utilité** : Boost d'une annonce pour plus de visibilité
- **Fonctionnalités** :
  - Sélection de la durée du boost
  - Paiement des crédits
- **Composants** :
  - `BoostAnnonceBottomSheet` : Bottom sheet pour le boost

#### **ProfileScreen** (`profile_screen.dart`)
- **Utilité** : Profil de l'utilisateur (dans le contexte des annonces)
- **Fonctionnalités** :
  - Mes annonces
  - Statistiques
  - Paramètres du profil

#### **WalletScreen** (`wallet_screen.dart`)
- **Utilité** : Portefeuille de crédits
- **Fonctionnalités** :
  - Solde actuel
  - Historique des transactions
  - Achat de crédits
  - Packages disponibles
- **Composants** :
  - `PackagesScreen` : Liste des packages de crédits
  - `RecapPage` : Récapitulatif avant achat
  - `SuccesPage` : Confirmation d'achat
  - `CreditPayBottomSheet` : Paiement des crédits

#### **PaymentPage** (`payment_page.dart`)
- **Utilité** : Page de paiement pour crédits
- **Fonctionnalités** :
  - Méthodes de paiement
  - Validation de la transaction

#### **ImageViewer** (`image_viewer.dart`)
- **Utilité** : Visualiseur d'images plein écran
- **Fonctionnalités** :
  - Zoom et navigation
  - Galerie d'images

#### **CustomTextField** (`custom_text_field.dart`)
- **Utilité** : Champ de texte personnalisé pour les annonces
- **Fonctionnalités** : Styles et validations spécifiques

---

## 📸 Modules de Story

### 📍 Module Story (`lib/app/modules/story/`)

#### **StoryViewPage** (`story_view_page/story_view_page.dart`)
- **Utilité** : Visualisation complète d'une story
- **Fonctionnalités** :
  - Lecture automatique des stories
  - Navigation entre stories
  - Marquer comme vu
  - Actions : Répondre, Partager, Voir les vues
  - Navigation vers le profil
- **Intégration** : Utilise le package `story_view`

#### **CreateMediaStory** (`media_story/create_media_story.dart`)
- **Utilité** : Création d'une story avec média (photo/vidéo)
- **Fonctionnalités** :
  - Sélection depuis la galerie
  - Prise de photo/vidéo
  - Édition (filtres, texte, stickers)
  - Publication

#### **CreateTextStory** (`text_story/create_text_story.dart`)
- **Utilité** : Création d'une story texte uniquement
- **Fonctionnalités** :
  - Saisie de texte
  - Choix de couleur de fond
  - Styles de texte
  - Publication

#### **StoryViewersScreen** (`story_views/story_viewers_screen.dart`)
- **Utilité** : Liste des personnes qui ont vu une story
- **Fonctionnalités** :
  - Liste des viewers
  - Statistiques de vues

---

## ⚙️ Modules de Paramètres

### 📍 Module Settings (`lib/app/modules/home/settings_modules/`)

#### **MyAccountPage** (`my_account/views/my_account_page.dart`)
- **Utilité** : Paramètres du compte utilisateur
- **Fonctionnalités** :
  - Informations personnelles
  - Photo de profil
  - Changement de mot de passe
  - Suppression du compte
- **Composants** :
  - `SheetForUpdatePassword` : Changement de mot de passe

#### **MyPrivacyPage** (`my_privacy/my_privacy_page.dart`)
- **Utilité** : Paramètres de confidentialité
- **Fonctionnalités** :
  - Visibilité du profil
  - Qui peut vous contacter
  - Blocage de contacts
  - Paramètres de dernière connexion

#### **BlockedContactsPage** (`blocked_contacts/views/blocked_contacts_page.dart`)
- **Utilité** : Liste des contacts bloqués
- **Fonctionnalités** :
  - Affichage des contacts bloqués
  - Déblocage

#### **LinkedDevicesPage** (`devices/linked_devices/views/linked_devices_page.dart`)
- **Utilité** : Gestion des appareils connectés
- **Fonctionnalités** :
  - Liste des appareils
  - Statut de chaque appareil
  - Déconnexion d'un appareil
- **Composants** :
  - `SheetForDeviceStatus` : Détails d'un appareil
  - `DeviceStatusPage` : Page de statut détaillée

#### **LinkByQrCodePage** (`devices/link_by_qr_code/views/link_by_qr_code_page.dart`)
- **Utilité** : Lier un appareil via QR code
- **Fonctionnalités** :
  - Génération de QR code
  - Scan de QR code
  - Appairage d'appareil

#### **AdminNotificationPage** (`admin_notification/views/admin_notification_page.dart`)
- **Utilité** : Notifications administratives
- **Fonctionnalités** :
  - Messages de l'administration
  - Notifications système

#### **HelpPage** (`help_tab/help/views/help_page.dart`)
- **Utilité** : Centre d'aide
- **Fonctionnalités** :
  - FAQ
  - Contact support
  - Tutoriels

#### **PrivacyPolicyPage** (`help_tab/privacy_policy/views/privacy_policy_page.dart`)
- **Utilité** : Politique de confidentialité
- **Fonctionnalités** : Affichage de la politique

---

## 🛠️ Modules Utilitaires

### 📍 Module Report (`lib/app/modules/report/`)

#### **ReportPage** (`views/report_page.dart`)
- **Utilité** : Signaler un contenu/utilisateur
- **Fonctionnalités** :
  - Sélection du type de signalement
  - Description du problème
  - Envoi du rapport

### 📍 Widgets Partagés (`lib/app/modules/chat_settings/widgets/`)

#### **ChatSettingsListSection** (`chat_settings_list_section.dart`)
- **Utilité** : Section réutilisable pour les paramètres de chat
- **Fonctionnalités** : Icône, titre, action

#### **ChatSettingsNavigationBar** (`chat_settings_navigation_bar.dart`)
- **Utilité** : Barre de navigation standardisée pour les paramètres
- **Fonctionnalités** : Titre, bouton retour

#### **ChatIconWithText** (`chat_icon_with_text.dart`)
- **Utilité** : Icône avec texte pour les actions de chat
- **Usage** : Boutons d'action (appel, message, etc.)

#### **LanguageTile** (`language_tile.dart`)
- **Utilité** : Tuile pour sélectionner la langue
- **Fonctionnalités** : Affichage de la langue actuelle

---

## 🎨 Composants Widgets Spécialisés

### Widgets de Chat
- **ChatUnReadCounter** : Compteur de messages non lus avec badge
- **CallItem** : Item d'appel avec informations (durée, type, statut)

### Widgets d'Annonces
- **AnnoncmentComponent** : Carte d'affichage d'annonce avec image, titre, prix
- **CreditPayBottomSheet** : Bottom sheet pour paiement de crédits

### Widgets de Navigation
- **WideRoomsNavigation** : Navigation pour écrans larges (liste des rooms)
- **WideMessagesNavigation** : Navigation pour écrans larges (messages)
- **WideChatInfoNavigation** : Navigation pour écrans larges (infos de chat)

---

## 📱 Architecture Mobile vs Wide

### Mobile
- Navigation par onglets (CupertinoTabScaffold)
- Bottom sheets pour les modales
- Navigation stack standard

### Wide (Tablettes/Desktop)
- Navigation multi-panneaux
- Vues côte à côte
- Navigation sans animation
- Support de plusieurs vues simultanées

---

## 🔗 Intégrations Externes

L'application utilise plusieurs packages externes pour les fonctionnalités de chat :
- **v_chat_sdk_core** : SDK de chat principal
- **v_chat_room_page** : Pages de chat
- **v_chat_message_page** : Pages de messages
- **v_chat_media_editor** : Édition de médias
- **v_platform** : Utilitaires multiplateformes
- **super_up_core** : Core de l'application Super Up

---

## 📊 Statistiques

- **Total de modules** : ~15 modules principaux
- **Total de vues/pages** : ~40+ écrans
- **Total de widgets réutilisables** : ~20+ widgets
- **Architecture** : Modulaire avec séparation claire des responsabilités
- **Support** : Mobile (iOS/Android) et Wide (Tablettes/Desktop)

---

## 🎯 Points d'Intérêt

### Modules les plus complexes :
1. **Home** : Gère toute la navigation principale
2. **Annonces** : Système complet de marketplace avec paiements
3. **Chat Settings** : Gestion avancée des paramètres de conversation
4. **Story** : Système complet de stories avec édition

### Modules les plus réutilisables :
1. **Core Widgets** : Widgets de base utilisés partout
2. **Chat Settings Widgets** : Composants réutilisables pour les paramètres
3. **Navigation** : Système de navigation adaptatif

### Fonctionnalités uniques :
1. **Système d'annonces intégré** : Marketplace dans l'app de chat
2. **Stories** : Système de stories similaire à Instagram/Snapchat
3. **Navigation adaptative** : Support mobile et desktop avec UI adaptée
4. **Système de crédits** : Portefeuille intégré pour les annonces

