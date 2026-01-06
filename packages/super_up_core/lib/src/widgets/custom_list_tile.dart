// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textless/textless.dart';

class CustomListTile extends StatefulWidget {
  final Widget leading;
  final Widget? trailing;
  final String title;
  final String? subtitle;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final EdgeInsets? padding;
  final bool enableFeedback;

  const CustomListTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.trailing,
    this.enableFeedback = true,
  });

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: theme.brightness == Brightness.dark
          ? Colors.white.withOpacity(0.05)
          : Colors.black.withOpacity(0.03),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null || widget.onLongPress != null) {
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
    widget.onTap?.call();
  }

  void _handleLongPress() {
    if (widget.enableFeedback) {
      HapticFeedback.mediumImpact();
    }
    widget.onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: widget.padding ?? const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.leading,
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 150),
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white.withOpacity(0.87)
                                  : Colors.black87,
                            ),
                            child: widget.title.text.maxLine(1).overflowEllipsis,
                          ),
                          if (widget.subtitle != null) ...[
                            const SizedBox(height: 4),
                            widget.subtitle!.text
                                .size(13)
                                .color(Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white60
                                    : Colors.black54)
                                .maxLine(1)
                                .overflowEllipsis,
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.trailing != null) ...[
                const SizedBox(width: 8),
                widget.trailing!,
              ],
            ],
          ),
        ],
      ),
    );

    if (widget.onTap == null && widget.onLongPress == null) {
      return content;
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap != null ? _handleTap : null,
      onLongPress: widget.onLongPress != null ? _handleLongPress : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        ),
        child: content,
      ),
    );
  }
}

class ChatListTile extends StatefulWidget {
  final Widget leading;
  final Widget? trailing;
  final String title;
  final Widget? subtitle;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final EdgeInsets? padding;
  final bool enableFeedback;

  const ChatListTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.trailing,
    this.enableFeedback = true,
  });

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.enableFeedback) {
      HapticFeedback.lightImpact();
    }
    widget.onTap?.call();
  }

  void _handleLongPress() {
    if (widget.enableFeedback) {
      HapticFeedback.mediumImpact();
    }
    widget.onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        if (widget.enableFeedback) {
          HapticFeedback.selectionClick();
        }
      },
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap != null ? _handleTap : null,
      onLongPress: widget.onLongPress != null ? _handleLongPress : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: ListTile(
          contentPadding: widget.padding ?? EdgeInsets.zero,
          leading: widget.leading,
          trailing: widget.trailing,
          dense: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          minLeadingWidth: 0,
          title: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: widget.subtitle,
          subtitleTextStyle: const TextStyle(height: 0.8),
        ),
      ),
    );
  }
}
