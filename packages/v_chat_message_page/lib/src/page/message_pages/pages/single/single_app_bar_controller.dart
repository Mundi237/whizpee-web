// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../../v_chat_message_page.dart';
import '../../providers/message_provider.dart';

class SingleAppBarController extends ValueNotifier<SingleAppBarStateModel>
    with StreamMix {
  final VRoom vRoom;
  final MessageProvider messageProvider;
  bool _isDisposed = false;

  SingleAppBarController({
    required this.vRoom,
    required this.messageProvider,
  }) : super(SingleAppBarStateModel.fromVRoom(vRoom)) {
    _initStreams();
    _autoUpdateLastSeenValue();
  }

  void updateOnline() {
    if (_isDisposed) return;
    value.isOnline = true;
    notifyListeners();
  }

  void updateTyping(VSocketRoomTypingModel typingModel) {
    if (_isDisposed) return;
    value.typingModel = typingModel;
    notifyListeners();
  }

  void updateLastSeen(DateTime lastSeenAt) {
    if (_isDisposed) return;
    value.lastSeenAt = lastSeenAt;
    notifyListeners();
  }

  void close() {
    if (_isDisposed) return;
    _isDisposed = true;
    closeStreamMix();
    dispose();
  }

  void updateOffline() async {
    if (_isDisposed) return;
    value.isOnline = false;
    notifyListeners();
  }

  void onOpenSearch() {
    if (_isDisposed) return;
    value.isSearching = true;
    notifyListeners();
  }

  void onCloseSearch() {
    if (_isDisposed) return;
    value.isSearching = false;
    notifyListeners();
  }

  void _initStreams() {
    streamsMix.addAll([
      VEventBusSingleton.vEventBus
          .on<VRoomOfflineEvent>()
          .where((e) => e.roomId == value.roomId)
          .listen((_) {
        updateOffline();
      }),
      VEventBusSingleton.vEventBus
          .on<VRoomOnlineEvent>()
          .where((e) => e.roomId == value.roomId)
          .listen((_) {
        updateOnline();
      }),
      VEventBusSingleton.vEventBus
          .on<VUpdateRoomTypingEvent>()
          .where((e) => e.roomId == value.roomId)
          .listen(_updateRoomTyping),
      VEventBusSingleton.vEventBus
          .on<VSingleBlockEvent>()
          .where((e) => e.roomId == value.roomId)
          .listen(_handleOnBlock)
    ]);
  }

  void _autoUpdateLastSeenValue() {
    if (!vRoom.isOnline && value.lastSeenAt == null) {
      updateFromRemote();
    }
  }

  Future<void> updateFromRemote() async {
    await vSafeApiCall<DateTime?>(
      request: () async {
        return await messageProvider.getLastSeenAt(value.peerId);
      },
      onSuccess: (response) {
        if (_isDisposed) return;
        value.lastSeenAt = response;
        notifyListeners();
      },
      config: const VApiConfig(
        ignoreTimeoutErrors: true,
        ignoreNetworkErrors: true,
      ),
    );
  }

  void _handleOnBlock(VSingleBlockEvent event) {
    if (_isDisposed) return;
    if (event.banModel.isThereBan) {
      value.lastSeenAt = null;
      value.isOnline = false;
      notifyListeners();
    } else {
      _autoUpdateLastSeenValue();
    }
  }

  void _updateRoomTyping(VUpdateRoomTypingEvent event) {
    updateTyping(event.typingModel);
  }
}

class SingleAppBarStateModel {
  DateTime? lastSeenAt;
  final String roomTitle;
  final String roomId;
  final String peerId;
  final String roomImage;
  VSocketRoomTypingModel typingModel;
  bool isOnline;
  bool isSearching;

  SingleAppBarStateModel._({
    required this.roomTitle,
    required this.roomId,
    required this.peerId,
    required this.roomImage,
    required this.typingModel,
    required this.isOnline,
    required this.isSearching,
  });

  factory SingleAppBarStateModel.fromVRoom(VRoom room) {
    return SingleAppBarStateModel._(
      roomId: room.id,
      typingModel: room.typingStatus,
      isOnline: room.isOnline,
      roomImage: room.thumbImage,
      roomTitle: room.realTitle,
      isSearching: false,
      peerId: room.peerId!,
    );
  }
}
