import 'dart:async';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up/app/core/api_service/auth/auth_api_service.dart';
import 'package:super_up/app/core/api_service/profile/profile_api_service.dart';
import 'package:super_up/app/core/app_nav/app_navigation.dart';
import 'package:super_up/app/modules/annonces/datas/services/api_services.dart';
import 'package:super_up/app/modules/annonces/datas/utils.dart';
import 'package:super_up/app/modules/auth/auth_utils.dart';
import 'package:super_up/app/modules/auth/continue_get_data/continue_get_data_screen.dart';
import 'package:super_up/app/modules/auth/phone_login/otp_screen.dart';
import 'package:super_up/app/modules/auth/phone_login/phone_authentication.dart';
import 'package:super_up/app/modules/auth/waiting_list/views/waiting_list_page.dart';
import 'package:super_up/app/modules/home/home_controller/views/home_view.dart';
import 'package:super_up/main.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart' show VPlatforms;

class SocialUser {
  String authId;
  String? identifier;
  String? email;
  String? name;
  String? photo;
  // phone
  String? phone;
  RegisterMethod type;

//<editor-fold desc="Data Methods">
  SocialUser({
    required this.authId,
    this.email,
    this.identifier,
    this.name,
    this.photo,
    this.phone,
    required this.type,
  });

  @override
  String toString() {
    return 'SocialUser{ identifier: $authId, email: $email, name: $name, photo: $photo, phone: $phone, type: $type,}';
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'identifier': authId,
  //     'email': email,
  //     'name': name,
  //     'phone': phone,
  //     // 'identifier': identifier,
  //     'photo': photo,
  //     'type': type.name,
  //   };
  // }

//</editor-fold>
}

class SocialLoginAuth {
  // static final _googleSignIn = GoogleSignIn();
  static final auth = FirebaseAuth.instance;
  static final authService = GetIt.I<AuthApiService>();
  static final profileService = GetIt.I<ProfileApiService>();

  static Future<void> emailSignIn({
    required String email,
    required String password,
  }) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> emailCreateAccount({
    required String email,
    required String password,
  }) async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<SocialUser?> phoneSignIn(String phoneNumber) async {
    final context = navigatorKey.currentState!.context;
    VAppAlert.showLoading(context: context);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed (mainly on Android)
          print("error in verificationCompleted $credential");
          // context.pop(); // Dismiss loading
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);
            await profileService.getMyProfile().then((e) async {
              // Navigator.pop(context);
              await VAppPref.setMap(SStorageKeys.myProfile.name, e.toMap());
              await VAppPref.setBool(SStorageKeys.isLogin.name, true);
              _homeNav(context);
            });
            // print(result);
            return;

            // AppNavigation.toPage(
            //   context,
            //   ContinueGetDataScreen(
            //     socialUser: SocialUser(
            //       authId: phoneNumber,
            //       type: RegisterMethod.phone,
            //     ),
            //   ),
            // );
          } catch (e) {
            print("error in verificationCompleted $e");
            Navigator.pop(context);
            _handleFirebaseAuthError(context, e);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print("error in verificationCompleted in verificationFailed $e");
          context.pop(); // Dismiss loading
          _handleFirebaseAuthError(context, e);
        },
        codeSent: (String verificationId, int? resendToken) {
          context.pop(); // Dismiss loading
          AppNavigation.toPage(
            context,
            OTPScreen(
              verificationId: verificationId,
              userPhone: phoneNumber,
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Only handle if loading is still shown (no code sent yet)
          if (ModalRoute.of(context)?.isCurrent != true) return;

          context.pop(); // Dismiss loading if still showing
          VAppAlert.showOkAlertDialog(
            context: context,
            title: S.of(context).error,
            //todo trans
            content: "Verification code request timed out. Please try again.",
          );
        },
      );

      return SocialUser(
        authId: phoneNumber,
        type: RegisterMethod.phone,
      );
    } catch (e) {
      print("error in verificationCompleted in catch $e");
      context.pop(); // Ensure loading is dismissed
      _handleFirebaseAuthError(context, e);
      return null;
    }
  }

  static final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  static StreamSubscription<GoogleSignInAuthenticationEvent>?
      _googleAuthSubscription;

  /// Initialize Google Sign-In and set up listener.
  /// This should be called during app initialization.
  static Future<void> initializeGoogleSignIn(BuildContext context) async {
    await googleSignIn.initialize();

    // Listen to authentication events
    _googleAuthSubscription?.cancel();
    _googleAuthSubscription = googleSignIn.authenticationEvents.listen(
      (GoogleSignInAuthenticationEvent event) {
        _handleGoogleAuthenticationEvent(context, event);
      },
      onError: (error) {
        print("Google Sign-In error: $error");
      },
    );

    // Attempt lightweight authentication (silent sign-in)
    await googleSignIn.attemptLightweightAuthentication();
  }

  /// Handle authentication events from Google Sign-In
  static Future<void> _handleGoogleAuthenticationEvent(
    BuildContext context,
    GoogleSignInAuthenticationEvent event,
  ) async {
    final GoogleSignInAccount? user = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    if (user != null) {
      // User signed in, process the authentication
      await _processGoogleUser(context, user);
    }
  }

  /// Process the Google user after successful sign-in via the stream
  static Future<void> _processGoogleUser(
    BuildContext context,
    GoogleSignInAccount user,
  ) async {
    try {
      final GoogleSignInAuthentication googleAuth = await user.authentication;

      Utils.printLog("Id Token : ${googleAuth.idToken}");

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final firebaseUser =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (firebaseUser.user != null) {
        final firebaseUserData = firebaseUser.user!;
        await firebaseUserData.updateDisplayName(user.displayName);
        await firebaseUserData.updatePhotoURL(user.photoUrl);
        await firebaseUserData.reload();

        // Après login Google réussi, rediriger vers la vérification du numéro de téléphone
        if (context.mounted) {
          AppNavigation.toPage(
            context,
            const PhoneAuthentication(),
          );
        }
        return;
      } else {
        if (context.mounted) {
          VAppAlert.showOkAlertDialog(
            context: context,
            title: S.of(context).error,
            content: "Login failed. Please try again.",
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        VAppAlert.showOkAlertDialog(
          context: context,
          title: S.of(context).error,
          content: e.message ?? e.code,
        );
      }
    } catch (e) {
      if (context.mounted) {
        VAppAlert.showOkAlertDialog(
          context: context,
          title: S.of(context).error,
          content: e.toString(),
        );
      }
    }
  }

  /// Trigger Google Sign-In for mobile platforms.
  /// On web, the renderButton handles this automatically.
  static Future<void> loginByGoogle(BuildContext context) async {
    if (kIsWeb) {
      // On web, authentication is handled by renderButton
      // which triggers the authenticationEvents stream
      return;
    }

    // On mobile, trigger the sign-in flow
    try {
      await googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );
      // The authenticationEvents stream will handle the rest
    } on GoogleSignInException catch (e) {
      VAppAlert.showOkAlertDialog(
        context: context,
        title: S.of(context).error,
        content: e.toString(),
      );
    } catch (e) {
      VAppAlert.showOkAlertDialog(
        context: context,
        title: S.of(context).error,
        content: e.toString(),
      );
    }
  }

  static void _homeNav(BuildContext context) {
    context.toPage(
      const HomeView(),
      withAnimation: true,
      removeAll: true,
    );
  }

// Helper method to handle Firebase Auth errors with localized messages
  static void _handleFirebaseAuthError(BuildContext context, dynamic error) {
    String errorMessage;
    print(error);
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-phone-number':
          errorMessage =
              "The phone number format is incorrect. Please enter a valid number.";
          break;
        case 'too-many-requests':
          errorMessage =
              "We've received too many requests from this device. Try again later.";
          break;
        case 'quota-exceeded':
          errorMessage = "The SMS quota for the project has been exceeded.";
          break;
        case 'user-disabled':
          errorMessage =
              "This account has been disabled. Please contact support.";
          break;
        case 'app-not-authorized':
          errorMessage =
              "This app is not authorized to use Firebase Authentication.";
          break;
        case 'captcha-check-failed':
          errorMessage = "The reCAPTCHA verification failed. Please try again.";
          break;
        case 'missing-phone-number':
          errorMessage = "Please provide a phone number.";
          break;
        case 'session-expired':
          errorMessage =
              "The verification session has expired. Please try again.";
          break;
        case 'network-request-failed':
          errorMessage =
              "A network error occurred. Please check your connection and try again.";
          break;
        default:
          errorMessage = "Verification failed: ${error.message ?? error.code}";
          break;
      }
    } else if (error is TimeoutException) {
      //todo trans
      errorMessage = "Verification timed out. Please try again.";
    } else {
      //todo trans
      errorMessage = "An unknown error occurred. Please try again.";
      if (kDebugMode) {
        print("Firebase Phone Auth Error: $error");
      }
    }

    // Show error dialog
    VAppAlert.showOkAlertDialog(
      context: context,
      title: S.of(context).error,
      content: errorMessage,
    );
  }
}
