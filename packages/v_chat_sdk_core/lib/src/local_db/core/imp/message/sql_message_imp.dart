// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:v_chat_sdk_core/src/local_db/core/abstraction/base_local_message_repo.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/message_table.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class SqlMessageImp extends BaseLocalMessageRepo {
  final Database _database;
  final _localId = MessageTable.columnLocalId;
  final _roomId = MessageTable.columnRoomId;
  final _table = MessageTable.tableName;

  SqlMessageImp(this._database);

  @override
  Future<int> delete(VDeleteMessageEvent event) {
    return _database.delete(
      _table,
      where: "$_localId =?",
      whereArgs: [event.localId],
    );
  }

  @override
  Future<VBaseMessage?> findByLocalId(String localId) async {
    final map = await _database.query(
      _table,
      where: "$_localId =?",
      whereArgs: [localId],
    );
    if (map.isEmpty) return null;
    return MessageFactory.createBaseMessage(map.first);
  }

  @override
  Future<int> insert(VInsertMessageEvent event) {
    return _database.insert(
      _table,
      event.messageModel.toLocalMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  @override
  Future<List<VBaseMessage>> search({
    required String text,
    required String roomId,
    int limit = 150,
  }) async {
    final maps = await _database.query(
      _table,
      where: "$_roomId =? AND ${MessageTable.columnContent} LIKE '%$text%' AND ${MessageTable.columnMessageType} != ?",
      whereArgs: [roomId, 'reaction'],
      orderBy: "${MessageTable.columnCreatedAt} DESC",
      limit: limit,
    );
    return maps.map((e) => MessageFactory.createBaseMessage(e)).toList();
  }

  @override
  Future<int> updateMessageStatus(VUpdateMessageStatusEvent event) {
    return _database.update(
      _table,
      {
        MessageTable.columnMessageEmitStatus: event.emitState.name,
      },
      where: "$_localId =?",
      whereArgs: [event.localId],
    );
  }

  @override
  Future<int> updateMessageToAllDeleted(VUpdateMessageAllDeletedEvent event) {
    return _database.update(
      _table,
      {
        MessageTable.columnAllDeletedAt: event.message.allDeletedAt,
      },
      where: "$_localId =?",
      whereArgs: [event.localId],
    );
  }

  @override
  Future<int> updateMessagesToDeliver(VUpdateMessageDeliverEvent event) {
    return _database.update(
      _table,
      {
        MessageTable.columnDeliveredAt: event.model.date,
      },
      where: '''
      ${MessageTable.columnRoomId} =?
      AND ${MessageTable.columnSenderId} =?
      AND  ${MessageTable.columnDeliveredAt} IS NULL 
      ''',
      whereArgs: [event.roomId, event.model.userId],
    );
  }

  @override
  Future<int> updateMessagesToSeen(VUpdateMessageSeenEvent event) async {
    await updateMessagesToDeliver(
      VUpdateMessageDeliverEvent(
        model: VSocketOnDeliverMessagesModel(
          roomId: event.roomId,
          userId: event.model.userId,
          date: event.model.date,
        ),
        roomId: event.roomId,
        localId: event.localId,
      ),
    );
    return _database.update(
      MessageTable.tableName,
      {
        MessageTable.columnSeenAt: event.model.date,
      },
      where: '''
          ${MessageTable.columnRoomId} =? 
          AND ${MessageTable.columnSenderId} =?
          AND ${MessageTable.columnSeenAt} IS NULL
          ''',
      whereArgs: [event.model.roomId, event.model.userId],
    );
  }

  @override
  Future<List<VBaseMessage>> getMessagesByStatus({
    required VMessageEmitStatus status,
    int limit = 90,
  }) async {
    final maps = await _database.query(
      _table,
      where: "${MessageTable.columnMessageEmitStatus} =?",
      whereArgs: [status.name],
      orderBy: "${MessageTable.columnId} DESC",
      limit: limit,
    );
    return maps.map((e) => MessageFactory.createBaseMessage(e)).toList();
  }

  @override
  Future<VBaseMessage?> findOneMessageBeforeThis(
    String createdAt,
    String roomId,
  ) async {
    final maps = await _database.query(
      _table,
      where: "${MessageTable.columnCreatedAt} <? AND $_roomId =? AND ${MessageTable.columnMessageType} != ?",
      whereArgs: [createdAt, roomId, 'reaction'],
      orderBy: "${MessageTable.columnCreatedAt} DESC",
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return MessageFactory.createBaseMessage(maps.first);
  }

  @override
  Future<int> updateContentTr(VUpdateContentTr event) {
    return _database.update(
      _table,
      {
        MessageTable.columnContentTr: event.contentTr,
      },
      where: "$_localId =?",
      whereArgs: [event.localId],
    );
  }


  @override
  Future<List<VBaseMessage>> getRoomMessages({
    required String roomId,
    required VRoomMessagesDto filter,
  }) async {
    final StringBuffer where = StringBuffer();

    if (filter.lastId != null) {
      where.write("AND ${MessageTable.columnId} < '${filter.lastId}'");
    }
    if (filter.between != null) {
      where.write(
        "AND ${MessageTable.columnId} BETWEEN '${filter.between!.targetId}' AND '${filter.between!.lastId}' ",
      );
    }

    // Filter out reaction messages
    where.write("AND ${MessageTable.columnMessageType} != 'reaction'");

    final maps = await _database.query(
      _table,
      orderBy: "${MessageTable.columnId} DESC",
      limit: filter.limit,
      where: "$_roomId =? $where",
      whereArgs: [roomId],
    );
    return maps.map((e) => MessageFactory.createBaseMessage(e)).toList();
  }

  @override
  Future<int> updateMessagesFromSendingToError() {
    return _database.update(
      _table,
      {
        MessageTable.columnMessageEmitStatus: VMessageEmitStatus.error.name,
      },
      where: "${MessageTable.columnMessageEmitStatus} =?",
      whereArgs: [VMessageEmitStatus.sending.name],
    );
  }

  @override
  Future<int> insertMany(List<VBaseMessage> messages) async {
    final l = <Future>[];
    for (final e in messages) {
      l.add(_insertPromise(e));
    }
    await Future.wait(l);
    return 1;
  }

  Future _insertPromise(VBaseMessage e) async {
    try {
      await _database.insert(
        _table,
        e.toLocalMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } catch (err) {
      await _database.update(
        _table,
        e.toLocalMap(
          withOutConTr: true,
          withOutIsDownload: true,
        ),
        where: "$_localId =?",
        whereArgs: [e.localId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  @override
  Future<void> reCreate() async {
    return _database.transaction((txn) => MessageTable.recreateTable(txn));
  }

  @override
  Future<int> deleteAllMessagesByRoomId(String roomId) {
    return _database.delete(_table, where: "$_roomId =?", whereArgs: [roomId]);
  }

  @override
  Future<int> updateFullMessage({
    required VBaseMessage baseMessage,
  }) {
    return _database.insert(
      _table,
      baseMessage.toLocalMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> updateMessageStar(VUpdateMessageStarEvent event) {
    return _database.update(
      _table,
      {
        MessageTable.columnIsStar: event.isStar ? 1 : 0,
      },
      where: "${MessageTable.columnLocalId} =?",
      whereArgs: [event.localId],
    );
  }

  @override
  Future<int> updateMessageOneSeenByMe(VUpdateMessageOneSeenEvent event) async {
    return _database.update(
      _table,
      {
        MessageTable.columnIsOneSeenByMe: 1,
      },
      where: "${MessageTable.columnLocalId} =?",
      whereArgs: [event.localId],
    );
  }

  @override
  Future<int> updateIsDownloadingMessage(VUpdateIsDownloadMessageEvent event) {
    return _database.update(
      _table,
      {
        MessageTable.columnIsDownloading: event.isDownloading ? 1 : 0,
      },
      where: "${MessageTable.columnLocalId} =?",
      whereArgs: [event.localId],
    );
  }

  @override
  Future<int> updateMessageReactions(VUpdateMessageReactionsEvent event) {
    return _database.update(
      _table,
      {
        MessageTable.columnReactionNumber: event.reactionNumber,
        MessageTable.columnReactionSample: event.reactionSample.isEmpty 
            ? null 
            : jsonEncode(event.reactionSample.map((e) => e.toJson()).toList()),
        MessageTable.columnCurrentUserEmoji: event.currentUserEmoji,
      },
      where: "${MessageTable.columnLocalId} = ?",
      whereArgs: [event.localId],
    );
  }
}
