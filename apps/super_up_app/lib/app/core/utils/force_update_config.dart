// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:upgrader/upgrader.dart';
import 'package:v_platform/v_platform.dart';

/// Configuration for forced app updates
class ForceUpdateConfig {
  // Singleton instance of Upgrader
  static Upgrader? _upgraderInstance;

  /// Creates an Upgrader instance configured for forced updates
  static Upgrader createUpgrader() {
    // Return existing instance if already created
    if (_upgraderInstance != null) {
      return _upgraderInstance!;
    }

    // Only enable for mobile platforms (Android and iOS)
    if (!VPlatforms.isMobile) {
      // Return a disabled upgrader for non-mobile platforms
      _upgraderInstance = Upgrader(
        durationUntilAlertAgain: const Duration(days: 365),
      );
      return _upgraderInstance!;
    }

    _upgraderInstance = Upgrader(
      // Minimum version - Force update if current version is below this
      // In production, set this to the actual minimum version required
      // Or use [:mav: X.X.X] in Play Store/App Store description
      minAppVersion: '1.0.2',  // Set to actual minimum version in production
      
      // Custom messages in French
      messages: _getFrenchMessages(),
      
      // Check for updates on each app launch
      durationUntilAlertAgain: const Duration(days: 1),
      
      // Production settings - disabled debug options
      debugDisplayAlways: false,  // DISABLED FOR PRODUCTION
      debugDisplayOnce: false,
      debugLogging: false,        // DISABLED FOR PRODUCTION
    );

    return _upgraderInstance!;
  }

  /// Custom French messages for the upgrade dialog
  static UpgraderMessages _getFrenchMessages() {
    return UpgraderMessages(
      code: 'fr',
    );
  }
}
