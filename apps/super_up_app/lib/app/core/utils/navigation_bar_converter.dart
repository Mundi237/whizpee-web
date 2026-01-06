// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// Helper class to convert AppBar properties to AppBar
class NavigationBarConverter {
  /// Converts AppBar style attributes to AppBar
  ///
  /// Example usage:
  /// ```dart
  /// // Before:
  /// appBar: AppBar(
  ///   middle: Text("Title"),
  ///   previousPageTitle: "Back",
  /// )
  ///
  /// // After:
  /// appBar: NavigationBarConverter.toAppBar(
  ///   title: "Title",
  ///   previousPageTitle: "Back",
  /// )
  /// ```
  static AppBar toAppBar({
    required String title,
    String? previousPageTitle,
    List<Widget>? actions,
    Color? backgroundColor,
    VoidCallback? onLeadingPressed,
    bool automaticallyImplyLeading = true,
    Widget? leading,
    PreferredSizeWidget? bottom,
    double? elevation,
    Color? foregroundColor,
  }) {
    return AppBar(
      title: Text(title),
      actions: actions,
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading ??
          (onLeadingPressed != null
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onLeadingPressed,
                )
              : null),
      bottom: bottom,
      elevation: elevation,
      foregroundColor: foregroundColor,
    );
  }
}
