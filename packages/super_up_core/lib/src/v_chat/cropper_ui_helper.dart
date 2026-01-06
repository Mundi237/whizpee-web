// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:s_translation/generated/l10n.dart';

/// Helper class to provide Material 3 compliant UI settings for image cropper
/// with enhanced visual feedback and accessibility
class CropperUIHelper {
  /// Returns Material 3 compliant Android UI settings with modern styling
  static AndroidUiSettings getAndroidUiSettings(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AndroidUiSettings(
      toolbarTitle: S.of(context).cropImage,
      toolbarColor: colorScheme.surface,
      toolbarWidgetColor: colorScheme.onSurface,
      statusBarColor: colorScheme.surface,
      backgroundColor: isDark 
          ? colorScheme.surface 
          : colorScheme.surface,
      activeControlsWidgetColor: colorScheme.primary,
      dimmedLayerColor: Colors.black.withValues(alpha: isDark ? 0.7 : 0.6),
      cropFrameColor: colorScheme.primary,
      cropGridColor: colorScheme.primary.withValues(alpha: isDark ? 0.6 : 0.5),
      cropFrameStrokeWidth: 3, // Increased for better visibility
      cropGridStrokeWidth: 1,
      cropGridRowCount: 3,
      cropGridColumnCount: 3,
      showCropGrid: true,
      lockAspectRatio: false,
      hideBottomControls: false,
      initAspectRatio: CropAspectRatioPreset.original,
    );
  }

  /// Returns iOS UI settings with proper styling and accessibility
  static IOSUiSettings getIOSUiSettings(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return IOSUiSettings(
      title: S.of(context).cropImage,
      doneButtonTitle: S.of(context).done,
      cancelButtonTitle: S.of(context).cancel,
      rotateClockwiseButtonHidden: false,
      rotateButtonsHidden: false,
      aspectRatioPickerButtonHidden: false,
      resetButtonHidden: false,
      aspectRatioLockEnabled: false,
      resetAspectRatioEnabled: true,
      hidesNavigationBar: false,
      minimumAspectRatio: 1.0,
      rectX: 0,
      rectY: 0,
      rectWidth: 0,
      rectHeight: 0,
    );
  }

  /// Returns Web UI settings for web platform
  static WebUiSettings getWebUiSettings(BuildContext context) {
    return WebUiSettings(
      context: context,
    );
  }

  /// Returns a complete list of UI settings for all platforms
  static List<PlatformUiSettings> getAllPlatformSettings(BuildContext context) {
    return [
      getAndroidUiSettings(context),
      getIOSUiSettings(context),
      getWebUiSettings(context),
    ];
  }
}
