// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

class AppSizeHelper {
  bool isSmall(BuildContext context) {
    return context.width < 820 && kIsWeb;
  }

  // final isDesktopOrWeb = VPlatforms.isWeb && !VPlatforms.isWebRunOnMobile ||
  //     VPlatforms.isDeskTop;
  bool isWide(BuildContext context) {
    bool isTablet = context.width >= 768;
    if (VPlatforms.isMobile && isTablet) {
      return true;
    }
    if (VPlatforms.isMobile) {
      return false;
    }
    if (VPlatforms.isWebRunOnMobile && !isTablet) {
      return false;
    }

    return true;
  }
}
