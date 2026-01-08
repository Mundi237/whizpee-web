// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Badge;

class ChatUnReadWidget extends StatefulWidget {
  /// The number of un-read chats to be displayed.
  final int unReadCount;

  /// Creates a new instance of [ChatUnReadWidget].
  const ChatUnReadWidget({super.key, required this.unReadCount});

  @override
  State<ChatUnReadWidget> createState() => _ChatUnReadWidgetState();
}

class _ChatUnReadWidgetState extends State<ChatUnReadWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.unReadCount == 0) return const SizedBox.shrink();
    
    final displayCount = widget.unReadCount > 99 ? '99+' : widget.unReadCount.toString();
    
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) => Transform.scale(
        scale: _pulseAnimation.value,
        child: child,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        constraints: const BoxConstraints(
          minHeight: 20,
          minWidth: 20,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: CupertinoColors.systemGreen,
          shape: widget.unReadCount > 99 ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: widget.unReadCount > 99 ? BorderRadius.circular(10) : null,
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGreen.withOpacity(0.5),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(
          displayCount,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
