// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:v_platform/v_platform.dart';
import 'package:s_translation/generated/l10n.dart';

import '../../../../v_chat_media_editor.dart';

// Constants for consistent styling
class _VideoItemConstants {
  static const double actionButtonSize = 30.0;
  static const double actionButtonSpacing = 4.0;
  static const double playButtonSize = 70.0;
  static const double containerPadding = 8.0;
}

class VideoItem extends StatefulWidget {
  final VMediaVideoRes video;
  final VoidCallback onCloseClicked;
  final Function(VMediaVideoRes item) onDelete;
  final Function(VMediaVideoRes item) onPlayVideo;
  final Function(VMediaVideoRes item)? onCompressVideo;
  final Function(VMediaVideoRes item)? onStartDraw;
  final bool hasCustomCompressionSettings;
  final String? compressionQualityDisplay;

  const VideoItem({
    super.key,
    required this.video,
    required this.onCloseClicked,
    required this.onDelete,
    required this.onPlayVideo,
    this.onCompressVideo,
    this.onStartDraw,
    this.hasCustomCompressionSettings = false,
    this.compressionQualityDisplay,
  });

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isPlayPressed = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          _buildTopActionBar(context),
          Expanded(
            child: Stack(
              children: [
                _buildVideoPlayer(context),
                if (widget.hasCustomCompressionSettings)
                  _buildCompressionIndicator(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the top action bar with close and action buttons
  Widget _buildTopActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_VideoItemConstants.containerPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCloseButton(context),
          Flexible(
            child: _buildActionButtons(context),
          ),
        ],
      ),
    );
  }

  /// Builds the close button
  Widget _buildCloseButton(BuildContext context) {
    return IconButton(
      iconSize: _VideoItemConstants.actionButtonSize,
      onPressed: () {
        HapticFeedback.lightImpact();
        widget.onCloseClicked();
      },
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        padding: const EdgeInsets.all(8),
      ),
      icon: const Icon(
        Icons.close,
        color: Colors.white,
      ),
      tooltip: S.of(context).close,
    );
  }

  /// Builds the action buttons with overflow handling
  Widget _buildActionButtons(BuildContext context) {
    final List<Widget> actionButtons = [];

    // Add compression button for supported platforms
    if (_shouldShowCompressionButton()) {
      actionButtons.add(_buildCompressionButton(context));
    }

    // Add delete button
    actionButtons.add(_buildDeleteButton(context));

    // Add edit button
    actionButtons.add(_buildEditButton(context));

    return Wrap(
      alignment: WrapAlignment.end,
      spacing: _VideoItemConstants.actionButtonSpacing,
      children: actionButtons,
    );
  }

  /// Determines if compression button should be shown
  bool _shouldShowCompressionButton() {
    return VPlatforms.isMobile &&
        !VPlatforms.isWeb &&
        widget.video.data.isFromPath &&
        widget.onCompressVideo != null;
  }

  /// Builds the compression settings button
  Widget _buildCompressionButton(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          iconSize: _VideoItemConstants.actionButtonSize,
          onPressed: () {
            HapticFeedback.selectionClick();
            widget.onCompressVideo!(widget.video);
          },
          style: IconButton.styleFrom(
            backgroundColor: widget.hasCustomCompressionSettings
                ? Colors.green.withValues(alpha: 0.8)
                : Colors.black.withValues(alpha: 0.5),
            padding: const EdgeInsets.all(8),
          ),
          icon: Icon(
            PhosphorIcons.gear(),
            color: widget.hasCustomCompressionSettings
                ? Colors.white
                : Colors.white,
          ),
          tooltip: widget.hasCustomCompressionSettings
              ? '${S.of(context).compressionSettings} (${widget.compressionQualityDisplay})'
              : S.of(context).compressionSettings,
        ),
        if (widget.hasCustomCompressionSettings)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.green.shade400,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade400.withValues(alpha: 0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// Builds the delete button
  Widget _buildDeleteButton(BuildContext context) {
    return IconButton(
      iconSize: _VideoItemConstants.actionButtonSize,
      onPressed: () {
        HapticFeedback.mediumImpact();
        widget.onDelete(widget.video);
      },
      style: IconButton.styleFrom(
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        padding: const EdgeInsets.all(8),
      ),
      icon: Icon(
        PhosphorIcons.trash(),
        color: Colors.white,
      ),
      tooltip: S.of(context).deleteVideo,
    );
  }

  /// Builds the edit button
  Widget _buildEditButton(BuildContext context) {
    return IconButton(
      iconSize: _VideoItemConstants.actionButtonSize,
      onPressed: () {
        HapticFeedback.selectionClick();
        widget.onStartDraw?.call(widget.video);
      },
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.8),
        padding: const EdgeInsets.all(8),
      ),
      icon: Icon(
        PhosphorIcons.pen(),
        color: Colors.white,
      ),
      tooltip: S.of(context).editVideo,
    );
  }

  /// Builds the video player with thumbnail and play button
  Widget _buildVideoPlayer(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildVideoThumbnail(context),
        _buildPlayButton(),
      ],
    );
  }

  /// Builds the video thumbnail background
  Widget _buildVideoThumbnail(BuildContext context) {
    final thumbImage = widget.video.data.thumbImage;
    
    if (thumbImage != null && widget.video.data.isFromPath) {
      final filePath = thumbImage.fileSource.fileLocalPath;
      if (filePath != null && filePath.isNotEmpty) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(filePath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildFallbackThumbnail();
              },
            ),
          ),
        );
      }
    }
    
    return _buildFallbackThumbnail();
  }

  /// Builds fallback thumbnail when no thumbnail is available
  Widget _buildFallbackThumbnail() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        PhosphorIcons.videoCamera(),
        color: Colors.white70,
        size: 60,
      ),
    );
  }

  /// Builds the play button overlay
  Widget _buildPlayButton() {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPlayPressed = true);
        HapticFeedback.mediumImpact();
      },
      onTapUp: (_) {
        setState(() => _isPlayPressed = false);
        widget.onPlayVideo(widget.video);
      },
      onTapCancel: () => setState(() => _isPlayPressed = false),
      child: AnimatedScale(
        scale: _isPlayPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          height: _VideoItemConstants.playButtonSize,
          width: _VideoItemConstants.playButtonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black54,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: _isPlayPressed ? 8 : 16,
                spreadRadius: _isPlayPressed ? 0 : 2,
              ),
            ],
          ),
          child: Icon(
            PhosphorIcons.play(PhosphorIconsStyle.fill),
            color: Colors.white,
            size: _VideoItemConstants.playButtonSize * 0.4,
          ),
        ),
      ),
    );
  }

  /// Builds compression settings indicator overlay
  Widget _buildCompressionIndicator(BuildContext context) {
    return Positioned(
      top: 12,
      left: 12,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        tween: Tween<double>(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green.shade600.withValues(alpha: 0.95),
                Colors.green.shade700.withValues(alpha: 0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.green.shade600.withValues(alpha: 0.4),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.settings,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                widget.compressionQualityDisplay ?? S.of(context).custom,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
