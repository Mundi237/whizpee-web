// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../super_up_core.dart';

class VThemeListener extends ValueNotifier<ThemeMode> {
  VThemeListener._() : super(ThemeMode.system) {
    _initializeTheme();
    _listenToSystemThemeChanges();
  }

  static final _instance = VThemeListener._();
  static VThemeListener get I => _instance;

  // Listen to system theme changes
  void _listenToSystemThemeChanges() {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      // Notify listeners when system theme changes
      if (value == ThemeMode.system) {
        notifyListeners();
      }
    };
  }

  // Initialize theme from stored preferences
  Future<void> _initializeTheme() async {
    final storedTheme = await _getStoredTheme();
    if (storedTheme != null) {
      value = storedTheme;
    } else {
      // First time app launch - detect and set system theme
      await setTheme(ThemeMode.system);
    }
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    await VAppPref.setStringKey(
      SStorageKeys.appTheme.name,
      themeMode.name,
    );
    value = themeMode;
  }

  Future<ThemeMode?> _getStoredTheme() async {
    final prefTheme = VAppPref.getStringOrNullKey(SStorageKeys.appTheme.name);
    if (prefTheme == null) return null;

    try {
      return ThemeMode.values.byName(prefTheme);
    } catch (e) {
      // Invalid theme name stored, return null to use default
      return null;
    }
  }

  ThemeMode get appTheme => value;

  // Get current system brightness
  Brightness get systemBrightness {
    return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }

  // Check if current theme is dark (useful for UI logic)
  bool get isDarkMode {
    switch (value) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return systemBrightness == Brightness.dark;
    }
  }

  // Get effective theme mode (resolves system to actual light/dark)
  ThemeMode get effectiveThemeMode {
    if (value == ThemeMode.system) {
      return systemBrightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light;
    }
    return value;
  }
}
