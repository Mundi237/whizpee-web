// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// Conditional widget builder with smooth transitions
/// Provides better UX by animating between states
class VConditionalBuilder extends StatefulWidget {
  final bool condition;
  final Widget Function() thenBuilder;
  final Widget Function()? elseBuilder;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool enableAnimation;

  const VConditionalBuilder({
    super.key,
    required this.condition,
    required this.thenBuilder,
    this.elseBuilder,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOut,
    this.enableAnimation = true,
  });

  @override
  State<VConditionalBuilder> createState() => _VConditionalBuilderState();
}

class _VConditionalBuilderState extends State<VConditionalBuilder> {
  @override
  Widget build(BuildContext context) {
    final thenWidget = widget.thenBuilder.call();
    final elseWidget = widget.elseBuilder?.call() ?? const SizedBox.shrink();

    if (!widget.enableAnimation) {
      return widget.condition ? thenWidget : elseWidget;
    }

    return AnimatedSwitcher(
      duration: widget.animationDuration,
      switchInCurve: widget.animationCurve,
      switchOutCurve: widget.animationCurve,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: widget.condition
          ? KeyedSubtree(
              key: const ValueKey('then'),
              child: thenWidget,
            )
          : KeyedSubtree(
              key: const ValueKey('else'),
              child: elseWidget,
            ),
    );
  }
}
