import 'dart:async';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pinput/pinput.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up/app/core/app_nav/app_navigation.dart';
import 'package:super_up/app/modules/annonces/datas/services/api_services.dart';
import 'package:super_up/app/modules/auth/social_login_auth.dart';
import 'package:super_up/app/modules/home/home_controller/views/home_view.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';
import 'package:super_up/app/core/utils/phone/contact_sync_service.dart';

import '../../../core/api_service/auth/auth_api_service.dart';
import '../../../core/api_service/profile/profile_api_service.dart';
import '../auth_utils.dart';
import '../continue_get_data/continue_get_data_screen.dart';
import '../waiting_list/views/waiting_list_page.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String userPhone;

  const OTPScreen({
    super.key,
    required this.verificationId,
    required this.userPhone,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String? code;
  bool _isLoading = false;
  final authService = GetIt.I<AuthApiService>();
  final profileService = GetIt.I<ProfileApiService>();
  final codeController = TextEditingController();

  // Error handling
  String? errorText;
  bool _hasError = false;

  // Resend code functionality
  bool _isResendActive = false;
  int _remainingSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _isResendActive = false;
    _remainingSeconds = 60;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _isResendActive = true;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = VThemeListener.I.isDarkMode;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0D0D0D),
                    const Color(0xFF1A0E2E),
                    const Color(0xFF2D1B4E),
                  ]
                : [
                    const Color(0xFF000000),
                    const Color(0xFF1A0E2E),
                    const Color(0xFF3D2257),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar with back button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.pop();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Title
                      Text(
                        "Saisissez le code reçu",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Subtitle with masked phone number
                      Text(
                        "Entrez le code à 6 chiffres envoyé par SMS au\n${formatPhoneNumber(widget.userPhone)}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.7),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // OTP Input
                      Center(
                        child: Pinput(
                          length: 6,
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          autofocus: true,
                          controller: codeController,
                          onCompleted: (pin) {
                            HapticFeedback.mediumImpact();
                            if (!_isLoading) _login();
                          },
                          onChanged: (value) {
                            setState(() {
                              code = value;
                              if (_hasError) _hasError = false;
                              if (errorText != null) errorText = null;
                            });
                          },
                          defaultPinTheme: PinTheme(
                            width: 52,
                            height: 60,
                            textStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              border: Border.all(
                                color: _hasError
                                    ? Colors.red.shade400
                                    : Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            width: 52,
                            height: 60,
                            textStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              border: Border.all(
                                color: _hasError
                                    ? Colors.red
                                    : AppTheme.primaryGreen,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: _hasError
                                      ? Colors.red.withValues(alpha: 0.3)
                                      : AppTheme.primaryGreen
                                          .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                          submittedPinTheme: PinTheme(
                            width: 52,
                            height: 60,
                            textStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.primaryGreen.withValues(alpha: 0.2),
                              border: Border.all(
                                color: AppTheme.primaryGreen,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          errorPinTheme: PinTheme(
                            width: 52,
                            height: 60,
                            textStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade900.withValues(alpha: 0.2),
                              border: Border.all(color: Colors.red, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      // Error Message
                      if (errorText != null)
                        Container(
                          margin: const EdgeInsets.only(top: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade900.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.shade400.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                color: Colors.red.shade300,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  errorText!,
                                  style: TextStyle(
                                    color: Colors.red.shade100,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 32),
                      // Resend code option
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "Vous n'avez pas reçu le code ?",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _isResendActive
                                ? TextButton(
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      _resendCode();
                                    },
                                    child: Text(
                                      "Renvoyer le code",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryGreen,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : Text(
                                    "Renvoyer le code ($_remainingSeconds",
                                    style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.5),
                                      fontSize: 14,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Verify Button
                      SizedBox(
                        width: double.infinity,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap:
                                (isBtnActive() && !_isLoading) ? _login : null,
                            borderRadius: BorderRadius.circular(16),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                gradient: (isBtnActive() && !_isLoading)
                                    ? LinearGradient(
                                        colors: [
                                          AppTheme.primaryGreen,
                                          AppTheme.primaryGreen
                                              .withValues(alpha: 0.8),
                                        ],
                                      )
                                    : null,
                                color: (isBtnActive() && !_isLoading)
                                    ? null
                                    : Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: (isBtnActive() && !_isLoading)
                                    ? [
                                        BoxShadow(
                                          color: AppTheme.primaryGreen
                                              .withValues(alpha: 0.4),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: _isLoading
                                    ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Text(
                                        "Confirmer",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resendCode() async {
    // Set state to show loading
    setState(() {
      _isResendActive = false;
      errorText = null;
      _hasError = false;
    });

    // Start the resend timer again
    _startResendTimer();
    await SocialLoginAuth.phoneSignIn(widget.userPhone);
  }

  String formatPhoneNumber(String phone) {
    if (phone.length > 4) {
      return "${phone.substring(0, phone.length - 4)}****";
    }
    return phone;
  }

  /// Validates the entered PIN and performs login
  void _login() async {
    // Clear previous errors
    setState(() {
      errorText = null;
      _hasError = false;
    });

    // Validate code
    if (code == null || code!.isEmpty) {
      setState(() {
        errorText = S.of(context).pleaseEnterVerificationCode;
        _hasError = true;
      });
      return;
    }

    if (code!.length != 6) {
      setState(() {
        errorText = S.of(context).pleaseEnterValid6DigitCode;
        _hasError = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    vSafeApiCall(
      onLoading: () {
        VAppAlert.showLoading(context: context, isDismissible: true);
      },
      request: () async {
        try {
          final credential = PhoneAuthProvider.credential(
            verificationId: widget.verificationId,
            smsCode: code!,
          );
          await FirebaseAuth.instance.signInWithCredential(credential);
        } catch (e) {
          throw _handleFirebaseAuthError(e);
        }
      },
      onSuccess: (response) async {
        try {
          // final authRes = await authService.checkMethod(
          //   authType: RegisterMethod.phone,
          //   authId: widget.userPhone,
          // );

          // if (authRes == null) {
          //   // User must complete data
          //   AppNavigation.toPage(
          //     context,
          //     ContinueGetDataScreen(
          //       socialUser: SocialUser(
          //         authId: widget.userPhone,
          //         type: RegisterMethod.phone,
          //       ),
          //     ),
          //     isRemoveAll: true,
          //   );
          //   return;
          // }
          await refreshToken();

          await profileService.getMyProfile().then((e) async {
            Navigator.pop(context);
            await VAppPref.setMap(SStorageKeys.myProfile.name, e.toMap());
            await VAppPref.setBool(SStorageKeys.isLogin.name, true);

            // Demander la permission d'accès aux contacts avant de rediriger
            final contactService = ContactSyncService();
            if (contactService.isPlatformSupported) {
              await contactService.initialize(context);
            }

            _homeNav(context);
          });
          // print(result);
          return;
          await vSafeApiCall<SMyProfile>(
            onLoading: () async {
              // Loading already shown
            },
            onError: (exception, trace) {
              if (kDebugMode) {
                print(trace);
              }

              Navigator.of(context).pop();
              final errEnum = EnumToString.fromString(
                ApiI18nErrorRes.values,
                exception.toString(),
              );

              setState(() {
                errorText = AuthTrUtils.tr(errEnum) ?? exception.toString();
                _hasError = true;
              });
            },
            request: () async {
              final deviceHelper = DeviceInfoHelper();
              await authService.login(LoginDto(
                authId: widget.userPhone,
                phone: widget.userPhone,
                identifier: null,
                method: RegisterMethod.phone,
                pushKey: await (await VChatController
                        .I.vChatConfig.currentPushProviderService)
                    ?.getToken(
                  VPlatforms.isWeb ? SConstants.webVapidKey : null,
                ),
                deviceInfo: await deviceHelper.getDeviceMapInfo(),
                deviceId: await deviceHelper.getId(),
                language: VLanguageListener.I.appLocal.languageCode,
                platform: VPlatforms.currentPlatform,
              ));
              return profileService.getMyProfile();
            },
            onSuccess: (response) async {
              final status = response.registerStatus;
              await VAppPref.setMap(
                SStorageKeys.myProfile.name,
                response.toMap(),
              );
              if (status == RegisterStatus.accepted) {
                refreshToken();
                await VAppPref.setBool(SStorageKeys.isLogin.name, true);
                _homeNav(context);
              } else {
                context.toPage(
                  WaitingListPage(
                    profile: response,
                  ),
                  withAnimation: true,
                  removeAll: true,
                );
              }
            },
            ignoreTimeoutAndNoInternet: false,
          );
        } catch (e) {
          Navigator.of(context).pop();
          setState(() {
            errorText = e.toString();
            _hasError = true;
          });
        }
      },
      onError: (exception, trace) {
        context.pop();

        setState(() {
          errorText = exception;
          _hasError = true;
        });

        if (kDebugMode) {
          print("Error in OTP verification: $trace");
        }
      },
    ).then((_) {
      // Reset loading flag after API call
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  /// Better handling of Firebase Auth errors with user-friendly messages
  String _handleFirebaseAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-verification-code':
          return S.of(context).invalidVerificationCode;
        case 'invalid-verification-id':
          return S.of(context).verificationSessionExpired;
        case 'too-many-requests':
          return S.of(context).tooManyAttempts;
        case 'network-request-failed':
          return S.of(context).networkError;
        default:
          return S.of(context).verificationFailed(error.message ?? error.code);
      }
    } else if (error is TimeoutException) {
      return S.of(context).verificationTimedOut;
    }
    return error.toString();
  }

  /// Navigates to the Home screen
  void _homeNav(BuildContext context) {
    context.toPage(
      const HomeView(),
      withAnimation: true,
      removeAll: true,
    );
  }

  /// Determines if the Verify button should be active
  bool isBtnActive() {
    if (code == null) return false;
    if (code!.length == 6) return true;
    return false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    codeController.dispose();
    super.dispose();
  }
}
