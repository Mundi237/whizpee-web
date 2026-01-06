// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

import 'no_animation_page_route.dart';

extension MediaQueryExt2 on BuildContext {
  bool get isDark => CupertinoTheme.of(this).brightness == Brightness.dark;

  CupertinoTextThemeData get cupertinoTextTheme =>
      CupertinoTheme.of(this).textTheme;

  Future<T?> toPage<T>(
    Widget page, {
    bool withAnimation = true,
    bool removeAll = false,
  }) {
    if (removeAll) {
      if (!withAnimation) {
        return Navigator.of(this).pushAndRemoveUntil(
          NoAnimationPageRoute(builder: (context) => page),
          (Route<dynamic> route) => false,
        );
      }
      return Navigator.of(this).pushAndRemoveUntil(
        VPlatforms.isIOS
            ? CupertinoPageRoute(builder: (context) => page)
            : MaterialPageRoute(builder: (context) => page),
        (Route<dynamic> route) => false,
      );
    }
    if (!withAnimation) {
      return Navigator.push(
        this,
        NoAnimationPageRoute(
          builder: (context) => page,
        ),
      );
    }
    return Navigator.push(
      this,
      VPlatforms.isIOS
          ? CupertinoPageRoute(
              builder: (context) => page,
            )
          : MaterialPageRoute(
              builder: (context) => page,
            ),
    );
  }

  void pop([Object? r]) => Navigator.pop(this, r);

  Future<T?> toPageAndRemoveAllWithOutAnimation<T>(Widget page) {
    return Navigator.of(this).pushAndRemoveUntil(
        NoAnimationPageRoute(builder: (context) => page),
        (Route<dynamic> route) => false);
  }

  bool get isRtl => Directionality.of(this).name.toLowerCase() == "rtl";

  // Get the MediaQuery
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  // Get the theme
  ThemeData get theme => Theme.of(this);

  // Get the text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Get the size of the screen
  Size get screenSize => MediaQuery.of(this).size;

  // Get the height of the screen
  double get height => MediaQuery.of(this).size.height;

  // Get the width of the screen
  double get width => MediaQuery.of(this).size.width;
}
