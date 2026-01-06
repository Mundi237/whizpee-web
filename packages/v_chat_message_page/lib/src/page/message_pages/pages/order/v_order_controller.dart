// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_input_ui/v_chat_input_ui.dart';
import 'package:v_chat_message_page/src/core/core.dart';
import 'package:v_chat_message_page/src/page/message_pages/controllers/v_base_message_controller.dart';
import 'package:v_chat_message_page/src/page/message_pages/pages/order/order_app_bar_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VOrderController extends VBaseMessageController {
  final OrderAppBarController orderAppBarController;
  final VMessageLocalization language;

  VOrderController({
    required super.vRoom,
    required super.vMessageConfig,
    required super.messageProvider,
    required super.scrollController,
    required super.inputStateController,
    required super.itemController,
    required this.orderAppBarController,
    required this.language,
  });

  @override
  void close() {
    orderAppBarController.close();
    super.close();
  }

  @override
  void onOpenSearch() {
    orderAppBarController.onOpenSearch();
    super.onOpenSearch();
  }

  @override
  void onCloseSearch() {
    orderAppBarController.onCloseSearch();
    super.onCloseSearch();
  }

  @override
  void onTitlePress(BuildContext context) {
    final toSingleSettings =
        VChatController.I.vNavigator.messageNavigator.toSingleSettings;
    if (toSingleSettings == null) return;
    toSingleSettings(
      context,
      VToChatSettingsModel(
        title: vRoom.realTitle,
        image: vRoom.thumbImage,
        roomId: roomId,
        room: vRoom,
      ),
      vRoom.peerId!,
    );
  }

  void onCreateCall(bool isVideo) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: language.makeCall,
      content: isVideo
          ? language.areYouWantToMakeVideoCall
          : language.areYouWantToMakeVoiceCall,
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
          id: vRoom.peerId!,
        ),
      ),

    );
  }

  Future onUpdateBlock(bool isBlocked) async {
    vSafeApiCall(
      request: () async {
        if (isBlocked) {
          return VChatController.I.blockApi.blockUser(peerId: vRoom.peerId!);
        } else {
          return VChatController.I.blockApi.unBlockUser(peerId: vRoom.peerId!);
        }
      },
      onSuccess: (response) {},
    );
  }

  @override
  Future<List<MentionModel>> onMentionRequireSearch(
      BuildContext context, String query) {
    return Future(() => []);
  }
}
