// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up/app/core/api_service/api_service.dart';
import 'package:super_up/app/modules/chat_settings/chat_star_messages/views/chat_star_messages_page.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../core/app_config/app_config_controller.dart';
import '../../../peer_profile/states/peer_profile_state.dart';
import '../../../report/views/report_page.dart';
import '../../chat_media_docs_voice/views/chat_media_view.dart';
import '../states/single_room_setting_state.dart';

class SingleRoomSettingsController
    extends SLoadingController<SingleRoomSettingState> {
  final VToChatSettingsModel _settingsModel;
  final sizer = GetIt.I.get<AppSizeHelper>();

  SingleRoomSettingsController(this._settingsModel)
      : super(SLoadingState(SingleRoomSettingState(_settingsModel)));
  final _profileApiService = GetIt.I.get<ProfileApiService>();

  String get roomId => _settingsModel.roomId;

  bool get isCallAllowed =>
      VPlatforms.isMobile ? VAppConfigController.appConfig.allowCall : false;

  @override
  void onInit() {
    getData();
    AdsBannerWidget.loadAd(
      VPlatforms.isAndroid
          ? SConstants.androidInterstitialId
          : SConstants.iosInterstitialId,
      enableAds: VAppConfigController.appConfig.enableAds,
    );
  }

  void muteRoomNotification() async {
    await vSafeApiCall<void>(
      onLoading: () {
        value.data.isUpdatingMute = true;
        update();
      },
      request: () async {
        await VChatController.I.nativeApi.remote.room.muteRoomNotification(
          roomId: roomId,
        );
        await VChatController.I.nativeApi.local.room.updateRoomIsMuted(
          VUpdateRoomMuteEvent(
            roomId: roomId,
            isMuted: true,
          ),
        );
      },
      onSuccess: (response) {
        value.data.settingsModel.room.isMuted = true;
        update();
      },
    );
    value.data.isUpdatingMute = false;
    update();
  }

  void updateOneTimeSeen(BuildContext context) {
    if (value.data.settingsModel.room.isOneSeen) {
      oneSeenOff();
    } else {
      oneSeenOne();
    }
  }

  void oneSeenOne() async {
    await vSafeApiCall<void>(
      onLoading: () {
        value.data.isUpdatingOneSeen = true;
        update();
      },
      request: () async {
        await VChatController.I.nativeApi.remote.room.oneSeenOn(
          roomId: roomId,
        );
        await VChatController.I.nativeApi.local.room.updateRoomOneSeen(
          VUpdateRoomOneSeenEvent(
            roomId: roomId,
            isEnable: true,
          ),
        );
      },
      onSuccess: (response) {
        value.data.settingsModel.room.isOneSeen = true;
        update();
      },
    );
    value.data.isUpdatingOneSeen = false;
    update();
  }

  void oneSeenOff() async {
    await vSafeApiCall<void>(
      onLoading: () {
        value.data.isUpdatingOneSeen = true;
        update();
      },
      request: () async {
        await VChatController.I.nativeApi.remote.room.oneSeenOff(
          roomId: roomId,
        );
        await VChatController.I.nativeApi.local.room.updateRoomOneSeen(
          VUpdateRoomOneSeenEvent(
            roomId: roomId,
            isEnable: false,
          ),
        );
      },
      onSuccess: (response) {
        value.data.settingsModel.room.isOneSeen = false;
        update();
      },
    );
    value.data.isUpdatingOneSeen = false;
    update();
  }

  void unMuteRoomNotification() async {
    await vSafeApiCall<void>(
      onLoading: () {
        value.data.isUpdatingMute = true;
        update();
      },
      request: () async {
        await VChatController.I.nativeApi.remote.room.unMuteRoomNotification(
          roomId: roomId,
        );
        await VChatController.I.nativeApi.local.room.updateRoomIsMuted(
          VUpdateRoomMuteEvent(
            roomId: roomId,
            isMuted: false,
          ),
        );
      },
      onSuccess: (response) {
        value.data.settingsModel.room.isMuted = false;
        update();
      },
    );
    value.data.isUpdatingMute = false;
    update();
  }

  Future<void> getData() async {
    await vSafeApiCall<PeerProfileModel>(
      request: () async {
        return _profileApiService.peerProfile(_settingsModel.room.peerId!);
      },
      onSuccess: (response) {
        value.data.user = response;
        setStateSuccess();
        notifyListeners();
      },
      config: const VApiConfig(
        ignoreTimeoutErrors: false,
        ignoreNetworkErrors: false,
      ),
    );
  }

  @override
  void onClose() {}

  void openFullImage(BuildContext context) {
    context.toPage(VImageViewer(
      showDownload: true,
      platformFileSource:
          VPlatformFile.fromUrl(networkUrl: value.data.settingsModel.image),
      downloadingLabel: S.of(context).downloading,
      successfullyDownloadedInLabel: S.of(context).done,
    ));
  }

  void starMessage(BuildContext context) {
    context.toPage(ChatStarMessagesPage(roomId: roomId));
  }

  void onShowMedia(BuildContext context) {
    context.toPage(ChatMediaView(roomId: roomId));
  }

  Future onBlockUser(BuildContext context) async {
    if (value.data.user!.isMeBanner) {
      return await _onUnBlock(context);
    }
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).blockUser,
      content:
          "${S.of(context).areYouSureToBlock} ${value.data.settingsModel.title}",
    );
    if (res == 1) {
      await vSafeApiCall(
        onLoading: () {
          value.data.isUpdatingBlock = true;
          update();
        },
        request: () async {
          await VChatController.I.blockApi.blockUser(
            peerId: _settingsModel.room.peerId!,
          );
        },
        onSuccess: (response) {
          getData();
        },
      );
      value.data.isUpdatingBlock = false;
      update();
    }
  }

  void onReportUser(BuildContext context) async {
    context.toPage(ReportPage(userId: _settingsModel.room.peerId!));
  }

  void openSearch(BuildContext context) {
    if (!sizer.isWide(context)) {
      context.pop("search");
    } else {
      chatInfoSearchStream.sink.add(false);
    }
  }

  void clearChat(BuildContext context) async {}

  void toUpdateNickName(BuildContext context) async {
    final text = await context.toPage(VSingleRename(
      appbarTitle: S.of(context).updateNickname,
      oldValue: value.data.settingsModel.room.nickName ?? "",
      subTitle: "",
    )) as String?;

    if (text != null) {
      await VChatController.I.nativeApi.remote.room
          .updateRoomNickName(roomId, text);
      await VChatController.I.nativeApi.local.room.updateNickName(
        VUpdateLocalRoomNickNameEvent(
          name: text,
          roomId: roomId,
        ),
      );
      value.data.settingsModel.room.nickName = text;
      update();
    }
  }

  void updateMute(BuildContext context) {
    if (value.data.settingsModel.room.isMuted) {
      unMuteRoomNotification();
    } else {
      muteRoomNotification();
    }
  }

  void voiceCall(BuildContext context) async {
    await VChatController.I.vNavigator.callNavigator.toCall(
      context,
      VCallDto(
        isVideoEnable: false,
        isCaller: true,
        roomId: roomId,
        peerUser: SBaseUser(
          userImage: _settingsModel.room.thumbImage,
          fullName: _settingsModel.room.realTitle,
          id: _settingsModel.room.peerId!,
        ),
      ),

    );
  }

  void videoCall(BuildContext context) async {
    await VChatController.I.vNavigator.callNavigator.toCall(
      context,
      VCallDto(
        isVideoEnable: true,
        isCaller: true,
        roomId: roomId,
        peerUser: SBaseUser(
          userImage: _settingsModel.room.thumbImage,
          fullName: _settingsModel.room.realTitle,
          id: _settingsModel.room.peerId!,
        ),
      ),

    );
  }

  Future _onUnBlock(BuildContext context) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).unBlockUser,
      content:
          "${S.of(context).areYouSureToUnBlock} ${value.data.settingsModel.title}",
    );
    if (res == 1) {
      await vSafeApiCall(
        onLoading: () {
          value.data.isUpdatingBlock = true;
          update();
        },
        request: () async {
          await VChatController.I.blockApi.unBlockUser(
            peerId: _settingsModel.room.peerId!,
          );
        },
        onSuccess: (response) {
          getData();
        },
      );
      value.data.isUpdatingBlock = false;
      update();
    }
  }

  void updateLanguageSwitch(bool data) async {
    if (data == false) {
      value.data.settingsModel.room.transTo = null;
    } else {
      await openChooseLanguageToTrans();
    }
    update();
  }

  Future openChooseLanguageToTrans() async {}
}
