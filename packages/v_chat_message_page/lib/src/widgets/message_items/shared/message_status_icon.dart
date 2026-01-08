// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../v_chat_message_page.dart';

class MessageStatusIconDataModel {
  final bool isMeSender;
  final bool isSeen;
  final bool isDeliver;
  final bool isAllDeleted;
  final VMessageEmitStatus emitStatus;

  const MessageStatusIconDataModel({
    required this.isMeSender,
    required this.isSeen,
    required this.isDeliver,
    this.isAllDeleted = false,
    required this.emitStatus,
  });
}

class MessageStatusIcon extends StatefulWidget {
  final VoidCallback? onReSend;
  final MessageStatusIconDataModel model;
  const MessageStatusIcon({
    super.key,
    required this.model,
    this.onReSend,
  });

  @override
  State<MessageStatusIcon> createState() => _MessageStatusIconState();
}

class _MessageStatusIconState extends State<MessageStatusIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(MessageStatusIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model.emitStatus != widget.model.emitStatus ||
        oldWidget.model.isSeen != widget.model.isSeen ||
        oldWidget.model.isDeliver != widget.model.isDeliver) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = context.vMessageTheme.messageSendingStatus;
    if (!widget.model.isMeSender || widget.model.isAllDeleted) {
      return const SizedBox.shrink();
    }
    
    Widget icon;
    if (widget.model.isSeen) {
      icon = themeData.seenIcon;
    } else if (widget.model.isDeliver) {
      icon = themeData.deliverIcon;
    } else {
      icon = _getIcon(themeData);
    }
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 0),
        child: icon,
      ),
    );
  }

  Widget _getIcon(VMsgStatusTheme themeData) {
    switch (widget.model.emitStatus) {
      case VMessageEmitStatus.serverConfirm:
        return themeData.sendIcon;
      case VMessageEmitStatus.error:
        return GestureDetector(
          onTapDown: (_) => HapticFeedback.selectionClick(),
          onTap: () {
            if (widget.onReSend != null) {
              HapticFeedback.mediumImpact();
              widget.onReSend!();
            }
          },
          child: themeData.refreshIcon,
        );
      case VMessageEmitStatus.sending:
        return themeData.pendingIcon;
    }
  }
}
