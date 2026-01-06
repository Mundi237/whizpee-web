// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';

class VideoCompressionProgress extends StatelessWidget {
  const VideoCompressionProgress({
    super.key,
    required this.progress,
    required this.fileName,
    this.onCancel,
  });

  final double progress;
  final String fileName;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          _buildProgressBar(context),
          const SizedBox(height: 16),
          _buildProgressText(context),
          if (onCancel != null) ...[
            const SizedBox(height: 20),
            _buildCancelButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.video_file,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).compressingVideo,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                fileName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _getProgressDescription(context),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade700,
                  ),
            ),
          ),
        ],
      ),
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
          foregroundColor: Colors.red.shade600,
          side: BorderSide(color: Colors.red.shade300),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  String _getProgressDescription(BuildContext context) {
    final s = S.of(context);
    if (progress < 0.2) {
      return s.analyzingVideoAndPreparingCompression;
    } else if (progress < 0.5) {
      return s.compressingVideoThisMayTakeAFewMoments;
    } else if (progress < 0.8) {
      return s.processingVideoDataAndOptimizingQuality;
    } else if (progress < 0.95) {
      return s.finalizingCompressionAndSavingFile;
    } else {
      return s.almostDoneJustAFewMoreSeconds;
    }
  }

  String _getEstimatedTimeText(BuildContext context) {
    final s = S.of(context);
    if (progress <= 0) return s.calculating;

    final remainingProgress = 1.0 - progress;
    if (remainingProgress <= 0) return s.finishing;

    if (progress < 0.1) return s.estimating;

    // Simple estimation based on current progress
    final estimatedSeconds =
        (remainingProgress / progress) * 45; // Rough estimate

    if (estimatedSeconds < 60) {
      return '~${estimatedSeconds.toInt()}s ${s.left}';
    } else {
      final minutes = (estimatedSeconds / 60).toInt();
      final seconds = (estimatedSeconds % 60).toInt();
      return '~${minutes}m ${seconds}s ${s.left}';
    }
  }
}
