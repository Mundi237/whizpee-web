// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';

class CustomMessageOptionsSheet extends StatefulWidget {
  final List<MessageOptionItem> options;
  final String? title;
  final String cancelLabel;
  final List<String> quickReactions;
  final ValueChanged<String>? onReactionSelected;
  final String? currentUserEmoji;

  const CustomMessageOptionsSheet({
    super.key,
    required this.options,
    this.title,
    required this.cancelLabel,
    this.quickReactions = const ['❤️', '😂', '😮', '😢', '😡', '👍'],
    this.onReactionSelected,
    this.currentUserEmoji,
  });

  @override
  State<CustomMessageOptionsSheet> createState() => _CustomMessageOptionsSheetState();
}

class _CustomMessageOptionsSheetState extends State<CustomMessageOptionsSheet> {
  bool _showEmojiPicker = false;
  Widget? _emojiPicker;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-build the emoji picker to avoid rebuilding it on every state change
    if (_emojiPicker == null) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      _emojiPicker = _buildEmojiPicker(context, isDark);
    }
  }

  void _handleOptionTap(BuildContext context, MessageOptionItem option) {
    Navigator.of(context).pop(option);
  }

  void _handleCancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _handleQuickReactionTap(BuildContext context, String emoji) {
    widget.onReactionSelected?.call(emoji);
    Navigator.of(context).pop();
  }

  void _toggleEmojiPicker() {
    setState(() => _showEmojiPicker = !_showEmojiPicker);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () => _handleCancel(context),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1F2937) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      if (widget.onReactionSelected != null)
                        _ReactionBar(
                          quickReactions: widget.quickReactions,
                          currentUserEmoji: widget.currentUserEmoji,
                          onReactionSelected: (emoji) => _handleQuickReactionTap(context, emoji),
                          onToggleEmojiPicker: _toggleEmojiPicker,
                        ),
                      if (widget.onReactionSelected != null) const SizedBox(height: 8),
                      if (widget.onReactionSelected != null)
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            final scale = Tween<double>(begin: 0.98, end: 1.0).animate(animation);
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(scale: scale, child: child),
                            );
                          },
                          child: _showEmojiPicker ? _emojiPicker : const SizedBox.shrink(),
                        ),
                      if (_showEmojiPicker && widget.onReactionSelected != null)
                        const SizedBox(height: 8),
                      _OptionsGrid(
                        options: widget.options,
                        onOptionTap: (option) => _handleOptionTap(context, option),
                      ),
                      const SizedBox(height: 8),
                      _CancelButton(
                        label: widget.cancelLabel,
                        onCancel: () => _handleCancel(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiPicker(BuildContext context, bool isDark) {
    final bg = isDark ? const Color(0xFF111827) : const Color(0xFFF9FAFB);
    return SizedBox(
      height: 260,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          _handleQuickReactionTap(context, emoji.emoji);
        },
        config: Config(
          height: 260,
          emojiViewConfig: EmojiViewConfig(
            columns: 7,
            emojiSizeMax: 28,
            backgroundColor: bg,
          ),
          categoryViewConfig: CategoryViewConfig(
            tabBarHeight: 36,
            indicatorColor: Theme.of(context).colorScheme.primary,
            iconColorSelected: Theme.of(context).colorScheme.primary,
          ),
          bottomActionBarConfig: const BottomActionBarConfig(
            enabled: true,
            showBackspaceButton: false,
            showSearchViewButton: false,
          ),
        ),
      ),
    );
  }
}

// Optimized: Re-action bar widget
class _ReactionBar extends StatelessWidget {
  final List<String> quickReactions;
  final String? currentUserEmoji;
  final ValueChanged<String> onReactionSelected;
  final VoidCallback onToggleEmojiPicker;

  const _ReactionBar({
    required this.quickReactions,
    required this.currentUserEmoji,
    required this.onReactionSelected,
    required this.onToggleEmojiPicker,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            for (final e in quickReactions)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _ReactionEmoji(
                  emoji: e,
                  isSelected: e == currentUserEmoji,
                  onSelected: onReactionSelected,
                ),
              ),
            const Spacer(),
            InkWell(
              onTap: onToggleEmojiPicker,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Icon(
                  Icons.more_horiz,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Optimized: Options grid widget
class _OptionsGrid extends StatelessWidget {
  final List<MessageOptionItem> options;
  final ValueChanged<MessageOptionItem> onOptionTap;

  const _OptionsGrid({required this.options, required this.onOptionTap});

  @override
  Widget build(BuildContext context) {
    final optionsCount = options.length;
    if (optionsCount == 0) return const SizedBox.shrink();

    final columns = optionsCount <= 4 ? optionsCount : 4;
    final rows = (optionsCount / columns).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: List.generate(rows, (rowIndex) {
          final startIndex = rowIndex * columns;
          final endIndex = (startIndex + columns).clamp(0, optionsCount);
          final rowOptions = options.sublist(startIndex, endIndex);

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...rowOptions.map(
                  (option) => _OptionItem(
                    option: option,
                    onTap: () => onOptionTap(option),
                  ),
                ),
                ...List.generate(
                  columns - rowOptions.length,
                  (index) => const Expanded(child: SizedBox()),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// Optimized: Individual option item widget
class _OptionItem extends StatelessWidget {
  final MessageOptionItem option;
  final VoidCallback onTap;

  const _OptionItem({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDestructive = option.isDestructive;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _getOptionBackgroundColor(option, isDark),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  option.icon,
                  color: _getOptionIconColor(option, isDark),
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                option.title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDestructive
                          ? (isDark ? Colors.red.shade300 : Colors.red.shade700)
                          : (isDark ? Colors.white.withOpacity(0.87) : Colors.black87),
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getOptionBackgroundColor(MessageOptionItem option, bool isDark) {
    if (option.isDestructive) {
      return isDark ? Colors.red.shade900.withOpacity(0.3) : Colors.red.shade50;
    }
    return isDark
        ? const Color(0xFF374151) // Dark gray
        : const Color(0xFFF3F4F6); // Light gray
  }

  Color _getOptionIconColor(MessageOptionItem option, bool isDark) {
    if (option.isDestructive) {
      return isDark ? Colors.red.shade300 : Colors.red.shade700;
    }
    return isDark ? Colors.white.withOpacity(0.87) : const Color(0xFF6B7280); // Medium gray
  }
}

// Optimized: Cancel button widget
class _CancelButton extends StatelessWidget {
  final String label;
  final VoidCallback onCancel;

  const _CancelButton({required this.label, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onCancel,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
              width: 0.5,
            ),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDark ? Colors.white.withOpacity(0.87) : Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ReactionEmoji extends StatefulWidget {
  final String emoji;
  final ValueChanged<String> onSelected;
  final bool isSelected;

  const _ReactionEmoji({
    required this.emoji,
    required this.onSelected,
    this.isSelected = false,
  });

  @override
  State<_ReactionEmoji> createState() => _ReactionEmojiState();
}

class _ReactionEmojiState extends State<_ReactionEmoji> {
  bool _hovered = false;
  bool _pressed = false;

  double get _scale => _pressed ? 1.22 : (_hovered ? 1.12 : 1.0);

  void _setHovered(bool v) {
    if (_hovered == v) return;
    setState(() => _hovered = v);
  }

  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        onTap: () => widget.onSelected(widget.emoji),
        child: RepaintBoundary(
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutBack,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: widget.isSelected
                  ? BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.primaryColor,
                        width: 2,
                      ),
                    )
                  : null,
              child: Text(
                widget.emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MessageOptionItem<T> {
  final T id;
  final String title;
  final IconData icon;
  final bool isDestructive;

  const MessageOptionItem({
    required this.id,
    required this.title,
    required this.icon,
    this.isDestructive = false,
  });
}

Future<MessageOptionItem?> showCustomMessageOptionsSheet({
  required BuildContext context,
  required List<MessageOptionItem> options,
  String? title,
  String? cancelLabel,
  List<String> quickReactions = const ['❤️', '😂', '😮', '😢', '😡', '👍'],
  ValueChanged<String>? onReactionSelected,
  String? currentUserEmoji,
}) async {
  return showModalBottomSheet<MessageOptionItem?>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => CustomMessageOptionsSheet(
      options: options,
      title: title,
      cancelLabel: cancelLabel ?? S.of(context).cancel,
      quickReactions: quickReactions,
      onReactionSelected: onReactionSelected,
      currentUserEmoji: currentUserEmoji,
    ),
  );
}
