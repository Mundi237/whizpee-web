import 'dart:async';
import 'dart:ui';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

class _OTPScreenState extends State<OTPScreen>
    with SingleTickerProviderStateMixin {
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

  // Animation
  late AnimationController _floatController;
  bool _isButtonHovered = false;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);
    _startResendTimer();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _timer?.cancel();
    codeController.dispose();
    super.dispose();
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
    final size = MediaQuery.of(context).size;

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
          child: Stack(
            children: [
              // Background glassmorphism circles
              Positioned(
                top: -70,
                left: -70,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Container(
                      width: 220 + (25 * _floatController.value),
                      height: 220 + (25 * _floatController.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.primaryGreen.withValues(alpha: 0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: -90,
                right: -90,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Container(
                      width: 250 - (25 * _floatController.value),
                      height: 250 - (25 * _floatController.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.purple.withValues(alpha: 0.12),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Main content
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 900) {
                    // Web/Tablet Layout (Split View)
                    return Column(
                      children: [
                        _buildTopBar(context),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 64, vertical: 48),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Left Column: Header Info
                                Expanded(
                                  flex: 1,
                                  child: _buildHeaderCard(context, isWeb: true),
                                ),
                                const SizedBox(width: 80),
                                // Right Column: Input Form
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildInputSection(context),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Mobile Layout
                    return Column(
                      children: [
                        _buildTopBar(context),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: size.height * 0.05),
                                _buildHeaderCard(context, isWeb: false),
                                const SizedBox(height: 40),
                                _buildInputSection(context),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.08),
              Colors.white.withValues(alpha: 0.04),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      context.pop();
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.12),
                            Colors.white.withValues(alpha: 0.06),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
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
        ),
      ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.3, end: 0),
    );
  }

  Widget _buildHeaderCard(BuildContext context, {required bool isWeb}) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                isWeb ? MainAxisAlignment.center : MainAxisAlignment.start,
            mainAxisSize: isWeb ? MainAxisSize.max : MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryGreen.withValues(alpha: 0.3),
                      AppTheme.primaryGreen.withValues(alpha: 0.15),
                    ],
                  ),
                  border: Border.all(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.lock_rounded,
                  size: 32,
                  color: AppTheme.primaryGreen,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .scale(begin: const Offset(0.8, 0.8)),
              const SizedBox(height: 20),
              Text(
                "Saisissez le code reçu",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 300.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              Text(
                "Entrez le code à 6 chiffres envoyé par SMS au ${formatPhoneNumber(widget.userPhone)}",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.75),
                  height: 1.6,
                  letterSpacing: 0.2,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 500.ms)
                  .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection(BuildContext context) {
    return Column(
      children: [
        // OTP Input with glassmorphism
        Center(
          child: Pinput(
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
              HapticFeedback.selectionClick();
            },
            defaultPinTheme: PinTheme(
              width: 54,
              height: 64,
              textStyle: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.12),
                    Colors.white.withValues(alpha: 0.06),
                  ],
                ),
                border: Border.all(
                  color: _hasError
                      ? Colors.red.shade400
                      : Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            focusedPinTheme: PinTheme(
              width: 54,
              height: 64,
              textStyle: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.18),
                    Colors.white.withValues(alpha: 0.1),
                  ],
                ),
                border: Border.all(
                  color: _hasError ? Colors.red : AppTheme.primaryGreen,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _hasError
                        ? Colors.red.withValues(alpha: 0.4)
                        : AppTheme.primaryGreen.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
            submittedPinTheme: PinTheme(
              width: 54,
              height: 64,
              textStyle: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryGreen.withValues(alpha: 0.25),
                    AppTheme.primaryGreen.withValues(alpha: 0.15),
                  ],
                ),
                border: Border.all(
                  color: AppTheme.primaryGreen,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            errorPinTheme: PinTheme(
              width: 54,
              height: 64,
              textStyle: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.shade900.withValues(alpha: 0.3),
                    Colors.red.shade900.withValues(alpha: 0.15),
                  ],
                ),
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 700.ms)
            .scale(begin: const Offset(0.95, 0.95)),

        // Error Message
        if (errorText != null)
          Container(
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.shade900.withValues(alpha: 0.4),
                  Colors.red.shade900.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.red.shade400.withValues(alpha: 0.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.shade400.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        Icons.error_rounded,
                        color: Colors.red.shade200,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        errorText!,
                        style: TextStyle(
                          color: Colors.red.shade50,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(duration: 300.ms).shake(),

        const SizedBox(height: 32),
        // Resend code option with glassmorphism
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.06),
                  Colors.white.withValues(alpha: 0.03),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Column(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 20,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Vous n'avez pas reçu le code ?",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _isResendActive
                        ? TextButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              _resendCode();
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              backgroundColor:
                                  AppTheme.primaryGreen.withValues(alpha: 0.15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Renvoyer le code",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                                fontSize: 16,
                                letterSpacing: 0.3,
                              ),
                            ),
                          )
                        : Text(
                            "Renvoyer le code dans $_remainingSeconds s",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 900.ms),
        const SizedBox(height: 32),

        // Verify Button with premium design
        GestureDetector(
          onTapDown: (_) {
            if (isBtnActive() && !_isLoading) {
              HapticFeedback.lightImpact();
              setState(() => _isButtonHovered = true);
            }
          },
          onTapUp: (_) {
            if (isBtnActive() && !_isLoading) {
              setState(() => _isButtonHovered = false);
              HapticFeedback.mediumImpact();
              _login();
            }
          },
          onTapCancel: () {
            setState(() => _isButtonHovered = false);
          },
          child: AnimatedScale(
            scale:
                _isButtonHovered && isBtnActive() && !_isLoading ? 0.97 : 1.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                gradient: (isBtnActive() && !_isLoading)
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryGreen,
                          AppTheme.primaryGreen.withValues(alpha: 0.85),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.15),
                          Colors.white.withValues(alpha: 0.1),
                        ],
                      ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: (isBtnActive() && !_isLoading)
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withValues(alpha: 0.5),
                          blurRadius: 24,
                          spreadRadius: 0,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: AppTheme.primaryGreen.withValues(alpha: 0.25),
                          blurRadius: 12,
                          spreadRadius: -2,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
              ),
              child: Center(
                child: _isLoading
                    ? SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Confirmer",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 1100.ms)
            .slideY(begin: 0.2, end: 0),
      ],
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
}
