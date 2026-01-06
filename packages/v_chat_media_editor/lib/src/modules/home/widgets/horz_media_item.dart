// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../v_chat_media_editor.dart';

// Constants for consistent styling
class _HorizontalMediaItemConstants {
  static const double containerHeight = 50.0;
  static const double containerWidth = 45.0;
  static const double borderWidth = 2.0;
  static const double borderRadius = 1.0;
  static const double videoBadgeRadius = 4.0;
  static const double videoBadgePadding = 1.0;
  static const double videoCameraIconSize = 17.0;
  static const double fileIconDefaultSize = 24.0;
  static const double opacityLevel = 0.7;
}

class HorizontalMediaItem extends StatelessWidget {
  final VBaseMediaRes mediaFile;
  final bool isLoading;

  const HorizontalMediaItem({
    super.key,
    required this.mediaFile,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _HorizontalMediaItemConstants.containerHeight,
      width: _HorizontalMediaItemConstants.containerWidth,
      decoration: _buildContainerDecoration(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildMediaContent(),
          if (_shouldShowVideoBadge()) _buildVideoBadge(),
        ],
      ),
    );
  }

  /// Builds the container decoration based on selection state
  BoxDecoration? _buildContainerDecoration() {
    if (!mediaFile.isSelected) return null;

    return BoxDecoration(
      borderRadius: BorderRadius.circular(
        _HorizontalMediaItemConstants.borderRadius,
      ),
      border: Border.all(
        color: Colors.red,
        width: _HorizontalMediaItemConstants.borderWidth,
      ),
    );
  }

  /// Builds the media content (image or placeholder)
  Widget _buildMediaContent() {
    if (isLoading && mediaFile is VMediaVideoRes) {
      return const SizedBox.shrink();
    }
    return _buildMediaImage();
  }

  /// Determines if video badge should be shown
  bool _shouldShowVideoBadge() {
    return mediaFile is VMediaVideoRes;
  }

  /// Builds the video camera badge overlay
  Widget _buildVideoBadge() {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(
          _HorizontalMediaItemConstants.videoBadgePadding,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(
            alpha: _HorizontalMediaItemConstants.opacityLevel,
          ),
          borderRadius: BorderRadius.circular(
            _HorizontalMediaItemConstants.videoBadgeRadius,
          ),
        ),
        child: Icon(
          PhosphorIcons.videoCamera(PhosphorIconsStyle.fill),
          size: _HorizontalMediaItemConstants.videoCameraIconSize,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Builds the appropriate media image widget with null safety
  Widget _buildMediaImage() {
    const BoxFit imageFit = BoxFit.cover;

    if (mediaFile is VMediaImageRes) {
      return _buildImageWidget(mediaFile as VMediaImageRes, imageFit);
    } else if (mediaFile is VMediaVideoRes) {
      return _buildVideoThumbnailWidget(mediaFile as VMediaVideoRes, imageFit);
    }
    return _buildFallbackWidget();
  }

  /// Builds image widget with proper null safety checks
  Widget _buildImageWidget(VMediaImageRes imageRes, BoxFit fit) {
    try {
      if (imageRes.data.isFromPath) {
        final filePath = imageRes.data.fileSource.fileLocalPath;
        if (filePath != null && filePath.isNotEmpty) {
          return Image.file(
            File(filePath),
            fit: fit,
            errorBuilder: _buildErrorWidget,
          );
        }
      }

      if (imageRes.data.isFromBytes) {
        final bytes = imageRes.data.fileSource.bytes;
        if (bytes != null && bytes.isNotEmpty) {
          return Image.memory(
            Uint8List.fromList(bytes),
            fit: fit,
            errorBuilder: _buildErrorWidget,
          );
        }
      }
    } catch (e) {
      // Handle any unexpected errors gracefully
      return _buildFallbackWidget();
    }

    return _buildFallbackWidget();
  }

  /// Builds video thumbnail widget with proper null safety checks
  Widget _buildVideoThumbnailWidget(VMediaVideoRes videoRes, BoxFit fit) {
    try {
      if (videoRes.data.isFromPath) {
        final thumbImage = videoRes.data.thumbImage;
        if (thumbImage != null) {
          final filePath = thumbImage.fileSource.fileLocalPath;
          if (filePath != null && filePath.isNotEmpty) {
            return Image.file(
              File(filePath),
              fit: fit,
              errorBuilder: _buildErrorWidget,
            );
          }
        }
      }
    } catch (e) {
      // Handle any unexpected errors gracefully
      return _buildFallbackWidget();
    }

    return _buildFallbackWidget();
  }

  /// Builds error widget when image loading fails
  Widget _buildErrorWidget(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return _buildFallbackWidget();
  }

  /// Builds fallback widget for unsupported or failed media
  Widget _buildFallbackWidget() {
    return Container(
      color: Colors.black87,
      child: Icon(
        PhosphorIcons.file(),
        color: Colors.white70,
        size: _HorizontalMediaItemConstants.fileIconDefaultSize,
      ),
    );
  }
}
