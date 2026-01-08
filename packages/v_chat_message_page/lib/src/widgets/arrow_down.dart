// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_up_core/super_up_core.dart';

class ListViewArrowDown extends StatefulWidget {
  const ListViewArrowDown({
    super.key,
    required this.onPress,
    required this.scrollController,
  });

  final VoidCallback onPress;
  final ScrollController scrollController;

  @override
  State<ListViewArrowDown> createState() => _ListViewArrowDownState();
}

class _ListViewArrowDownState extends State<ListViewArrowDown>
    with SingleTickerProviderStateMixin {
  bool isShown = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_listener);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: isShown ? Offset.zero : const Offset(0, 2),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        opacity: isShown ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: GestureDetector(
          onTapDown: (_) {
            setState(() => _isPressed = true);
            _controller.forward();
            HapticFeedback.selectionClick();
          },
          onTapUp: (_) {
            setState(() => _isPressed = false);
            _controller.reverse();
          },
          onTapCancel: () {
            setState(() => _isPressed = false);
            _controller.reverse();
          },
          onTap: () {
            HapticFeedback.mediumImpact();
            widget.onPress();
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: context.isDark
                    ? CupertinoColors.secondarySystemGroupedBackground.darkColor
                    : CupertinoColors.secondarySystemGroupedBackground,
                boxShadow: _isPressed
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Icon(
                CupertinoIcons.arrow_down_circle_fill,
                color: Colors.indigoAccent,
                size: 28,
                shadows: _isPressed
                    ? []
                    : [
                        Shadow(
                          color: Colors.indigoAccent.withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _listener() {
    final shouldShow = widget.scrollController.offset > 150.0;
    if (isShown != shouldShow) {
      setState(() {
        isShown = shouldShow;
      });
    }
  }
}
