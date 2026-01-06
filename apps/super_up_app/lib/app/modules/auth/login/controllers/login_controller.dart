// Copyright 2023
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:email_validator/email_validator.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:super_up/app/core/app_config/app_config_controller.dart';
import 'package:super_up/app/modules/auth/auth_utils.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../core/api_service/auth/auth_api_service.dart';
import '../../../../core/api_service/profile/profile_api_service.dart';
import '../../../../core/app_nav/app_navigation.dart';
import '../../../home/home_controller/views/home_view.dart';
// import '../../continue_get_data/continue_get_data_screen.dart';
import '../../social_login_auth.dart';
import '../../waiting_list/views/waiting_list_page.dart';

class LoginController extends ValueNotifier implements SBaseController {
  // Controllers for email and password input fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Services injected via dependency injection
  final AuthApiService authService;
  final ProfileApiService profileService;

  // Helper for device-related information
  final DeviceInfoHelper deviceHelper = DeviceInfoHelper();

  // Flag to prevent multiple login attempts simultaneously
  bool isLoggingIn = false;

  LoginController(
    this.authService,
    this.profileService,
  ) : super(null);

  @override
  void onInit() {
    if (kDebugMode) {
      emailController.text = "user1@gmail.com";
      passwordController.text = "12345678";
    }
  }

  @override
  void onClose() {
    // Dispose controllers to free up resources
    emailController.dispose();
    passwordController.dispose();
  }

  /// Navigates to the Home screen after successful login
  void _navigateToHome(BuildContext context) {
    AppNavigation.toPage(
      context,
      const HomeView(),
      isRemoveAll: true,
      withAnimation: true,
    );
  }

  /// Initiates the email/password login process
  Future<void> login(BuildContext context) async {
    if (isLoggingIn) return; // Prevent multiple login attempts

    final email = emailController.text.trim();
    final password = passwordController.text;

    // Input Validation
    if (!EmailValidator.validate(email)) {
      VAppAlert.showErrorSnackBar(
        message: S.of(context).emailNotValid,
        context: context,
      );
      return;
    }

    if (password.isEmpty) {
      VAppAlert.showErrorSnackBar(
        message: S.of(context).passwordMustHaveValue,
        context: context,
      );
      return;
    }

    if (_isLoginNotAllowed()) {
      VAppAlert.showErrorSnackBar(
        message: S.of(context).loginNowAllowedNowPleaseTryAgainLater,
        context: context,
      );
      return;
    }

    // Perform the login
    await _performLogin(
      context,
      loginMethod: RegisterMethod.email,
      email: email,
      password: password,
    );
  }

  /// Initiates login using a QR code
  Future<void> loginWithQrCode(BuildContext context, String barCode) async {
    if (isLoggingIn) return; // Prevent multiple login attempts

    await _performLogin(
      context,
      loginMethod: RegisterMethod.qrCode,
      email: barCode, // Assuming 'email' field is used for QR code identifier
    );
  }

  void updateLoginStatus(bool x) {
    isLoggingIn = x;
    notifyListeners();
  }

  /// Core method to handle the login process
  Future<void> _performLogin(
    BuildContext context, {
    required RegisterMethod loginMethod,
    required String email,
    String? password,
  }) async {
    if (isLoggingIn) return; // Double-check to prevent multiple logins
    updateLoginStatus(true);
    try {
      // Obtain the push notification token
      final pushKey =
          await (await VChatController.I.vChatConfig.currentPushProviderService)
              ?.getToken(VPlatforms.isWeb ? SConstants.webVapidKey : null);

      // Perform the login API call
      await authService.login(LoginDto(
        email: email,
        authId: email,
        phone: null,
        identifier: null,
        method: loginMethod,
        pushKey: pushKey,
        deviceInfo: await deviceHelper.getDeviceMapInfo(),
        deviceId: await deviceHelper.getId(),
        language: VLanguageListener.I.appLocal.languageCode,
        platform: VPlatforms.currentPlatform,
        password: password,
      ));

      // If login method is email/password, perform additional email sign-in
      if (loginMethod == RegisterMethod.email && password != null) {
        await SocialLoginAuth.emailSignIn(
          email: email,
          password: password,
        );
      }

      // Retrieve user profile
      final profile = await profileService.getMyProfile();

      // Save profile data locally
      await VAppPref.setMap(SStorageKeys.myProfile.name, profile.toMap());

      // Handle navigation based on registration status
      final status = profile.registerStatus;
      if (status == RegisterStatus.accepted) {
        await VAppPref.setBool(SStorageKeys.isLogin.name, true);
        _navigateToHome(context);
      } else {
        AppNavigation.toPage(
          context,
          WaitingListPage(profile: profile),
          withAnimation: true,
          isRemoveAll: true,
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific authentication errors

      String errorMessage = _mapFirebaseAuthExceptionToMessage(e);
      VAppAlert.showErrorSnackBarWithoutContext(
        message: errorMessage,
      );
    } catch (exception, stackTrace) {
      if (kDebugMode) {
        print(stackTrace);
      }

      // Map generic exceptions to user-friendly messages
      final errEnum = exception is ApiI18nErrorRes
          ? exception
          : EnumToString.fromString(
              ApiI18nErrorRes.values,
              exception.toString(),
            );
      VAppAlert.showErrorSnackBarWithoutContext(
        message: AuthTrUtils.tr(errEnum) ?? exception.toString(),
      );
    } finally {
      updateLoginStatus(false);
    }
  }

  /// Maps FirebaseAuthException codes to user-friendly messages
  String _mapFirebaseAuthExceptionToMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'invalidEmail';
      // return S.current.invalidEmail;
      case 'user-disabled':
        return "userDisabled";
      //return S.current.userDisabled;
      case 'user-not-found':
        return 'user-not-found';
      // return S.current.userNotFound;
      case 'wrong-password':
        return 'wrong-password';
      // return S.current.wrongPassword;
      default:
        return 'unknownError';
      // return S.current.unknownError;
    }
  }

  /// Checks if login is allowed based on platform configurations
  bool _isLoginNotAllowed() {
    if (VPlatforms.isMobile &&
        !VAppConfigController.appConfig.allowMobileLogin) {
      return true;
    }
    if (VPlatforms.isWeb && !VAppConfigController.appConfig.allowWebLogin) {
      return true;
    }
    if (VPlatforms.isDeskTop &&
        !VAppConfigController.appConfig.allowDesktopLogin) {
      return true;
    }
    return false;
  }

  /// Retrieves the web scan code (QR code)
  Future<String> getWebScan() async {
    return authService.getWebScan(await deviceHelper.getId());
  }

  void toLoginWithPhone() {}
}
