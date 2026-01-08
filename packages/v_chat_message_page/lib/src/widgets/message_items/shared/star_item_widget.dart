// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarItemWidget extends StatefulWidget {
  final bool isStar;

  const StarItemWidget({
    super.key,
    required this.isStar,
  });

  @override
  State<StarItemWidget> createState() => _StarItemWidgetState();
}

class _StarItemWidgetState extends State<StarItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    if (widget.isStar) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(StarItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isStar != widget.isStar) {
      if (widget.isStar) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isStar) return const SizedBox.shrink();
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: Transform.rotate(
          angle: _rotateAnimation.value * 2 * 3.14159,
          child: child,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(
          CupertinoIcons.star_fill,
          color: Colors.green,
          size: 16,
        ),
      ),
    );
  }
}
