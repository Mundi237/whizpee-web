// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:super_up/app/core/app_config/app_config_controller.dart';
import 'package:super_up/app/core/app_nav/app_navigation.dart';
import 'package:super_up/app/modules/splash/views/splash_view.dart';
import 'package:super_up/main.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../../core/controllers/version_checker_controller.dart';
import '../states/setting_state.dart';
import '../views/media_storage_settings.dart';
import '../views/sheet_for_choose_language.dart';

class SettingsTabController extends SLoadingController<SettingState> {
  SettingsTabController()
      : super(
          SLoadingState(
            SettingState(
              isDarkMode: VAppPref.getStringOrNullKey(
                    SStorageKeys.appTheme.name,
                  ) ==
                  ThemeMode.dark.name,
              language: VAppPref.getStringOrNullKey(
                    SStorageKeys.appLanguageTitle.name,
                  ) ??
                  "English",
              inAppAlerts: VAppPref.getBoolOrNull(
                    SStorageKeys.inAppAlerts.name,
                  ) ??
                  true,
            ),
          ),
        );
  final versionCheckerController = GetIt.I.get<VersionCheckerController>();
  final appConfig = VAppConfigController.appConfig;

  @override
  void onClose() {}

  @override
  void onInit() {}

  Future<void> logout(BuildContext context) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).areYouSure,
      content:
          "${S.of(context).yourAreAboutToLogoutFromThisAccount} ${AppAuth.myProfile.baseUser.fullName}",
    );
    if (res == 1) {
      vSafeApiCall(onLoading: () {
        VAppAlert.showLoading(context: context);
      }, request: () async {
        FirebaseAuth.instance.signOut();
        await VChatController.I.profileApi.logout();
        AppAuth.setProfileNull();
        await VAppPref.clear();
      }, onSuccess: (response) {
        AppAuth.setProfileNull();
        AppNavigation.toPage(context, const SplashView(),
            isRemoveAll: true, withAnimation: false);
      }, onError: (exception, trace) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });
    }
  }

  Future<void> onThemeChange(BuildContext context) async {
    final newTheme = !value.data.isDarkMode;
    value.data = value.data.copyWith(isDarkMode: newTheme);
    //update the flutter cupertino theme
    CupertinoTheme.of(navigatorKey.currentState!.context)
        .copyWith(brightness: newTheme ? Brightness.dark : Brightness.light);
    VThemeListener.I
        .setTheme(newTheme == false ? ThemeMode.light : ThemeMode.dark);
    notifyListeners();
  }

  FutureOr<void> onLanguageChange(BuildContext context) async {
    final res = await showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SheetForChooseLanguage(),
    ) as ModelSheetItem?;
    if (res == null) {
      return;
    }
    value.data = value.data.copyWith(language: res.title);
    await VLanguageListener.I.setLocal(Locale(res.id.toString()));
    await VAppPref.setStringKey(
      SStorageKeys.appLanguageTitle.name,
      res.title,
    );
    notifyListeners();
  }

  FutureOr<void> checkForUpdates(BuildContext context) async {
    await versionCheckerController.checkForUpdates(context, true);
  }

  FutureOr<void> onChangeAppNotifications(BuildContext context) async {
    final options = <ModelSheetItem>[
      ModelSheetItem<bool>(
        title: S.of(context).on,
        id: true,
      ),
      ModelSheetItem<bool>(
        title: S.of(context).off,
        id: false,
      ),
    ];
    final res = await VAppAlert.showModalSheetWithActions(
      content: options,
      context: navigatorKey.currentState!.context,
    ) as ModelSheetItem<bool>?;
    if (res == null) return;
    value.data = value.data.copyWith(inAppAlerts: res.id);
    notifyListeners();
    await VAppPref.setBool(
      SStorageKeys.inAppAlerts.name,
      res.id,
    );
    final pushService =
        await VChatController.I.vChatConfig.currentPushProviderService;
    if (pushService == null) return null;

    if (res.id) {
      ///enable
      final token = await pushService.getToken(
        VPlatforms.isWeb ? SConstants.webVapidKey : null,
      );
      if (token == null) return;
      await VChatController.I.nativeApi.remote.profile
          .addPushKey(fcm: token, voipKey: null);
    } else {
      await pushService.deleteToken();
      await VChatController.I.nativeApi.remote.profile.deleteFcm();
    }
  }

  FutureOr<void> onStorageClick(BuildContext context) async {
    if (VPlatforms.isMobile) {
      context.toPage(const MediaStorageSettings());
      return;
    }
    VAppAlert.showOkAlertDialog(
      context: context,
      title: S.of(context).dataPrivacy,
      content: S
          .of(context)
          .allDataHasBeenBackupYouDontNeedToManageSaveTheDataByYourself,
    );
  }

  FutureOr<void> tellAFriend(BuildContext context) async {
    await SharePlus.instance.share(ShareParams(text: '''
    
    Install ${SConstants.appName}
    
    ANDROID
    ${appConfig.googlePayUrl}
    
    IOS
    ${appConfig.appleStoreUrl}
    
    WEB
    ${appConfig.webChatUrl}
    
    '''));
  }
}
