// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:v_video_compressor/v_video_compressor.dart';
import 'package:v_platform/v_platform.dart';
import 'package:s_translation/generated/l10n.dart';

// Constants for consistent styling
class _VideoCompressionConstants {
  static const double borderRadius = 12.0;
  static const double iconSize = 20.0;
  // static const double iconContainerSize = 40.0; // Currently unused
  static const double optionPadding = 16.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 20.0;
  static const double animationDuration = 200.0;
}

class VideoCompressionOptions extends StatefulWidget {
  const VideoCompressionOptions({
    super.key,
    required this.videoPath,
    required this.onCompressionSelected,
    this.initialQuality = VVideoCompressQuality.medium,
  });

  final String videoPath;
  final Function(VVideoCompressQuality? quality) onCompressionSelected;
  final VVideoCompressQuality initialQuality;

  @override
  State<VideoCompressionOptions> createState() =>
      _VideoCompressionOptionsState();
}

class _VideoCompressionOptionsState extends State<VideoCompressionOptions>
    with TickerProviderStateMixin {
  String? _videoFileSize;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(
        milliseconds: _VideoCompressionConstants.animationDuration.toInt(),
      ),
      vsync: this,
    );
    // Animation setup for smooth transitions
    _animationController.forward();
    _getVideoFileSize();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Get video file size for display
  Future<void> _getVideoFileSize() async {
    try {
      final file = File(widget.videoPath);
      if (await file.exists()) {
        final fileSizeBytes = await file.length();
        final fileSizeMB = (fileSizeBytes / (1024 * 1024)).toStringAsFixed(1);
        setState(() {
          _videoFileSize = '${fileSizeMB}MB';
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: _VideoCompressionConstants.spacingLarge),
            if (_videoFileSize != null) _buildVideoInfo(context),
            const SizedBox(height: _VideoCompressionConstants.spacingMedium),
            _buildCompressionOptions(),
            const SizedBox(height: _VideoCompressionConstants.spacingMedium),
            _buildSkipOption(),
          ],
        ),
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
                S.of(context).videoCompression,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                S.of(context).chooseQualityForYourVideo,
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

  Widget _buildVideoInfo(BuildContext context) {
    final fileName = widget.videoPath.split('/').last;
    return Container(
      padding: const EdgeInsets.all(_VideoCompressionConstants.optionPadding),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(
          _VideoCompressionConstants.borderRadius,
        ),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.video_file,
              color: Colors.blue.shade700,
              size: _VideoCompressionConstants.iconSize,
            ),
          ),
          const SizedBox(width: _VideoCompressionConstants.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade800,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${S.of(context).originalFileSize}: $_videoFileSize',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue.shade600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompressionOptions() {
    return Column(
      children: [
        _buildQualityOption(
          VVideoCompressQuality.ultraLow,
          S.of(context).ultraLowQuality,
          S.of(context).smallestFileSizeFasterUpload,
          Icons.flash_on,
          Colors.red,
          _getEstimatedSizeReduction(0.9), // 90% reduction
        ),
        const SizedBox(height: _VideoCompressionConstants.spacingSmall),
        _buildQualityOption(
          VVideoCompressQuality.veryLow,
          S.of(context).veryLowQuality,
          S.of(context).verySmallFileSize,
          Icons.speed,
          Colors.orange.shade700,
          _getEstimatedSizeReduction(0.8), // 80% reduction
        ),
        const SizedBox(height: _VideoCompressionConstants.spacingSmall),
        _buildQualityOption(
          VVideoCompressQuality.low,
          S.of(context).lowQuality,
          S.of(context).smallFileSizeFasterUploadLow,
          Icons.trending_down,
          Colors.green,
          _getEstimatedSizeReduction(0.7), // 70% reduction
        ),
        const SizedBox(height: _VideoCompressionConstants.spacingSmall),
        _buildQualityOption(
          VVideoCompressQuality.medium,
          S.of(context).mediumQuality,
          S.of(context).balancedQualityAndFileSize,
          Icons.balance,
          Colors.orange,
          _getEstimatedSizeReduction(0.5), // 50% reduction
        ),
        const SizedBox(height: _VideoCompressionConstants.spacingSmall),
        _buildQualityOption(
          VVideoCompressQuality.high,
          S.of(context).highQuality,
          S.of(context).betterQualityLargerFileSize,
          Icons.high_quality,
          Colors.blue,
          _getEstimatedSizeReduction(0.3), // 30% reduction
        ),
      ],
    );
  }

  String? _getEstimatedSizeReduction(double reductionRatio) {
    if (_videoFileSize == null) return null;

    try {
      final originalSizeMB = double.parse(_videoFileSize!.replaceAll('MB', ''));
      final estimatedSizeMB = originalSizeMB * (1 - reductionRatio);
      return '~${estimatedSizeMB.toStringAsFixed(1)}MB';
    } catch (e) {
      return null;
    }
  }

  Widget _buildQualityOption(
    VVideoCompressQuality quality,
    String title,
    String description,
    IconData icon,
    Color color,
    String? estimatedSize,
  ) {
    final isSelected =
        widget.initialQuality == quality; // Show initial selection only

    return InkWell(
      onTap: () {
        // Immediately apply the selection
        widget.onCompressionSelected(quality);
        Navigator.of(context).pop();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? color.withValues(alpha: 0.1) : null,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: Duration(
                milliseconds:
                    _VideoCompressionConstants.animationDuration.toInt(),
              ),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isSelected ? color : Colors.grey.shade400)
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: AnimatedSwitcher(
                duration: Duration(
                  milliseconds:
                      _VideoCompressionConstants.animationDuration.toInt(),
                ),
                child: Icon(
                  icon,
                  key: ValueKey('$quality-$isSelected'),
                  color: isSelected ? color : Colors.grey.shade600,
                  size: _VideoCompressionConstants.iconSize,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: isSelected ? color : null,
                          ),
                        ),
                      ),
                      if (estimatedSize != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: (isSelected ? color : Colors.grey.shade400)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            estimatedSize,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? color : Colors.grey.shade600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipOption() {
    return InkWell(
      onTap: () {
        // Immediately apply skip compression (no compression)
        widget.onCompressionSelected(null);
        Navigator.of(context).pop();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade400.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.close,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).skipCompression,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    S.of(context).sendOriginalVideoWithoutCompression,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action buttons removed - selection is now immediate
}

/// Show compression options bottom sheet
Future<VVideoCompressQuality?> showVideoCompressionOptions(
  BuildContext context, {
  required String videoPath,
  VVideoCompressQuality initialQuality = VVideoCompressQuality.medium,
}) async {
  if (!VPlatforms.isMobile || VPlatforms.isWeb) {
    return null; // No compression on non-mobile platforms or web
  }

  VVideoCompressQuality? selectedQuality;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => VideoCompressionOptions(
      videoPath: videoPath,
      initialQuality: initialQuality,
      onCompressionSelected: (quality) {
        selectedQuality = quality;
      },
    ),
  );

  return selectedQuality;
}
