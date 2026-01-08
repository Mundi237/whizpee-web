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
  static const double borderWidth = 2.5;
  static const double borderRadius = 6.0;
  static const double videoBadgeRadius = 6.0;
  static const double videoBadgePadding = 2.0;
  static const double videoCameraIconSize = 14.0;
  static const double fileIconDefaultSize = 24.0;
  static const double opacityLevel = 0.85;
}

class HorizontalMediaItem extends StatefulWidget {
  final VBaseMediaRes mediaFile;
  final bool isLoading;

  const HorizontalMediaItem({
    super.key,
    required this.mediaFile,
    required this.isLoading,
  });

  @override
  State<HorizontalMediaItem> createState() => _HorizontalMediaItemState();
}

class _HorizontalMediaItemState extends State<HorizontalMediaItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: _HorizontalMediaItemConstants.containerHeight,
      width: _HorizontalMediaItemConstants.containerWidth,
      decoration: _buildContainerDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          _HorizontalMediaItemConstants.borderRadius,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildMediaContent(),
            if (_shouldShowVideoBadge()) _buildVideoBadge(),
            if (widget.isLoading) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  /// Builds the container decoration based on selection state
  BoxDecoration? _buildContainerDecoration() {
    if (!widget.mediaFile.isSelected) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(
          _HorizontalMediaItemConstants.borderRadius,
        ),
        border: Border.all(
          color: Colors.transparent,
          width: _HorizontalMediaItemConstants.borderWidth,
        ),
      );
    }

    return BoxDecoration(
      borderRadius: BorderRadius.circular(
        _HorizontalMediaItemConstants.borderRadius,
      ),
      border: Border.all(
        color: Colors.red,
        width: _HorizontalMediaItemConstants.borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.red.withValues(alpha: 0.3),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ],
    );
  }

  /// Builds the media content (image or placeholder)
  Widget _buildMediaContent() {
    if (widget.isLoading && widget.mediaFile is VMediaVideoRes) {
      return const SizedBox.shrink();
    }
    return _buildMediaImage();
  }

  /// Determines if video badge should be shown
  bool _shouldShowVideoBadge() {
    return widget.mediaFile is VMediaVideoRes && !widget.isLoading;
  }

  /// Builds the video camera badge overlay
  Widget _buildVideoBadge() {
    return Positioned(
      top: 2,
      right: 2,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        tween: Tween<double>(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(
            _HorizontalMediaItemConstants.videoBadgePadding + 2,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(
                  alpha: _HorizontalMediaItemConstants.opacityLevel,
                ),
                Colors.black87.withValues(
                  alpha: _HorizontalMediaItemConstants.opacityLevel,
                ),
              ],
            ),
            borderRadius: BorderRadius.circular(
              _HorizontalMediaItemConstants.videoBadgeRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(
            PhosphorIcons.videoCamera(PhosphorIconsStyle.fill),
            size: _HorizontalMediaItemConstants.videoCameraIconSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Builds loading shimmer overlay
  Widget _buildLoadingOverlay() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.1),
              ],
              stops: [
                _shimmerController.value - 0.3,
                _shimmerController.value,
                _shimmerController.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      },
    );
  }

  /// Builds the appropriate media image widget with null safety
  Widget _buildMediaImage() {
    const BoxFit imageFit = BoxFit.cover;

    if (widget.mediaFile is VMediaImageRes) {
      return _buildImageWidget(widget.mediaFile as VMediaImageRes, imageFit);
    } else if (widget.mediaFile is VMediaVideoRes) {
      return _buildVideoThumbnailWidget(
          widget.mediaFile as VMediaVideoRes, imageFit);
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
