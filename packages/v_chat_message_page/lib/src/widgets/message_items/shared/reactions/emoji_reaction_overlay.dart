// Copyright 2025, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnEmojiSelected = void Function(String emoji);

class EmojiReactionOverlay {
  static OverlayEntry? _entry;

  static bool get isShown => _entry != null;

  static void hide() {
    _entry?.remove();
    _entry = null;
  }

  static void show({
    required BuildContext context,
    required Rect targetRect,
    required OnEmojiSelected onSelected,
    required VoidCallback onMore,
    List<String>? emojis,
    String? currentUserEmoji,
  }) {
    if (isShown) hide();

    final media = MediaQuery.of(context);
    final screenSize = media.size;
    final padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 8);
    final emojiSize = 24.0;
    final itemPadding = 8.0;

    final items = (emojis ?? const ['❤️', '😂', '😮', '😢', '😡', '👍']);
    final count = items.length + 1; // +1 for more button
    final perItemWidth = emojiSize + (itemPadding * 2);
    final barWidth = (perItemWidth * count) + padding.horizontal;
    final barHeight = emojiSize + (itemPadding * 2) + padding.vertical;

    final preferTop = targetRect.top - 8.0 - barHeight;
    final showAbove = preferTop > media.padding.top + 8.0;

    final centerX = targetRect.left + (targetRect.width / 2);
    final left = math.max(8.0, math.min(centerX - (barWidth / 2), screenSize.width - barWidth - 8.0));
    final top = showAbove ? preferTop : targetRect.bottom + 8.0;

    _entry = OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            // Barrier to detect outside taps
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: hide,
                child: const SizedBox.expand(),
              ),
            ),
            Positioned(
              left: left,
              top: top,
              child: _ReactionBar(
                items: items,
                currentUserEmoji: currentUserEmoji,
                onSelected: (e) {
                  hide();
                  onSelected(e);
                },
                onMore: () {
                  hide();
                  onMore();
                },
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }
}

class _ReactionBar extends StatefulWidget {
  final List<String> items;
  final OnEmojiSelected onSelected;
  final VoidCallback onMore;
  final String? currentUserEmoji;

  const _ReactionBar({
    required this.items,
    required this.onSelected,
    required this.onMore,
    this.currentUserEmoji,
  });

  @override
  State<_ReactionBar> createState() => _ReactionBarState();
}

class _ReactionBarState extends State<_ReactionBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < widget.items.length; i++)
                  _EmojiItem(
                    emoji: widget.items[i],
                    isSelected: widget.items[i] == widget.currentUserEmoji,
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      widget.onSelected(widget.items[i]);
                    },
                    delay: Duration(milliseconds: i * 30),
                  ),
                _MoreItem(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    widget.onMore();
                  },
                  delay: Duration(milliseconds: widget.items.length * 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmojiItem extends StatefulWidget {
  final String emoji;
  final VoidCallback onTap;
  final bool isSelected;
  final Duration delay;

  const _EmojiItem({
    required this.emoji,
    required this.onTap,
    this.isSelected = false,
    this.delay = Duration.zero,
  });

  @override
  State<_EmojiItem> createState() => _EmojiItemState();
}

class _EmojiItemState extends State<_EmojiItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          HapticFeedback.selectionClick();
        },
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isPressed ? 0.85 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.all(10),
            decoration: widget.isSelected
                ? BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: theme.primaryColor,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  )
                : BoxDecoration(
                    color: _isPressed
                        ? theme.brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.05)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
            child: Text(
              widget.emoji,
              style: const TextStyle(fontSize: 26),
            ),
          ),
        ),
      ),
    );
  }
}

class _MoreItem extends StatefulWidget {
  final VoidCallback onTap;
  final Duration delay;

  const _MoreItem({
    required this.onTap,
    this.delay = Duration.zero,
  });

  @override
  State<_MoreItem> createState() => _MoreItemState();
}

class _MoreItemState extends State<_MoreItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          HapticFeedback.selectionClick();
        },
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isPressed ? 0.85 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _isPressed
                  ? Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.add_circle_outline,
              size: 26,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
