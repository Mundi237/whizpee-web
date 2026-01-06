// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up/app/core/app_config/app_config_controller.dart';
import 'package:super_up/app/core/app_nav/app_navigation.dart';
import 'package:super_up/app/modules/chat_settings/broadcast_room_settings/views/broadcast_room_settings_view.dart';
import 'package:super_up/app/modules/chat_settings/group_room_settings/views/group_room_settings_view.dart';
import 'package:super_up/app/modules/chat_settings/single_room_settings/views/single_room_settings_view.dart';
import 'package:super_up/app/modules/peer_profile/views/peer_profile_view.dart';
import 'package:super_up/app/modules/report/views/report_page.dart';
import 'package:super_up/v_chat_v2/translations.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_firebase_fcm/v_chat_firebase_fcm.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';

// import 'package:v_chat_one_signal/v_chat_one_signal.dart';
// import 'package:v_chat_one_signal/v_chat_one_signal.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

Future initVChat(GlobalKey<NavigatorState> navigatorKey) async {
  await VChatController.init(
    navigatorKey: navigatorKey,
    vChatConfig: VChatConfig(
      ///don't update
      baseUrl: SConstants.sApiBaseUrl,
      vPush: VPush(
        enableVForegroundNotification: true,
        vPushConfig: const VLocalNotificationPushConfig(),

        ///if you support fcm push notifications
        fcmProvider: VChatFcmProver(),

        ///if you support OneSignal push notifications
        // oneSignalProvider: VChatOneSignalProver(
        //   appId: SConstants.oneSignalAppId,
        // ),
      ),
      ///don't update
      onReportUserPress: (context, id) {
        context.toPage(ReportPage(userId: id));
      },
    ),
    ///don't update
    vNavigator: VNavigator(
      roomNavigator: vDefaultRoomNavigator,
      callNavigator: vDefaultCallNavigator,
      messageNavigator: VMessageNavigator(
        //this happens when user click on image in message page
        toImageViewer: (context, source, showDownload) {
          AppNavigation.toPage(
            context,
            VImageViewer(
              showDownload: showDownload,
              platformFileSource: source,
              downloadingLabel: S.of(context).downloading,
              successfullyDownloadedInLabel:
                  S.of(context).successfullyDownloadedIn,
            ),
            appNavigationType: AppNavigationType.popUpAlert,
          );
        },
        //this happens when user click on video in message page
        toVideoPlayer: (context, source, showDownload) {
          SStorageKeys.vAccessToken;
          AppNavigation.toPage(
            context,
            VVideoPlayer(
              showDownload: showDownload,
              platformFileSource: source,
              downloadingLabel: S.of(context).downloading,
              successfullyDownloadedInLabel:
                  S.of(context).successfullyDownloadedIn,
            ),
            appNavigationType: AppNavigationType.popUpAlert,
          );
        },

        //when user click on notification or lunch the app from notification this function will call to open the message page
        toMessagePage: (context, vRoom) {
          final config = VAppConfigController.appConfig;
          final messageConfig = VMessageConfig(
            googleMapsApiKey: SConstants.googleMapsApiKey,
            isCallsAllowed: VPlatforms.isMobile ? config.allowCall : false,
            isSendMediaAllowed: config.allowSendMedia,
            isEnableAds: config.enableAds,
            onMessageAttachmentIconPress: null,
            onUserUnBlockAnother: null,
            showDisconnectedWidget: true,
            onMessageLongPress: null,
            onMessageReactionSelected: (m, emoji) {
              final ctx = navigatorKey.currentContext;
              if (ctx != null) {
                final text = 'Reaction $emoji selected';
                ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content: Text(text)),
                );
              }
            },
            onUserBlockAnother: null,
            maxMediaSize: 1024 * 1024 * config.maxChatMediaSize,
            compressImageQuality: 55,
            maxRecordTime: const Duration(minutes: 30),
          );
          final msgPage = VMessagePage(
            vRoom: vRoom,
            localization: vMessageLocalizationPageModel(context),
            vMessageConfig: messageConfig,
          );
          return AppNavigation.toPage(
            context,
            msgPage,
            appNavigationType: AppNavigationType.messages,
            isRemoveAllWide: true,
          );
        },
        //this happens when user click on see message information to know when the message send or delivered or seen at for `direct` chat
        toSingleChatMessageInfo: (context, baseMessage) {
          AppNavigation.toPage(
            context,
            VMessageSingleStatusPage(
              message: baseMessage,
              deliveredLabel: S.of(context).delivered,
              readLabel: S.of(context).read,
              vMessageLocalization: VMessageLocalization.fromEnglish(),
            ),
            appNavigationType: AppNavigationType.messages,
          );
        },
        //this happens when user click on see message information to know when the message send or delivered or seen at for `broadcast` chat
        toBroadcastChatMessageInfo: (context, baseMessage) {
          AppNavigation.toPage(
            context,
            VMessageBroadcastStatusPage(
              message: baseMessage,
              deliveredLabel: S.of(context).delivered,
              readLabel: S.of(context).read,
              messageInfoLabel: S.of(context).messageInfo,
              vMessageLocalization: VMessageLocalization.fromEnglish(),
            ),
            appNavigationType: AppNavigationType.messages,
          );
        },
        //this happens when user click on see message information to know when the message send or delivered or seen at for `group` chat
        toGroupChatMessageInfo: (context, baseMessage) {
          AppNavigation.toPage(
            context,
            VMessageGroupStatusPage(
              message: baseMessage,
              deliveredLabel: S.of(context).delivered,
              readLabel: S.of(context).read,
              messageInfoLabel: S.of(context).messageInfo,
              vMessageLocalization: VMessageLocalization.fromEnglish(),
            ),
            appNavigationType: AppNavigationType.messages,
          );
        },
        //when user click on group title or icon to open group information to know more about this group like group members and more data
        toGroupSettings: (context, data) async {
          return await AppNavigation.toPage(
            context,
            GroupRoomSettingsView(settingsModel: data),
            appNavigationType: AppNavigationType.chatInfo,
            isRemoveAllWide: true,
          );
        },
        //when user click on peer user in direct chat title or icon to open peer chat user page you should handle this out of v chat scope
        toSingleSettings: (context, data, identifier) async {
          return await AppNavigation.toPage(
            context,
            SingleRoomSettingsView(settingsModel: data),
            appNavigationType: AppNavigationType.chatInfo,
            isRemoveAllWide: true,
          );
        },
        //when user click `broadcast` chat title or icon to open broadcast chat page you should handle this out of v chat scope
        toBroadcastSettings: (context, data) async {
          return await AppNavigation.toPage(
            context,
            BroadcastRoomSettingsView(settingsModel: data),
            appNavigationType: AppNavigationType.chatInfo,
            isRemoveAllWide: true,
          );
        },
        //when user click on group mention so need to open peer profile you should handle this out of v chat scope
        toUserProfilePage: (context, identifier) {
          return AppNavigation.toPage(
            context,
            PeerProfileView(peerId: identifier),
            appNavigationType: AppNavigationType.chatRoom,
          );
        },
      ),
    ),
  );
}
