// import 'dart:async';
//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:stop_watch_timer/stop_watch_timer.dart';
// import 'package:super_up_core/super_up_core.dart';
//
// import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';
//
// class AgoraCallListener extends ValueNotifier<RTCState> {
//   AgoraCallListener(this.dto) : super(RTCState());
//   final VCallDto dto;
//
//   late BuildContext context;
//   final _agoraEngine = createAgoraRtcEngine();
//   late final RtcEngineEventHandler _eventHandler;
//
//   String get channelName => dto.roomId;
//
//   int get userLength => value.users.length;
//
//   StreamSubscription? callStream;
//
//   bool get _callerIsVideoEnable => dto.isVideoEnable;
//
//   final stopWatchTimer = StopWatchTimer();
//
//   final _videoConfig = const VideoEncoderConfiguration(
//     orientationMode: OrientationMode.orientationModeAdaptive,
//   );
//
//   Future<void> _initializeAgora() async {
//     // Set aspect ratio for video according to platform
//
//     await _initAgoraRtcEngine();
//     _addAgoraEventHandlers();
//     if (_callerIsVideoEnable) {
//       await _agoraEngine.enableVideo();
//       await _agoraEngine.startPreview();
//     }
//
//     // // Join the channel
//     final userToken = await VChatController.I.nativeApi.remote.calls
//         .getAgoraAccess(channelName);
//     if (_callerIsVideoEnable) {
//       value.isVideoEnabled = true;
//       await _agoraEngine.setVideoEncoderConfiguration(_videoConfig);
//       value.isSpeakerEnabled = true;
//     }
//     // Join the channel
//     await _agoraEngine.joinChannel(
//       token: userToken,
//       channelId: channelName,
//       uid: 0,
//       options: ChannelMediaOptions(
//         autoSubscribeVideo: true,
//         autoSubscribeAudio: true,
//         clientRoleType: ClientRoleType.clientRoleBroadcaster,
//         publishCameraTrack: dto.isVideoEnable,
//         publishMicrophoneTrack: true,
//       ),
//     );
//
//     if (dto.isCaller) createCall();
//     if (dto.meetId != null) _acceptCall();
//   }
//
//   Future<void> _onCallEnd() async {
//     await _agoraEngine.leaveChannel();
//     _agoraEngine.release();
//     endCallApi();
//   }
//
//   Future<void> _initAgoraRtcEngine() async {
//     try {
//       await _agoraEngine.initialize(
//         const RtcEngineContext(
//           appId: SConstants.agoraAppId,
//         ),
//       );
//       await _agoraEngine
//           .setChannelProfile(ChannelProfileType.channelProfileCommunication);
//     } catch (err) {
//       print(err);
//       VAppAlert.showErrorSnackBar(
//         message: "$err",
//         context: context,
//       );
//     }
//   }
//
//   Future<void> _addAgoraEventHandlers() async {
//     _eventHandler = RtcEngineEventHandler(
//       onError: (code, String msg) {
//         final info = 'LOG::onError: $code Message is  $msg';
//         debugPrint(info);
//       },
//
//       ///Indicates that the local user has successfully joined the channel.
//       onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
//         final info =
//             'LOG::onJoinChannel: ${connection.channelId}, uid: ${connection.localUid}';
//         debugPrint(info);
//         value.currentUid = connection.localUid;
//         await _agoraEngine.enableAudio();
//         await _agoraEngine.muteLocalAudioStream(false);
//         await _agoraEngine.muteLocalVideoStream(!_callerIsVideoEnable);
//
//         if (_callerIsVideoEnable) {
//           value.isVideoEnabled = true;
//           await _agoraEngine.setVideoEncoderConfiguration(_videoConfig);
//           await _agoraEngine.setEnableSpeakerphone(true);
//           value.isSpeakerEnabled = true;
//         }
//
//         final myUser = RTCUser(
//           uid: value.currentUid!,
//           isAudioEnabled: true,
//           isVideoEnabled: _callerIsVideoEnable,
//           view: AgoraVideoView(
//             controller: VideoViewController(
//               rtcEngine: _agoraEngine,
//               canvas: const VideoCanvas(
//                 uid: 0,
//               ),
//             ),
//           ),
//         );
//         value.users.add(myUser);
//         notifyListeners();
//       },
//       //for my mic is 100% works
//       onFirstLocalAudioFramePublished: (RtcConnection connection, int elapsed) {
//         final info = 'LOG::firstLocalAudio: $elapsed';
//         debugPrint(info);
//         for (final RTCUser user in value.users) {
//           if (user.uid == value.currentUid) {
//             user.isAudioEnabled = true;
//           }
//         }
//         notifyListeners();
//       },
//       //for my camera is 100% works
//       onFirstLocalVideoFrame: (
//         VideoSourceType source,
//         int width,
//         int height,
//         int elapsed,
//       ) {
//         debugPrint('LOG::firstLocalVideo');
//         for (final RTCUser user in value.users) {
//           if (user.uid == value.currentUid) {
//             user.isVideoEnabled = value.isVideoEnabled;
//
//             // Update the view
//             user.view = AgoraVideoView(
//               controller: VideoViewController(
//                 rtcEngine: _agoraEngine,
//                 canvas: const VideoCanvas(
//                   uid: 0, // Use 0 for local video
//                 ),
//               ),
//             );
//           }
//         }
//         notifyListeners();
//       },
//       //called when i call the leave channel api
//       onLeaveChannel: (RtcConnection connection, RtcStats stats) {
//         debugPrint('LOG::onLeaveChannel');
//         value.users.clear();
//         notifyListeners();
//       },
//
//       ///new remote user has been joined!
//       onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//         final info = 'LOG::userJoined: $remoteUid';
//         debugPrint(info);
//         value.users.add(
//           RTCUser(
//             uid: remoteUid,
//             view: AgoraVideoView(
//               controller: VideoViewController.remote(
//                 rtcEngine: _agoraEngine,
//                 canvas: VideoCanvas(uid: remoteUid),
//                 connection: RtcConnection(
//                   channelId: channelName,
//                   localUid: value.currentUid!,
//                 ),
//               ),
//             ),
//           ),
//         );
//
//         notifyListeners();
//       },
//       onUserOffline: (RtcConnection connection, int remoteUid,
//           UserOfflineReasonType reason) {
//         final info = 'LOG::userOffline: $remoteUid';
//         debugPrint(info);
//         RTCUser? userToRemove;
//         for (final RTCUser user in value.users) {
//           if (user.uid == remoteUid) {
//             userToRemove = user;
//           }
//         }
//         value.users.remove(userToRemove);
//         notifyListeners();
//       },
//       onFirstRemoteAudioFrame:
//           (RtcConnection connection, int userId, int elapsed) {
//         final info = 'LOG::firstRemoteAudio: $userId';
//         debugPrint(info);
//         for (final RTCUser user in value.users) {
//           if (user.uid == userId) {
//             user.isAudioEnabled = true;
//           }
//         }
//         notifyListeners();
//       },
//       onFirstRemoteVideoFrame: (RtcConnection connection, int remoteUid,
//           int width, int height, int elapsed) {
//         final info = 'LOG::firstRemoteVideo: $remoteUid ${width}x $height';
//         debugPrint(info);
//         for (final RTCUser user in value.users) {
//           if (user.uid == remoteUid) {
//             user
//               ..isVideoEnabled = true
//               ..view = AgoraVideoView(
//                 controller: VideoViewController.remote(
//                   rtcEngine: _agoraEngine,
//                   canvas: VideoCanvas(
//                     uid: remoteUid,
//                   ),
//                   connection: connection,
//                 ),
//               );
//           }
//         }
//         notifyListeners();
//       },
//       onRemoteVideoStateChanged: (RtcConnection connection, int remoteUid,
//           RemoteVideoState state, RemoteVideoStateReason reason, int elapsed) {
//         final info = 'LOG::remoteVideoStateChanged: $remoteUid $state $reason';
//         debugPrint(info);
//         for (final RTCUser user in value.users) {
//           if (user.uid == remoteUid) {
//             user.isVideoEnabled =
//                 state != RemoteVideoState.remoteVideoStateStopped;
//           }
//         }
//         notifyListeners();
//       },
//       onTokenPrivilegeWillExpire: (connection, token) {
//         final info =
//             'LOG::onTokenPrivilegeWillExpire: $connection token $token ';
//         debugPrint(info);
//       },
//       onRemoteAudioStateChanged: (RtcConnection connection, int remoteUid,
//           RemoteAudioState state, RemoteAudioStateReason reason, int elapsed) {
//         final info = 'LOG::remoteAudioStateChanged: $remoteUid $state $reason';
//         debugPrint(info);
//         for (final RTCUser user in value.users) {
//           if (user.uid == remoteUid) {
//             user.isAudioEnabled =
//                 state != RemoteAudioState.remoteAudioStateStopped;
//           }
//         }
//         notifyListeners();
//       },
//     );
//     _agoraEngine.registerEventHandler(
//       _eventHandler,
//     );
//   }
//
//   void onToggleCamera() {
//     value.isVideoEnabled = !value.isVideoEnabled;
//     for (final RTCUser user in value.users) {
//       if (user.uid == value.currentUid) {
//         user.isVideoEnabled = value.isVideoEnabled;
//       }
//     }
//     notifyListeners();
//     _agoraEngine.muteLocalVideoStream(!value.isVideoEnabled);
//   }
//
//   void onToggleMicrophone() {
//     value.isMicEnabled = !value.isMicEnabled;
//     for (final RTCUser user in value.users) {
//       if (user.uid == value.currentUid) {
//         user.isAudioEnabled = value.isMicEnabled;
//       }
//     }
//
//     notifyListeners();
//     _agoraEngine.muteLocalAudioStream(!value.isMicEnabled);
//   }
//
//   void onToggleSpeaker() {
//     value.isSpeakerEnabled = !value.isSpeakerEnabled;
//
//     notifyListeners();
//     _agoraEngine.setEnableSpeakerphone(value.isSpeakerEnabled);
//   }
//
//   void onSwitchCamera() => _agoraEngine.switchCamera();
//
//   Future<void> createCall() async {
//     try {
//       value.meetId = await VChatController.I.nativeApi.remote.calls.createCall(
//         roomId: dto.roomId,
//         withVideo: dto.isVideoEnable,
//       );
//     } catch (err) {
//       VAppAlert.showErrorSnackBar(message: err.toString(), context: context);
//       await Future.delayed(const Duration(milliseconds: 500));
//       context.pop();
//     }
//   }
//
//   ///call this once you want to end the call but it must be started
//   Future endCallApi() async {
//     final meetIdValue = dto.meetId ?? value.meetId;
//     if (meetIdValue == null) return;
//     await vSafeApiCall<bool>(
//       request: () async {
//         return VChatController.I.nativeApi.remote.calls.endCallV2(meetIdValue);
//       },
//       onSuccess: (_) {},
//       onError: (exception, trace) async {},
//     );
//   }
//
//   void _addListeners() {
//     callStream = VChatController.I.nativeApi.streams.callStream.listen(
//       (e) async {
//         if (e is VCallAcceptedEvent) {
//           value.status = VRTCStatus.accepted;
//           notifyListeners();
//           stopWatchTimer.onStartTimer();
//           return;
//         }
//         if (e is VCallTimeoutEvent) {
//           value.status = VRTCStatus.timeout;
//           notifyListeners();
//           context.pop();
//           return;
//         }
//         if (e is VCallEndedEvent) {
//           value.status = VRTCStatus.callEnd;
//           notifyListeners();
//           if (context.mounted) {
//             context.pop();
//           }
//           return;
//         }
//         if (e is VCallRejectedEvent) {
//           value.status = VRTCStatus.rejected;
//           notifyListeners();
//           context.pop();
//           return;
//         }
//       },
//     );
//   }
//
//   Future<void> _acceptCall() async {
//     await VChatController.I.nativeApi.remote.calls.acceptCall(
//       meetId: dto.meetId!,
//     );
//     stopWatchTimer.onStartTimer();
//
//     value.status = VRTCStatus.accepted;
//     notifyListeners();
//   }
//
//   @override
//   Future<void> dispose() async {
//     stopWatchTimer.dispose();
//     WakelockPlus.disable();
//     callStream?.cancel();
//     await _onCallEnd();
//     super.dispose();
//   }
// }
