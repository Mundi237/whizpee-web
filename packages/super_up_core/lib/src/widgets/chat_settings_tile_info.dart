// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatSettingsTileInfo extends StatefulWidget {
  const ChatSettingsTileInfo({
    super.key,
    required this.title,
    this.trailing,
    this.margin = const EdgeInsets.all(10),
    this.padding,
    this.onPressed,
    this.enableFeedback = true,
  });

  final Widget title;
  final EdgeInsets? padding;
  final EdgeInsets margin;
  final Widget? trailing;
  final VoidCallback? onPressed;
  final bool enableFeedback;

  @override
  State<ChatSettingsTileInfo> createState() => _ChatSettingsTileInfoState();
}

class _ChatSettingsTileInfoState extends State<ChatSettingsTileInfo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      _controller.forward();
      if (widget.enableFeedback) {
        HapticFeedback.selectionClick();
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  void _handleTap() {
    if (widget.enableFeedback) {
      HapticFeedback.lightImpact();
    }
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: CupertinoListSection.insetGrouped(
        hasLeading: false,
        dividerMargin: 0,
        topMargin: 0,
        additionalDividerMargin: 0,
        margin: widget.margin,
        children: [
          GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: CupertinoListTile(
              onTap: widget.onPressed != null ? _handleTap : null,
              padding: widget.padding,
              leadingSize: 0,
              title: DefaultTextStyle(
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                child: widget.title,
              ),
              trailing: widget.trailing != null
                  ? AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: widget.trailing,
                    )
                  : null,
            ),
          )
        ],
      ),
    );
  }
}
