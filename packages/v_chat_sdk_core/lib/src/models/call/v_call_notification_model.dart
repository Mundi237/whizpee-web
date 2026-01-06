import 'package:enum_to_string/enum_to_string.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/src/utils/enums.dart';

class VCallNotificationModel {
  final String callId;
  final String userName;
  final String roomId;
  final String userImage;
  final bool withVideo;
  final VRoomType roomType;
  final VCallStatus callStatus;
  final String? groupName;

//<editor-fold desc="Data Methods">
  const VCallNotificationModel({
    required this.callId,
    required this.userName,
    required this.userImage,
    required this.withVideo,
    required this.roomId,
    required this.roomType,
    required this.callStatus,
    this.groupName,
  });

  @override
  String toString() {
    return 'VCallNotificationModel{callId: $callId, userName: $userName, roomId: $roomId, userImage: $userImage, withVideo: $withVideo, roomType: $roomType, callStatus: $callStatus, groupName: $groupName}';
  }
  String get userImageS3 => SConstants.baseMediaUrl + userImage;
  Map<String, dynamic> toMap() {
    return {
      'callId': callId,
      'userName': userName,
      'userImage': userImage,
      'roomId': roomId,
      'withVideo': withVideo,
      'roomType': roomType.name,
      'callStatus': callStatus.name,
      'groupName': groupName,
    };
  }

  factory VCallNotificationModel.fromMap(Map<String, dynamic> map) {
    return VCallNotificationModel(
      callId: map['callId'] as String,
      userName: map['userName'] as String,
      roomId: map['roomId'] as String,
      userImage: map['userImage'] as String,
      withVideo: map['withVideo'] as bool,
      roomType: VRoomType.values.byName(map['roomType'] as String),
      callStatus: EnumToString.fromString(
              VCallStatus.values, map['callStatus'] as String) ??
          VCallStatus.serverRestart,
      groupName: map['groupName'] as String?,
    );
  }

//</editor-fold>
}
