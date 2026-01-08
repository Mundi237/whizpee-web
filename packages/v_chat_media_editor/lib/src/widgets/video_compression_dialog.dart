// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_video_compressor/v_video_compressor.dart';
import 'package:s_translation/generated/l10n.dart';

class VideoCompressionDialog extends StatefulWidget {
  const VideoCompressionDialog({
    super.key,
    required this.videoPath,
    required this.onCompressionSelected,
    this.initialQuality = VVideoCompressQuality.medium,
  });

  final String videoPath;
  final Function(VVideoCompressQuality? quality) onCompressionSelected;
  final VVideoCompressQuality initialQuality;

  @override
  State<VideoCompressionDialog> createState() => _VideoCompressionDialogState();
}

class _VideoCompressionDialogState extends State<VideoCompressionDialog>
    with SingleTickerProviderStateMixin {
  VVideoCompressQuality? _selectedQuality;
  bool _skipCompression = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _selectedQuality = widget.initialQuality;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
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
            Expanded(child: Text(S.of(context).videoCompression)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).chooseCompressionQualityForYourVideo,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 16),
              _buildCompressionOption(
                VVideoCompressQuality.low,
                S.of(context).lowQuality,
                S.of(context).smallestFileSizeFasterUpload,
                Icons.speed,
              ),
              const SizedBox(height: 8),
              _buildCompressionOption(
                VVideoCompressQuality.medium,
                S.of(context).mediumQuality,
                S.of(context).balancedQualityAndFileSize,
                Icons.balance,
              ),
              const SizedBox(height: 8),
              _buildCompressionOption(
                VVideoCompressQuality.high,
                S.of(context).highQuality,
                S.of(context).betterQualityLargerFileSize,
                Icons.high_quality,
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey.shade300),
              const SizedBox(height: 12),
              _buildSkipCompressionOption(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(S.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              final quality = _skipCompression ? null : _selectedQuality;
              widget.onCompressionSelected(quality);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(S.of(context).apply),
          ),
        ],
      ),
    );
  }

  Widget _buildCompressionOption(
    VVideoCompressQuality quality,
    String title,
    String description,
    IconData icon,
  ) {
    final isSelected = _selectedQuality == quality && !_skipCompression;

    return AnimatedScale(
      scale: isSelected ? 1.0 : 0.98,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() {
            _selectedQuality = quality;
            _skipCompression = false;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.2)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color:
                            isSelected ? Theme.of(context).primaryColor : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedScale(
                scale: isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                child: Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkipCompressionOption() {
    return AnimatedScale(
      scale: _skipCompression ? 1.0 : 0.98,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() {
            _skipCompression = !_skipCompression;
            if (_skipCompression) _selectedQuality = null;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: _skipCompression ? Colors.orange : Colors.grey.shade300,
              width: _skipCompression ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color:
                _skipCompression ? Colors.orange.withValues(alpha: 0.1) : null,
            boxShadow: _skipCompression
                ? [
                    BoxShadow(
                      color: Colors.orange.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _skipCompression
                      ? Colors.orange.withValues(alpha: 0.2)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.do_not_disturb_on,
                  color:
                      _skipCompression ? Colors.orange : Colors.grey.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).skipCompression,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: _skipCompression ? Colors.orange : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      S.of(context).sendOriginalVideoWithoutCompression,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedScale(
                scale: _skipCompression ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
