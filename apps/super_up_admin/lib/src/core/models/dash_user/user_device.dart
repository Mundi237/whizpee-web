// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class UserDevice {
  String id;
  String userDeviceId;
  String uId;
  String dIp;
  String platform;
  DateTime lastSeenAt;
  int visits;

  UserDevice({
    required this.id,
    required this.userDeviceId,
    required this.uId,
    required this.dIp,
    required this.platform,
    required this.lastSeenAt,
    required this.visits,
  });

  factory UserDevice.fromJson(Map<String, dynamic> json) {
    return UserDevice(
      id: json['_id'],
      userDeviceId: json['userDeviceId'],
      uId: json['uId'],
      dIp: json['dIp'],
      platform: json['platform'],
      lastSeenAt: DateTime.parse(json['lastSeenAt']),
      visits: json['visits'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userDeviceId': userDeviceId,
      'uId': uId,
      'dIp': dIp,
      'platform': platform,
      'lastSeenAt': lastSeenAt.toIso8601String(),
      'visits': visits,
    };
  }
}
