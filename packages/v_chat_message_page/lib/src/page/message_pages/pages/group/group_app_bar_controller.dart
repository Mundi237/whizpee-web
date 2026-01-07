// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_message_page/src/core/stream_mixin.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../providers/message_provider.dart';

class GroupAppBarController extends ValueNotifier<GroupAppBarStateModel>
    with StreamMix {
  final VRoom vRoom;
  final MessageProvider messageProvider;
  bool _isDisposed = false;

  GroupAppBarController({
    required this.vRoom,
    required this.messageProvider,
  }) : super(GroupAppBarStateModel.fromVRoom(vRoom)) {
    streamsMix.addAll([
      VEventBusSingleton.vEventBus.on<VUpdateRoomImageEvent>().listen((event) {
        if (_isDisposed) return;
        value.roomImage = event.image;
        notifyListeners();
      }),
      VEventBusSingleton.vEventBus.on<VUpdateRoomNameEvent>().listen((event) {
        if (_isDisposed) return;
        value.roomTitle = event.name;
        notifyListeners();
      }),
      VEventBusSingleton.vEventBus
          .on<VUpdateRoomTypingEvent>()
          .where((e) => e.roomId == value.roomId)
          .listen((event) => updateTyping(event.typingModel)),
    ]);
  }

  void close() {
    if (_isDisposed) return;
    _isDisposed = true;
    closeStreamMix();
    dispose();
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

  void updateRoomImage(String value) {
    if (_isDisposed) return;
    this.value.roomImage = value;
    notifyListeners();
  }

  void updateValue(VMyGroupInfo value) {
    if (_isDisposed) return;
    this.value.myGroupInfo = value;
    notifyListeners();
  }

  void updateTyping(VSocketRoomTypingModel typingModel) {
    if (_isDisposed) return;
    value.typingModel = typingModel;
    notifyListeners();
  }
}

class GroupAppBarStateModel {
  String roomTitle;
  final String roomId;
  String roomImage;
  bool isSearching;
  VMyGroupInfo myGroupInfo;
  VSocketRoomTypingModel typingModel;

  GroupAppBarStateModel._({
    required this.roomTitle,
    required this.roomId,
    required this.roomImage,
    required this.myGroupInfo,
    required this.typingModel,
    required this.isSearching,
  });

  factory GroupAppBarStateModel.fromVRoom(VRoom room) {
    return GroupAppBarStateModel._(
      roomId: room.id,
      typingModel: room.typingStatus,
      roomImage: room.thumbImage,
      myGroupInfo: VMyGroupInfo.empty(),
      roomTitle: room.realTitle,
      isSearching: false,
    );
  }
}
