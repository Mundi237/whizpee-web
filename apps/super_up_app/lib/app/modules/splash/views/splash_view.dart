// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:super_up/app/core/widgets/iconic_splash_logo.dart';
import 'package:super_up/app/core/widgets/animated_whizpee_logo.dart';
import 'package:super_up/app/modules/splash/controllers/splash_controller.dart';
import 'package:super_up_core/super_up_core.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late final SplashController controller;
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late AnimationController _rotateController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    HapticFeedback.lightImpact();
    controller = SplashController();
    controller.onInit();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 20000),
      vsync: this,
    )..repeat();

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    _rotateController.dispose();
    _waveController.dispose();
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = VThemeListener.I.isDarkMode;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0D0D0D),
                    const Color(0xFF1A0E2E),
                    const Color(0xFF2D1B4E),
                  ]
                : [
                    const Color(0xFF000000),
                    const Color(0xFF1A0E2E),
                    const Color(0xFF4A2E7C),
                  ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Glassmorphism circles avec animation de rotation
              AnimatedBuilder(
                animation: _rotateController,
                builder: (context, child) {
                  return Positioned(
                    top: -100 + (30 * _floatController.value),
                    right: -100,
                    child: Transform.rotate(
                      angle: _rotateController.value * 2 * 3.14159,
                      child: Container(
                        width: 350,
                        height: 350,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.primaryGreen.withValues(alpha: 0.15),
                              AppTheme.primaryGreen.withValues(alpha: 0.08),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  return Positioned(
                    bottom: -150 - (40 * _floatController.value),
                    left: -150,
                    child: Transform.rotate(
                      angle: -_rotateController.value * 1.5 * 3.14159,
                      child: Container(
                        width: 450,
                        height: 450,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.purple.withValues(alpha: 0.12),
                              Colors.purple.withValues(alpha: 0.06),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Animation d'onde qui se propage depuis le centre
              AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return Positioned.fill(
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width *
                            (0.5 + _waveController.value * 2.5),
                        height: MediaQuery.of(context).size.width *
                            (0.5 + _waveController.value * 2.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.primaryGreen.withValues(
                                alpha: (0.3 - _waveController.value * 0.28)
                                    .clamp(0.0, 0.3),
                              ),
                              AppTheme.primaryGreen.withValues(
                                alpha: (0.15 - _waveController.value * 0.14)
                                    .clamp(0.0, 0.15),
                              ),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Animation d'onde secondaire avec décalage
              AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return Positioned.fill(
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width *
                            (0.3 +
                                (_waveController.value - 0.3).clamp(0.0, 1.0) *
                                    2.5),
                        height: MediaQuery.of(context).size.width *
                            (0.3 +
                                (_waveController.value - 0.3).clamp(0.0, 1.0) *
                                    2.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.purple.withValues(
                                alpha: (0.2 -
                                        (_waveController.value - 0.3)
                                                .clamp(0.0, 1.0) *
                                            0.18)
                                    .clamp(0.0, 0.2),
                              ),
                              Colors.purple.withValues(
                                alpha: (0.1 -
                                        (_waveController.value - 0.3)
                                                .clamp(0.0, 1.0) *
                                            0.09)
                                    .clamp(0.0, 0.1),
                              ),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Contenu principal sans cadre
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Column(
                      children: [
                        // Logo sans cadre, directement avec animation
                        const IconicSplashLogo(
                          size: 140,
                        )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 200.ms)
                            .scale(
                              begin: const Offset(0.85, 0.85),
                              duration: 800.ms,
                              curve: Curves.easeOutBack,
                            )
                            .shimmer(
                              delay: 1200.ms,
                              duration: 1500.ms,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                        const SizedBox(height: 32),
                        const AnimatedWhizpeeLogo(
                          height: 48,
                          isCompact: false,
                        )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 400.ms)
                            .slideY(begin: 0.2, end: 0),
                        const SizedBox(height: 48),
                        // Loading indicator premium avec glassmorphism
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
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
                              width: 1,
                            ),
                          ),
                          child: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Center(
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          strokeCap: StrokeCap.round,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            AppTheme.primaryGreen
                                                .withValues(alpha: 0.4),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 38,
                                        height: 38,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3.5,
                                          strokeCap: StrokeCap.round,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            AppTheme.primaryGreen,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.primaryGreen,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.primaryGreen
                                                  .withValues(alpha: 0.5),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .fadeIn(duration: 500.ms, delay: 1000.ms)
                            .scale(
                              duration: 5000.ms,
                              begin: const Offset(0.7, 0.7),
                              curve: Curves.easeOutBack,
                            ),
                      ],
                    ),
                    // Version avec glassmorphism
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: ValueListenableBuilder(
                        valueListenable: controller,
                        builder: (context, value, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
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
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                child: Text(
                                  controller.version,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 500.ms, delay: 1200.ms)
                              .slideY(begin: 0.3, end: 0);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
