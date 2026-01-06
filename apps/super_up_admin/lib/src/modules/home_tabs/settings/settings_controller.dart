// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_admin/src/core/api_service/s_admin/s_admin_api_service.dart';
import 'package:super_up_core/super_up_core.dart';

import '../../../../main.dart';

class SettingsController extends SLoadingController<AppConfigModel> {
  SettingsController() : super(SLoadingState(AppConfigModel.init()));
  final _apiService = GetIt.I.get<SAdminApiService>();

  @override
  void onClose() {}

  @override
  void onInit() {
    getData();
  }

  BuildContext get context => navigatorKey.currentState!.context;

  void getData() async {
    vSafeApiCall<AppConfigModel>(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        return _apiService.getConfig();
      },
      onSuccess: (response) {
        value.data = response;
        setStateSuccess();
      },
      onError: (exception) {
        VAppAlert.showErrorSnackBar(
            message: exception.message, context: context);
      },
    );
  }

  void updateAllowCall(bool data) {
    value.data = value.data.copyWith(allowCall: data);
    submitForm();
  }

  void submitForm() {
    vSafeApiCall<AppConfigModel>(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        await _apiService.updateConfig(value.data.toMap());
        return _apiService.getConfig();
      },
      onSuccess: (response) {
        value.data = response;
        setStateSuccess();
      },
      onError: (exception) {
        VAppAlert.showErrorSnackBar(
            message: exception.message, context: context);
      },
    );
  }

  void onUpdateFeedbackEmail() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).updateFeedBackEmail,
      context: context,
      textFields: [
        DialogTextField(
          initialText: value.data.feedbackEmail,
          keyboardType: TextInputType.emailAddress,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(feedbackEmail: res.first);
    submitForm();
  }

  void onUpdateMaxMessageForward() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).setMaxMessageForwardAndShare,
      context: context,
      textFields: [
        DialogTextField(
          initialText: value.data.maxForward.toString(),
          keyboardType: TextInputType.number,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(maxForward: int.parse(res.first));
    submitForm();
  }

  void updateAllowMobileLogin(bool data) {
    value.data = value.data.copyWith(allowMobileLogin: data);
    submitForm();
  }

  void updateAllowWebLogin(bool data) {
    value.data = value.data.copyWith(allowWebLogin: data);
    submitForm();
  }

  void updateAllowDesktopLogin(bool data) {
    value.data = value.data.copyWith(allowDesktopLogin: data);
    submitForm();
  }

  void updateAllowCreateGroup(bool data) {
    value.data = value.data.copyWith(allowCreateGroup: data);
    submitForm();
  }

  void updateAllowCreateBroadcast(bool data) {
    value.data = value.data.copyWith(allowCreateBroadcast: data);
    submitForm();
  }

  void updateAllowSendMedia(bool data) {
    value.data = value.data.copyWith(allowSendMedia: data);
    submitForm();
  }

  void updateAllowAds(bool data) {
    value.data = value.data.copyWith(enableAds: data);
    submitForm();
  }

  void onUpdatePrivacyUrl() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).setNewPrivacyPolicyUrl,
      context: context,
      textFields: [
        DialogTextField(
          initialText: value.data.privacyUrl.toString(),
          keyboardType: TextInputType.url,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(privacyUrl: res.first);
    submitForm();
  }

  void onUpdateStoreUrls() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).appleStoreAppUrl,
      context: context,
      textFields: [
        DialogTextField(
          initialText: value.data.appleStoreUrl,
          hintText: S.of(context).appleIos,
          keyboardType: TextInputType.url,
          maxLines: 3,
          minLines: 2,
          prefixText: S.of(context).appleIos,
        ),
        DialogTextField(
          hintText: S.of(context).googleAndroid,
          initialText: value.data.googlePayUrl,
          keyboardType: TextInputType.url,
          prefixText: S.of(context).googleAndroid,
        ),
        DialogTextField(
            initialText: value.data.windowsStoreUrl,
            hintText: S.of(context).microsoftWindows,
            keyboardType: TextInputType.url,
            prefixText: S.of(context).microsoftWindows),
        DialogTextField(
            hintText: S.of(context).appleMacStoreUrl,
            initialText: value.data.macStoreUrl,
            keyboardType: TextInputType.url,
            prefixText: S.of(context).appleMacStoreUrl),
        DialogTextField(
          hintText: S.of(context).webChat,
          initialText: value.data.webChatUrl,
          keyboardType: TextInputType.url,
          prefixText: S.of(context).webChat,
        ),
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(
      appleStoreUrl: res[0],
      googlePayUrl: res[1],
      windowsStoreUrl: res[2],
      macStoreUrl: res[3],
      webChatUrl: res[4],
    );
    submitForm();
  }

  void onUpdateAppleUrl() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).appleStoreAppUrl,
      context: context,
      textFields: [
        DialogTextField(
          initialText: value.data.appleStoreUrl.toString(),
          keyboardType: TextInputType.url,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(appleStoreUrl: res.first);
    submitForm();
  }

  void onUpdateGooglePlayUrl() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).googlePlayAppUrl,
      context: context,
      textFields: [
        DialogTextField(
          initialText: value.data.googlePayUrl.toString(),
          keyboardType: TextInputType.url,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(googlePayUrl: res.first);
    submitForm();
  }

  void onUpdateMaxExpireEmailTime() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).forgetPasswordExpireTime,
      context: context,
      textFields: [
        DialogTextField(
          initialText: value.data.maxExpireEmailTime.toString(),
          keyboardType: TextInputType.number,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(maxExpireEmailTime: int.parse(res.first));
    submitForm();
  }

  void onUpdateCallTimeout() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).callTimeoutInSeconds,
      context: context,
      textFields: [
        DialogTextField(
          initialText: (value.data.callTimeout ~/ 1000).toString(),
          keyboardType: TextInputType.number,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(callTimeout: int.parse(res.first) * 1000);
    submitForm();
  }

  void onUpdateMaxGroupMembers() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).setMaxGroupMembers,
      context: context,
      textFields: [
        DialogTextField(
          initialText: (value.data.maxGroupMembers).toString(),
          keyboardType: TextInputType.number,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(maxGroupMembers: int.parse(res.first));
    submitForm();
  }

  void onUpdateMaxBroadcastMembers() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).setMaxBroadcastMembers,
      context: context,
      textFields: [
        DialogTextField(
          initialText: (value.data.maxBroadcastMembers).toString(),
          keyboardType: TextInputType.number,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(maxBroadcastMembers: int.parse(res.first));
    submitForm();
  }

  void onUpdateAppName() async {
    final res = await VAppAlert.showTextInputDialog(
      title: S.of(context).name,
      context: context,
      textFields: [
        DialogTextField(
          initialText: value.data.appName,
          keyboardType: TextInputType.text,
        )
      ],
    );
    if (res == null) return;
    value.data = value.data.copyWith(appName: res.first);
    submitForm();
  }

  void onUpdateUserRegisterStatus() {
    if (value.data.userRegisterStatus == "pending") {
      value.data = value.data.copyWith(userRegisterStatus: "accepted");
    } else {
      value.data = value.data.copyWith(userRegisterStatus: "pending");
    }
    submitForm();
  }
}
