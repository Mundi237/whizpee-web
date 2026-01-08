// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_chat_message_page/src/v_chat/platform_cache_image_widget.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../core/types.dart';

class ReplyItemWidget extends StatefulWidget {
  final VBaseMessage? rToMessage;
  final VMessageCallback? onHighlightMessage;
  final bool isMeSender;
  final String repliedToYourSelf;

  const ReplyItemWidget({
    super.key,
    required this.rToMessage,
    required this.onHighlightMessage,
    required this.isMeSender,
    required this.repliedToYourSelf,
  });

  @override
  State<ReplyItemWidget> createState() => _ReplyItemWidgetState();
}

class _ReplyItemWidgetState extends State<ReplyItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
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
    if (widget.rToMessage == null) {
      return const SizedBox.shrink();
    }
    final method =
        context.vMessageTheme.vMessageItemTheme.replyMessageItemBuilder;
    if (method != null) {
      return method(context, widget.isMeSender, widget.rToMessage!);
    }

    return GestureDetector(
      onTapDown: (_) {
        if (widget.onHighlightMessage != null) {
          setState(() => _isPressed = true);
          _controller.forward();
          HapticFeedback.selectionClick();
        }
      },
      onTapUp: (_) {
        if (widget.onHighlightMessage != null) {
          setState(() => _isPressed = false);
          _controller.reverse();
        }
      },
      onTapCancel: () {
        if (widget.onHighlightMessage != null) {
          setState(() => _isPressed = false);
          _controller.reverse();
        }
      },
      onTap: widget.onHighlightMessage == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.onHighlightMessage!(widget.rToMessage!);
            },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: const BoxConstraints(maxWidth: 300, minWidth: 150),
          decoration: BoxDecoration(
            color: widget.isMeSender
                ? context.vMessageTheme.senderReplyColor
                : context.vMessageTheme.receiverReplyColor,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(8),
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
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 3,
                    decoration: BoxDecoration(
                      color: widget.isMeSender ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTitle(context),
                          style: TextStyle(
                            color: widget.isMeSender ? Colors.green : Colors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.rToMessage!.realContentMentionParsedWithAt,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _getImage()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getTitle(BuildContext context) {
    if (widget.rToMessage!.isMeSender && widget.isMeSender) {
      return widget.repliedToYourSelf;
    }
    return widget.rToMessage!.senderName;
  }

  Widget _getImage() {
    if (widget.rToMessage! is VImageMessage) {
      final msg = widget.rToMessage! as VImageMessage;
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: VPlatformCacheImageWidget(
          source: msg.data.fileSource,
          borderRadius: BorderRadius.circular(6),
          size: const Size(40, 40),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
