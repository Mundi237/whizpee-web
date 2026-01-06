// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';

import 'settings_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final controller = SettingsController();
  final sizer = GetIt.I.get<AppSizeHelper>();

  @override
  void initState() {
    controller.onInit();
    super.initState();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: sizer.isWide(context)
          ? AppBar(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.settings,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  S.of(context).settings.h5,
                ],
              ),
              centerTitle: true,
            )
          : null,
      body: ValueListenableBuilder(
        valueListenable: controller,
        builder: (_, value, ___) {
          final loadingState = controller.loadingState;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topCenter,
                constraints: sizer.isWide(context)
                    ? BoxConstraints(maxWidth: context.width * .6)
                    : null,
                child: Card(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: loadingState == VChatLoadingState.loading,
                            child: const LinearProgressIndicator(),
                          ),
                          CheckboxListTile(
                            value: value.data.allowCall,
                            onChanged: (value) {
                              controller.updateAllowCall(value ?? false);
                            },
                            title: Text(S.of(context).allowCalls),
                            subtitle: Text(
                              S
                                  .of(context)
                                  .ifThisOptionEnabledTheVideoAndVoiceCallWillBeAllowed,
                            ),
                          ),
                          const Divider(
                            height: 10,
                          ),
                          CheckboxListTile(
                            value: value.data.enableAds,
                            onChanged: (value) {
                              controller.updateAllowAds(value ?? false);
                            },
                            title: Text(S.of(context).allowAds),
                            subtitle: Text(
                              S
                                  .of(context)
                                  .ifThisOptionEnabledTheGoogleAdsBannerWillAppearInChats,
                            ),
                          ),
                          const Divider(
                            height: 10,
                          ),
                          CheckboxListTile(
                            value: value.data.allowMobileLogin,
                            onChanged: (value) {
                              controller.updateAllowMobileLogin(value ?? false);
                            },
                            title: Text(S.of(context).allowMobileLogin),
                            subtitle: Text(
                              S
                                  .of(context)
                                  .ifThisOptionDisabledTheMobileLoginOrRegisterWillBeBlockedOnAndroidIosOnly,
                            ),
                          ),
                          const Divider(
                            height: 10,
                          ),
                          CheckboxListTile(
                            value: value.data.allowWebLogin,
                            onChanged: (value) {
                              controller.updateAllowWebLogin(value ?? false);
                            },
                            title: Text(S.of(context).allowWebLogin),
                            subtitle: Text(
                              S
                                  .of(context)
                                  .ifThisOptionDisabledTheWebLoginOrRegisterWillBeBlocked,
                            ),
                          ),
                          const Divider(
                            height: 10,
                          ),
                          CheckboxListTile(
                            value: value.data.allowDesktopLogin,
                            onChanged: (value) {
                              controller
                                  .updateAllowDesktopLogin(value ?? false);
                            },
                            title: Text(S.of(context).allowDesktopLogin),
                            subtitle: Text(
                              S
                                  .of(context)
                                  .ifThisOptionDisabledTheDesktopLoginOrRegisterWindowsMacWillBeBlocked,
                            ),
                          ),
                          const Divider(
                            height: 10,
                          ),
                          CheckboxListTile(
                            value: value.data.allowCreateGroup,
                            onChanged: (value) {
                              controller.updateAllowCreateGroup(value ?? false);
                            },
                            title: Text(S.of(context).allowCreateGroups),
                            subtitle: Text(
                              S
                                  .of(context)
                                  .ifThisOptionDisabledTheCreateChatGroupsWillBeBlocked,
                            ),
                          ),
                          const Divider(
                            height: 10,
                          ),
                          CheckboxListTile(
                            value: value.data.allowCreateBroadcast,
                            onChanged: (value) {
                              controller
                                  .updateAllowCreateBroadcast(value ?? false);
                            },
                            title: Text(S.of(context).allowCreateBroadcast),
                            subtitle: Text(
                              S
                                  .of(context)
                                  .ifThisOptionDisabledTheCreateChatBroadcastWillBeBlocked,
                            ),
                          ),
                          const Divider(
                            height: 10,
                          ),
                          CheckboxListTile(
                            value: value.data.allowSendMedia,
                            onChanged: (value) {
                              controller.updateAllowSendMedia(value ?? false);
                            },
                            title: Text(S.of(context).allowSendMedia),
                            subtitle: Text(
                              S
                                  .of(context)
                                  .ifThisOptionDisabledTheSendChatFilesImageVideosAndLocationWillBeBlocked,
                            ),
                          ),
                          const Divider(
                            height: 10,
                          ),
                          ListTile(
                            title: S.of(context).feedBackEmail.text,
                            subtitle: value.data.feedbackEmail.text,
                            onTap: controller.onUpdateFeedbackEmail,
                          ),
                          const Divider(
                            height: 10,
                          ),
                          ListTile(
                            title: S.of(context).name.text,
                            subtitle: value.data.appName.text,
                            onTap: controller.onUpdateAppName,
                          ),
                          const Divider(
                            height: 10,
                          ),
                          ListTile(
                            title: S.of(context).privacyUrl.text,
                            subtitle: value.data.privacyUrl.text,
                            onTap: controller.onUpdatePrivacyUrl,
                          ),
                          const Divider(
                            height: 10,
                          ),
                          ListTile(
                            title: S.of(context).storeUrls.text,
                            subtitle: "Apple,Google,Microsoft".text,
                            onTap: controller.onUpdateStoreUrls,
                          ),
                          const Divider(
                            height: 10,
                          ),
                          ListTile(
                            title:
                                S.of(context).setMaxMessageForwardAndShare.text,
                            subtitle:
                                "${value.data.maxForward} ${S.of(context).messages}"
                                    .toString()
                                    .text,
                            onTap: controller.onUpdateMaxMessageForward,
                          ),
                          ListTile(
                            title: S.of(context).userRegisterStatus.text,
                            subtitle:
                                value.data.userRegisterStatus.toString().text,
                            onTap: controller.onUpdateUserRegisterStatus,
                          ),
                          const Divider(
                            height: 10,
                          ),
                          ListTile(
                            title: S.of(context).forgetPasswordExpireTime.text,
                            subtitle:
                                "${value.data.maxExpireEmailTime} ${S.of(context).minutes}"
                                    .toString()
                                    .text,
                            onTap: controller.onUpdateMaxExpireEmailTime,
                          ),
                          const Divider(
                            height: 10,
                          ),
                          ListTile(
                            title: S.of(context).callTimeoutInSeconds.text,
                            subtitle:
                                "${value.data.callTimeout ~/ 1000} ${S.of(context).seconds}"
                                    .toString()
                                    .text,
                            onTap: controller.onUpdateCallTimeout,
                          ),
                          const Divider(
                            height: 10,
                          ),
                          ListTile(
                            title: S.of(context).setMaxGroupMembers.text,
                            subtitle:
                                "${value.data.maxGroupMembers} ${S.of(context).members}"
                                    .toString()
                                    .text,
                            onTap: controller.onUpdateMaxGroupMembers,
                          ),
                          const Divider(
                            height: 10,
                          ),
                          ListTile(
                            title: S.of(context).setMaxBroadcastMembers.text,
                            subtitle:
                                "${value.data.maxBroadcastMembers} ${S.of(context).members}"
                                    .toString()
                                    .text,
                            onTap: controller.onUpdateMaxBroadcastMembers,
                          ),
                          const SizedBox(
                            height: 40,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
