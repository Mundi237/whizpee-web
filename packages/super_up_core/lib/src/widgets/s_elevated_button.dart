// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_up_core/src/utils/utils.dart';
import 'package:super_up_core/src/v_chat/extension.dart';

class SElevatedButton extends StatefulWidget {
  final String title;
  final VoidCallback? onPress;
  final bool isLoading;
  final IconData? icon;
  final double height;

  const SElevatedButton({
    super.key,
    required this.title,
    required this.onPress,
    this.isLoading = false,
    this.icon,
    this.height = 52,
  });

  @override
  State<SElevatedButton> createState() => _SElevatedButtonState();
}

class _SElevatedButtonState extends State<SElevatedButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPress != null && !widget.isLoading) {
      HapticFeedback.selectionClick();
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPress != null && !widget.isLoading) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTap() {
    if (widget.onPress != null && !widget.isLoading) {
      HapticFeedback.mediumImpact();
      widget.onPress!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPress == null || widget.isLoading;
    final isDark = context.isDark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            height: widget.height,
            decoration: BoxDecoration(
              color: _getBackgroundColor(isDark, isDisabled),
              borderRadius: BorderRadius.circular(12),
              boxShadow: isDisabled
                  ? []
                  : [
                      BoxShadow(
                        color: (isDark ? Colors.white24 : AppTheme.primaryGreen)
                            .withOpacity(_isPressed ? 0.2 : (_isHovered ? 0.4 : 0.3)),
                        blurRadius: _isPressed ? 6 : (_isHovered ? 12 : 8),
                        offset: Offset(0, _isPressed ? 2 : (_isHovered ? 4 : 3)),
                      ),
                    ],
            ),
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: widget.isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark ? Colors.white70 : Colors.white,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDisabled ? Colors.white60 : Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(bool isDark, bool isDisabled) {
    if (isDisabled) {
      return isDark ? Colors.white12 : CupertinoColors.systemGrey3;
    }
    if (_isPressed) {
      return isDark
          ? Colors.white.withOpacity(0.15)
          : AppTheme.primaryGreen.withOpacity(0.8);
    }
    if (_isHovered) {
      return isDark
          ? Colors.white.withOpacity(0.28)
          : AppTheme.primaryGreen.withOpacity(0.9);
    }
    return isDark ? Colors.white24 : AppTheme.primaryGreen;
  }
}
