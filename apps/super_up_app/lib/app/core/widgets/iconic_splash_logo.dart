import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

/// Logo iconique RÉVOLUTIONNAIRE pour le splash screen
/// Repousse TOUTES les limites du design Flutter avec des effets 3D, particules, hologramme
class IconicSplashLogo extends StatefulWidget {
  final double size;

  const IconicSplashLogo({
    super.key,
    this.size = 180,
  });

  @override
  State<IconicSplashLogo> createState() => _IconicSplashLogoState();
}

class _IconicSplashLogoState extends State<IconicSplashLogo>
    with TickerProviderStateMixin {
  late AnimationController _masterController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late AnimationController _hologramController;
  late AnimationController _energyController;

  @override
  void initState() {
    super.initState();

    // Contrôleur maître pour orchestrer toutes les animations
    _masterController = AnimationController(
      duration: const Duration(milliseconds: 6000),
      vsync: this,
    )..repeat();

    // Rotation 3D fluide et continue
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 12000),
      vsync: this,
    )..repeat();

    // Pulsation du glow
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Particules orbitales
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    )..repeat();

    // Effet hologramme
    _hologramController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    // Vagues d'énergie
    _energyController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _masterController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _hologramController.dispose();
    _energyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 2,
      height: widget.size * 2,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _masterController,
          _rotationController,
          _pulseController,
          _particleController,
          _hologramController,
          _energyController,
        ]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Couche 1: Vagues d'énergie expansives
              ..._buildEnergyWaves(),

              // Couche 2: Anneaux orbitaux tournants
              ..._buildOrbitalRings(),

              // Couche 3: Particules orbitales
              ..._buildOrbitalParticles(),

              // Couche 4: Glow pulsant multicouche
              ..._buildMultiLayerGlow(),

              // Couche 5: Logo central avec effet 3D révolutionnaire
              _buildRevolutionary3DLogo(),

              // Couche 6: Effet hologramme scanlines
              _buildHologramEffect(),

              // Couche 7: Particules étincelles aléatoires
              ..._buildSparkles(),

              // Couche 8: Aura de puissance
              _buildPowerAura(),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildEnergyWaves() {
    return List.generate(3, (index) {
      final progress = (_energyController.value + (index * 0.33)) % 1.0;
      final scale = 1.0 + (progress * 1.5);
      final opacity = (1.0 - progress) * 0.4;

      return Transform.scale(
        scale: scale,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primaryGreen.withValues(alpha: opacity),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGreen.withValues(alpha: opacity * 0.6),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _buildOrbitalRings() {
    return List.generate(2, (ringIndex) {
      final angle = _rotationController.value *
          2 *
          math.pi *
          (ringIndex % 2 == 0 ? 1 : -1);

      return Transform.rotate(
        angle: angle,
        child: SizedBox(
          width: widget.size * (1.2 + ringIndex * 0.2),
          height: widget.size * (1.2 + ringIndex * 0.2),
          child: CustomPaint(
            painter: _OrbitalRingPainter(
              color: AppTheme.primaryGreen,
              opacity: 0.3 + (_pulseController.value * 0.3),
              segments: 8 + ringIndex * 4,
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildOrbitalParticles() {
    return List.generate(12, (index) {
      final angle = (index / 12) * 2 * math.pi +
          (_particleController.value * 2 * math.pi);
      final distance = widget.size * 0.6;
      final size =
          6.0 + math.sin(_masterController.value * 2 * math.pi + index) * 3.0;

      return Positioned(
        left: widget.size + math.cos(angle) * distance,
        top: widget.size + math.sin(angle) * distance,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppTheme.primaryGreen,
                AppTheme.primaryGreen.withValues(alpha: 0.0),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGreen.withValues(alpha: 0.8),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _buildMultiLayerGlow() {
    return [
      // Glow massif externe
      Transform.scale(
        scale: 2.5 + (_pulseController.value * 0.3),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppTheme.primaryGreen
                    .withValues(alpha: 0.15 * _pulseController.value),
                Colors.purple.withValues(alpha: 0.1 * _pulseController.value),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      // Glow moyen
      Transform.scale(
        scale: 1.8 + (_pulseController.value * 0.2),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppTheme.primaryGreen
                    .withValues(alpha: 0.3 * _pulseController.value),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      // Glow proche intense
      Transform.scale(
        scale: 1.3 + (_pulseController.value * 0.15),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppTheme.primaryGreen
                    .withValues(alpha: 0.5 * _pulseController.value),
                AppTheme.primaryGreen
                    .withValues(alpha: 0.2 * _pulseController.value),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildRevolutionary3DLogo() {
    final rotationY = math.sin(_rotationController.value * 2 * math.pi) * 0.3;
    final rotationX = math.cos(_rotationController.value * 2 * math.pi) * 0.15;
    final scale =
        1.0 + (math.sin(_masterController.value * 2 * math.pi) * 0.05);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Perspective forte
        ..rotateY(rotationY)
        ..rotateX(rotationX)
        ..scale(scale),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ombres multiples pour profondeur 3D extrême
          for (int i = 10; i > 0; i--)
            Transform.translate(
              offset: Offset(
                i * math.cos(rotationY) * 1.5,
                i * math.sin(rotationX) * 1.5,
              ),
              child: Opacity(
                opacity: 0.05 * (11 - i) / 10,
                child: Container(
                  width: widget.size * 0.55,
                  height: widget.size * 0.55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Logo principal avec multiples effets
          Container(
            width: widget.size * 0.55,
            height: widget.size * 0.55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.primaryGreen.withValues(alpha: 0.3),
                  AppTheme.primaryGreen,
                  AppTheme.primaryGreen,
                  const Color(0xFF00FF9D),
                ],
                stops: const [0.0, 0.4, 0.8, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.8),
                  blurRadius: 50,
                  spreadRadius: 20,
                ),
                BoxShadow(
                  color: AppTheme.primaryGreen,
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.size * 0.55),
              child: Stack(
                children: [
                  // Image du logo
                  Center(
                    child: Image.asset(
                      "assets/logo.png",
                      width: widget.size * 0.45,
                      height: widget.size * 0.45,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Overlay gradient animé
                  Container(
                    decoration: BoxDecoration(
                      gradient: SweepGradient(
                        colors: [
                          Colors.transparent,
                          AppTheme.primaryGreen
                              .withValues(alpha: 0.3 * _pulseController.value),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                        transform: GradientRotation(
                            _masterController.value * 2 * math.pi),
                      ),
                    ),
                  ),

                  // Reflet brillant qui se déplace
                  Positioned(
                    left: (widget.size * 0.55 * 0.5) +
                        (math.cos(_masterController.value * 2 * math.pi) *
                            widget.size *
                            0.2),
                    top: (widget.size * 0.55 * 0.3) +
                        (math.sin(_masterController.value * 2 * math.pi) *
                            widget.size *
                            0.1),
                    child: Container(
                      width: widget.size * 0.2,
                      height: widget.size * 0.3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(
                                alpha: 0.6 * _pulseController.value),
                            Colors.white.withValues(
                                alpha: 0.2 * _pulseController.value),
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
          ),
        ],
      ),
    );
  }

  Widget _buildHologramEffect() {
    return ClipOval(
      child: SizedBox(
        width: widget.size * 0.7,
        height: widget.size * 0.7,
        child: Stack(
          children: List.generate(30, (index) {
            final offset = (index * (widget.size * 0.7 / 30)) +
                (_hologramController.value * widget.size * 0.7);

            return Positioned(
              top: offset % (widget.size * 0.7),
              left: 0,
              right: 0,
              child: Container(
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppTheme.primaryGreen.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  List<Widget> _buildSparkles() {
    return List.generate(16, (index) {
      final angle = (index / 16) * 2 * math.pi;
      final distance = widget.size * 0.5 +
          (math.sin(_masterController.value * 2 * math.pi + index) *
              widget.size *
              0.15);
      final sparkleOpacity =
          (math.sin(_energyController.value * 2 * math.pi + index) * 0.5 + 0.5);

      return Positioned(
        left: widget.size + math.cos(angle) * distance,
        top: widget.size + math.sin(angle) * distance,
        child: Opacity(
          opacity: sparkleOpacity,
          child: Icon(
            Icons.auto_awesome,
            size: 12 + (sparkleOpacity * 8),
            color: AppTheme.primaryGreen,
            shadows: [
              Shadow(
                color: AppTheme.primaryGreen.withValues(alpha: 0.8),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPowerAura() {
    return Transform.scale(
      scale: 1.6 + (_energyController.value * 0.2),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.transparent,
              AppTheme.primaryGreen
                  .withValues(alpha: 0.1 * (1 - _energyController.value)),
              AppTheme.primaryGreen
                  .withValues(alpha: 0.2 * (1 - _energyController.value)),
              Colors.transparent,
            ],
            stops: const [0.0, 0.6, 0.8, 1.0],
          ),
        ),
      ),
    );
  }
}

class _OrbitalRingPainter extends CustomPainter {
  final Color color;
  final double opacity;
  final int segments;

  _OrbitalRingPainter({
    required this.color,
    required this.opacity,
    required this.segments,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < segments; i++) {
      final startAngle = (i / segments) * 2 * math.pi;
      final sweepAngle = (math.pi / segments) * 0.7;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_OrbitalRingPainter oldDelegate) => true;
}
