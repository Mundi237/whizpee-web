import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_up/app/core/widgets/animated_whizpee_logo.dart';
import 'package:super_up/app/modules/auth/social_login_auth.dart';
import 'package:super_up_core/super_up_core.dart';

class LoginMethodSelection extends StatefulWidget {
  const LoginMethodSelection({super.key});

  @override
  State<LoginMethodSelection> createState() => _LoginMethodSelectionState();
}

class _LoginMethodSelectionState extends State<LoginMethodSelection> {
  bool _isGoogleLoading = false;

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
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: AnimatedWhizpeeLogo(
                  height: 56,
                  isCompact: false,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.08),
                      Text(
                        "Bienvenue sur Whizpee",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 200.ms)
                          .slideY(begin: 0.3, end: 0),
                      const SizedBox(height: 16),
                      Text(
                        "Connectez-vous avec votre compte Google",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.7),
                          height: 1.5,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 400.ms)
                          .slideY(begin: 0.3, end: 0),
                      SizedBox(height: size.height * 0.1),
                      _buildGoogleButton(
                        context: context,
                        isLoading: _isGoogleLoading,
                        onTap: _handleGoogleSignIn,
                      ).animate().fadeIn(duration: 600.ms, delay: 600.ms).scale(
                            begin: const Offset(0.9, 0.9),
                            end: const Offset(1.0, 1.0),
                          ),
                      const SizedBox(height: 48),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Text(
                              "En vous connectant, vous acceptez nos",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4,
                              runSpacing: 4,
                              children: [
                                Icon(
                                  Icons.verified_user_outlined,
                                  size: 12,
                                  color: AppTheme.primaryGreen,
                                ),
                                Text(
                                  "Conditions d'utilisation",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.primaryGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  " et notre ",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                                Icon(
                                  Icons.privacy_tip_outlined,
                                  size: 12,
                                  color: AppTheme.primaryGreen,
                                ),
                                Text(
                                  "Politique de confidentialité",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.primaryGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildGoogleButton({
    required BuildContext context,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.string(
                      googleSvgString,
                      height: 28,
                      width: 28,
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Continuer avec Google",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
        ),
      ),
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
