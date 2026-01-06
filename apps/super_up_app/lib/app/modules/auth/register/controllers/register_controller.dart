// // Copyright 2023,
// // All rights reserved. Use of this source code is governed by a
// // MIT license that can be found in the LICENSE file.
//
// import 'dart:async';
//
// import 'package:email_validator/email_validator.dart';
// import 'package:enum_to_string/enum_to_string.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:super_up/app/core/app_nav/app_navigation.dart';
// import 'package:super_up/app/modules/auth/continue_get_data/continue_get_data_screen.dart';
// import 'package:super_up/app/modules/auth/waiting_list/views/waiting_list_page.dart';
// import 'package:super_up_core/super_up_core.dart';
// import 'package:s_translation/generated/l10n.dart';
// import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
// import 'package:v_platform/v_platform.dart';
//
// import '../../../../core/api_service/auth/auth_api_service.dart';
// import '../../../../core/api_service/profile/profile_api_service.dart';
// import '../../../../core/app_config/app_config_controller.dart';
// import '../../../home/home_controller/views/home_view.dart';
// import '../../auth_utils.dart';
// import '../../social_login_auth.dart';
//
// /// Controller responsible for handling user registration.
// class RegisterController extends ValueNotifier implements SBaseController {
//   // Controllers for input fields
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmController = TextEditingController();
//
//   // Services injected via dependency injection
//   final AuthApiService authService;
//   final ProfileApiService profileService;
//
//   // Helper for device-related information
//   final DeviceInfoHelper deviceHelper = DeviceInfoHelper();
//
//   // Flag to prevent multiple registration attempts simultaneously
//   bool isRegistering = false;
//
//   RegisterController(
//     this.authService,
//     this.profileService,
//   ) : super(null);
//
//   @override
//   void onInit() {
//     if (kDebugMode) {
//       // Pre-fill fields for debugging purposes
//       nameController.text = "Test User";
//       emailController.text = "testuser@example.com";
//       passwordController.text = "Password123";
//       confirmController.text = "Password123";
//     }
//   }
//
//   @override
//   void onClose() {
//     // Dispose controllers to free up resources
//     nameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     confirmController.dispose();
//   }
//
//   /// Initiates the user registration process.
//   Future<void> register(BuildContext context) async {
//     if (isRegistering) return; // Prevent multiple registration attempts
//
//     final name = nameController.text.trim();
//     final email = emailController.text.trim();
//     final password = passwordController.text;
//     final confirmPassword = confirmController.text;
//
//     // Input Validation
//     if (name.isEmpty) {
//       VAppAlert.showErrorSnackBar(
//         message: S.of(context).nameMustHaveValue,
//         context: context,
//       );
//       return;
//     }
//
//     if (!EmailValidator.validate(email)) {
//       VAppAlert.showErrorSnackBar(
//         message: S.of(context).emailNotValid,
//         context: context,
//       );
//       return;
//     }
//
//     if (password.isEmpty) {
//       VAppAlert.showErrorSnackBar(
//         message: S.of(context).passwordMustHaveValue,
//         context: context,
//       );
//       return;
//     }
//
//     if (password != confirmPassword) {
//       VAppAlert.showErrorSnackBar(
//         message: S.of(context).passwordNotMatch,
//         context: context,
//       );
//       return;
//     }
//
//     if (_isLoginNotAllowed()) {
//       VAppAlert.showErrorSnackBar(
//         message: S.of(context).loginNowAllowedNowPleaseTryAgainLater,
//         context: context,
//       );
//       return;
//     }
//
//     // Perform the registration
//     await _performRegistration(
//       context,
//       name: name,
//       email: email,
//       password: password,
//     );
//   }
//   void updateRegisterStatus(bool x) {
//     isRegistering = x;
//     notifyListeners();
//   }
//
//
//   /// Core method to handle the registration process.
//   Future<void> _performRegistration(
//     BuildContext context, {
//     required String name,
//     required String email,
//     String? password,
//     RegisterMethod loginMethod = RegisterMethod.email,
//   }) async {
//     if (isRegistering) {
//       return; // Double-check to prevent multiple registrations
//     }
//     updateRegisterStatus(true);
//     try {
//       // Obtain the push notification token
//       final pushKey =
//           await (await VChatController.I.vChatConfig.currentPushProviderService)
//               ?.getToken(VPlatforms.isWeb ? SConstants.webVapidKey : null);
//
//       // Prepare the registration DTO
//       final registerDto = RegisterDto(
//         email: email,
//         method: loginMethod,
//         authId: email,
//         identifier: null,
//         phone: null,
//         image: null,
//         fullName: name,
//         pushKey: pushKey,
//         deviceInfo: await deviceHelper.getDeviceMapInfo(),
//         deviceId: await deviceHelper.getId(),
//         language: VLanguageListener.I.appLocal.languageCode,
//         platform: VPlatforms.currentPlatform,
//         password: password,
//       );
//
//       // Perform the registration API call
//       await authService.register(registerDto);
//
//       // If registering via email/password, create the account in social login
//       if (loginMethod == RegisterMethod.email && password != null) {
//         await SocialLoginAuth.emailCreateAccount(
//           email: email,
//           password: password,
//         );
//       }
//
//       // Retrieve user profile
//       final profile = await profileService.getMyProfile();
//
//       // Save profile data locally
//       await VAppPref.setMap(SStorageKeys.myProfile.name, profile.toMap());
//
//       // Handle navigation based on registration status
//       final status = profile.registerStatus;
//       if (status == RegisterStatus.accepted) {
//         await VAppPref.setBool(SStorageKeys.isLogin.name, true);
//         _navigateToHome(context);
//       } else {
//         AppNavigation.toPage(
//           context,
//           WaitingListPage(profile: profile),
//           withAnimation: true,
//           isRemoveAll: true,
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       // Handle Firebase-specific authentication errors
//       String errorMessage = _mapFirebaseAuthExceptionToMessage(e);
//
//       VAppAlert.showOkAlertDialog(
//         context: context,
//         title: S.of(context).error,
//         content: errorMessage,
//       );
//     } catch (exception, stackTrace) {
//       if (kDebugMode) {
//         print(stackTrace);
//       }
//       // Map generic exceptions to user-friendly messages
//       final errEnum = exception is ApiI18nErrorRes
//           ? exception
//           : EnumToString.fromString(
//               ApiI18nErrorRes.values,
//               exception.toString(),
//             );
//
//       VAppAlert.showOkAlertDialog(
//         context: context,
//         title: S.of(context).error,
//         content: AuthTrUtils.tr(errEnum) ?? exception.toString(),
//       );
//     } finally {
//       // Dismiss the loading dialog
//       updateRegisterStatus(false);
//     }
//   }
//
//   /// Maps FirebaseAuthException codes to user-friendly messages.
//   String _mapFirebaseAuthExceptionToMessage(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'email-already-in-use':
//         return "emailAlreadyInUse";
//       case 'invalid-email':
//         return "invalidEmail";
//       case 'operation-not-allowed':
//         return "operationNotAllowed";
//       case 'weak-password':
//         return "weakPassword";
//       default:
//         return "unknownError";
//     }
//   }
//
//   void _navigateToHome(BuildContext context) {
//     AppNavigation.toPage(
//       context,
//       const HomeView(),
//       isRemoveAll: true,
//       withAnimation: true,
//     );
//   }
//
//   /// Checks if login is allowed based on platform configurations.
//   bool _isLoginNotAllowed() {
//     if (VPlatforms.isMobile &&
//         !VAppConfigController.appConfig.allowMobileLogin) {
//       return true;
//     }
//     if (VPlatforms.isWeb && !VAppConfigController.appConfig.allowWebLogin) {
//       return true;
//     }
//     if (VPlatforms.isDeskTop &&
//         !VAppConfigController.appConfig.allowDesktopLogin) {
//       return true;
//     }
//     return false;
//   }
//
//   void toLoginWithPhone() {
//   }
// }
