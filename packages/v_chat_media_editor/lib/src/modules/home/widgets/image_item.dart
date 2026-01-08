// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:v_platform/v_platform.dart';
import 'package:s_translation/generated/l10n.dart';

import '../../../../v_chat_media_editor.dart';
import '../../../core/platform_cache_image_widget.dart';

// Constants for consistent styling
class _ImageItemConstants {
  static const double actionButtonSize = 30.0;
  static const double actionButtonSpacing = 4.0;
  static const double containerPadding = 8.0;
}

class ImageItem extends StatefulWidget {
  final VMediaImageRes image;
  final VoidCallback onCloseClicked;
  final Function(VMediaImageRes item) onDelete;
  final Function(VMediaImageRes item) onCrop;
  final Function(VMediaImageRes item) onStartDraw;

  const ImageItem({
    super.key,
    required this.image,
    required this.onCloseClicked,
    required this.onDelete,
    required this.onCrop,
    required this.onStartDraw,
  });

  @override
  State<ImageItem> createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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
            child: _buildImageWidget(),
          ),
        ],
      ),
    );
  }

  /// Builds the top action bar with close and action buttons
  Widget _buildTopActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_ImageItemConstants.containerPadding),
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
    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 150),
      child: IconButton(
        iconSize: _ImageItemConstants.actionButtonSize,
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
      ),
    );
  }

  /// Builds the action buttons with overflow handling
  Widget _buildActionButtons(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: _ImageItemConstants.actionButtonSpacing,
      children: [
        _buildDeleteButton(context),
        _buildCropButton(context),
        _buildEditButton(context),
      ],
    );
  }

  /// Builds the delete button
  Widget _buildDeleteButton(BuildContext context) {
    return IconButton(
      iconSize: _ImageItemConstants.actionButtonSize,
      onPressed: () {
        HapticFeedback.mediumImpact();
        widget.onDelete(widget.image);
      },
      style: IconButton.styleFrom(
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        padding: const EdgeInsets.all(8),
      ),
      icon: Icon(
        PhosphorIcons.trash(),
        color: Colors.white,
      ),
      tooltip: S.of(context).deleteImage,
    );
  }

  /// Builds the crop button
  Widget _buildCropButton(BuildContext context) {
    final bool isCropEnabled = !VPlatforms.isWeb;
    return IconButton(
      iconSize: _ImageItemConstants.actionButtonSize,
      onPressed: isCropEnabled
          ? () {
              HapticFeedback.selectionClick();
              widget.onCrop(widget.image);
            }
          : null,
      style: IconButton.styleFrom(
        backgroundColor: isCropEnabled
            ? Colors.black.withValues(alpha: 0.5)
            : Colors.grey.withValues(alpha: 0.3),
        padding: const EdgeInsets.all(8),
      ),
      icon: Icon(
        PhosphorIcons.crop(),
        color: isCropEnabled ? Colors.white : Colors.grey,
      ),
      tooltip: isCropEnabled
          ? S.of(context).cropImage
          : S.of(context).cropNotAvailableOnWeb,
    );
  }

  /// Builds the edit button
  Widget _buildEditButton(BuildContext context) {
    return IconButton(
      iconSize: _ImageItemConstants.actionButtonSize,
      onPressed: () {
        HapticFeedback.selectionClick();
        widget.onStartDraw(widget.image);
      },
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.8),
        padding: const EdgeInsets.all(8),
      ),
      icon: const Icon(
        Icons.edit,
        color: Colors.white,
      ),
      tooltip: S.of(context).editImage,
    );
  }

  /// Builds the image widget
  Widget _buildImageWidget() {
    return VPlatformCacheImageWidget(
      source: widget.image.data.fileSource,
      fit: BoxFit.contain,
    );
  }
}
