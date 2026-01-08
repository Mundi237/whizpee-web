// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_chat_input_ui/src/models/models.dart';

class MessageRecordBtn extends StatefulWidget {
  final VoidCallback onRecordClick;

  const MessageRecordBtn({super.key, required this.onRecordClick});

  @override
  State<MessageRecordBtn> createState() => _MessageRecordBtnState();
}

class _MessageRecordBtnState extends State<MessageRecordBtn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
        HapticFeedback.heavyImpact();
        widget.onRecordClick();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: _isPressed
                  ? [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: child,
          ),
        ),
        child: context.vInputTheme.recordBtn,
      ),
    );
  }
}
