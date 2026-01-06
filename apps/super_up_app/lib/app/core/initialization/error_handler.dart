// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';

/// Central error handler for the application
class AppErrorHandler {
  /// Singleton instance
  static final AppErrorHandler _instance = AppErrorHandler._internal();

  /// Factory constructor for the singleton
  factory AppErrorHandler() => _instance;

  /// Private constructor
  AppErrorHandler._internal();

  /// Handle errors during initialization
  void handleInitError(Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print('Initialization error: $error');
      print(stackTrace);
    }

    // Here you could add error reporting to a service like Firebase Crashlytics
    // or another error monitoring solution
    // Example: FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }

  /// Handle runtime errors
  void handleRuntimeError(Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print('Runtime error: $error');
      print(stackTrace);
    }

    // Add error reporting logic here
  }
}
