// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../assets/data/api_messages.dart';
import '../../../assets/data/local_messages.dart';

class MessageProvider {
  final _remoteMessage = VChatController.I.nativeApi.remote.message;
  final _remoteAnnouncementRoom =
      VChatController.I.nativeApi.remote.announcementRoom;
  final _localMessage = VChatController.I.nativeApi.local.message;
  final _localRoom = VChatController.I.nativeApi.local.room;
  final _remoteRoom = VChatController.I.nativeApi.remote.room;
  final _remoteProfile = VChatController.I.nativeApi.remote.profile;
  final _socket = VChatController.I.nativeApi.remote.socketIo;

  Future<List<VBaseMessage>> getFakeLocalMessages() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return fakeLocalMessages
        .map((e) => MessageFactory.createBaseMessage(e))
        .toList();
  }

  Future<List<VBaseMessage>> getFakeApiMessages() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return fakeApiMessages
        .map((e) => MessageFactory.createBaseMessage(e))
        .toList();
  }

  Future<List<VBaseMessage>> getLocalMessages({
    required String roomId,
    required VRoomMessagesDto filter,
  }) async {
    return _localMessage.getRoomMessages(
      roomId: roomId,
      filter: filter,
    );
  }

  Future<List<VBaseMessage>> getApiMessages({
    required String roomId,
    required VRoomMessagesDto dto,
  }) async {
    print("🔍 [MessageProvider] getApiMessages called for roomId: $roomId");
    print("🔍 [MessageProvider] DTO: ${dto.toMap()}");

    // Determine the room type to route to the correct API
    final room = await _localRoom.getOneWithLastMessageByRoomId(roomId);
    print("🔍 [MessageProvider] Room found: ${room != null}");
    print("🔍 [MessageProvider] Room type: ${room?.roomType}");
    print(
        "🔍 [MessageProvider] Is announcement: ${room?.roomType == VRoomType.a}");

    final List<VBaseMessage> apiMessages;

    if (room?.roomType == VRoomType.a) {
      // Route to announcement room API for announcement conversations
      print("🔍 [MessageProvider] ✅ Routing to ANNOUNCEMENT ROOM API");
      apiMessages = await _remoteAnnouncementRoom.getAnnouncementRoomMessages(
        roomId: roomId,
        dto: dto,
      );
    } else {
      // Route to standard VChat API for normal conversations
      print("🔍 [MessageProvider] ✅ Routing to STANDARD VCHAT API");
      apiMessages = await _remoteMessage.getRoomMessages(
        roomId: roomId,
        dto: dto,
      );
    }

    print("🔍 [MessageProvider] Retrieved ${apiMessages.length} messages");
    unawaited(_localMessage.cacheRoomMessages(apiMessages));
    return apiMessages;
  }

  void setSeen(String roomId) async {
    await _socket.socketCompleter.future;
    _socket.emitSeenRoomMessages(roomId);
    unawaited(_localRoom.updateRoomUnreadToZero(roomId));
  }

  Future<DateTime?> getLastSeenAt(String peerId) async {
    return _remoteProfile.getUserLastSeenAt(peerId);
  }

  Future<bool> checkGroupStatus(String roomId) async {
    return _remoteRoom.getGroupStatus(roomId);
  }

  void emitTypingChanged(VSocketRoomTypingModel model) {
    return _socket.emitUpdateRoomStatus(model);
  }

  Future<List<VBaseMessage>> search(String roomId, String text) {
    return _localMessage.searchMessage(text, roomId);
  }

  Future deleteMessageFromAll(String roomId, String mId) async {
    return _remoteMessage.deleteMessageFromAll(roomId, mId);
  }

  Future deleteMessageFromMe(VBaseMessage msg) async {
    await _localMessage.deleteMessageByLocalId(msg);
    return _remoteMessage.deleteMessageFromMe(msg.roomId, msg.id);
  }
}
