// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/src/utils/enums.dart';

/// Represents a record of a single video call in the VChat application.
class VCallHistory {
  final String id;
  final SBaseUser caller;
  final VCallStatus callStatus;
  final CallGroupData? callGroupData;
  final VRoomType roomType;
  final bool withVideo;

  final DateTime? endAt;
  final DateTime createdAt;

  VCallHistory({
    required this.id,
    required this.caller,
    required this.callStatus,
    this.callGroupData,
    required this.roomType,
    required this.withVideo,
    this.endAt,
    required this.createdAt,
  });

  factory VCallHistory.fromJson(Map<String, dynamic> json) {
    return VCallHistory(
      id: json['_id'] as String,
      caller: SBaseUser.fromMap(json['caller'] as Map<String, dynamic>),
      callStatus: VCallStatus.values.byName(json['callStatus'] as String),
      callGroupData: json['roomId'] != null
          ? CallGroupData.fromMap(json['roomId'] as Map<String, dynamic>)
          : null,
      roomType: VRoomType.values.byName(json['roomType'] as String),
      withVideo: json['withVideo'] as bool,
      endAt: json['endAt'] != null
          ? DateTime.parse(json['endAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  String get getTitle {
    if (roomType == VRoomType.g) {
      return "${caller.fullName} :${callGroupData?.gName}";
    }
    return caller.fullName;
  }

  String get getImage {
    if (roomType == VRoomType.g) {
      return callGroupData!.gImg;
    }
    return caller.userImage;
  }

  String? get duration {
    if (endAtDate == null) return null;
    return endAtDate!.difference(startAtDate).inMinutes.toString();
  }

  DateTime get startAtDate => createdAt.toLocal();

  DateTime? get endAtDate => endAt?.toLocal();

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'caller': caller.toMap(),
      'callStatus': callStatus.name,
      'roomId': callGroupData?.toJson(),
      'roomType': roomType.name,
      'withVideo': withVideo,
      'endAt': endAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class CallGroupData {
  final String id;
  final String gName;
  final String gImg;
  final DateTime createdAt;

  CallGroupData({
    required this.id,
    required this.gName,
    required this.gImg,
    required this.createdAt,
  });

  factory CallGroupData.fromMap(Map<String, dynamic> json) {
    return CallGroupData(
      id: json['_id'] as String,
      gName: json['gName'] as String,
      gImg: json['gImg'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'gName': gName,
      'gImg': gImg,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
