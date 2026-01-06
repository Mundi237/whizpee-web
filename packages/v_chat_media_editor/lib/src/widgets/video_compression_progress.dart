// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';

/// A widget that displays video compression progress with a progress bar,
/// estimated time, and cancel button.
class VideoCompressionProgress extends StatelessWidget {
  const VideoCompressionProgress({
    super.key,
    required this.progress,
    required this.onCancel,
    this.title = 'Compressing Video',
  });

  /// Current progress value between 0.0 and 1.0
  final double progress;

  /// Callback when cancel button is pressed
  final VoidCallback onCancel;

  /// Title to display above the progress
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildProgressIndicator(context),
          const SizedBox(height: 16),
          _buildProgressText(context),
          const SizedBox(height: 24),
          _buildCancelButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.video_settings,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).compressingVideo,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                S.of(context).analyzingVideoAndPreparingCompression,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              _getEstimatedTimeText(context),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressText(BuildContext context) {
    return Text(
      _getProgressDescription(context),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onCancel,
        icon: const Icon(Icons.cancel_outlined),
        label: Text(S.of(context).cancelCompression),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  String _getProgressDescription(BuildContext context) {
    if (progress < 0.3) {
      return S.of(context).analyzingVideoAndPreparingCompression;
    } else if (progress < 0.7) {
      return S.of(context).compressingVideoWait;
    } else if (progress < 0.9) {
      return S.of(context).finalizingCompression;
    } else {
      return S.of(context).almostDone;
    }
  }

  String _getEstimatedTimeText(BuildContext context) {
    if (progress <= 0) return S.of(context).calculating;

    final remainingProgress = 1.0 - progress;
    if (remainingProgress <= 0) return S.of(context).finishing;

    // Simple estimation based on current progress
    if (progress < 0.1) return S.of(context).estimating;

    final estimatedSeconds =
        (remainingProgress / progress) * 30; // Rough estimate

    if (estimatedSeconds < 60) {
      return '~${estimatedSeconds.toInt()}s ${S.of(context).remaining}';
    } else {
      final minutes = (estimatedSeconds / 60).toInt();
      return '~${minutes}m ${S.of(context).remaining}';
    }
  }
}
