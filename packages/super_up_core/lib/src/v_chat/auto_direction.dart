// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

/// Automatically detects and applies text direction (RTL/LTR)
/// Provides smooth transitions when direction changes
class AutoDirection extends StatefulWidget {
  final String text;
  final Widget child;
  final void Function(bool isRTL)? onDirectionChange;
  final bool enableAnimation;
  final Duration animationDuration;

  const AutoDirection({
    super.key,
    required this.text,
    required this.child,
    this.onDirectionChange,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  AutoDirectionState createState() => AutoDirectionState();
}

class AutoDirectionState extends State<AutoDirection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  TextDirection? _currentDirection;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _currentDirection = _getTextDirection(widget.text);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AutoDirection oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    final oldDirection = _getTextDirection(oldWidget.text);
    final newDirection = _getTextDirection(widget.text);
    
    if (oldDirection != newDirection) {
      if (widget.enableAnimation) {
        _controller.reset();
        _controller.forward();
      }
      
      setState(() {
        _currentDirection = newDirection;
      });
      
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.onDirectionChange?.call(newDirection == TextDirection.rtl),
      );
    }
  }

  TextDirection _getTextDirection(String text) {
    if (text.isEmpty) {
      return Directionality.of(context);
    }
    return intl.Bidi.detectRtlDirectionality(text)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  @override
  Widget build(BuildContext context) {
    final direction = _currentDirection ?? _getTextDirection(widget.text);
    
    if (!widget.enableAnimation) {
      return Directionality(
        textDirection: direction,
        child: widget.child,
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Directionality(
        textDirection: direction,
        child: widget.child,
      ),
    );
  }
}
