// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class UserData {
  final int totalUsersCount;
  final int deleted;
  final int banned;
  final int allVerifiedUsersCount;
  final Map<String, int> userStatusCounter;
  final int online;

  UserData({
    required this.totalUsersCount,
    required this.deleted,
    required this.banned,
    required this.allVerifiedUsersCount,
    required this.userStatusCounter,
    required this.online,
  });

  UserData.empty()
      : totalUsersCount = 0,
        deleted = 0,
        banned = 0,
        allVerifiedUsersCount = 0,
        userStatusCounter = {},
        online = 0;

  Map<String, dynamic> toMap() {
    return {
      'totalUsersCount': totalUsersCount,
      'deleted': deleted,
      'banned': banned,
      'allVerifiedUsersCount': allVerifiedUsersCount,
      'userStatusCounter': userStatusCounter,
      'online': online,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      totalUsersCount: map['totalUsersCount'],
      deleted: map['deleted'],
      banned: map['banned'],
      allVerifiedUsersCount: map['allVerifiedUsersCount'],
      userStatusCounter: Map<String, int>.from(map['userStatusCounter']),
      online: map['online'],
    );
  }
}

class UserDevices {
  final int all;
  final int web;
  final int ios;
  final int mac;
  final int windows;
  final int linux;
  final int android;
  final int other;

  UserDevices({
    required this.all,
    required this.web,
    required this.ios,
    required this.mac,
    required this.windows,
    required this.linux,
    required this.android,
    required this.other,
  });

  UserDevices.empty()
      : all = 0,
        web = 0,
        ios = 0,
        mac = 0,
        windows = 0,
        linux = 0,
        android = 0,
        other = 0;

  Map<String, dynamic> toMap() {
    return {
      'all': all,
      'web': web,
      'ios': ios,
      'mac': mac,
      'windows': windows,
      'linux': linux,
      'android': android,
      'other': other,
    };
  }

  factory UserDevices.fromMap(Map<String, dynamic> map) {
    return UserDevices(
      all: map['all'],
      web: map['web'],
      ios: map['ios'],
      mac: map['mac'],
      windows: map['windows'],
      linux: map['linux'],
      android: map['android'],
      other: map['other'],
    );
  }
}

class Statistics {
  final int visits;
  final int iosVisits;
  final int androidVisits;
  final int webVisits;
  final int otherVisits;

  Statistics({
    required this.visits,
    required this.iosVisits,
    required this.androidVisits,
    required this.webVisits,
    required this.otherVisits,
  });

  Statistics.empty()
      : visits = 0,
        iosVisits = 0,
        androidVisits = 0,
        webVisits = 0,
        otherVisits = 0;

  Map<String, dynamic> toMap() {
    return {
      'visits': visits,
      'iosVisits': iosVisits,
      'androidVisits': androidVisits,
      'webVisits': webVisits,
      'otherVisits': otherVisits,
    };
  }

  factory Statistics.fromMap(Map<String, dynamic> map) {
    return Statistics(
      visits: map['visits'],
      iosVisits: map['iosVisits'],
      androidVisits: map['androidVisits'],
      webVisits: map['webVisits'],
      otherVisits: map['otherVisits'],
    );
  }
}

class Country {
  final String id;
  final String code;
  final String emoji;
  final String unicode;
  final String name;
  final String image;

  Country({
    required this.id,
    required this.code,
    required this.emoji,
    required this.unicode,
    required this.name,
    required this.image,
  });

  Country.empty()
      : id = "",
        code = "",
        emoji = "",
        unicode = "",
        name = "",
        image = "";

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'code': code,
      'emoji': emoji,
      'unicode': unicode,
      'name': name,
      'image': image,
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      id: map['_id'],
      code: map['code'],
      emoji: map['emoji'],
      unicode: map['unicode'],
      name: map['name'],
      image: map['image'],
    );
  }
}

class UserCountries {
  final int count;
  final Country country;

  UserCountries({
    required this.count,
    required this.country,
  });

  UserCountries.empty()
      : count = 0,
        country = Country.empty();

  Map<String, dynamic> toMap() {
    return {
      'count': count,
      'country': country.toMap(),
    };
  }

  factory UserCountries.fromMap(Map<String, dynamic> map) {
    return UserCountries(
      count: map['count'],
      country: Country.fromMap(map['country']),
    );
  }
}

class MessagesCounter {
  final int messages;
  final int textMessages;
  final int imageMessages;
  final int videoMessages;
  final int voiceMessages;
  final int fileMessages;
  final int infoMessages;
  final int callMessages;
  final int voiceCallMessages;
  final int videoCallMessages;
  final int locationMessages;
  final int allDeletedMessages;

  MessagesCounter({
    required this.messages,
    required this.textMessages,
    required this.imageMessages,
    required this.voiceCallMessages,
    required this.videoCallMessages,
    required this.videoMessages,
    required this.voiceMessages,
    required this.fileMessages,
    required this.infoMessages,
    required this.callMessages,
    required this.locationMessages,
    required this.allDeletedMessages,
  });

  MessagesCounter.empty()
      : messages = 0,
        textMessages = 0,
        imageMessages = 0,
        videoMessages = 0,
        voiceMessages = 0,
        fileMessages = 0,
        infoMessages = 0,
        videoCallMessages = 0,
        voiceCallMessages = 0,
        callMessages = 0,
        locationMessages = 0,
        allDeletedMessages = 0;

  Map<String, dynamic> toMap() {
    return {
      'messages': messages,
      'textMessages': textMessages,
      'imageMessages': imageMessages,
      'videoMessages': videoMessages,
      'voiceMessages': voiceMessages,
      'fileMessages': fileMessages,
      'videoCallMessages': videoCallMessages,
      'voiceCallMessages': voiceCallMessages,
      'infoMessages': infoMessages,
      'callMessages': callMessages,
      'locationMessages': locationMessages,
      'allDeletedMessages': allDeletedMessages,
    };
  }

  factory MessagesCounter.fromMap(Map<String, dynamic> map) {
    return MessagesCounter(
      messages: map['messages'],
      textMessages: map['textMessages'],
      imageMessages: map['imageMessages'],
      videoMessages: map['videoMessages'],
      voiceMessages: map['voiceMessages'],
      voiceCallMessages: map['voiceCallMessages'],
      videoCallMessages: map['videoCallMessages'],
      fileMessages: map['fileMessages'],
      infoMessages: map['infoMessages'],
      callMessages: map['callMessages'],
      locationMessages: map['locationMessages'],
      allDeletedMessages: map['allDeletedMessages'],
    );
  }
}

class RoomCounter {
  final int single;
  final int order;
  final int group;
  final int broadcast;
  final int total;

  RoomCounter({
    required this.single,
    required this.order,
    required this.group,
    required this.broadcast,
    required this.total,
  });

  RoomCounter.empty()
      : single = 0,
        order = 0,
        group = 0,
        total = 0,
        broadcast = 0;

  Map<String, dynamic> toMap() {
    return {
      'single': single,
      'order': order,
      'group': group,
      'total': total,
      'broadcast': broadcast,
    };
  }

  factory RoomCounter.fromMap(Map<String, dynamic> map) {
    return RoomCounter(
      single: map['single'],
      order: map['order'],
      total: map['total'],
      group: map['group'],
      broadcast: map['broadcast'],
    );
  }
}

class MainDashBoardModel {
  final UserData usersData;
  final UserDevices usersDevices;
  final Statistics statistics;
  final List<UserCountries> usersCountries;
  final MessagesCounter messagesCounter;
  final RoomCounter roomCounter;

  MainDashBoardModel({
    required this.usersData,
    required this.usersDevices,
    required this.statistics,
    required this.usersCountries,
    required this.messagesCounter,
    required this.roomCounter,
  });

  MainDashBoardModel.empty()
      : usersData = UserData.empty(),
        usersDevices = UserDevices.empty(),
        statistics = Statistics.empty(),
        usersCountries = [],
        messagesCounter = MessagesCounter.empty(),
        roomCounter = RoomCounter.empty();

  Map<String, dynamic> toMap() {
    return {
      'usersData': usersData.toMap(),
      'usersDevices': usersDevices.toMap(),
      'statistics': statistics.toMap(),
      'usersCountries': usersCountries.map((uc) => uc.toMap()).toList(),
      'messagesCounter': messagesCounter.toMap(),
      'roomCounter': roomCounter.toMap(),
    };
  }

  factory MainDashBoardModel.fromMap(Map<String, dynamic> map) {
    return MainDashBoardModel(
      usersData: UserData.fromMap(map['usersData']),
      usersDevices: UserDevices.fromMap(map['usersDevices']),
      statistics: Statistics.fromMap(map['statistics']),
      usersCountries: List<UserCountries>.from(
          map['usersCountries'].map((uc) => UserCountries.fromMap(uc))),
      messagesCounter: MessagesCounter.fromMap(map['messagesCounter']),
      roomCounter: RoomCounter.fromMap(map['roomCounter']),
    );
  }
}
