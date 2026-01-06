// Copyright 2025, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

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

class _ReactionBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.2),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final e in items)
              _EmojiItem(
                emoji: e,
                isSelected: e == currentUserEmoji,
                onTap: () => onSelected(e),
              ),
            _MoreItem(onTap: onMore),
          ],
        ),
      ),
    );
  }
}

class _EmojiItem extends StatelessWidget {
  final String emoji;
  final VoidCallback onTap;
  final bool isSelected;

  const _EmojiItem({
    required this.emoji,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: isSelected
            ? BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.primaryColor,
                  width: 2,
                ),
              )
            : null,
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class _MoreItem extends StatelessWidget {
  final VoidCallback onTap;

  const _MoreItem({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Icon(
          Icons.more_horiz,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
