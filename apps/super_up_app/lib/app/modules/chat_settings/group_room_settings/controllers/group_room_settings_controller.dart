// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up/app/modules/chat_settings/chat_star_messages/views/chat_star_messages_page.dart';
import 'package:super_up/app/modules/chat_settings/group_room_settings/mobile/sheet_for_add_members_to_group.dart';
import 'package:super_up/app/modules/group_members/views/group_members_view.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../chat_media_docs_voice/views/chat_media_view.dart';
import '../states/group_room_setting_state.dart';

class GroupRoomSettingsController
    extends SLoadingController<GroupRoomSettingState> {
  final txtController = TextEditingController();
  final sizer = GetIt.I.get<AppSizeHelper>();
  final VToChatSettingsModel _settingsModel;

  GroupRoomSettingsController(this._settingsModel)
      : super(SLoadingState(GroupRoomSettingState(_settingsModel)));

  VToChatSettingsModel get settingsModel => value.data.settingsModel;

  VMyGroupInfo? get groupInfo => value.data.groupInfo;

  bool get isMeAdminOrSuper {
    if (value.data.groupInfo!.myRole == VGroupMemberRole.member) return false;
    return true;
  }

  String? get getGroupDesc {
    if (value.data.groupInfo!.groupSettings == null) return null;
    return value.data.groupInfo!.groupSettings!.desc;
  }

  String get roomId => value.data.settingsModel.roomId;

  @override
  void onInit() {
    getData();
  }

  Future<void> getData() async {
    await vSafeApiCall<VMyGroupInfo>(
      onLoading: () async {
        setStateLoading();
      },
      onError: (exception) {
        setStateError(exception.message);
      },
      request: () async {
        return VChatController.I.roomApi.getGroupVMyGroupInfo(roomId: roomId);
      },
      onSuccess: (response) {
        value.data.groupInfo = response;
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
  void onClose() {
    txtController.dispose();
  }

  void addParticipantsToGroup(BuildContext context) async {
    final users = await showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SheetForAddMembersToGroup(
        groupId: roomId,
      ),
    ) as List<SBaseUser>?;

    if (users != null) {
      await _addGroupMembers(context, users.map((e) => e.id).toList());
      await getData();
    }
  }

  void onChangeGroupDescriptionClicked(BuildContext context) async {
    final newTitle = await context.toPage(VSingleRename(
      appbarTitle: S.of(context).updateGroupDescription,
      oldValue: groupInfo!.groupSettings!.desc,
      subTitle: S.of(context).updateGroupDescriptionWillUpdateAllGroupMembers,
    )) as String?;
    if (newTitle == null || newTitle.toString().isEmpty) return;
    if (newTitle != settingsModel.title) {
      await vSafeApiCall<String>(
        request: () async {
          await VChatController.I.roomApi
              .updateGroupDescription(roomId: roomId, description: newTitle);
          return newTitle;
        },
        onSuccess: (response) {
          value.data.groupInfo = groupInfo!.copyWith(
            groupSettings: groupInfo!.groupSettings!.copyWith(desc: newTitle),
          );
          update();
        },
      );
    }
  }

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

  void onGoShowMembers(BuildContext context) {
    context.toPage(GroupMembersView(
      roomId: roomId,
      myGroupInfo: groupInfo!,
      settingsModel: settingsModel,
    ));
  }

  Future _addGroupMembers(BuildContext context, List<String> list) async {
    await vSafeApiCall<void>(
      // onLoading: () {
      //   VAppAlert.showLoading(context: context, isDismissible: true);
      // },
      request: () async {
        await VChatController.I.roomApi.addParticipantsToGroup(roomId, list);
      },
      onSuccess: (response) {
        //Navigator.of(context).pop();
        VAppAlert.showSuccessSnackBar(
          context: context,
          message: S.of(context).usersAddedSuccessfully,
        );
      },
      onError: (exception) {
        VAppAlert.showErrorSnackBar(
          context: context,
          message: exception.toString(),
        );
      },
    );
  }

  void openFullImage(BuildContext context) {
    context.toPage(
      VImageViewer(
        showDownload: true,
        platformFileSource: VPlatformFile.fromUrl(
          networkUrl: settingsModel.image,
        ),
        downloadingLabel: S.of(context).downloading,
        successfullyDownloadedInLabel: S.of(context).successfullyDownloadedIn,
      ),
    );
  }

  void openStarredMessages(BuildContext context) {
    context.toPage(ChatStarMessagesPage(roomId: roomId));
  }

  void openChatMedia(BuildContext context) {
    context.toPage(ChatMediaView(roomId: roomId));
  }

  void openSearch(BuildContext context) {
    if (!sizer.isWide(context)) {
      context.pop("search");
    } else {
      chatInfoSearchStream.sink.add(true);
    }
  }

  Future openEditTitle(BuildContext context) async {
    final newTitle = await context.toPage(VSingleRename(
      appbarTitle: S.of(context).updateGroupTitle,
      oldValue: settingsModel.title,
      subTitle: '',
    )) as String?;
    if (newTitle == null || newTitle.toString().isEmpty) return;
    if (newTitle != settingsModel.title) {
      await vSafeApiCall<String>(
        request: () async {
          await VChatController.I.nativeApi.local.room.updateRoomName(
              VUpdateRoomNameEvent(roomId: roomId, name: newTitle));
          await VChatController.I.roomApi
              .updateGroupTitle(roomId: roomId, title: newTitle);
          return newTitle;
        },
        onSuccess: (response) {
          value.data.settingsModel.title = response;
          update();
          VAppAlert.showSuccessSnackBar(
              message: S.of(context).success, context: context);
        },
      );
    }
  }

  Future openEditImage(BuildContext context) async {
    final image = await VAppPick.getCroppedImage(context: context);
    if (image == null) return;
    await vSafeApiCall<String>(
      request: () async {
        final url = await VChatController.I.roomApi.updateGroupImage(
          roomId: roomId,
          file: image,
        );
        await VChatController.I.nativeApi.local.room
            .updateRoomImage(VUpdateRoomImageEvent(roomId: roomId, image: url));
        return url;
      },
      onSuccess: (response) {
        value.data.settingsModel.image = response;

        VAppAlert.showSuccessSnackBar(
            message: S.of(context).success, context: context);
        update();
      },
      onError: (exception) {
        VAppAlert.showErrorSnackBar(
            message: S.of(context).error, context: context);
      },
    );
  }

  Future<void> leaveGroup(BuildContext context) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).areYouSureToLeaveThisGroupThisActionCantUndo,
      content: S.of(context).leaveGroupAndDeleteYourMessageCopy,
    );
    if (res != 1) return;
    await vSafeApiCall(
      onLoading: () {
        value.data.isUpdatingExitGroup = true;
        update();
      },
      request: () async {
        return await VChatController.I.nativeApi.remote.room.leaveGroup(roomId);
      },
      onSuccess: (response) async {
        context.pop();
        context.pop();
      },
    );

    value.data.isUpdatingExitGroup = false;
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
}
