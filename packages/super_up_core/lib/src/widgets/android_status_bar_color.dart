// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class AndroidStatusBarColor extends StatelessWidget {
  final Widget child;
  final ThemeMode themeMode;

  const AndroidStatusBarColor({
    super.key,
    required this.child,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    return child;
    // if (!VPlatforms.isAndroid) return child;
    // return AnnotatedRegion<SystemUiOverlayStyle>(
    //   value: const SystemUiOverlayStyle(
    //     // statusBarColor:
    //     //     themeMode == ThemeMode.dark ? Colors.black : Colors.white,
    //
    //     // statusBarIconBrightness:
    //     //     themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light,
    //   ),
    //   child: child,
    // );
  }
}
