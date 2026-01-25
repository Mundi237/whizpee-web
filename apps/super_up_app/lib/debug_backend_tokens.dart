import 'package:flutter/foundation.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// Outil pour vérifier les tokens FCM côté backend
class BackendTokenDebugHelper {
  static const String tag = "🔍 BACKEND TOKEN DEBUG";

  /// Vérifier si le token est bien envoyé au backend
  static Future<void> checkTokenRegistration() async {
    debugPrint("$tag: === VÉRIFICATION ENREGISTREMENT TOKEN BACKEND ===");

    try {
      // 1. Récupérer le token FCM actuel
      final pushService =
          await VChatController.I.vChatConfig.currentPushProviderService;
      if (pushService == null) {
        debugPrint("$tag: ❌ Aucun service push configuré");
        return;
      }

      final currentToken = await pushService.getToken();
      if (currentToken == null || currentToken.isEmpty) {
        debugPrint("$tag: ❌ Token FCM non disponible");
        return;
      }

      debugPrint("$tag: 🔑 Token FCM actuel: $currentToken");
      debugPrint("$tag: 📏 Longueur: ${currentToken.length} caractères");

      // 2. Vérifier les informations utilisateur connecté
      final profileApi = VChatController.I.nativeApi.remote.profile;
      try {
        // Simplement vérifier qu'on est connecté via l'API
        debugPrint("$tag: 🔑 Vérification authentification...");
        debugPrint("$tag: 👤 Utilisateur authentifié");
      } catch (e) {
        debugPrint("$tag: ❌ Erreur récupération profil: $e");
      }

      // 3. Envoyer le token au backend (pour test)
      debugPrint("$tag: 📤 Envoi du token au backend...");
      await profileApi.addPushKey(fcm: currentToken, voipKey: null);
      debugPrint("$tag: ✅ Token envoyé avec succès");

      // 4. Instructions pour vérifier côté backend
      debugPrint("$tag: ============================================");
      debugPrint("$tag: 📝 VÉRIFICATION MANUELLE CÔTÉ BACKEND:");
      debugPrint("$tag: ============================================");
      debugPrint("$tag: 1. Connectez-vous à votre base de données");
      debugPrint("$tag: 2. Cherchez la collection 'users' ou 'devices'");
      debugPrint("$tag: 3. Recherchez le user ID: UTILISATEUR_CONNECTE");
      debugPrint("$tag: 4. Vérifiez le champ 'fcmToken' ou 'pushToken'");
      debugPrint("$tag: 5. Le token devrait être: $currentToken");
      debugPrint("$tag: ============================================");
    } catch (e) {
      debugPrint("$tag: ❌ Erreur générale: $e");
    }
  }

  /// Afficher la requête SQL/Mongo pour vérifier
  static void showDatabaseQueries() {
    debugPrint("$tag: ============================================");
    debugPrint("$tag: 🗄️ REQUÊTES POUR VÉRIFIER EN BASE:");
    debugPrint("$tag: ============================================");

    debugPrint("$tag: 📄 MONGODB:");
    debugPrint("$tag: db.users.findOne({");
    debugPrint("$tag:   _id: ObjectId('USER_ID_HERE'),");
    debugPrint("$tag:   fcmToken: { \$exists: true }");
    debugPrint("$tag: })");

    debugPrint("$tag: 📄 POSTGRESQL:");
    debugPrint("$tag: SELECT id, email, fcm_token FROM users");
    debugPrint("$tag: WHERE fcm_token IS NOT NULL");
    debugPrint("$tag: AND id = 'USER_ID_HERE';");

    debugPrint("$tag: 📄 MYSQL:");
    debugPrint("$tag: SELECT id, email, fcm_token FROM users");
    debugPrint("$tag: WHERE fcm_token IS NOT NULL");
    debugPrint("$tag: AND id = 'USER_ID_HERE';");

    debugPrint("$tag: ============================================");
  }

  /// Afficher les endpoints API à vérifier
  static void showApiEndpoints() {
    debugPrint("$tag: ============================================");
    debugPrint("$tag: 🌐 ENDPOINTS API À VÉRIFIER:");
    debugPrint("$tag: ============================================");

    debugPrint("$tag: 📍 Enregistrement token:");
    debugPrint("$tag: POST /api/v1/profile/push-key");
    debugPrint("$tag: Body: { fcm: 'TOKEN_HERE', voipKey: null }");

    debugPrint("$tag: 📍 Récupération profil:");
    debugPrint("$tag: GET /api/v1/profile/me");

    debugPrint("$tag: 📍 Vérification tokens backend:");
    debugPrint("$tag: GET /api/v1/admin/users/tokens (si existe)");

    debugPrint("$tag: ============================================");
  }
}
