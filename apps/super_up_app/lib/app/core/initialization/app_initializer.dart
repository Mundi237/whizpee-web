// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:super_up/app/core/initialization/error_handler.dart';
import 'package:super_up/app/core/utils/lazy_injection.dart';
import 'package:super_up/app/modules/annonces/datas/injector.dart';
import 'package:super_up/firebase_options.dart';
import 'package:super_up/v_chat_v2/v_chat_config.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:v_chat_call_service/v_chat_call_service.dart';
import 'package:v_chat_firebase_fcm/v_chat_firebase_fcm.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';
import 'package:window_manager/window_manager.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../utils/ios_call_handler.dart';

/// Handles all application initialization steps
class AppInitializer {
  /// Initialize all required components for the app
  static Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    try {
      // Ensure Flutter binding is initialized
      WidgetsFlutterBinding.ensureInitialized();

      // Platform-specific initializations
      await _initializePlatformSpecifics();

      // Initialize services and configurations
      registerSingletons();
      VPlatformFileUtils.baseMediaUrl = SConstants.baseMediaUrl;

      // Initialize Firebase if on supported platforms
      await _initializeFirebase();

      // Initialize preferences
      await VAppPref.init();
      final preferences = await SharedPreferences.getInstance();
      initInjectorApp(preferences: preferences);

      // Initialize chat and call services
      await initVChat(navigatorKey);
      await _initCallServices();

      // Initialize iOS call handler
      await IOSCallHandler.instance.initialize();
    } catch (e, stackTrace) {
      // Handle initialization errors
      AppErrorHandler().handleInitError(e, stackTrace);
    }
  }

  /// Initialize Firebase on supported platforms
  static Future<void> _initializeFirebase() async {
    if (VPlatforms.isMobile || VPlatforms.isMacOs || VPlatforms.isWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  /// Initialize platform-specific features
  static Future<void> _initializePlatformSpecifics() async {
    // Desktop window configuration
    if (VPlatforms.isDeskTop) {
      await _setDesktopWindow();
    }

    // Web URL strategy configuration
    if (VPlatforms.isWeb) {
      setPathUrlStrategy();
    }
  }

  /// Configure desktop window settings
  static Future<void> _setDesktopWindow() async {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      minimumSize: const Size(600, 1000),
      size: const Size(1500, 1000),
      backgroundColor: Colors.transparent,
      skipTaskbar: true,
      title: SConstants.appName,
      titleBarStyle: VPlatforms.isWindows ? null : TitleBarStyle.hidden,
      fullScreen: false,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  /// Initialize call services (CallKit + Foreground Service)
  static Future<void> _initCallServices() async {
    // Initialize existing CallKit functionality
    CallKeepHandler.I.configureFlutterCallKeep(false);

    // Initialize foreground call service for persistent call notifications
    if (VPlatforms.isAndroid) {
      try {
        final callServiceManager = CallServiceManager.instance;
        await callServiceManager.initialize();
        debugPrint('CallServiceManager initialized successfully');
      } catch (e) {
        debugPrint('Failed to initialize CallServiceManager: $e');
      }
    }
  }
}
