# 🚀 Guide de Lancement - Super Up App

## Prérequis Vérifiés ✅
- Flutter 3.38.4 installé
- Dart 3.10.3 installé
- Melos configuré
- Dépendances installées (`melos bs` exécuté)

## Options de Lancement

### Option 1: Lancer sur Android (Recommandé)
```bash
# Connecter un appareil Android ou démarrer un émulateur
flutter emulators --launch <emulator_id>

# Ou vérifier les appareils disponibles
flutter devices

# Lancer l'app
cd apps/super_up_app
flutter run -d <device_id>
```

### Option 2: Lancer sur iOS (si sur macOS)
```bash
cd apps/super_up_app
flutter run -d <ios_device_id>
```

### Option 3: Lancer sur Web (avec limitations)
**⚠️ Problème actuel:** Firebase n'est pas configuré pour Web

**Solution temporaire:**
```bash
cd apps/super_up_app
flutter run -d chrome
```

**Note:** L'app crashera au démarrage car:
- Firebase n'est pas configuré pour Web (voir `firebase_options.dart`)
- Le backend `api.whizpee.com` doit être accessible

### Option 4: Lancer sur Linux Desktop
**⚠️ Problème:** Firebase n'est pas configuré pour Linux

## Configuration Requise

### 1. Backend API
L'application nécessite un serveur backend accessible:
- **URL Production:** `https://api.whizpee.com/api/v1`
- **Alternative:** Configurer un serveur local dans `packages/super_up_core/lib/src/s_constants.dart`

```dart
// Pour utiliser un serveur local:
static const _productionBaseUrl = "192.168.1.120:3000";
```

### 2. Firebase Configuration
Pour activer Web/Linux, exécuter:
```bash
# Installer FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurer Firebase pour toutes les plateformes
cd apps/super_up_app
flutterfire configure
```

### 3. Services Tiers (Optionnels)
Configurer dans `packages/super_up_core/lib/src/s_constants.dart`:
- **Agora** (appels vidéo): `agoraAppId`
- **Google Maps**: `googleMapsApiKey`
- **OneSignal** (notifications): `oneSignalAppId`
- **AdMob** (publicités): `androidBannerAdsUnitId`, `iosBannerAdsUnitId`

## Commandes Melos Utiles

```bash
# Bootstrap (installer toutes les dépendances)
melos bs

# Générer le code (build_runner)
melos g_app

# Analyser le code
melos analyze

# Formater le code
melos format

# Build Android APK
melos build_android

# Build Web
melos build_web
```

## Structure de l'Application

```
apps/super_up_app/
├── lib/
│   ├── main.dart                    # Point d'entrée
│   ├── firebase_options.dart        # Config Firebase
│   ├── app/
│   │   ├── core/                    # Infrastructure
│   │   │   ├── initialization/      # Initialisation app
│   │   │   ├── api_service/         # Services API
│   │   │   └── utils/               # Utilitaires
│   │   └── modules/                 # Fonctionnalités
│   │       ├── splash/              # Écran de démarrage
│   │       ├── auth/                # Authentification
│   │       ├── home/                # Écran principal
│   │       ├── chat_settings/       # Paramètres chat
│   │       └── story/               # Stories
│   └── v_chat_v2/                   # Configuration V-Chat
└── pubspec.yaml
```

## Dépannage

### Erreur: "VAppPref.instance is null"
**Cause:** L'initialisation de SharedPreferences a échoué
**Solution:** Vérifier que Firebase est correctement configuré pour la plateforme cible

### Erreur: "Firebase not configured for platform"
**Solution:** Exécuter `flutterfire configure` pour la plateforme

### Erreur de connexion au backend
**Solution:** 
1. Vérifier que `api.whizpee.com` est accessible
2. Ou configurer un serveur local dans `s_constants.dart`

## Lancement Rapide (Android)

```bash
# 1. Vérifier les appareils
flutter devices

# 2. Lancer sur Android
cd apps/super_up_app
flutter run

# L'app devrait se lancer et afficher l'écran de splash
```

## Fonctionnalités Principales

- 💬 **Chat en temps réel** (Socket.IO)
- 📞 **Appels audio/vidéo** (Agora)
- 📸 **Stories** (photos/vidéos)
- 👥 **Groupes & Broadcasts**
- 🔔 **Notifications push** (FCM/OneSignal)
- 📍 **Partage de localisation** (Google Maps)
- 🎨 **Éditeur de médias**
- 🌐 **Multi-plateforme** (Android, iOS, Web, Desktop)

## Notes Importantes

1. **Backend requis:** L'app ne peut pas fonctionner sans backend
2. **Firebase requis:** Pour l'authentification et les notifications
3. **Mode développement:** Utiliser un émulateur Android pour les tests
4. **Production:** Configurer tous les services tiers avant le déploiement
