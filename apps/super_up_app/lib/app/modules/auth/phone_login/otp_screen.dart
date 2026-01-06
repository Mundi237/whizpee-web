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
    final theme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: theme.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(S.of(context).codePage),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: MediaQuery.of(context).size.height * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          "assets/logo.jpg",
                          height: 120,
                          width: 120,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        S.of(context).enterVerificationCode,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle with masked phone number
                      Text(
                        S.of(context).sentSixDigitCode(
                            formatPhoneNumber(widget.userPhone)),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            color: theme.textPrimary.withValues(alpha: 0.6)),
                      ),
                      const SizedBox(height: 40),

                      // OTP Input
                      Pinput(
                        length: 6,
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
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
                          width: 56,
                          height: 56,
                          textStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: _hasError
                                    ? Colors.red.shade300
                                    : Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                            color: theme.background,
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: _hasError
                                    ? Colors.red
                                    : AppColors.primaryColor,
                                width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        errorPinTheme: PinTheme(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      // Error Message
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: errorText != null ? 40 : 0,
                        padding: const EdgeInsets.only(top: 8.0),
                        child: errorText != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      errorText!,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 14),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),

                      const SizedBox(height: 24),

                      // Resend code option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).didntReceiveCode,
                            style: TextStyle(
                                fontSize: 14,
                                color:
                                    theme.textPrimary.withValues(alpha: 0.7)),
                          ),
                          _isResendActive
                              ? TextButton(
                                  onPressed: _resendCode,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(50, 30),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    S.of(context).resend,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor),
                                  ),
                                )
                              : Text(
                                  S
                                      .of(context)
                                      .resendInSeconds(_remainingSeconds),
                                  style: TextStyle(
                                      color: AppColors.primaryColor
                                          .withValues(alpha: 0.7)),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Verify Button
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 50,
                child: SElevatedButton(
                  title: _isLoading ? "" : S.of(context).verify,
                  onPress: (isBtnActive() && !_isLoading) ? _login : null,
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
