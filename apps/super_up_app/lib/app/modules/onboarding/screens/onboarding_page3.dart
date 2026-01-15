import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:super_up/app/core/widgets/animated_whizpee_logo.dart';
import 'package:super_up_core/super_up_core.dart';
import 'login_method_selection.dart';

class OnboardingPage3 extends StatefulWidget {
  const OnboardingPage3({super.key});

  @override
  State<OnboardingPage3> createState() => _OnboardingPage3State();
}

class _OnboardingPage3State extends State<OnboardingPage3>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  bool _isButtonHovered = false;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);
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
    final accentColor = Colors.blue;

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
                top: -70,
                right: -70,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Container(
                      width: 230 + (28 * _floatController.value),
                      height: 230 + (28 * _floatController.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            accentColor.withValues(alpha: 0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: -60,
                left: -60,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Container(
                      width: 260 - (28 * _floatController.value),
                      height: 260 - (28 * _floatController.value),
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
              Column(
                children: [
                  // Top logo
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.06),
                            Colors.white.withValues(alpha: 0.02),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: const AnimatedWhizpeeLogo(
                            height: 40,
                            isCompact: true,
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: -0.3, end: 0),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.05),
                          // Icon with glassmorphism
                          AnimatedBuilder(
                            animation: _floatController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, -10 * _floatController.value),
                                child: Container(
                                  width: size.width * 0.7,
                                  height: size.width * 0.7,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        accentColor.withValues(alpha: 0.2),
                                        Colors.purple.withValues(alpha: 0.15),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(52),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white
                                                .withValues(alpha: 0.12),
                                            Colors.white
                                                .withValues(alpha: 0.05),
                                          ],
                                        ),
                                        border: Border.all(
                                          color: Colors.white
                                              .withValues(alpha: 0.15),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: accentColor.withValues(
                                                alpha: 0.3),
                                            blurRadius: 50,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 15, sigmaY: 15),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: RadialGradient(
                                                colors: [
                                                  accentColor.withValues(
                                                      alpha: 0.3),
                                                  accentColor.withValues(
                                                      alpha: 0.1),
                                                ],
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.favorite_rounded,
                                              size: 100,
                                              color: accentColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                              .animate()
                              .fadeIn(duration: 800.ms, delay: 200.ms)
                              .scale(
                                begin: const Offset(0.8, 0.8),
                                duration: 1000.ms,
                                curve: Curves.easeOutBack,
                              ),
                          SizedBox(height: size.height * 0.08),
                          // Content card
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Container(
                              padding: const EdgeInsets.all(32),
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
                                  filter:
                                      ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                  child: Column(
                                    children: [
                                      // Feature badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            colors: [
                                              accentColor.withValues(
                                                  alpha: 0.3),
                                              accentColor.withValues(
                                                  alpha: 0.15),
                                            ],
                                          ),
                                          border: Border.all(
                                            color: accentColor.withValues(
                                                alpha: 0.4),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.auto_awesome_rounded,
                                              size: 16,
                                              color: accentColor,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Expérience Unique",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: accentColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                          .animate()
                                          .fadeIn(
                                              duration: 500.ms, delay: 600.ms)
                                          .scale(begin: const Offset(0.8, 0.8)),
                                      const SizedBox(height: 24),
                                      Text(
                                        "Votre aventure, vos règles",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          height: 1.2,
                                          letterSpacing: -0.5,
                                        ),
                                      )
                                          .animate()
                                          .fadeIn(
                                              duration: 600.ms, delay: 700.ms)
                                          .slideY(begin: 0.2, end: 0),
                                      const SizedBox(height: 16),
                                      Text(
                                        "Trouvez des rencontres authentiques et créez des connexions qui comptent. Whizpee, l'app de rencontre qui vous ressemble.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white
                                              .withValues(alpha: 0.75),
                                          height: 1.6,
                                          letterSpacing: 0.2,
                                        ),
                                      )
                                          .animate()
                                          .fadeIn(
                                              duration: 600.ms, delay: 900.ms)
                                          .slideY(begin: 0.2, end: 0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                  // Bottom navigation
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
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
                              child: Row(
                                children: [
                                  _buildPageIndicator(false),
                                  const SizedBox(width: 8),
                                  _buildPageIndicator(false),
                                  const SizedBox(width: 8),
                                  _buildPageIndicator(true),
                                ],
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 500.ms, delay: 1100.ms),
                            GestureDetector(
                              onTapDown: (_) {
                                HapticFeedback.lightImpact();
                                setState(() => _isButtonHovered = true);
                              },
                              onTapUp: (_) {
                                setState(() => _isButtonHovered = false);
                                HapticFeedback.mediumImpact();
                                context.toPage(const LoginMethodSelection());
                              },
                              onTapCancel: () {
                                setState(() => _isButtonHovered = false);
                              },
                              child: AnimatedScale(
                                scale: _isButtonHovered ? 0.95 : 1.0,
                                duration: const Duration(milliseconds: 150),
                                curve: Curves.easeOut,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 28,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppTheme.primaryGreen,
                                        AppTheme.primaryGreen
                                            .withValues(alpha: 0.85),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primaryGreen
                                            .withValues(alpha: 0.5),
                                        blurRadius: 24,
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
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 500.ms, delay: 1200.ms)
                                .slideX(begin: 0.3, end: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
      curve: Curves.easeOut,
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.primaryGreen
            : Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
    );
  }
}
