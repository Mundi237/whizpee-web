// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';

/// Manages all theme-related operations and configurations
class AppThemeManager {
  /// Returns the appropriate brightness for iOS based on the current theme mode
  static Brightness getIosBrightness(ThemeMode themeMode) {
    if (themeMode == ThemeMode.dark) {
      return Brightness.dark;
    }
    if (themeMode == ThemeMode.light) {
      return Brightness.light;
    }

    // Default to light theme if system theme is chosen
    VAppPref.setStringKey(SStorageKeys.appTheme.name, ThemeMode.light.name);
    return Brightness.light;
  }

  /// Creates the dark theme data with all necessary extensions
  static ThemeData getDarkTheme() {
    return ThemeData.dark(useMaterial3: true).copyWith(
      appBarTheme: AppBarTheme(centerTitle: true),
      scaffoldBackgroundColor: Colors.black,
      cupertinoOverrideTheme: getCupertinoTheme(ThemeMode.dark),
      extensions: [
        VMessageTheme.dark().copyWith(
          senderBubbleColor: const Color(0xff005046),
          receiverBubbleColor: const Color(0xff363638),
          senderTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16.5,
          ),
          receiverTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16.5,
          ),
        ),
        VRoomTheme.dark().copyWith(),
      ],
    );
  }

  /// Creates the light theme data with all necessary extensions
  static ThemeData getLightTheme() {
    return ThemeData.light(useMaterial3: true).copyWith(
      appBarTheme: AppBarTheme(centerTitle: true),
      primaryColor: Colors.green,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      cupertinoOverrideTheme: getCupertinoTheme(ThemeMode.light),
      extensions: [
        VMessageTheme.light().copyWith(
          senderBubbleColor: const Color(0xffE2FFD4),
          receiverBubbleColor: const Color(0xffFFFFFF),
          senderTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16.5,
          ),
          receiverTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 16.5,
          ),
        ),
        VRoomTheme.light().copyWith(),
      ],
    );
  }

  /// Creates the Cupertino theme data based on the current theme mode
  static CupertinoThemeData getCupertinoTheme(ThemeMode themeMode) {
    final brightness = getIosBrightness(themeMode);
    final isDark = brightness == Brightness.dark;

    // Create the appropriate text theme based on dark/light mode
    final textTheme =
        isDark ? _getDarkCupertinoTextTheme() : _getLightCupertinoTextTheme();

    return CupertinoThemeData(
      brightness: brightness,
      applyThemeToAll: true,
      barBackgroundColor: isDark ? Colors.black : Colors.white,
      primaryColor: Colors.green,
      primaryContrastingColor: Colors.green,
      textTheme: textTheme,
      scaffoldBackgroundColor: isDark ? Colors.black : CupertinoColors.white,
    );
  }

  /// Returns the dark mode Cupertino text theme
  static CupertinoTextThemeData _getDarkCupertinoTextTheme() {
    return CupertinoTextThemeData(
      // Base text style for most text
      textStyle: TextStyle(
        color: CupertinoColors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
      ),
      // Action buttons (like in dialogs)
      actionTextStyle: TextStyle(
        color: Colors.green,
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
      ),
      // Tab labels at bottom of screen
      tabLabelTextStyle: TextStyle(
        color: CupertinoColors.systemGrey,
        fontSize: 10.0,
        fontWeight: FontWeight.w500,
      ),
      // Standard navigation bar title
      navTitleTextStyle: TextStyle(
        color: CupertinoColors.white,
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
      ),
      // Large navigation bar title (collapsible header)
      navLargeTitleTextStyle: TextStyle(
        color: CupertinoColors.white,
        fontSize: 34.0,
        fontWeight: FontWeight.bold,
      ),
      // Navigation bar action items
      navActionTextStyle: TextStyle(
        color: Colors.green,
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
      ),
      // Picker text style (eg. for date pickers)
      pickerTextStyle: TextStyle(
        color: CupertinoColors.white,
        fontSize: 16.0,
      ),
      // Date/time picker text style
      dateTimePickerTextStyle: TextStyle(
        color: CupertinoColors.white,
        fontSize: 21.0,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  /// Returns the light mode Cupertino text theme
  static CupertinoTextThemeData _getLightCupertinoTextTheme() {
    return CupertinoTextThemeData(
      // Base text style for most text
      textStyle: TextStyle(
        color: CupertinoColors.black,
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
      ),
      // Action buttons (like in dialogs)
      actionTextStyle: TextStyle(
        color: Colors.green,
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
      ),
      // Tab labels at bottom of screen
      tabLabelTextStyle: TextStyle(
        color: CupertinoColors.systemGrey,
        fontSize: 10.0,
        fontWeight: FontWeight.w500,
      ),
      // Standard navigation bar title
      navTitleTextStyle: TextStyle(
        color: CupertinoColors.black,
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
      ),
      // Large navigation bar title (collapsible header)
      navLargeTitleTextStyle: TextStyle(
        color: CupertinoColors.black,
        fontSize: 34.0,
        fontWeight: FontWeight.bold,
      ),
      // Navigation bar action items
      navActionTextStyle: TextStyle(
        color: Colors.green,
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
      ),
      // Picker text style (eg. for date pickers)
      pickerTextStyle: TextStyle(
        color: CupertinoColors.black,
        fontSize: 16.0,
      ),
      // Date/time picker text style
      dateTimePickerTextStyle: TextStyle(
        color: CupertinoColors.black,
        fontSize: 21.0,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
