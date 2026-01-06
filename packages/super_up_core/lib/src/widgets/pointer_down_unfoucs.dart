// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_platform/v_platform.dart';

/// Widget that unfocuses text fields when user taps outside
/// Improves keyboard management UX on mobile devices
class PointerDownUnFocus extends StatelessWidget {
  final Widget child;
  final bool enableHapticFeedback;

  const PointerDownUnFocus({
    super.key,
    required this.child,
    this.enableHapticFeedback = false,
  });

  @override
  Widget build(BuildContext context) {
    // Only apply on mobile where keyboard management is important
    if (!VPlatforms.isMobile) return child;
    
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        final currentFocus = FocusScope.of(context);
        // Only unfocus if there's actually a focused widget
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          if (enableHapticFeedback) {
            HapticFeedback.selectionClick();
          }
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}
