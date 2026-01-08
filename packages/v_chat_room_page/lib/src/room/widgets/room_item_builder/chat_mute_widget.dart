// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/room/shared/shared.dart';

class ChatMuteWidget extends StatefulWidget {
  /// Flag indicating whether the current chat is muted.
  final bool isMuted;

  /// Creates a new instance of [ChatMuteWidget].
  const ChatMuteWidget({super.key, required this.isMuted});

  @override
  State<ChatMuteWidget> createState() => _ChatMuteWidgetState();
}

class _ChatMuteWidgetState extends State<ChatMuteWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    if (widget.isMuted) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(ChatMuteWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMuted != widget.isMuted) {
      if (widget.isMuted) {
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
    final vRoomTheme = context.vRoomTheme;

    if (!widget.isMuted) return const SizedBox.shrink();
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(right: 4),
          child: vRoomTheme.muteIcon,
        ),
      ),
    );
  }
}
