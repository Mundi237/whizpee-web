// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
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

class _VideoCompressionDialogState extends State<VideoCompressionDialog> {
  VVideoCompressQuality? _selectedQuality;
  bool _skipCompression = false;

  @override
  void initState() {
    super.initState();
    _selectedQuality = widget.initialQuality;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).videoCompression),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).chooseCompressionQualityForYourVideo,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildCompressionOption(
            VVideoCompressQuality.low,
            S.of(context).lowQuality,
            S.of(context).smallestFileSizeFasterUpload,
            Icons.speed,
          ),
          _buildCompressionOption(
            VVideoCompressQuality.medium,
            S.of(context).mediumQuality,
            S.of(context).balancedQualityAndFileSize,
            Icons.balance,
          ),
          _buildCompressionOption(
            VVideoCompressQuality.high,
            S.of(context).highQuality,
            S.of(context).betterQualityLargerFileSize,
            Icons.high_quality,
          ),
          const Divider(),
          _buildSkipCompressionOption(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: () {
            final quality = _skipCompression ? null : _selectedQuality;
            widget.onCompressionSelected(quality);
            Navigator.of(context).pop();
          },
          child: Text(S.of(context).apply),
        ),
      ],
    );
  }

  Widget _buildCompressionOption(
    VVideoCompressQuality quality,
    String title,
    String description,
    IconData icon,
  ) {
    final isSelected = _selectedQuality == quality && !_skipCompression;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedQuality = quality;
          _skipCompression = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    ),
                  ),
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
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipCompressionOption() {
    return InkWell(
      onTap: () {
        setState(() {
          _skipCompression = !_skipCompression;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: _skipCompression ? Colors.orange : Colors.grey.shade300,
            width: _skipCompression ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: _skipCompression ? Colors.orange.withValues(alpha: 0.1) : null,
        ),
        child: Row(
          children: [
            Icon(
              Icons.do_not_disturb_on,
              color: _skipCompression ? Colors.orange : Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).skipCompression,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _skipCompression ? Colors.orange : null,
                    ),
                  ),
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
            if (_skipCompression)
              const Icon(
                Icons.check_circle,
                color: Colors.orange,
              ),
          ],
        ),
      ),
    );
  }
}
