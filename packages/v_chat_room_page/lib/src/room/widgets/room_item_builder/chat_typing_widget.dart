// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatTypingWidget extends StatefulWidget {
  /// The text to be displayed along with the typing indicator.
  final String text;

  /// Creates a [ChatTypingWidget] widget.
  const ChatTypingWidget({super.key, required this.text});

  @override
  State<ChatTypingWidget> createState() => _ChatTypingWidgetState();
}

class _ChatTypingWidgetState extends State<ChatTypingWidget>
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
                  width: 5,
                  height: 5,
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
        Flexible(
          child: Text(
            widget.text,
            style: const TextStyle(
              color: CupertinoColors.systemGreen,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
