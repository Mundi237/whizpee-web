// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:chopper/chopper.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/message_table.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VReactionMessage extends VBaseMessage {
  VReactionMessage({
    required super.id,
    required super.senderId,
    required super.senderName,
    required super.senderImageThumb,
    required super.linkAtt,
    required super.emitStatus,
    required super.isEncrypted,
    required super.contentTr,
    required super.platform,
    required super.roomId,
    required super.content,
    required super.messageType,
    required super.localId,
    required super.createdAt,
    required super.updatedAt,
    required super.replyTo,
    required super.seenAt,
    required super.deliveredAt,
    required super.forwardId,
    required super.allDeletedAt,
    required super.parentBroadcastId,
    required super.isStared,
    required this.emoji,
    required this.reactedToMessageId,
  });

  /// The emoji reaction
  final String emoji;
  
  /// The ID of the message being reacted to
  final String reactedToMessageId;

  VReactionMessage.buildMessage({
    required super.content,
    required super.isEncrypted,
    required super.linkAtt,
    required super.roomId,
    required this.emoji,
    required this.reactedToMessageId,
    super.forwardId,
    super.broadcastId,
    super.replyTo,
  }) : super.buildMessage(messageType: VMessageType.reaction);

  VReactionMessage.fromRemoteMap(super.map)
      : emoji = map['emoji'] as String? ?? '',
        reactedToMessageId = map['reactedToMessageId'] as String? ?? '',
        super.fromRemoteMap();

  VReactionMessage.fromLocalMap(super.map)
      : emoji = map[MessageTable.columnEmoji] as String? ?? '',
        reactedToMessageId = map[MessageTable.columnReactedToMessageId] as String? ?? '',
        super.fromLocalMap();

  @override
  bool operator ==(Object other) =>
      other is VBaseMessage && localId == other.localId;

  @override
  int get hashCode => localId.hashCode;

  @override
  Map<String, Object?> toRemoteMap() {
    final map = super.toRemoteMap();
    map['emoji'] = emoji;
    map['reactedToMessageId'] = reactedToMessageId;
    return map;
  }

  @override
  Map<String, Object?> toLocalMap({
    bool withOutConTr = false,
    bool withOutIsDownload = false,
  }) {
    final map = super.toLocalMap(
      withOutConTr: withOutConTr,
      withOutIsDownload: withOutIsDownload,
    );
    map[MessageTable.columnEmoji] = emoji;
    map[MessageTable.columnReactedToMessageId] = reactedToMessageId;
    return map;
  }

  @override
  List<PartValue> toListOfPartValue() {
    final baseList = super.toListOfPartValue();
    return [
      ...baseList,
      PartValue('emoji', emoji),
      PartValue('reactedToMessageId', reactedToMessageId),
    ];
  }
}