// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_message_page/src/page/message_pages/pages/single/single_app_bar_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../../v_chat_message_page.dart';

class VSingleController extends VBaseMessageController with StreamMix {
  final SingleAppBarController singleAppBarController;
  final VMessageLocalization language;
  StreamSubscription? _subscription;

  VSingleController({
    required super.vRoom,
    required super.messageProvider,
    required super.scrollController,
    required super.inputStateController,
    required super.itemController,
    required this.singleAppBarController,
    required super.vMessageConfig,
    required this.language,
  }) {
    _initStreams();
    _getFromCache();
    _checkBanRemote();
    _subscription = chatInfoSearchStream.stream.listen((event) {
      onOpenSearch();
    });
    print(vRoom.peerPrivacy);
  }

  @override
  void close() {
    singleAppBarController.close();
    _subscription?.cancel();
    closeStreamMix();
    super.close();
  }

  @override
  void onOpenSearch() {
    singleAppBarController.onOpenSearch();
    super.onOpenSearch();
  }

  @override
  void onCloseSearch() {
    singleAppBarController.onCloseSearch();
    super.onCloseSearch();
  }

  @override
  void onTitlePress(BuildContext context) async {
    final x =
        await VChatController.I.vNavigator.messageNavigator.toSingleSettings!(
      context,
      VToChatSettingsModel(
        title: vRoom.realTitle,
        image: vRoom.thumbImage,
        roomId: roomId,
        room: vRoom,
      ),
      vRoom.peerId!,
    );
    if (x == "search") {
      onOpenSearch();
    }
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

  void _initStreams() {
    streamsMix.add(VEventBusSingleton.vEventBus
        .on<VSingleBlockEvent>()
        .where((e) => e.roomId == vRoom.id)
        .listen(_handleBlockEvent));
  }

  void _handleBlockEvent(VSingleBlockEvent event) async {
    await updateValue(event.banModel);
    if (event.banModel.isThereBan) {
      inputStateController.closeChat();
    } else {
      inputStateController.openChat();
    }
  }

  Future<void> _getFromCache() async {
    final res = VAppPref.getMap("ban-${vRoom.id}");
    if (res == null) return;
    updateValue(VSingleBlockModel.fromMap(res));
  }

  Future<void> updateValue(VSingleBlockModel value) async {
    await VAppPref.setMap("ban-${vRoom.id}", value.toMap());
    if (value.isThereBan) {
      inputStateController.closeChat();
    } else {
      inputStateController.openChat();
    }
  }

  Future<void> _checkBanRemote() async {
    if (vRoom.roomType.isSingleOrOrder) {
      await vSafeApiCall<VSingleBlockModel>(
        request: () {
          return VChatController.I.blockApi
              .checkIfThereBan(peerId: vRoom.peerId!);
        },
        onSuccess: (response) async {
          await updateValue(response);
        },
      );
    }
  }
}
