// Copyright 2025, the hatemragab project.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MessageReactionsBar extends StatefulWidget {
  final int reactionNumber;
  final List<ReactionSample> reactionSample;
  final bool isMeSender;
  final VoidCallback? onTap;

  const MessageReactionsBar({
    super.key,
    required this.reactionNumber,
    required this.reactionSample,
    required this.isMeSender,
    this.onTap,
  });

  @override
  State<MessageReactionsBar> createState() => _MessageReactionsBarState();
}

class _MessageReactionsBarState extends State<MessageReactionsBar>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
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
    if (widget.reactionNumber == 0 || widget.reactionSample.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTapDown: (_) {
        if (widget.onTap != null) {
          setState(() => _isPressed = true);
          _controller.forward();
          HapticFeedback.selectionClick();
        }
      },
      onTapUp: (_) {
        if (widget.onTap != null) {
          setState(() => _isPressed = false);
          _controller.reverse();
        }
      },
      onTapCancel: () {
        if (widget.onTap != null) {
          setState(() => _isPressed = false);
          _controller.reverse();
        }
      },
      onTap: widget.onTap != null
          ? () {
              HapticFeedback.lightImpact();
              widget.onTap!();
            }
          : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]?.withValues(alpha: 0.9)
                : Colors.grey[200]?.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isPressed
                  ? (Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[500]!
                      : Colors.grey[400]!)
                  : (Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[600]!
                      : Colors.grey[300]!),
              width: _isPressed ? 1.0 : 0.5,
            ),
            boxShadow: _isPressed
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Display emoji sample with stagger effect
              ...widget.reactionSample.take(3).map((reactionSample) {
                final index = widget.reactionSample.indexOf(reactionSample);
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < 2 ? 2 : 0,
                    left: index > 0 ? -4 : 0,
                  ),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: _isPressed ? 15 : 16,
                    ),
                    child: Text(reactionSample.emoji),
                  ),
                );
              }),
              if (widget.reactionNumber > 0) ...[
                const SizedBox(width: 6),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[300]
                        : Colors.grey[700],
                  ),
                  child: Text(widget.reactionNumber.toString()),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}