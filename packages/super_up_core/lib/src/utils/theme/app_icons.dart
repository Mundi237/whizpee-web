// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

abstract class AppIcons {
  ///message
  static const Widget muteIcon = Icon(
    Icons.volume_off_sharp,
    size: 22,
    color: AppColors.accentColor,
  );

  static const Widget archiveIcon = Icon(Icons.archive);

  static const Widget sendMessage = Icon(
    Icons.done,
    size: 16,
  );

  static const Widget pendingMessage = Icon(
    Icons.access_time,
    size: 16,
  );
  static const Widget deliverMessageStatus = Icon(
    Icons.done_all_outlined,
    color: CupertinoColors.systemGreen,
    size: 16,
  );
  static const Widget seenMessageStatus = Icon(
    Icons.done_all_outlined,
    color: AppColors.primaryColor,
    size: 16,
  );
}
