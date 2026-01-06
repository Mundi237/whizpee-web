// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';

abstract class VAppAlert {
  static void showErrorSnackBar({
    required String msg,
    required BuildContext context,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(
        seconds: 5,
      ),
    ));
  }

  static Future<ModelSheetItem?> showModalSheet<T>({
    String? title,
    required List<ModelSheetItem> content,
    required BuildContext context,
    required String cancelText,
  }) async {
    // Convert to attachment options for WhatsApp-style UI
    final attachmentOptions = content
        .map((item) => AttachmentOptionItem(
              id: item.id,
              title: item.title,
              icon: _getIconDataFromIcon(item.iconData),
            ))
        .toList();

    final result = await showCustomAttachmentOptionsSheet(
      context: context,
      options: attachmentOptions,
      title: title,
      cancelLabel: cancelText,
    );

    return result != null
        ? content.firstWhere((item) => item.id == result.id)
        : null;
  }

  static IconData _getIconDataFromIcon(Icon? icon) {
    if (icon?.icon != null) {
      return icon!.icon!;
    }
    return Icons.attach_file; // Default fallback icon
  }
}

class ModelSheetItem<T> {
  final T id;
  final String title;
  final Icon? iconData;

  ModelSheetItem({
    required this.title,
    required this.id,
    this.iconData,
  });
}

class CustomAttachmentOptionsSheet extends StatelessWidget {
  final List<AttachmentOptionItem> options;
  final String? title;
  final String cancelLabel;

  const CustomAttachmentOptionsSheet({
    super.key,
    required this.options,
    this.title,
    required this.cancelLabel,
  });

  void _handleOptionTap(BuildContext context, AttachmentOptionItem option) {
    Navigator.of(context).pop(option);
  }

  void _handleCancel(BuildContext context) {
    Navigator.of(context).pop();
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    _buildOptionsGrid(context, isDark),
                    const SizedBox(height: 8),
                    _buildCancelButton(context, isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsGrid(BuildContext context, bool isDark) {
    // WhatsApp style: 4 columns max, clean grid layout
    final optionsCount = options.length;
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
                ...rowOptions
                    .map((option) => _buildOptionItem(context, option, isDark)),
                // Fill remaining space if row is not full
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

  Widget _buildOptionItem(
    BuildContext context,
    AttachmentOptionItem option,
    bool isDark,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _handleOptionTap(context, option),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // WhatsApp style circular icon
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
              // Option label
              Text(
                option.title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.87)
                          : Colors.black87,
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

  Color _getOptionBackgroundColor(AttachmentOptionItem option, bool isDark) {
    // WhatsApp style colors for attachments
    return isDark
        ? const Color(0xFF374151) // Dark gray
        : const Color(0xFFF3F4F6); // Light gray
  }

  Color _getOptionIconColor(AttachmentOptionItem option, bool isDark) {
    // WhatsApp style icon colors
    return isDark
        ? Colors.white.withValues(alpha: 0.87)
        : const Color(0xFF6B7280); // Medium gray
  }

  Widget _buildCancelButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => _handleCancel(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
        ),
        child: Text(
          cancelLabel,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.87)
                    : Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class AttachmentOptionItem<T> {
  final T id;
  final String title;
  final IconData icon;

  const AttachmentOptionItem({
    required this.id,
    required this.title,
    required this.icon,
  });
}

Future<AttachmentOptionItem?> showCustomAttachmentOptionsSheet({
  required BuildContext context,
  required List<AttachmentOptionItem> options,
  String? title,
  String? cancelLabel,
}) async {
  return showModalBottomSheet<AttachmentOptionItem?>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => CustomAttachmentOptionsSheet(
      options: options,
      title: title,
      cancelLabel: cancelLabel ?? S.of(context).cancel,
    ),
  );
}
