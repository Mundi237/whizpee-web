// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_admin/src/core/api_service/api_service.dart';
import 'package:super_up_admin/src/modules/splash.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:v_platform/v_platform.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'color_schemes.g.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  VPlatformFileUtils.baseMediaUrl = SConstants.baseMediaUrl;
  await VAppPref.init();
  _inject();
  _setupTimeAgo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: VUtilsWrapper(
        builder: (context, locale, themeMode) {
          return MaterialApp(
            title: SConstants.appName,
            navigatorKey: navigatorKey,
            home: const Splash(),
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightColorScheme,
              cupertinoOverrideTheme: const CupertinoThemeData(
                brightness: Brightness.light,
                textTheme: CupertinoTextThemeData(
                  textStyle: TextStyle(color: Colors.black),
                ),
              ),
            ).copyWith(
                //textTheme: GoogleFonts.robotoSerifTextTheme().copyWith(),
                ),
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkColorScheme,
              cupertinoOverrideTheme: const CupertinoThemeData(
                brightness: Brightness.dark,
                textTheme: CupertinoTextThemeData(
                  textStyle: TextStyle(color: Colors.white),
                ),
              ),
            ).copyWith(
                // textTheme: GoogleFonts.robotoSerifTextTheme().copyWith(),
                ),
            themeMode: themeMode,
            locale: locale,

            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return PointerDownUnFocus(
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}


void _inject() {
  GetIt.I.registerSingleton<SAdminApiService>(SAdminApiService.init());
  GetIt.I.registerSingleton<AppSizeHelper>(AppSizeHelper());
}

void _setupTimeAgo() {
  setLocaleMessages('ar', ArMessages());
  setLocaleMessages('bs', BsMessages());
  setLocaleMessages('cs', CsMessages());
  setLocaleMessages('fi', FiMessages());
  setLocaleMessages('da', DaMessages());
  setLocaleMessages('fr', FiMessages());
  setLocaleMessages('mn', MnMessages());
  setLocaleMessages('it', ItMessages());
  setLocaleMessages('rw', RwMessages());
  setLocaleMessages('ko', KoMessages());
  setLocaleMessages('uk', UkMessages());
  setLocaleMessages('vi', ViMessages());
  setLocaleMessages('pt', PtBrMessages());
  setLocaleMessages('hi', HiMessages());
  setLocaleMessages('ru', RuMessages());
  setLocaleMessages('gr', GrMessages());
  setLocaleMessages('he', HeMessages());
  setLocaleMessages('hi', HiMessages());
  setLocaleMessages('ja', JaMessages());
  setLocaleMessages('ko', KoMessages());
  setLocaleMessages('tr', TrMessages());
  setLocaleMessages('uk', UkMessages());
  setLocaleMessages('zh', ZhMessages());
  setLocaleMessages('es', EsMessages());
}
