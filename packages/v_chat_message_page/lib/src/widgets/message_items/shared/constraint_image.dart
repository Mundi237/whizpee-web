// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_message_page/src/v_chat/platform_cache_image_widget.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// Helper class for calculating image display dimensions
class _ImageDimensionCalculator {
  static Size calculateDisplaySize(
    BuildContext context,
    VMessageImageData data,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate maximum allowed dimensions based on screen size
    final maxImageHeight =
        screenWidth < 600 ? screenHeight * .60 : screenHeight * .30;
    final maxImageWidth =
        screenWidth < 600 ? screenWidth * .72 : screenWidth * .40;

    // Calculate the actual display dimensions based on image aspect ratio
    final imageAspectRatio = data.width / data.height;

    // Calculate dimensions that respect both the image aspect ratio and max constraints
    double displayWidth;
    double displayHeight;

    if (imageAspectRatio > 1) {
      // Landscape image - width is the limiting factor
      displayWidth = maxImageWidth;
      displayHeight = displayWidth / imageAspectRatio;

      // If height exceeds max height, recalculate based on height
      if (displayHeight > maxImageHeight) {
        displayHeight = maxImageHeight;
        displayWidth = displayHeight * imageAspectRatio;
      }
    } else {
      // Portrait or square image - height is the limiting factor
      displayHeight = maxImageHeight;
      displayWidth = displayHeight * imageAspectRatio;

      // If width exceeds max width, recalculate based on width
      if (displayWidth > maxImageWidth) {
        displayWidth = maxImageWidth;
        displayHeight = displayWidth / imageAspectRatio;
      }
    }

    return Size(displayWidth, displayHeight);
  }
}

class VConstraintImage extends StatelessWidget {
  final VMessageImageData data;
  final BorderRadius? borderRadius;
  final BoxFit? fit;

  const VConstraintImage({
    super.key,
    required this.data,
    this.borderRadius,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final displaySize =
        _ImageDimensionCalculator.calculateDisplaySize(context, data);

    return SizedBox(
      width: displaySize.width,
      height: displaySize.height,
      child: VPlatformCacheImageWidget(
        source: data.fileSource,
        borderRadius: borderRadius,
        fit: fit,
        size: displaySize,
      ),
    );
  }
}

class VConstraintHashBlurImage extends StatelessWidget {
  final VMessageImageData data;

  const VConstraintHashBlurImage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final displaySize =
        _ImageDimensionCalculator.calculateDisplaySize(context, data);

    return SizedBox(
      width: displaySize.width,
      height: displaySize.height,
      child: Container(
        color: Colors.black,
        child: const SizedBox(),
      ),
    );
  }
}
