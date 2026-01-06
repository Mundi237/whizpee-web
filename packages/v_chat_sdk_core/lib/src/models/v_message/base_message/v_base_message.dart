// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:bson/bson.dart';
import 'package:chopper/chopper.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/message_table.dart';
import 'package:v_chat_sdk_core/src/utils/string_utils.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_sdk_core/src/models/v_message/reaction_sample_model.dart';
import 'package:v_platform/v_platform.dart';

abstract class VDownloadableMessage {
  VPlatformFile get fileSource;

  String get localFilePathWithExt;

  bool get isFileDownloaded;
}

abstract class VUploadMessage {
  VPlatformFile get fileSource;

  String get localFilePathWithExt;
}

/// Abstract base class for a message.
///
/// This class defines the general structure and data of a message. It is
/// intended to be subclassed for different kinds of messages.
abstract class VBaseMessage {
  VBaseMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderImageThumb,
    required this.platform,
    required this.roomId,
    required this.content,
    required this.messageType,
    required this.localId,
    required this.createdAt,
    required this.updatedAt,
    required this.emitStatus,
    required this.replyTo,
    required this.seenAt,
    this.isOneSeenByMe = false,
    this.isOneSeen = false,
    this.isDownloading = false,
    required this.deliveredAt,
    required this.forwardId,
    required this.allDeletedAt,
    required this.parentBroadcastId,
    required this.isStared,
    required this.isEncrypted,
    required this.contentTr,
    required this.linkAtt,
    this.reactionNumber = 0,
    this.reactionSample = const [],
    this.currentUserEmoji,
  });

  /// Unique ID of the message. This will be changed if message get from remote.
  String id;

  /// ID of the sender.
  String senderId;

  /// Name of the sender.
  String senderName;

  // Link Data
  VLinkPreviewData? linkAtt;

  /// Thumbnail image URL of the sender.
  String senderImageThumb;

  /// The platform through which this message was sent.
  final String platform;

  /// ID of the room where this message was sent.
  final String roomId;

  /// The content of the message from the server.
  @protected
  final String content;

  /// Type of the message.
  VMessageType messageType;

  /// Translated content of the message.
  String? contentTr;

  /// Status of the message emit (server confirm, error, sending).
  VMessageEmitStatus emitStatus;

  /// If this message is a reply, the original message it replies to.
  VBaseMessage? replyTo;

  /// Time when the message was seen.
  String? seenAt;

  /// Time when the message was delivered.
  String? deliveredAt;

  /// ID of the message that this message was forwarded from.
  String? forwardId;

  /// Time when the message was deleted from all.
  String? allDeletedAt;

  /// If the message was sent through broadcast, the ID of the parent broadcast.
  String? parentBroadcastId;

  /// Unique local ID of the message. This is used to uniquely identify the
  /// message across all messages, and is useful because the server message ID
  /// will change.
  String localId;

  /// Time when the message was sent.
  String createdAt;

  /// Time when the message was last updated.
  final String updatedAt;

  /// If the message is encrypted.
  final bool isEncrypted;

  /// If the user intends to delete this message.
  bool isDeleted = false;

  bool get isUploading => emitStatus == VMessageEmitStatus.sending;

  // bool get isFileDownloaded =>  VFileUtils.;

  /// If the message is starred.
  bool isStared;

  bool isDownloading;
  double progress = -0.1;

  bool get isMessageHasProgress => isDownloading || emitStatus.isSending;

  final bool isOneSeen;
  bool isOneSeenByMe;

  /// Reaction counters and preview for UI display
  int reactionNumber;
  List<ReactionSample> reactionSample;
  
  /// Current user's selected emoji (null if no reaction)
  String? currentUserEmoji;

  VBaseMessage.fromRemoteMap(Map<String, dynamic> map)
      : id = map['_id'] as String,
        senderId = map['sId'] as String,
        senderName = map['sName'] as String,
        senderImageThumb = map['sImg'] as String,
        platform = map['plm'] as String,
        isEncrypted = map['isEncrypted'] as bool,
        forwardId = map['forId'] as String?,
        roomId = map['rId'] as String,
        isOneSeen = (map['isOneSeen'] as bool?) ?? false,
        isOneSeenByMe = (map['isOneSeenByMe'] as bool?) ?? false,
        contentTr = null,
        linkAtt = map['linkAtt'] == null
            ? null
            : VLinkPreviewData.fromMap(map['linkAtt'] as Map<String, dynamic>),
        isStared = (map['isStared'] as bool?) ?? false,
        content = map['c'] as String,
        messageType =
            EnumToString.fromString(VMessageType.values, map['mT'] as String) ?? VMessageType.bug,
        replyTo = map['rTo'] == null
            ? null
            : MessageFactory.createBaseMessage(
                map['rTo'] as Map<String, dynamic>,
              ),
        seenAt = map['sAt'] as String?,
        deliveredAt = map['dAt'] as String?,
        allDeletedAt = map['dltAt'] as String?,
        parentBroadcastId = map['pBId'] as String?,
        localId = map['lId'] as String,
        isDownloading = false,
        createdAt = map['createdAt'] as String,
        emitStatus = VMessageEmitStatus.serverConfirm,
        updatedAt = map['updatedAt'] as String,
        reactionNumber = (map['reactionNumber'] as int?) ?? 0,
        reactionSample = (map['reactionSample'] as List<dynamic>?)
            ?.map((e) => ReactionSample.fromJson(e as Map<String, dynamic>))
            .toList() ?? const [],
        currentUserEmoji = map['currentUserEmoji'] as String?;

  /// from local
  VBaseMessage.fromLocalMap(Map<String, dynamic> map)
      : id = map[MessageTable.columnId] as String,
        senderId = map[MessageTable.columnSenderId] as String,
        senderName = map[MessageTable.columnSenderName] as String,
        senderImageThumb = map[MessageTable.columnSenderImageThumb] as String,
        platform = map[MessageTable.columnPlatform] as String,
        roomId = map[MessageTable.columnRoomId] as String,
        isDownloading = (map[MessageTable.columnIsDownloading] as int?) == 1,
        isEncrypted = (map[MessageTable.columnIsEncrypted] as int) == 1,
        isStared = (map[MessageTable.columnIsStar] as int) == 1,
        contentTr = map[MessageTable.columnContentTr] as String?,
        content = map[MessageTable.columnContent] as String,
        seenAt = map[MessageTable.columnSeenAt] as String?,
        isOneSeenByMe = (map[MessageTable.columnIsOneSeenByMe] as int?) == 1,
        isOneSeen = (map[MessageTable.columnIsOneSeen] as int?) == 1,
        replyTo = map[MessageTable.columnReplyTo] == null
            ? null
            : MessageFactory.createBaseMessage(
                jsonDecode(map[MessageTable.columnReplyTo] as String) as Map<String, dynamic>,
              ),
        deliveredAt = map[MessageTable.columnDeliveredAt] as String?,
        forwardId = map[MessageTable.columnForwardId] as String?,
        allDeletedAt = map[MessageTable.columnAllDeletedAt] as String?,
        parentBroadcastId = map[MessageTable.columnParentBroadcastId] as String?,
        localId = map[MessageTable.columnLocalId] as String,
        createdAt = map[MessageTable.columnCreatedAt] as String,
        updatedAt = map[MessageTable.columnUpdatedAt] as String,
        linkAtt = map[MessageTable.columnLinkAttachment] == null
            ? null
            : VLinkPreviewData.fromMap(
                jsonDecode(map[MessageTable.columnLinkAttachment] as String)
                    as Map<String, dynamic>,
              ),
        emitStatus =
            VMessageEmitStatus.values.byName(map[MessageTable.columnMessageEmitStatus] as String),
        messageType = EnumToString.fromString(
              VMessageType.values,
              map[MessageTable.columnMessageType] as String,
            ) ??
            VMessageType.bug,
        reactionNumber = (map[MessageTable.columnReactionNumber] as int?) ?? 0,
        reactionSample = map[MessageTable.columnReactionSample] != null
            ? (jsonDecode(map[MessageTable.columnReactionSample] as String) as List<dynamic>)
                .map((e) => ReactionSample.fromJson(e as Map<String, dynamic>))
                .toList()
            : const [],
        currentUserEmoji = map[MessageTable.columnCurrentUserEmoji] as String?;

  Map<String, Object?> toLocalMap({
    bool withOutConTr = false,
    bool withOutIsDownload = false,
  }) {
    final map = {
      MessageTable.columnId: id,
      MessageTable.columnSenderId: senderId,
      MessageTable.columnSenderName: senderName,
      MessageTable.columnSenderImageThumb: senderImageThumb,
      MessageTable.columnPlatform: platform,
      MessageTable.columnRoomId: roomId,
      MessageTable.columnContentTr: contentTr,
      MessageTable.columnIsStar: isStared ? 1 : 0,
      MessageTable.columnIsEncrypted: isEncrypted ? 1 : 0,
      MessageTable.columnContent: content,
      MessageTable.columnIsDownloading: isDownloading ? 1 : 0,
      MessageTable.columnMessageType: messageType.name,
      MessageTable.columnReplyTo: replyTo == null ? null : jsonEncode(replyTo!.toLocalMap()),
      MessageTable.columnSeenAt: seenAt,
      MessageTable.columnIsOneSeenByMe: isOneSeenByMe ? 1 : 0,
      MessageTable.columnIsOneSeen: isOneSeen ? 1 : 0,
      MessageTable.columnLinkAttachment: linkAtt == null ? null : jsonEncode(linkAtt!.toMap()),
      MessageTable.columnDeliveredAt: deliveredAt,
      MessageTable.columnForwardId: forwardId,
      MessageTable.columnAllDeletedAt: allDeletedAt,
      MessageTable.columnMessageEmitStatus: emitStatus.name,
      MessageTable.columnParentBroadcastId: parentBroadcastId,
      MessageTable.columnLocalId: localId,
      MessageTable.columnCreatedAt: createdAt,
      MessageTable.columnUpdatedAt: updatedAt,
      MessageTable.columnReactionNumber: reactionNumber,
      MessageTable.columnReactionSample: reactionSample.isEmpty ? null : jsonEncode(reactionSample.map((e) => e.toJson()).toList()),
      MessageTable.columnCurrentUserEmoji: currentUserEmoji,
    };
    if (withOutConTr) {
      map.remove(MessageTable.columnContentTr);
    }
    if (withOutIsDownload) {
      map.remove(MessageTable.columnIsDownloading);
    }
    return map;
  }

  List<PartValue> toListOfPartValue() {
    return [
      PartValue('content', content),
      PartValue('localId', localId),
      PartValue('localId', localId),
      PartValue('isEncrypted', isEncrypted),
      PartValue('forwardLocalId', forwardId),
      PartValue(
        'linkAtt',
        linkAtt == null ? null : jsonEncode(linkAtt!.toMap()),
      ),
      PartValue('messageType', messageType.name),
      PartValue(
        'replyToLocalId',
        replyTo == null || isForward ? null : replyTo!.localId,
      ),
    ];
  }

  @override
  bool operator ==(Object other) => other is VBaseMessage && localId == other.localId;

  @override
  int get hashCode => localId.hashCode;

  bool get isMeSender {
    return VAppConstants.myId == senderId;
  }

  ///Some Getters
  bool get isForward => forwardId != null;

  String get realContent => contentTr ?? content;

  bool get isTrans => contentTr != null;

  bool get isAllDeleted => allDeletedAt != null;

  bool get canNotSwipe => isAllDeleted || isDeleted || isOneSeen;

  String get realContentMentionParsedWithAt => VStringUtils.parseVMentions(realContent);

  DateTime get createdAtDate => DateTime.parse(createdAt).toLocal();

  DateTime? get seenAtDate => seenAt == null ? null : DateTime.parse(seenAt!).toLocal();

  DateTime get updatedAtDate => DateTime.parse(updatedAt).toLocal();

  DateTime? get deliveredAtDate =>
      deliveredAt == null ? null : DateTime.parse(deliveredAt!).toLocal();

  DateTime? get deletedAtDate =>
      allDeletedAt == null ? null : DateTime.parse(allDeletedAt!).toLocal();

  bool get isFromBroadcast => parentBroadcastId != null;

  bool get isContainReply => replyTo != null;

  @override
  String toString() {
    return 'BaseMessage{id: $id, senderId: $senderId, senderName: $senderName, senderImageThumb: $senderImageThumb, platform: $platform, roomId: $roomId, content: $content, messageType: $messageType, messageStatus: $emitStatus, replyTo: $replyTo, seenAt: $seenAt, deliveredAt: $deliveredAt, forwardId: $forwardId, deletedAt: $allDeletedAt, parentBroadcastId: $parentBroadcastId,  localId: $localId, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted, isStared: $isStared}';
  }

  VBaseMessage.buildMessage({
    required this.content,
    required this.roomId,
    required this.messageType,
    required this.isEncrypted,
    required this.linkAtt,
    this.forwardId,
    String? broadcastId,
    this.replyTo,
  })  : id = ObjectId().oid,
        localId = const Uuid().v4(),
        platform = VPlatforms.currentPlatform,
        createdAt = DateTime.now().toLocal().toIso8601String(),
        updatedAt = DateTime.now().toLocal().toIso8601String(),
        senderId = VAppConstants.myProfile.id,
        isStared = false,
        senderName = VAppConstants.myProfile.fullName,
        senderImageThumb = VAppConstants.myProfile.userImage,
        emitStatus = VMessageEmitStatus.sending,
        parentBroadcastId = broadcastId,
        isOneSeen = false,
        isDownloading = false,
        isOneSeenByMe = false,
        allDeletedAt = null,
        seenAt = null,
        deliveredAt = null,
        reactionNumber = 0,
        reactionSample = const [],
        currentUserEmoji = null;

  Map<String, Object?> toRemoteMap() {
    return {
      "_id": id,
      "sId": senderId,
      "sName": senderName,
      "sImg": senderImageThumb,
      "plm": platform,
      "mT": messageType.name,
      "rId": roomId,
      "c": realContent,
      "isOneSeenByMe": isOneSeenByMe,
      "isOneSeen": isOneSeen,
      "isDownloading": false,
      "isStared": isStared,
      "isEncrypted": isEncrypted,
      "sAt": seenAt,
      "rTo": replyTo == null ? null : (replyTo!).toRemoteMap(),
      "lId": localId,
      "dAt": deliveredAt,
      "linkAtt": linkAtt?.toMap(),
      "forId": forwardId,
      "dltAt": allDeletedAt,
      "pBId": parentBroadcastId,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
