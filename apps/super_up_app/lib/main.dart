// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:super_up/app/core/app/app_factory.dart';
import 'package:super_up/app/core/initialization/app_initializer.dart';

/// Global navigator key used across the app
final navigatorKey = GlobalKey<NavigatorState>();

/// Application entry point
void main() async {
  // Initialize all required app components
  await AppInitializer.initialize(navigatorKey);

  // Run the app with the created widget
  runApp(
    AppFactory.createApp(navigatorKey),
  );
}
