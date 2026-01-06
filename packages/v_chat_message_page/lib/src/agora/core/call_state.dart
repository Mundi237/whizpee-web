import 'package:flutter/cupertino.dart';

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class CallState {
  VCallStatus status = VCallStatus.ring;
  String? callId;
  bool isMicEnabled = true;
  bool isSpeakerEnabled = false;
  bool isVideoEnabled = false;
  //users
  final users = <AgoraUser>{};
  int? currentUid;
}

class AgoraUser {
  final int uid;
  String? name;
  bool? isAudioEnabled;
  bool? isVideoEnabled;
  Widget? view;

  AgoraUser({
    required this.uid,
    this.name,
    this.isAudioEnabled,
    this.isVideoEnabled,
    this.view,
  });

  @override
  String toString() {
    return 'AgoraUser{uid: $uid, name: $name, isAudioEnabled: $isAudioEnabled, isVideoEnabled: $isVideoEnabled }';
  }
}
