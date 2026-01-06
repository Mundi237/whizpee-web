// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';

// Constants for consistent styling
class _EnhancedVideoCompressionProgressConstants {
  static const double containerMargin = 16.0;
  static const double containerPadding = 24.0;
  static const double borderRadius = 16.0;
  static const double progressBarHeight = 8.0;
  static const double progressBarRadius = 6.0;
  static const double iconSize = 28.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double animationDuration = 500.0;
  static const double pulseAnimationDuration = 1500.0;
}

class EnhancedVideoCompressionProgress extends StatefulWidget {
  const EnhancedVideoCompressionProgress({
    super.key,
    required this.progress,
    required this.fileName,
    this.onCancel,
    this.estimatedTimeRemaining,
    this.originalFileSize,
    this.estimatedCompressedSize,
  });

  final double progress;
  final String fileName;
  final VoidCallback? onCancel;
  final Duration? estimatedTimeRemaining;
  final String? originalFileSize;
  final String? estimatedCompressedSize;

  @override
  State<EnhancedVideoCompressionProgress> createState() =>
      _EnhancedVideoCompressionProgressState();
}

class _EnhancedVideoCompressionProgressState
    extends State<EnhancedVideoCompressionProgress>
    with TickerProviderStateMixin {
  late AnimationController _progressAnimationController;
  late AnimationController _pulseAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  // double _displayedProgress = 0.0; // Currently unused

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _updateProgress();
  }

  void _initializeAnimations() {
    _progressAnimationController = AnimationController(
      duration: Duration(
        milliseconds: _EnhancedVideoCompressionProgressConstants
            .animationDuration
            .toInt(),
      ),
      vsync: this,
    );

    _pulseAnimationController = AnimationController(
      duration: Duration(
        milliseconds: _EnhancedVideoCompressionProgressConstants
            .pulseAnimationDuration
            .toInt(),
      ),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeOut,
    ));

    _pulseAnimationController.repeat(reverse: true);
    _fadeAnimationController.forward();
  }

  @override
  void didUpdateWidget(EnhancedVideoCompressionProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _updateProgress();
    }
  }

  void _updateProgress() {
    _progressAnimationController.animateTo(widget.progress).then((_) {
      if (mounted) {
        setState(() {
          // Progress updated via animation
        });
      }
    });
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _pulseAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AnimatedContainer(
        duration: Duration(
          milliseconds: _EnhancedVideoCompressionProgressConstants
              .animationDuration
              .toInt(),
        ),
        margin: const EdgeInsets.all(
          _EnhancedVideoCompressionProgressConstants.containerMargin,
        ),
        padding: const EdgeInsets.all(
          _EnhancedVideoCompressionProgressConstants.containerPadding,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(
            _EnhancedVideoCompressionProgressConstants.borderRadius,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              blurRadius: 40,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            const SizedBox(
              height: _EnhancedVideoCompressionProgressConstants.spacingLarge,
            ),
            _buildProgressSection(context),
            const SizedBox(
              height: _EnhancedVideoCompressionProgressConstants.spacingMedium,
            ),
            _buildStatusSection(context),
            if (widget.originalFileSize != null ||
                widget.estimatedCompressedSize != null) ...[
              const SizedBox(
                height:
                    _EnhancedVideoCompressionProgressConstants.spacingMedium,
              ),
              _buildFileSizeInfo(context),
            ],
            if (widget.onCancel != null) ...[
              const SizedBox(
                height: _EnhancedVideoCompressionProgressConstants.spacingLarge,
              ),
              _buildCancelButton(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.video_file,
              color: Colors.white,
              size: _EnhancedVideoCompressionProgressConstants.iconSize,
            ),
          ),
        ),
        const SizedBox(
          width: _EnhancedVideoCompressionProgressConstants.spacingMedium,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).compressingVideo,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(
                height: _EnhancedVideoCompressionProgressConstants.spacingSmall,
              ),
              Text(
                widget.fileName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
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

  Widget _buildProgressSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(widget.progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            if (widget.estimatedTimeRemaining != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Text(
                  _formatDuration(widget.estimatedTimeRemaining!),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
          ],
        ),
        const SizedBox(
          height: _EnhancedVideoCompressionProgressConstants.spacingMedium,
        ),
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return Stack(
              children: [
                Container(
                  height: _EnhancedVideoCompressionProgressConstants
                      .progressBarHeight,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(
                      _EnhancedVideoCompressionProgressConstants
                          .progressBarRadius,
                    ),
                  ),
                ),
                Container(
                  height: _EnhancedVideoCompressionProgressConstants
                      .progressBarHeight,
                  width: MediaQuery.of(context).size.width *
                      0.8 *
                      _progressAnimation.value,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(
                      _EnhancedVideoCompressionProgressConstants
                          .progressBarRadius,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: Colors.grey.shade600,
          ),
          const SizedBox(
            width: _EnhancedVideoCompressionProgressConstants.spacingSmall,
          ),
          Expanded(
            child: Text(
              _getProgressDescription(context),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileSizeInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.storage,
            size: 18,
            color: Colors.green.shade600,
          ),
          const SizedBox(
            width: _EnhancedVideoCompressionProgressConstants.spacingSmall,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.originalFileSize != null)
                  Text(
                    '${S.of(context).originalFileSize}: ${widget.originalFileSize}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                if (widget.estimatedCompressedSize != null)
                  Text(
                    '${S.of(context).estimatedFileSize}: ${widget.estimatedCompressedSize}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
              ],
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
        onPressed: widget.onCancel,
        icon: const Icon(Icons.close),
        label: Text(S.of(context).cancelCompression),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red.shade600,
          side: BorderSide(color: Colors.red.shade300),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  String _getProgressDescription(BuildContext context) {
    final s = S.of(context);
    if (widget.progress < 0.1) {
      return s.analyzingVideoAndPreparingCompression;
    } else if (widget.progress < 0.3) {
      return s.compressingVideoThisMayTakeAFewMoments;
    } else if (widget.progress < 0.7) {
      return s.processingVideoDataAndOptimizingQuality;
    } else if (widget.progress < 0.95) {
      return s.finalizingCompressionAndSavingFile;
    } else {
      return s.almostDoneJustAFewMoreSeconds;
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    if (minutes > 0) {
      return '${minutes}m ${seconds}s ${S.of(context).left}';
    } else {
      return '${seconds}s ${S.of(context).left}';
    }
  }
}
