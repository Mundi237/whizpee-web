import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:super_up/app/core/widgets/animated_whizpee_logo.dart';
import 'package:super_up_core/super_up_core.dart';
import 'login_method_selection.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

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
                  height: 48,
                  isCompact: true,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Container(
                      width: size.width * 0.8,
                      height: size.width * 0.8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.blue.withValues(alpha: 0.3),
                            Colors.purple.withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(48),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.withValues(alpha: 0.15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withValues(alpha: 0.4),
                                blurRadius: 60,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.favorite_border_rounded,
                            size: 120,
                            color: Colors.blue.shade400,
                          ),
                        ),
                      ),
                    )
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .scale(
                          duration: 3000.ms,
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1.05, 1.05),
                          curve: Curves.easeInOut,
                        )
                        .then()
                        .shimmer(
                          duration: 2000.ms,
                          color: Colors.blue.withValues(alpha: 0.3),
                        ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        children: [
                          Text(
                            "Votre aventure, vos règles.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 600.ms, delay: 400.ms)
                              .slideY(begin: 0.3, end: 0),
                          const SizedBox(height: 16),
                          Text(
                            "Rencontres éphémères ou durables, vous décidez de l'arrangement.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withValues(alpha: 0.7),
                              height: 1.5,
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 600.ms, delay: 600.ms)
                              .slideY(begin: 0.3, end: 0),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildPageIndicator(false),
                        const SizedBox(width: 8),
                        _buildPageIndicator(false),
                        const SizedBox(width: 8),
                        _buildPageIndicator(true),
                      ],
                    ).animate().fadeIn(duration: 600.ms, delay: 800.ms),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.toPage(
                            const LoginMethodSelection(),
                            withAnimation: true,
                            removeAll: true,
                          );
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryGreen,
                                AppTheme.primaryGreen.withValues(alpha: 0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryGreen
                                    .withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Commencer",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 1000.ms)
                        .slideX(begin: 0.5, end: 0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.primaryGreen
            : Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
