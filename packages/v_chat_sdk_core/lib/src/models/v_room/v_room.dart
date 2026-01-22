// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/message_table.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/room_table.dart';
import 'package:v_chat_sdk_core/src/models/v_room/annonces.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VRoom {
  /// The unique identifier of the room.
  final String id;
  final UserPrivacy? peerPrivacy;

  /// The title of the room in a specific language (could be a local language).
  String title;

  /// The English title of the room.
  String enTitle;

  /// The URL or path to the thumbnail image of the room.
  String thumbImage;

  /// The type of the room, defined by the `VRoomType` enum.
  VRoomType roomType;

  /// A flag indicating if the room is archived.
  bool isArchived;

  /// The count of unread messages in the room.
  int unReadCount;

  /// The last message that was sent in the room.
  VBaseMessage lastMessage;

  /// A flag indicating if the room is deleted.
  bool isDeleted = false;

  /// The timestamp when the room was created.
  final DateTime createdAt;

  /// A flag indicating if notifications for the room are muted.
  bool isMuted;

  /// A flag indicating if the room is currently online.
  bool isOnline;
  bool isOneSeen;

  /// The current typing status of the room.
  VSocketRoomTypingModel typingStatus;

  /// A nickname for the room.
  String? nickName;

  /// The language to translate the messages to.
  String? transTo;

  /// The peer ID if this is a peer-to-peer room.
  final String? peerId;

  /// A flag used for selecting the room, for example in a multi-select scenario.
  bool isSelected = false;

  String get thumbImageS3 => /*SConstants.baseMediaUrl +*/ thumbImage;

  String get realTitle => nickName ?? title;

  int mentionsCount;
  Annonces? annonce;

  VRoom({
    required this.id,
    required this.title,
    required this.enTitle,
    required this.roomType,
    required this.thumbImage,
    this.mentionsCount = 0,
    required this.transTo,
    required this.peerPrivacy,
    required this.isArchived,
    required this.unReadCount,
    required this.isOneSeen,
    required this.lastMessage,
    required this.createdAt,
    required this.isMuted,
    this.isOnline = false,
    required this.peerId,
    required this.nickName,
    this.typingStatus = VSocketRoomTypingModel.offline,
    this.annonce,
  });

  VRoom.empty()
      : id = "",
        title = "",
        transTo = null,
        thumbImage = "empty!.png",
        isArchived = false,
        roomType = VRoomType.s,
        mentionsCount = 0,
        createdAt = DateTime.now(),
        enTitle = "",
        unReadCount = 0,
        peerPrivacy = null,
        isMuted = false,
        isOneSeen = false,
        isDeleted = false,
        nickName = null,
        peerId = null,
        typingStatus = VSocketRoomTypingModel.offline,
        isOnline = false,
        lastMessage = VEmptyMessage(),
        annonce = null;

  VRoom.fromMap(Map<String, dynamic> map)
      : id = map['rId'] as String,
        transTo = map['tTo'] as String?,
        title = map['t'] as String,
        thumbImage = (map['img'] as String?) ?? '',
        mentionsCount = map['mentionsCount'] as int,
        isArchived = map['isA'] as bool,
        isOneSeen = (map['isOneSeen'] as bool?) ?? false,
        roomType = VRoomType.values.byName(map['rT'] as String),
        createdAt = DateTime.parse(map['createdAt'] as String),
        enTitle = removeDiacritics(map['t'] as String),
        unReadCount = map['uC'] as int,
        isMuted = map['isM'] as bool,
        isDeleted = map['isD'] as bool,
        nickName = map['nTitle'] as String?,
        typingStatus = VSocketRoomTypingModel.offline,
        isOnline = false,
        peerId = map['pId'] as String?,
        annonce =
            map['annonce'] is Map ? Annonces.fromMap(map['annonce']) : null,
        peerPrivacy = (map['peerData'] == null)
            ? null
            : UserPrivacy.fromMap(
                map['peerData']['userPrivacy'] as Map<String, dynamic>,
              ),
        lastMessage = map['lastMessage'] == null
            ? VEmptyMessage()
            : MessageFactory.createBaseMessage(
                map['lastMessage'] as Map<String, dynamic>,
              );

  VRoom.fromLocalMap(Map<String, dynamic> map)
      : id = map[RoomTable.columnId] as String? ?? '',
        roomType = VRoomType.values
            .byName(map[RoomTable.columnRoomType] as String? ?? ''),
        title = map[RoomTable.columnTitle] as String,
        thumbImage = map[RoomTable.columnThumbImage] as String,
        transTo = map[RoomTable.columnTransTo] as String?,
        isArchived = (map[RoomTable.columnIsArchived] as int) == 1,
        createdAt = DateTime.parse(map[RoomTable.columnCreatedAt] as String),
        enTitle = map[RoomTable.columnEnTitle] as String,
        unReadCount = map[RoomTable.columnUnReadCount] as int,
        mentionsCount = (map[RoomTable.columnMentionsCount] as int?) ?? 0,
        isOneSeen = (map[RoomTable.columnIsOneSeen] as int?) == 1,
        isMuted = (map[RoomTable.columnIsMuted] as int) == 1,
        nickName = map[RoomTable.columnNickName] as String?,
        typingStatus = VSocketRoomTypingModel.offline,
        isOnline = false,
        peerId = map[RoomTable.columnPeerId] as String?,
        peerPrivacy = map[RoomTable.columnPeerPrivacy] == null
            ? null
            : UserPrivacy.fromMap(
                jsonDecode(map[RoomTable.columnPeerPrivacy] as String)
                    as Map<String, dynamic>,
              ),
        lastMessage = map[MessageTable.columnMessageType] == null
            ? VEmptyMessage()
            : MessageFactory.createBaseMessage(map),
        annonce = map[RoomTable.columnAnnonce] == null
            ? null
            : Annonces.fromMap(
                jsonDecode(map[RoomTable.columnAnnonce] as String)
                    as Map<String, dynamic>,
              );

  Map<String, dynamic> toLocalMap() {
    return {
      RoomTable.columnId: id,
      RoomTable.columnTitle: title,
      RoomTable.columnTransTo: transTo,
      RoomTable.columnThumbImage: thumbImage,
      RoomTable.columnMentionsCount: mentionsCount,
      RoomTable.columnEnTitle: enTitle,
      RoomTable.columnPeerPrivacy:
          peerPrivacy == null ? null : jsonEncode(peerPrivacy!.toMap()),
      RoomTable.columnRoomType: roomType.name,
      RoomTable.columnIsArchived: isArchived ? 1 : 0,
      RoomTable.columnUnReadCount: unReadCount,
      RoomTable.columnCreatedAt: createdAt.toUtc().toIso8601String(),
      RoomTable.columnIsMuted: isMuted ? 1 : 0,
      RoomTable.columnIsOneSeen: isOneSeen ? 1 : 0,
      RoomTable.columnNickName: nickName,
      RoomTable.columnPeerId: peerId,
      RoomTable.columnAnnonce:
          annonce == null ? null : jsonEncode(annonce!.toMap()),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VRoom && runtimeType == other.runtimeType && id == other.id);

  @override
  int get hashCode => id.hashCode;

  DateTime get lastMessageTime => lastMessage.createdAtDate;

  @override
  String toString() {
    return 'BaseRoom{id: $id, title: $title, enTitle: $enTitle,transTo $transTo , thumbImage: $thumbImage, roomType: $roomType, isArchived: $isArchived, unReadCount: $unReadCount, lastMessage: $lastMessage, isDeleted: $isDeleted, createdAt: $createdAt,}';
  }

  ///getters
  bool get isRoomMuted {
    final current = this;
    if (roomType.isSingle) {
      return current.isMuted;
    }
    if (roomType.isGroup) {
      return current.isMuted;
    }
    return false;
  }

  bool get isCta => roomType == VRoomType.a;

  bool get isTransEnable => transTo != null;

  // String? roomTypingText(BuildContext context) {
  //   final current = this;
  //   if (roomType.isSingle) {
  //     return current.typingStatus.inSingleText(context);
  //   }
  //   if (roomType.isGroup) {
  //     return current.typingStatus.inGroupText(context);
  //   }
  //   return null;
  // }

  bool get isRoomOnline {
    final current = this;
    if (roomType.isSingle) {
      return current.isOnline;
    }
    return false;
  }

  bool get isRoomUnread => unReadCount != 0;

  // bool get isThereBlock => blockerId != null;
  //
  // bool get isMeBlocker {
  //   if (blockerId == null) return false;
  //   return VAppConstants.myProfile.baseUser.vChatId == blockerId;
  // }

  String get lastMessageTimeString => DateFormat.jm(
        Localizations.localeOf(VChatController.I.navigationContext)
            .languageCode,
      ).format(lastMessage.createdAtDate);

  void toggleSelect() {
    isSelected = !isSelected;
  }

  VRoom copyWith({
    String? id,
    String? title,
    String? enTitle,
    String? thumbImage,
    VRoomType? roomType,
    bool? isArchived,
    int? unReadCount,
    VBaseMessage? lastMessage,
    bool? isDeleted,
    DateTime? createdAt,
    bool? isMuted,
    int? mentionsCount,
    UserPrivacy? peerPrivacy,
    bool? isOneSeen,
    bool? isOnline,
    VSocketRoomTypingModel? typingStatus,
    String? nickName,
    String? transTo,
    String? peerId,
    String? blockerId,
    Annonces? annonce,
  }) {
    return VRoom(
      id: id ?? this.id,
      peerId: peerId ?? this.peerId,
      title: title ?? this.title,
      peerPrivacy: peerPrivacy ?? this.peerPrivacy,
      isOneSeen: isOneSeen ?? this.isOneSeen,
      enTitle: enTitle ?? this.enTitle,
      transTo: transTo ?? this.transTo,
      thumbImage: thumbImage ?? this.thumbImage,
      roomType: roomType ?? this.roomType,
      isArchived: isArchived ?? this.isArchived,
      unReadCount: unReadCount ?? this.unReadCount,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      isMuted: isMuted ?? this.isMuted,
      isOnline: isOnline ?? this.isOnline,
      typingStatus: typingStatus ?? this.typingStatus,
      nickName: nickName ?? this.nickName,
      mentionsCount: mentionsCount ?? this.mentionsCount,
      annonce: annonce ?? this.annonce,
    );
  }
}
