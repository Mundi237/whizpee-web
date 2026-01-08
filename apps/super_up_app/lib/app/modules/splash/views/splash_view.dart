// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
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

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final SplashController controller;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    controller = SplashController();
    controller.onInit();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
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
              // Animated circles background
              Positioned(
                top: -100,
                right: -100,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.primaryGreen.withValues(
                                alpha: 0.2 * _pulseController.value),
                            AppTheme.primaryGreen.withValues(
                                alpha: 0.05 * _pulseController.value),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: -150,
                left: -150,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.purple.withValues(
                                alpha: 0.15 * (1 - _pulseController.value)),
                            Colors.purple.withValues(
                                alpha: 0.05 * (1 - _pulseController.value)),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Column(
                      children: [
                        // Logo iconique RÉVOLUTIONNAIRE
                        const IconicSplashLogo(
                          size: 160,
                        ),
                        const SizedBox(height: 48),
                        // Logo texte avec effets sobres et élégants
                        const AnimatedWhizpeeLogo(
                          height: 56,
                          isCompact: false,
                        ),
                        const SizedBox(height: 24),
                        // Loading indicator amélioré
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Ring extérieur
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.primaryGreen
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                              // Ring principal
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.primaryGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .fadeIn(duration: 400.ms, delay: 800.ms)
                            .scale(
                              duration: 1000.ms,
                              begin: const Offset(0.8, 0.8),
                              curve: Curves.elasticOut,
                            ),
                      ],
                    ),
                    Column(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: controller,
                          builder: (context, value, child) {
                            return Text(
                              controller.version,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ).animate().fadeIn(duration: 400.ms, delay: 800.ms);
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
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
