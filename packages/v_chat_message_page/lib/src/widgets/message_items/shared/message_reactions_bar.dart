// Copyright 2025, the hatemragab project.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MessageReactionsBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (reactionNumber == 0 || reactionSample.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]?.withValues(alpha: 0.8)
              : Colors.grey[200]?.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[600]!
                : Colors.grey[300]!,
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display emoji sample
            ...reactionSample.take(3).map((reactionSample) => Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Text(
                reactionSample.emoji,
                style: const TextStyle(fontSize: 14),
              ),
            )),
            if (reactionNumber > 0) ...[
              const SizedBox(width: 4),
              Text(
                reactionNumber.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[300]
                      : Colors.grey[700],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}