// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:super_up_core/super_up_core.dart';

class PeerProfileModel {
  final SSearchUser searchUser;
  final String lastSeenAt;
  final bool isMeBanner;
  final bool isPeerBanner;
  final bool isOnline;
  final String? roomId;
  final UserPrivacy userPrivacy;

//<editor-fold desc="Data Methods">
  const PeerProfileModel({
    required this.searchUser,
    required this.isOnline,
    required this.lastSeenAt,
    required this.isMeBanner,
    required this.isPeerBanner,
    required this.userPrivacy,
    required this.roomId,
  });

  bool get getIsThereBan => isMeBanner || isPeerBanner;

  PeerProfileModel copyWith({
    SSearchUser? searchUser,
    String? lastSeenAt,
    UserPrivacy? userPrivacy,
    bool? isMeBanner,
    bool? isOnline,
    bool? isPeerBanner,
    String? roomId,
  }) {
    return PeerProfileModel(
      searchUser: searchUser ?? this.searchUser,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      isMeBanner: isMeBanner ?? this.isMeBanner,
      userPrivacy: userPrivacy ?? this.userPrivacy,
      isOnline: isOnline ?? this.isOnline,
      isPeerBanner: isPeerBanner ?? this.isPeerBanner,
      roomId: roomId ?? this.roomId,
    );
  }

  factory PeerProfileModel.fromMap(Map<String, dynamic> map) {
    return PeerProfileModel(
      searchUser: SSearchUser.fromMap(map),
      lastSeenAt: map['lastSeenAt'] as String,
      isMeBanner: map['isMeBanner'] as bool,
      userPrivacy:
          UserPrivacy.fromMap(map['userPrivacy'] as Map<String, dynamic>),
      isOnline: map['isOnline'] as bool,
      isPeerBanner: map['isPeerBanner'] as bool,
      roomId: map['roomId'] == "" ? null : map['roomId'] as String?,
    );
  }

//</editor-fold>
}
