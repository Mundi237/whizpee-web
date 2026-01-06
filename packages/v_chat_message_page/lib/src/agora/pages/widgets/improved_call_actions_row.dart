// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class ImprovedCallActionButton extends StatefulWidget {
  const ImprovedCallActionButton({
    super.key,
    this.onTap,
    required this.icon,
    this.isEnabled = true,
    this.backgroundColor,
    this.radius = 28,
    this.iconSize = 24,
    this.iconColor,
    this.disabledBackgroundColor,
    this.disabledIconColor,
  });

  final VoidCallback? onTap;
  final IconData icon;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final double radius;
  final double iconSize;
  final Color? iconColor;
  final Color? disabledIconColor;

  @override
  State<ImprovedCallActionButton> createState() =>
      _ImprovedCallActionButtonState();
}

class _ImprovedCallActionButtonState extends State<ImprovedCallActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _shadowAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = _getBackgroundColor();
    final effectiveIconColor = _getIconColor();

    return GestureDetector(
      onTapDown: widget.isEnabled ? _onTapDown : null,
      onTapUp: widget.isEnabled ? _onTapUp : null,
      onTapCancel: widget.isEnabled ? _onTapCancel : null,
      onTap: widget.isEnabled ? widget.onTap : null,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.radius * 2,
              height: widget.radius * 2,
              decoration: BoxDecoration(
                color: effectiveBackgroundColor,
                shape: BoxShape.circle,
                boxShadow: widget.isEnabled
                    ? [
                        BoxShadow(
                          color: effectiveBackgroundColor.withValues(alpha:0.3),
                          blurRadius: 12 * _shadowAnimation.value,
                          spreadRadius: 2 * _shadowAnimation.value,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha:0.2),
                          blurRadius: 8 * _shadowAnimation.value,
                          offset: Offset(0, 4 * _shadowAnimation.value),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha:0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                border: Border.all(
                  color: widget.isEnabled
                      ? Colors.white.withValues(alpha:0.2)
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    widget.icon,
                    key: ValueKey(widget.icon),
                    size: widget.iconSize,
                    color: effectiveIconColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getBackgroundColor() {
    if (!widget.isEnabled) {
      return widget.disabledBackgroundColor ?? Colors.grey.shade800;
    }
    return widget.backgroundColor ?? Colors.white.withValues(alpha:0.9);
  }

  Color _getIconColor() {
    if (!widget.isEnabled) {
      return widget.disabledIconColor ?? Colors.grey.shade600;
    }
    return widget.iconColor ?? Colors.black87;
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _onTapEnd();
  }

  void _onTapCancel() {
    _onTapEnd();
  }

  void _onTapEnd() {
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class CallActionButtonGroup extends StatelessWidget {
  const CallActionButtonGroup({
    super.key,
    required this.buttons,
    this.spacing = 16.0,
    this.alignment = WrapAlignment.spaceEvenly,
  });

  final List<Widget> buttons;
  final double spacing;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: alignment,
      spacing: spacing,
      runSpacing: spacing,
      children: buttons,
    );
  }
}

class PulsingCallActionButton extends StatefulWidget {
  const PulsingCallActionButton({
    super.key,
    required this.child,
    this.isPulsing = true,
  });

  final Widget child;
  final bool isPulsing;

  @override
  State<PulsingCallActionButton> createState() =>
      _PulsingCallActionButtonState();
}

class _PulsingCallActionButtonState extends State<PulsingCallActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isPulsing) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulsingCallActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPulsing != oldWidget.isPulsing) {
      if (widget.isPulsing) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isPulsing ? _pulseAnimation.value : 1.0,
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
}
