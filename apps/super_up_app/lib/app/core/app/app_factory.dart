// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up/app/core/theme/app_theme_manager.dart';
import 'package:super_up/app/core/utils/force_update_config.dart';
import 'package:super_up/app/core/widgets/main_builder.dart';
import 'package:super_up/app/modules/splash/views/splash_view.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:upgrader/upgrader.dart';

/// Factory class for creating the application widget
class AppFactory {
  /// Creates the main application widget
  static Widget createApp(GlobalKey<NavigatorState> navigatorKey) {
    return VUtilsWrapper(
      builder: (_, local, themeMode) {
        return OKToast(
          position: ToastPosition.bottom,
          child: MaterialApp(
              navigatorKey: navigatorKey,
              title: SConstants.appName,
              locale: local,
              supportedLocales: S.delegate.supportedLocales,
              localizationsDelegates: const [
                S.delegate,
                ...PhoneFieldLocalization.delegates,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (context, child) => MainBuilder(
                    child: child,
                  ),
              home: const _UpgradeWrapper(
                child: SplashView(),
              ),
              debugShowCheckedModeBanner: false,
              theme: AppThemeManager.getLightTheme(),
              darkTheme: AppThemeManager.getDarkTheme(),
              themeMode: ThemeMode.dark // themeMode,
              ),
        );
      },
    );
  }
}

/// Wrapper widget for the upgrade alert
class _UpgradeWrapper extends StatelessWidget {
  final Widget child;

  const _UpgradeWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: ForceUpdateConfig.createUpgrader(),
      // Force update settings - no way to dismiss
      showIgnore: false, // No "Ignore" button
      showLater: false, // No "Later" button
      barrierDismissible: false, // Cannot dismiss by tapping outside
      shouldPopScope: () => false, // Prevent back button from dismissing
      child: child,
    );
  }
}
