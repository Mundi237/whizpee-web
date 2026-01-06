// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../../../super_up_core.dart';

class VLanguageListener extends ValueNotifier<Locale> {
  VLanguageListener._() : super(const Locale("en"));

  static final _instance = VLanguageListener._();

  static VLanguageListener get I {
    return _instance;
  }

  Future setLocal(Locale locale) async {
    await VAppPref.setStringKey(
      SStorageKeys.appLanguageCode.name,
      locale.languageCode,
    );

    value = locale;
  }

  Locale get appLocal {
    final prefLang = VAppPref.getStringOrNullKey(
      SStorageKeys.appLanguageCode.name,
    );
    if (prefLang == null) {
      unawaited(
        VAppPref.setStringKey(
          SStorageKeys.appLanguageTitle.name,
          deviceLocal.languageCode,
        ),
      );
      unawaited(setLocal(deviceLocal));
      return deviceLocal;
    }
    final split = prefLang.split("_");
    if (split.length == 1) {
      return Locale(split.first);
    } else {
      return Locale(split.first, split.last);
    }
  }

  Locale get deviceLocal => WidgetsBinding.instance.platformDispatcher.locale;
}
