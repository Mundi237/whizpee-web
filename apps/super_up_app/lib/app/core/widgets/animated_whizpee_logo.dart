import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

/// Widget élégant et sobre pour afficher le logo texte Whizpee
/// Animations fluides et subtiles, design épuré, ergonomie optimale
class AnimatedWhizpeeLogo extends StatefulWidget {
  final double height;
  final bool isCompact;

  const AnimatedWhizpeeLogo({
    super.key,
    this.height = 56,
    this.isCompact = false,
  });

  @override
  State<AnimatedWhizpeeLogo> createState() => _AnimatedWhizpeeLogoState();
}

class _AnimatedWhizpeeLogoState extends State<AnimatedWhizpeeLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _breatheAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Un seul contrôleur pour tous les effets (meilleure performance)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();

    // Effet de respiration subtil
    _breatheAnimation = Tween<double>(begin: 0.97, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOutCubic),
      ),
    );

    // Effet shimmer élégant
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutQuad,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = VThemeListener.I.isDarkMode;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _breatheAnimation.value,
          child: SizedBox(
            height: widget.height,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Glow subtil et élégant
                if (!widget.isCompact)
                  Positioned.fill(
                    child: Transform.scale(
                      scale: 1.4,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.primaryGreen.withValues(
                                alpha: 0.12 *
                                    math.sin(_controller.value * math.pi),
                              ),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // Logo principal avec effet shimmer élégant
                ClipRect(
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      final shimmerPosition = _shimmerAnimation.value;
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.85),
                          Colors.white,
                          Colors.white,
                          Colors.white.withValues(alpha: 0.85),
                        ],
                        stops: [
                          math.max(0.0, shimmerPosition - 0.3),
                          math.max(0.0, shimmerPosition - 0.1),
                          math.min(1.0, shimmerPosition + 0.1),
                          math.min(1.0, shimmerPosition + 0.3),
                        ],
                      ).createShader(bounds);
                    },
                    child: Image.asset(
                      isDark
                          ? "assets/whizpee-text-wb-dark.png"
                          : "assets/whizpee-text-wb-light.png",
                      height: widget.height,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),

                // Accent glow très subtil
                if (!widget.isCompact)
                  Positioned(
                    bottom: -widget.height * 0.15,
                    child: Container(
                      width: widget.height * 2,
                      height: widget.height * 0.3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppTheme.primaryGreen.withValues(
                              alpha: 0.08 *
                                  math.sin(_controller.value * math.pi * 2),
                            ),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
