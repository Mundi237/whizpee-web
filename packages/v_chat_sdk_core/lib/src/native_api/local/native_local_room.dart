// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.
import 'dart:async';

import 'package:sqflite/sqlite_api.dart';
import 'package:v_chat_sdk_core/src/local_db/core/abstraction/base_local_room_repo.dart';
import 'package:v_chat_sdk_core/src/local_db/core/imp/room/memory_room_imp.dart';
import 'package:v_chat_sdk_core/src/local_db/core/imp/room/sql_room_imp.dart';
import 'package:v_chat_sdk_core/src/native_api/local/native_local_message.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

/// Represents the Native Local Room that manages room data in the VChat
/// application, both in local (in-memory and SQL) databases.
class NativeLocalRoom {
  late final BaseLocalRoomRepo _roomRepo;
  final NativeLocalMessage _localMessage;
  final _emitter = VEventBusSingleton.vEventBus;
  final Map<String, Timer?> _typingTimers = {};

  /// Creates a new instance of [NativeLocalRoom].
  ///
  /// Uses the appropriate local room repository (memory or SQL) based on the platform (Web or others).
  NativeLocalRoom(Database? database, this._localMessage) {
    _roomRepo = VPlatforms.isWeb ? MemoryRoomImp() : SqlRoomImp(database!);
  }

  /// Fetches rooms along with their last message from the local room repository.
  Future<List<VRoom>> getRooms({int limit = 100}) async {
    _refreshUnReadCounter();
    return _roomRepo.getRoomsWithLastMessage(limit: limit);
  }

  /// get all room unread counter.
  Future<int> getTotalUnReadCount() {
    return _roomRepo.getUnReadRoomsCount();
  }



  void _refreshUnReadCounter() {
    unawaited(_reloadUnreadCounterForMessages());
    unawaited(_reloadUnreadCounterForRooms());
  }

  /// Reloads the unread counter.
  Future<void> _reloadUnreadCounterForMessages() async {
    final unreadCount = await _roomRepo.getUnReadMessagesCount();
    _emitter.fire(VTotalUnReadMessagesCount(unreadCount));
  }

  /// Reloads the unread counter.
  Future<void> _reloadUnreadCounterForRooms() async {
    final unreadCount = await _roomRepo.getUnReadRoomsCount();
    _emitter.fire(VTotalUnReadRoomsCount(unreadCount));
  }

  /// get all room unread counter.
  Future<int> getTotalUnReadCountFroMessages() {
    return _roomRepo.getUnReadMessagesCount();
  }

  /// get all room unread counter.
  Future<int> getTotalUnReadCountFroRooms() {
    return _roomRepo.getUnReadRoomsCount();
  }

  /// Fetches a room with its last message by its roomId from the local room repository.
  Future<VRoom?> getOneWithLastMessageByRoomId(String id) =>
      _roomRepo.getOneWithLastMessageByRoomId(id);

  /// Checks if a room exists in the local room repository.
  Future<bool> isRoomExist(String id) => _roomRepo.isRoomExist(id);

  /// Safely inserts the given [room] into the local room repository.
  ///
  /// Checks if a room with the same roomId exists before proceeding with the insertion.
  Future<void> safeInsertRoom(VRoom room) async {
    if (!await isRoomExist(room.id)) {
      final event = VInsertRoomEvent(roomId: room.id, room: room);
      await _roomRepo.insert(event);
      await _localMessage.safeInsertMessage(room.lastMessage);
      _emitter.fire(event);
    }
  }

  /// Caches multiple rooms into the local room repository.
  ///
  /// Recreates the room and message tables if the [rooms] list is empty and [deleteOnEmpty] is true.
  /// or update the room if it exists.
  Future<int> cacheRooms(
    List<VRoom> rooms, {
    required bool deleteOnEmpty,
  }) async {
    if (rooms.isEmpty && deleteOnEmpty) {
      await reCreateRoomTable();
      await _localMessage.reCreateMessageTable();
      return 1;
    }

    await _localMessage
        .cacheRoomMessages(rooms.map((e) => e.lastMessage).toList());
    await _roomRepo.insertMany(rooms);
    _refreshUnReadCounter();
    return 1;
  }

  /// Updates room typing based on the given [typing].
  ///
  /// Emits a [VUpdateRoomTypingEvent] on successful update.
  Future<int> updateRoomTyping(VSocketRoomTypingModel typing) async {
    final event =
        VUpdateRoomTypingEvent(roomId: typing.roomId, typingModel: typing);
    _emitter.fire(event);
    // Handle timer logic based on typing status
    if (typing.status == VRoomTypingEnum.typing ||
        typing.status == VRoomTypingEnum.recording) {
      _startTypingTimeout(typing);
    } else if (typing.status == VRoomTypingEnum.stop) {
      _cancelTypingTimeout(typing.roomId);
    }
    return 1;
  }

  void _startTypingTimeout(VSocketRoomTypingModel typing) {
    // Cancel existing timer if any
    _cancelTypingTimeout(typing.roomId);

    // Start new 25-second timer
    _typingTimers[typing.roomId] = Timer(const Duration(seconds: 25), () {
      // Auto-fire stop typing event
      final stopTyping = typing.copyWith(status: VRoomTypingEnum.stop);
      final stopEvent = VUpdateRoomTypingEvent(
          roomId: stopTyping.roomId, typingModel: stopTyping);
      _emitter.fire(stopEvent);
      _typingTimers.remove(typing.roomId);
    });
  }

  void _cancelTypingTimeout(String roomId) {
    _typingTimers[roomId]?.cancel();
    _typingTimers.remove(roomId);
  }

  /// Updates room block based on the given [ban].
  ///
  /// Emits a [VSingleBlockEvent] on successful update.
  Future<int> updateRoomBlock(VSingleBlockModel ban) async {
    final event = VSingleBlockEvent(banModel: ban, roomId: ban.roomId);
    _emitter.fire(event);
    return 1;
  }

  /// Updates room online based on the given [events].
  void updateRoomOnline(List<VOnlineOfflineModel> events) {
    for (final event in events) {
      _emitter.fire(event);
    }
  }

  /// Updates room name based on the given [event].
  Future<int> updateRoomName(VUpdateRoomNameEvent event) async {
    _emitter.fire(event);
    return _roomRepo.updateName(event);
  }

  /// Updates room image based on the given [event].
  Future<int> updateRoomImage(VUpdateRoomImageEvent event) async {
    _emitter.fire(event);
    return _roomRepo.updateImage(event);
  }

  Future<int> updateNickName(VUpdateLocalRoomNickNameEvent event) async {
    _emitter.fire(event);
    return _roomRepo.updateNickName(event);
  }

  /// Adds one to the unread count of the room with the given [roomId].
  Future<int> updateRoomUnreadCountAddOne(String roomId) async {
    final event = VUpdateRoomUnReadCountByOneEvent(roomId: roomId);
    _emitter.fire(event);
    await _roomRepo.updateCountByOne(event);
    _refreshUnReadCounter();
    return 1;
  }

  /// Sets the unread count of the room with the given [roomId] to zero.
  Future<int> updateRoomUnreadToZero(String roomId) async {
    final event = VUpdateRoomUnReadCountToZeroEvent(roomId: roomId);
    _emitter.fire(event);
    await _roomRepo.updateCountToZero(event);
    _refreshUnReadCounter();
    return 1;
  }

  /// Updates room mute status based on the given [event].
  Future<int> updateRoomIsMuted(VUpdateRoomMuteEvent event) async {
    _emitter.fire(event);
    return _roomRepo.updateIsMuted(event);
  }

  /// Updates room mute status based on the given [event].
  Future<int> updateRoomOneSeen(VUpdateRoomOneSeenEvent event) async {
    _emitter.fire(event);
    return _roomRepo.updateOneSeen(event);
  }

  /// Searches for rooms in the local room repository with a matching [text].
  Future<List<VRoom>> searchRoom({
    required String text,
    int limit = 20,
  }) async =>
      _roomRepo.search(text, limit, null);

  /// Fetches a room by its peerId from the local room repository.
  Future<VRoom?> getRoomByPeerId(String peerId) async =>
      _roomRepo.getOneByPeerId(peerId);

  /// Deletes a room with the given [roomId] from the local room repository.
  Future<void> deleteRoom(String roomId) async {
    await _localMessage.deleteMessageByRoomId(roomId);
    await _roomRepo.delete(VDeleteRoomEvent(roomId: roomId));
    _refreshUnReadCounter();
    _emitter.fire(VDeleteRoomEvent(roomId: roomId));
  }

  /// Drops the existing room table and creates a new one in the local room repository.
  Future<void> reCreateRoomTable() => _roomRepo.reCreate();

  /// Updates the 'transTo' field of a room with the given [roomId] based on the [transTo] parameter.
  Future<void> updateTransTo({
    required String roomId,
    required String? transTo,
  }) async {
    final e = VUpdateTransToEvent(roomId: roomId, transTo: transTo);
    await _roomRepo.updateTransTo(e);
    _emitter.fire(e);
  }
}
