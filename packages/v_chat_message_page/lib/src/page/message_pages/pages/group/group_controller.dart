// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_input_ui/v_chat_input_ui.dart';
import 'package:v_chat_message_page/src/core/stream_mixin.dart';
import 'package:v_chat_message_page/src/page/message_pages/controllers/v_base_message_controller.dart';
import 'package:v_chat_message_page/src/page/message_pages/pages/group/group_app_bar_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VGroupController extends VBaseMessageController with StreamMix {
  final GroupAppBarController groupAppBarController;
  final String _cacheKey = "group-info-";
  StreamSubscription? _subscription;

  VGroupController({
    required super.vRoom,
    required super.vMessageConfig,
    required super.messageProvider,
    required super.scrollController,
    required super.inputStateController,
    required super.itemController,
    required this.groupAppBarController,
  }) {
    _initStreams();
    _getFromCache();
    _updateMyInfoRemote();
    _subscription = chatInfoSearchStream.stream.listen((event) {
      onOpenSearch();
    });
  }

  @override
  void close() {
    groupAppBarController.close();
    _subscription?.cancel();
    closeStreamMix();
    super.close();
  }

  @override
  void onOpenSearch() {
    groupAppBarController.onOpenSearch();
    super.onOpenSearch();
  }

  Future<void> _getFromCache() async {
    final res = VAppPref.getMap("$_cacheKey${vRoom.id}");
    if (res == null) return;
    final info = VMyGroupInfo.fromMap(res);
    _updateInputState(info);
    groupAppBarController.updateValue(info);
  }

  Future<void> _updateMyInfoRemote() async {
    await vSafeApiCall<VMyGroupInfo>(
      request: () {
        return VChatController.I.roomApi.getGroupVMyGroupInfo(roomId: vRoom.id);
      },
      onSuccess: (response) async {
        groupAppBarController.updateValue(response);
        _updateInputState(response);
        await VAppPref.setMap("$_cacheKey${vRoom.id}", response.toMap());
      },
    );
  }

  void onCreateCall(BuildContext context, bool isVideo) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).makeCall,
      content: isVideo
          ? S.of(context).areYouWantToMakeVideoCall
          : S.of(context).areYouWantToMakeVoiceCall,
    );
    if (res != 1) return;

    VChatController.I.vNavigator.callNavigator.toCall(
      context,
      VCallDto(
        isVideoEnable: isVideo,
        roomId: vRoom.id,
        isCaller: true,
        peerUser: SBaseUser(
          userImage: vRoom.thumbImage,
          fullName: vRoom.realTitle,
          id: vRoom.id,
        ),
      ),

    );
  }

  void _updateInputState(VMyGroupInfo info) {
    if (info.isMeOut) {
      inputStateController.closeChat();
    } else {
      inputStateController.openChat();
    }
  }

  @override
  void onCloseSearch() {
    groupAppBarController.onCloseSearch();
    super.onCloseSearch();
  }

  @override
  void onTitlePress(BuildContext context) async {
    final toGroupSettings =
        VChatController.I.vNavigator.messageNavigator.toGroupSettings;
    if (toGroupSettings == null) return;
    final x = await toGroupSettings(
      context,
      VToChatSettingsModel(
        title: vRoom.realTitle,
        image: vRoom.thumbImage,
        roomId: roomId,
        room: vRoom,
      ),
    );
    if (x == "search") onOpenSearch();
  }

  @override
  Future<List<MentionModel>> onMentionRequireSearch(
    BuildContext context,
    String query,
  ) async {
    final data = await VChatController.I.nativeApi.remote.room
        .searchToMention(roomId, filter: VBaseFilter(fullName: query));
    return data.map((e) => MentionModel.fromMap(e.toMap())).toList();
  }

  void _initStreams() {
    streamsMix.add(
      VEventBusSingleton.vEventBus
          .on<VOnGroupKicked>()
          .where((e) => e.roomId == vRoom.id)
          .listen(_onGroupKick),
    );
  }

  void _onGroupKick(VOnGroupKicked event) {
    inputStateController.closeChat();
  }
}
