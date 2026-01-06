// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color buttonBackground = Color(0xff10826E);
  static const Color textColor = Color(0xff86939A);
  static const Color textGrayColor = Color(0xff97A1A7);
  static const Color textFieldBorderColor = Color(0xff00A884);
  static const Color textLinkColor = Color(0xff3E98BE);
  static const Color scaffoldBackground = Color(0xffffffff);
  static const Color primaryColor = Color(0xFF075E54);
  static const Color accentColor = Color(0xFF008069);
  static const Color linkColor = Color(0xFFA390EC);

  /// message status colors
  static const Color seenMessageIcon = CupertinoColors.systemGreen;
  static const Color deliverMessageIcon = Colors.black;
  static const Color sendMessageIcon = Colors.black;

  /// unread colors
  static const Color unreadMessageColor = Colors.amber;

  /// read colors
  static const Color readMessageColor = Colors.grey;

  static const Color typingColor = Colors.lightGreen;
  static const Color iconGrayColor = Color(0xff189583);
}
