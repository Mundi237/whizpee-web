import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:flutter/foundation.dart';

/// Debug tool pour diagnostiquer les problèmes de notifications FCM
class NotificationDebugHelper {
  static const String tag = "🔔 NOTIFICATION DEBUG";

  /// Étape 1: Vérifier la configuration Firebase et les permissions
  static Future<void> checkFirebaseConfiguration() async {
    debugPrint("$tag: === VÉRIFICATION CONFIGURATION FIREBASE ===");

    try {
      // Vérifier si Firebase est initialisé
      if (Firebase.apps.isEmpty) {
        debugPrint("$tag: ❌ Firebase n'est pas initialisé");
        return;
      } else {
        debugPrint("$tag: ✅ Firebase est initialisé");
        debugPrint("$tag: 📱 App ID: ${Firebase.apps.first.options.appId}");
        debugPrint(
            "$tag: 🌐 Project ID: ${Firebase.apps.first.options.projectId}");
      }

      // Vérifier les permissions de notification
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();
      debugPrint(
          "$tag: 📋 Status permissions: ${settings.authorizationStatus}");

      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
          debugPrint("$tag: ✅ Notifications autorisées");
          break;
        case AuthorizationStatus.denied:
          debugPrint("$tag: ❌ Notifications refusées par l'utilisateur");
          break;
        case AuthorizationStatus.notDetermined:
          debugPrint("$tag: ⏳ Permissions non encore demandées");
          break;
        case AuthorizationStatus.provisional:
          debugPrint("$tag: 🔄 Permissions provisionnelles");
          break;
      }

      // Demander les permissions si nécessaire
      if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        debugPrint("$tag: 📝 Demande des permissions...");
        await FirebaseMessaging.instance.requestPermission(
          sound: true,
          badge: true,
          alert: true,
          criticalAlert: true,
        );
      }
    } catch (e) {
      debugPrint("$tag: ❌ Erreur configuration Firebase: $e");
    }
  }

  /// Étape 2: Récupérer et afficher le token FCM
  static Future<void> checkFcmToken() async {
    debugPrint("$tag: === VÉRIFICATION TOKEN FCM ===");

    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        debugPrint("$tag: ✅ Token FCM récupéré:");
        debugPrint("$tag: 🔑 Token: $token");
        debugPrint("$tag: 📏 Longueur: ${token.length} caractères");

        // Vérifier le format du token
        if (token.length > 100) {
          debugPrint("$tag: ✅ Format du token semble correct");
        } else {
          debugPrint("$tag: ⚠️ Token semble trop court, possible problème");
        }
      } else {
        debugPrint("$tag: ❌ Token FCM null ou non récupéré");
      }

      // Écouter les rafraîchissements de token
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        debugPrint("$tag: 🔄 Token rafraîchi: $newToken");
      });
    } catch (e) {
      debugPrint("$tag: ❌ Erreur récupération token: $e");
    }
  }

  /// Étape 3: Tester l'envoi de notification locale
  static Future<void> testLocalNotification() async {
    debugPrint("$tag: === TEST NOTIFICATION LOCALE ===");

    try {
      // Simuler une notification locale via VChat
      final eventBus = VEventBusSingleton.vEventBus;

      // Envoyer un événement de notification test
      eventBus.fire(VOnNewNotifications(
        title: "🧪 Test Notification",
        body: "Ceci est une notification de test locale",
      ));

      debugPrint("$tag: ✅ Notification locale envoyée");
    } catch (e) {
      debugPrint("$tag: ❌ Erreur notification locale: $e");
    }
  }

  /// Étape 4: Vérifier l'envoi du token au backend
  static Future<void> checkTokenToBackend() async {
    debugPrint("$tag: === VÉRIFICATION ENVOI TOKEN BACKEND ===");

    try {
      // Récupérer le service push actuel
      final pushService =
          await VChatController.I.vChatConfig.currentPushProviderService;
      if (pushService == null) {
        debugPrint("$tag: ❌ Aucun service push configuré");
        return;
      }

      debugPrint("$tag: 📡 Service push: ${pushService.serviceName()}");

      // Récupérer le token
      final token = await pushService.getToken();
      if (token == null || token.isEmpty) {
        debugPrint("$tag: ❌ Token null ou vide depuis le service push");
        return;
      }

      debugPrint("$tag: 🔑 Token depuis service: $token");

      // Vérifier si le token est déjà envoyé au backend
      final profileApi = VChatController.I.nativeApi.remote.profile;
      debugPrint("$tag: 📤 Envoi du token au backend...");

      await profileApi.addPushKey(fcm: token, voipKey: null);
      debugPrint("$tag: ✅ Token envoyé au backend avec succès");
    } catch (e) {
      debugPrint("$tag: ❌ Erreur envoi token backend: $e");
    }
  }

  /// Étape 5: Afficher les informations de diagnostic complètes
  static Future<void> runFullDiagnostic() async {
    debugPrint("$tag: ============================================");
    debugPrint("$tag: 🚀 DÉMARRAGE DIAGNOSTIC COMPLET NOTIFICATIONS");
    debugPrint("$tag: ============================================");

    await checkFirebaseConfiguration();
    await Future.delayed(const Duration(seconds: 1));

    await checkFcmToken();
    await Future.delayed(const Duration(seconds: 1));

    await checkTokenToBackend();
    await Future.delayed(const Duration(seconds: 1));

    await testLocalNotification();

    debugPrint("$tag: ============================================");
    debugPrint("$tag: ✅ DIAGNOSTIC TERMINÉ");
    debugPrint("$tag: ============================================");

    // Instructions pour tester depuis Firebase Console
    debugPrint("$tag: 📝 INSTRUCTIONS POUR TEST MANUEL:");
    debugPrint("$tag: 1. Allez sur https://console.firebase.google.com");
    debugPrint("$tag: 2. Sélectionnez le projet 'whizpee-91213'");
    debugPrint("$tag: 3. Allez dans Cloud Messaging > Créer une notification");
    debugPrint(
        "$tag: 4. Ciblez par 'Token FCM' avec le token affiché ci-dessus");
    debugPrint("$tag: 5. Envoyez et vérifiez la réception");
  }
}

/// Widget pour lancer le diagnostic depuis l'app
class NotificationDebugWidget extends StatelessWidget {
  const NotificationDebugWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Debug Notifications"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await NotificationDebugHelper.runFullDiagnostic();
              },
              child: const Text("🚀 Lancer Diagnostic Complet"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await NotificationDebugHelper.checkFcmToken();
              },
              child: const Text("🔑 Vérifier Token FCM"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await NotificationDebugHelper.testLocalNotification();
              },
              child: const Text("🔔 Tester Notification Locale"),
            ),
          ],
        ),
      ),
    );
  }
}
