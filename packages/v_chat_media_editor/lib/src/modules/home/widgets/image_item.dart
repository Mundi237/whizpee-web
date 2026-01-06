// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
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

class ImageItem extends StatelessWidget {
  final VMediaImageRes image;
  final VoidCallback onCloseClicked;
  final Function(VMediaImageRes item) onDelete;
  final Function(VMediaImageRes item) onCrop;
  final Function(VMediaImageRes item) onStartDraw;

  const ImageItem(
      {super.key,
      required this.image,
      required this.onCloseClicked,
      required this.onDelete,
      required this.onCrop,
      required this.onStartDraw});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopActionBar(context),
        Expanded(
          child: _buildImageWidget(),
        ),
      ],
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
    return IconButton(
      iconSize: _ImageItemConstants.actionButtonSize,
      onPressed: onCloseClicked,
      icon: const Icon(
        Icons.close,
        color: Colors.white,
      ),
      tooltip: S.of(context).close,
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
      onPressed: () => onDelete(image),
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
      onPressed: isCropEnabled ? () => onCrop(image) : null,
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
      onPressed: () => onStartDraw(image),
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
      source: image.data.fileSource,
      fit: BoxFit.contain,
    );
  }
}
