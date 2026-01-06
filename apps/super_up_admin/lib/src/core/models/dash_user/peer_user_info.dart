// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:super_up_admin/src/core/models/dash_user/user_device.dart';
import 'package:super_up_admin/src/core/models/dash_user/user_report.dart';

import '../admin.dart';

class PeerUserInfo {
  final DashUser user;
  final List<UserDevice> userDevices;
  final RoomCounter roomCounter;
  final MessagesCounter messagesCounter;
  final List<Country> userCountries;
  final List<UserReport> userReports;

  PeerUserInfo({
    required this.user,
    required this.userDevices,
    required this.roomCounter,
    required this.messagesCounter,
    required this.userCountries,
    required this.userReports,
  });

  PeerUserInfo.init()
      : user = DashUser.empty(),
        userDevices = [],
        roomCounter = RoomCounter.empty(),
        messagesCounter = MessagesCounter.empty(),
        userCountries = [],
        userReports = [];

  factory PeerUserInfo.fromMap(Map<String, dynamic> map) {
    return PeerUserInfo(
      user: DashUser.fromMap(map['userInfo']),
      userDevices: List<UserDevice>.from(
        map['userDevices'].map((x) => UserDevice.fromJson(x)),
      ),
      roomCounter: RoomCounter.fromMap(map['chats']['roomCounter']),
      messagesCounter: MessagesCounter.fromMap(map['chats']['messagesCounter']),
      userReports: (map['userReports'] as List)
          .map((e) => UserReport.fromMap(e))
          .toList(),
      userCountries: (map['userCountries'] as List)
          .map((e) => Country.fromMap(e))
          .toList(),
    );
  }
}
