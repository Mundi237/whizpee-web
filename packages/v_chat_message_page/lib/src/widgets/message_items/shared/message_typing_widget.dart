// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageTypingWidget extends StatefulWidget {
  final String text;
  const MessageTypingWidget({super.key, required this.text});

  @override
  State<MessageTypingWidget> createState() => _MessageTypingWidgetState();
}

class _MessageTypingWidgetState extends State<MessageTypingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) => Opacity(
            opacity: _pulseAnimation.value,
            child: child,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: CupertinoColors.systemGreen,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          widget.text,
          style: const TextStyle(
            color: CupertinoColors.systemGreen,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
