// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_voice_player/v_chat_voice_player.dart';

class MessageStatusState {
  final List<VMessageStatusModel> seen = [];
  final List<VMessageStatusModel> deliver = [];

  @override
  String toString() {
    return 'MessageStatusState{seen: $seen, deliver: $deliver}';
  }
}

class MessageGroupStatusController extends ValueNotifier<MessageStatusState> {
  final VBaseMessage message;
  Timer? _timer;

  MessageGroupStatusController(this.message) : super(MessageStatusState()) {
    getData();
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (Timer t) => getData(),
    );
  }

  VChatLoadingState state = VChatLoadingState.ideal;
  VVoiceMessageController? voiceMessageController;

  void close() {
    voiceMessageController?.dispose();
    _timer?.cancel();
    dispose();
  }

  VVoiceMessageController? getVoiceController(VBaseMessage message) {
    if (message is VVoiceMessage && voiceMessageController == null) {
      voiceMessageController = VVoiceMessageController(
        id: message.localId,
        audioSrc: message.data.fileSource,
        maxDuration: message.data.durationObj,
      );
      return voiceMessageController;
    } else if (message is VVoiceMessage && voiceMessageController != null) {
      return voiceMessageController;
    }
    return null;
  }

  void getData() async {
    await vSafeApiCall<MessageStatusState>(
      onLoading: () {
        if (state != VChatLoadingState.success) {
          state = VChatLoadingState.loading;
          notifyListeners();
        }
      },
      request: () async {
        final newState = MessageStatusState();
        newState.seen
            .addAll(await VChatController.I.roomApi.getMessageStatusForGroup(
          roomId: message.roomId,
          messageId: message.id,
          isSeen: true,
        ));
        newState.deliver
            .addAll(await VChatController.I.roomApi.getMessageStatusForGroup(
          roomId: message.roomId,
          messageId: message.id,
          isSeen: false,
        ));

        return newState;
      },
      onSuccess: (response) {
        value = response;
        state = VChatLoadingState.success;
        notifyListeners();
      },
      onError: (exception) {
        state = VChatLoadingState.error;
        notifyListeners();
      },
    );
  }
}
