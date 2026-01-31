import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_up/app/core/widgets/animated_whizpee_logo.dart';
import 'package:super_up/app/core/widgets/google_sign_in_button.dart'
    as google_button;
import 'package:super_up/app/modules/auth/social_login_auth.dart';
import 'package:super_up_core/super_up_core.dart';

class LoginMethodSelection extends StatefulWidget {
  const LoginMethodSelection({super.key});

  @override
  State<LoginMethodSelection> createState() => _LoginMethodSelectionState();
}

class _LoginMethodSelectionState extends State<LoginMethodSelection>
    with SingleTickerProviderStateMixin {
  bool _isGoogleLoading = false;
  bool _isButtonHovered = false;
  bool _isGoogleSignInInitialized = false;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);

    // Initialize Google Sign-In
    _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    await SocialLoginAuth.initializeGoogleSignIn(context);
    if (mounted) {
      setState(() {
        _isGoogleSignInInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = VThemeListener.I.isDarkMode;
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
                top: -80,
                left: -80,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Container(
                      width: 240 + (30 * _floatController.value),
                      height: 240 + (30 * _floatController.value),
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
                bottom: -100,
                right: -100,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Container(
                      width: 280 - (30 * _floatController.value),
                      height: 280 - (30 * _floatController.value),
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 64, vertical: 48),
                      child: Row(
                        children: [
                          // Left Column: Branding & Info
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Logo
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withValues(alpha: 0.08),
                                        Colors.white.withValues(alpha: 0.04),
                                      ],
                                    ),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.12),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: const AnimatedWhizpeeLogo(
                                        height: 48,
                                        isCompact: false,
                                      ),
                                    ),
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 600.ms)
                                    .slideX(begin: -0.3, end: 0),
                                const SizedBox(height: 64),
                                // Welcome Text
                                Container(
                                  padding: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withValues(alpha: 0.08),
                                        Colors.white.withValues(alpha: 0.03),
                                      ],
                                    ),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Bienvenue sur Whizpee",
                                        style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          height: 1.1,
                                          letterSpacing: -1,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        "Connectez-vous pour commencer votre aventure.\nUne expérience fluide et sécurisée vous attend.",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white
                                              .withValues(alpha: 0.7),
                                          height: 1.6,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 600.ms, delay: 200.ms)
                                    .slideX(begin: -0.2, end: 0),
                              ],
                            ),
                          ),
                          const SizedBox(width: 80),
                          // Right Column: Action
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildWelcomeIcon(),
                                const SizedBox(height: 48),
                                _buildGoogleButton(),
                                const SizedBox(height: 32),
                                _buildTerms(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Mobile Layout
                    return Column(
                      children: [
                        // Top logo with glassmorphism
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withValues(alpha: 0.08),
                                  Colors.white.withValues(alpha: 0.04),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.12),
                                width: 1.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: const AnimatedWhizpeeLogo(
                                  height: 48,
                                  isCompact: false,
                                ),
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: -0.3, end: 0),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              children: [
                                SizedBox(height: size.height * 0.1),
                                // Welcome card with glassmorphism
                                Container(
                                  padding: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withValues(alpha: 0.1),
                                        Colors.white.withValues(alpha: 0.05),
                                      ],
                                    ),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.15),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 30,
                                        offset: const Offset(0, 15),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(32),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 12, sigmaY: 12),
                                      child: Column(
                                        children: [
                                          _buildWelcomeIcon(),
                                          const SizedBox(height: 32),
                                          Text(
                                            "Bienvenue sur Whizpee",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              height: 1.2,
                                              letterSpacing: -0.5,
                                            ),
                                          )
                                              .animate()
                                              .fadeIn(
                                                  duration: 600.ms,
                                                  delay: 300.ms)
                                              .slideY(begin: 0.2, end: 0),
                                          const SizedBox(height: 16),
                                          Text(
                                            "Connectez-vous avec votre compte Google pour commencer votre aventure",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white
                                                  .withValues(alpha: 0.7),
                                              height: 1.6,
                                              letterSpacing: 0.2,
                                            ),
                                          )
                                              .animate()
                                              .fadeIn(
                                                  duration: 600.ms,
                                                  delay: 500.ms)
                                              .slideY(begin: 0.2, end: 0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.08),
                                _buildGoogleButton(),
                                SizedBox(height: size.height * 0.06),
                                _buildTerms(),
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

  Widget _buildWelcomeIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        Icons.waving_hand_rounded,
        size: 48,
        color: AppTheme.primaryGreen,
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).scale(
          begin: const Offset(0.8, 0.8),
          curve: Curves.easeOutBack,
        );
  }

  Widget _buildTerms() {
    return Container(
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
              Text(
                "En vous connectant, vous acceptez nos",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                runSpacing: 4,
                children: [
                  Icon(
                    Icons.verified_user_rounded,
                    size: 14,
                    color: AppTheme.primaryGreen,
                  ),
                  Text(
                    "Conditions d'utilisation",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    " et notre ",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  Icon(
                    Icons.privacy_tip_rounded,
                    size: 14,
                    color: AppTheme.primaryGreen,
                  ),
                  Text(
                    "Politique de confidentialité",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 900.ms);
  }

  Widget _buildGoogleButton() {
    return GestureDetector(
      onTapDown: (_) {
        if (!_isGoogleLoading) {
          HapticFeedback.lightImpact();
          setState(() => _isButtonHovered = true);
        }
      },
      onTapUp: (_) {
        if (!_isGoogleLoading) {
          setState(() => _isButtonHovered = false);
          HapticFeedback.mediumImpact();
          _handleGoogleSignIn();
        }
      },
      onTapCancel: () {
        setState(() => _isButtonHovered = false);
      },
      child: AnimatedScale(
        scale: _isButtonHovered ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(
            vertical: 22,
            horizontal: 32,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 30,
                spreadRadius: 0,
                offset: const Offset(0, 15),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: -5,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: kIsWeb
              ? (_isGoogleSignInInitialized
                  ? google_button.renderGoogleSignInButton(
                      onPressed: _handleGoogleSignIn,
                    )
                  : const Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black87,
                          ),
                        ),
                      ),
                    ))
              : _isGoogleLoading
                  ? const Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black87,
                          ),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.string(
                          googleSvgString,
                          height: 32,
                          width: 32,
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          "Continuer avec Google",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 700.ms).scale(
          begin: const Offset(0.9, 0.9),
          curve: Curves.easeOutBack,
        );
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      await SocialLoginAuth.loginByGoogle(context);
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }
}

const googleSvgString =
    '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 48 48"><path fill="#ffc107" d="M43.611 20.083H42V20H24v8h11.303c-1.649 4.657-6.08 8-11.303 8c-6.627 0-12-5.373-12-12s5.373-12 12-12c3.059 0 5.842 1.154 7.961 3.039l5.657-5.657C34.046 6.053 29.268 4 24 4C12.955 4 4 12.955 4 24s8.955 20 20 20s20-8.955 20-20c0-1.341-.138-2.65-.389-3.917" stroke-width="1" stroke="#ffc107"/><path fill="#ff3d00" d="m6.306 14.691l6.571 4.819C14.655 15.108 18.961 12 24 12c3.059 0 5.842 1.154 7.961 3.039l5.657-5.657C34.046 6.053 29.268 4 24 4C16.318 4 9.656 8.337 6.306 14.691" stroke-width="1" stroke="#ff3d00"/><path fill="#4caf50" d="M24 44c5.166 0 9.86-1.977 13.409-5.192l-6.19-5.238A11.9 11.9 0 0 1 24 36c-5.202 0-9.619-3.317-11.283-7.946l-6.522 5.025C9.505 39.556 16.227 44 24 44" stroke-width="1" stroke="#4caf50"/><path fill="#1976d2" d="M43.611 20.083H42V20H24v8h11.303a12.04 12.04 0 0 1-4.087 5.571l.003-.002l6.19 5.238C36.971 39.205 44 34 44 24c0-1.341-.138-2.65-.389-3.917" stroke-width="1" stroke="#1976d2"/></svg>';
