import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../v_chat_message_page.dart';
import '../../core/call_state.dart';

class VCallController extends ValueNotifier<CallState> {
  VCallController(this.dto) : super(CallState()) {
    _initializeAgora();
    _addListeners();
    unawaited(WakelockPlus.enable());
    CallKeepHandler.I.endCalls(null);
    _initForgroundService(dto);
  }

  final VCallDto dto;

  late BuildContext context;
  final _agoraEngine = createAgoraRtcEngine();
  late final RtcEngineEventHandler _eventHandler;
  final _audioPlayer = AudioPlayer();

  String get channelName => dto.roomId;

  int get userLength => value.users.length;

  StreamSubscription? callStream;

  bool get _callerIsVideoEnable => dto.isVideoEnable;

  final stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  Future<void> disposeRingPlayer() async {
    if (_audioPlayer.source != null) {
      await _audioPlayer.dispose();
    }
  }

  final _videoConfig = const VideoEncoderConfiguration(
    orientationMode: OrientationMode.orientationModeAdaptive,
  );

  Future<void> _initializeAgora() async {
    // Set aspect ratio for video according to platform

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    if (_callerIsVideoEnable) {
      await _agoraEngine.enableVideo();
      await _agoraEngine.startPreview();
    }

    // // Join the channel
    final userToken = await VChatController.I.nativeApi.remote.calls
        .getAgoraAccess(channelName);
    if (_callerIsVideoEnable) {
      value.isVideoEnabled = true;
      await _agoraEngine.setVideoEncoderConfiguration(_videoConfig);
      value.isSpeakerEnabled = true;
    }
    // Join the channel
    await _agoraEngine.joinChannel(
      token: userToken,
      channelId: channelName,
      uid: 0,
      options: ChannelMediaOptions(
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: dto.isVideoEnable,
        publishMicrophoneTrack: true,
      ),
    );

    if (dto.isCaller) createCall();
    if (dto.callId != null) _acceptCall();
  }

  Future<void> _onCallEnd() async {
    await _agoraEngine.leaveChannel();
    _agoraEngine.release();

    // End foreground service
    await VChatCallServiceIntegration.instance.endCall();

    endCallApi();
  }

  Future<void> _initAgoraRtcEngine() async {
    try {
      await _agoraEngine.initialize(
        const RtcEngineContext(
          appId: SConstants.agoraAppId,
        ),
      );
      await _agoraEngine
          .setChannelProfile(ChannelProfileType.channelProfileCommunication);
    } catch (err) {
      print(err);
      VAppAlert.showSuccessSnackBar(
        message: "$err",
        context: context,
      );
    }
  }

  Future<void> _addAgoraEventHandlers() async {
    _eventHandler = RtcEngineEventHandler(
      onError: (code, String msg) {
        final info = 'LOG::onError: $code Message is  $msg';
        debugPrint(info);
      },

      ///Indicates that the local user has successfully joined the channel.
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
        final info =
            'LOG::onJoinChannel: ${connection.channelId}, uid: ${connection.localUid}';
        debugPrint(info);
        value.currentUid = connection.localUid;
        await _agoraEngine.enableAudio();
        await _agoraEngine.muteLocalAudioStream(false);
        await _agoraEngine.muteLocalVideoStream(!_callerIsVideoEnable);

        if (_callerIsVideoEnable) {
          value.isVideoEnabled = true;
          await _agoraEngine.setVideoEncoderConfiguration(_videoConfig);
          await _agoraEngine.setEnableSpeakerphone(true);
          value.isSpeakerEnabled = true;
        }

        final myUser = AgoraUser(
          uid: value.currentUid!,
          isAudioEnabled: true,
          isVideoEnabled: _callerIsVideoEnable,
          view: AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: _agoraEngine,
              canvas: const VideoCanvas(
                uid: 0,
              ),
            ),
          ),
        );
        value.users.add(myUser);
        notifyListeners();
      },
      //for my mic is 100% works
      onFirstLocalAudioFramePublished: (RtcConnection connection, int elapsed) {
        final info = 'LOG::firstLocalAudio: $elapsed';
        debugPrint(info);
        for (AgoraUser user in value.users) {
          if (user.uid == value.currentUid) {
            user.isAudioEnabled = true;
          }
        }
        notifyListeners();
      },
      //for my camera is 100% works
      onFirstLocalVideoFrame: (
        VideoSourceType source,
        int width,
        int height,
        int elapsed,
      ) {
        debugPrint('LOG::firstLocalVideo');
        for (AgoraUser user in value.users) {
          if (user.uid == value.currentUid) {
            user.isVideoEnabled = value.isVideoEnabled;

            // Update the view
            user.view = AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: _agoraEngine,
                canvas: const VideoCanvas(
                  uid: 0, // Use 0 for local video
                ),
              ),
            );
          }
        }
        notifyListeners();
      },
      //called when i call the leave channel api
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        debugPrint('LOG::onLeaveChannel');
        value.users.clear();
        notifyListeners();
      },

      ///new remote user has been joined!
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        final info = 'LOG::userJoined: $remoteUid';
        debugPrint(info);
        value.users.add(
          AgoraUser(
            uid: remoteUid,
            view: AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: _agoraEngine,
                canvas: VideoCanvas(uid: remoteUid),
                connection: RtcConnection(
                  channelId: channelName,
                  localUid: value.currentUid!,
                ),
              ),
            ),
          ),
        );
        if (value.users.isNotEmpty) {
          disposeRingPlayer();
          if (!stopWatchTimer.isRunning) {
            stopWatchTimer.onStartTimer();
          }
          value.status = VCallStatus.inCall;

          // Notify foreground service that call is now connected
          VChatCallServiceIntegration.instance.onCallConnected();
        }
        notifyListeners();
      },
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        final info = 'LOG::userOffline: $remoteUid';
        debugPrint(info);
        AgoraUser? userToRemove;
        for (AgoraUser user in value.users) {
          if (user.uid == remoteUid) {
            userToRemove = user;
          }
        }
        value.users.remove(userToRemove);
        notifyListeners();
      },
      onFirstRemoteAudioFrame:
          (RtcConnection connection, int userId, int elapsed) {
        final info = 'LOG::firstRemoteAudio: $userId';
        debugPrint(info);
        for (AgoraUser user in value.users) {
          if (user.uid == userId) {
            user.isAudioEnabled = true;
          }
        }
        notifyListeners();
      },
      onFirstRemoteVideoFrame: (RtcConnection connection, int remoteUid,
          int width, int height, int elapsed) {
        final info = 'LOG::firstRemoteVideo: $remoteUid ${width}x $height';
        debugPrint(info);
        for (AgoraUser user in value.users) {
          if (user.uid == remoteUid) {
            user
              ..isVideoEnabled = true
              ..view = AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: _agoraEngine,
                  canvas: VideoCanvas(
                    uid: remoteUid,
                  ),
                  connection: connection,
                ),
              );
          }
        }
        notifyListeners();
      },
      onRemoteVideoStateChanged: (RtcConnection connection, int remoteUid,
          RemoteVideoState state, RemoteVideoStateReason reason, int elapsed) {
        final info = 'LOG::remoteVideoStateChanged: $remoteUid $state $reason';
        debugPrint(info);
        for (AgoraUser user in value.users) {
          if (user.uid == remoteUid) {
            user.isVideoEnabled =
                state != RemoteVideoState.remoteVideoStateStopped;
          }
        }
        notifyListeners();
      },
      onTokenPrivilegeWillExpire: (connection, token) {
        final info =
            'LOG::onTokenPrivilegeWillExpire: $connection token $token ';
        debugPrint(info);
      },
      onRemoteAudioStateChanged: (RtcConnection connection, int remoteUid,
          RemoteAudioState state, RemoteAudioStateReason reason, int elapsed) {
        final info = 'LOG::remoteAudioStateChanged: $remoteUid $state $reason';
        debugPrint(info);
        for (AgoraUser user in value.users) {
          if (user.uid == remoteUid) {
            user.isAudioEnabled =
                state != RemoteAudioState.remoteAudioStateStopped;
          }
        }
        notifyListeners();
      },
    );
    _agoraEngine.registerEventHandler(
      _eventHandler,
    );
  }

  void onToggleCamera() {
    value.isVideoEnabled = !value.isVideoEnabled;
    for (AgoraUser user in value.users) {
      if (user.uid == value.currentUid) {
        user.isVideoEnabled = value.isVideoEnabled;
      }
    }
    notifyListeners();
    _agoraEngine.muteLocalVideoStream(!value.isVideoEnabled);
  }

  void onToggleMicrophone() {
    value.isMicEnabled = !value.isMicEnabled;
    for (AgoraUser user in value.users) {
      if (user.uid == value.currentUid) {
        user.isAudioEnabled = value.isMicEnabled;
      }
    }

    notifyListeners();
    _agoraEngine.muteLocalAudioStream(!value.isMicEnabled);
  }

  void onToggleSpeaker() {
    value.isSpeakerEnabled = !value.isSpeakerEnabled;

    notifyListeners();
    _agoraEngine.setEnableSpeakerphone(value.isSpeakerEnabled);
  }

  void onSwitchCamera() => _agoraEngine.switchCamera();

  void createCall() async {
    try {
      playSoundWithInterval();
      value.callId = await VChatController.I.nativeApi.remote.calls.createCall(
        roomId: dto.roomId,
        withVideo: dto.isVideoEnable,
      );
    } catch (err) {
      VAppAlert.showSuccessSnackBar(message: err.toString(), context: context);
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pop(context);
    }
  }

  ///call this once you want to end the call but it must be started
  Future endCallApi() async {
    final meetIdValue = dto.callId ?? value.callId;
    if (meetIdValue == null) return;
    await vSafeApiCall<bool>(
      request: () async {
        return VChatController.I.nativeApi.remote.calls.endCallV2(meetIdValue);
      },
      onSuccess: (_) {},
      onError: (exception) async {},
    );
  }

  void _addListeners() {
    callStream = VChatController.I.nativeApi.streams.callStream.listen(
      (e) async {
        if (e is VCallAcceptedEvent) {
          value.status = VCallStatus.inCall;
          notifyListeners();
          stopWatchTimer.onStartTimer();
          return;
        }
        // if (e is VCallTimeoutEvent) {
        //   value.status = VCallStatus.timeout;
        //   notifyListeners();
        //   Navigator.pop(context);
        //   return;
        // }
        if (e is VCallEndedEvent) {
          value.status = VCallStatus.finished;
          notifyListeners();
          if (context.mounted) {
            Navigator.pop(context);
          }
          return;
        }
        if (e is VCallRejectedEvent) {
          value.status = VCallStatus.rejected;
          notifyListeners();
          Navigator.pop(context);

          return;
        }
      },
    );
  }

  void _acceptCall() async {
    await VChatController.I.nativeApi.remote.calls.acceptCall(
      callId: dto.callId!,
    );
    stopWatchTimer.onStartTimer();

    value.status = VCallStatus.inCall;
    notifyListeners();
  }

  @override
  void dispose() async {
    stopWatchTimer.dispose();
    WakelockPlus.disable();
    callStream?.cancel();
    await _onCallEnd();
    disposeRingPlayer();
    VChatCallServiceIntegration.instance.dispose();
    super.dispose();
  }

  Future<void> playSoundWithInterval() async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File(join(tempDir.path, 'temp_audio.mp3'));

    // Check if file exists
    if (!await tempFile.exists()) {
      // File doesn't exist, load from assets and save
      final bytes = await rootBundle
          .load('packages/v_chat_message_page/assets/dialing.mp3');
      final audioBytes = bytes.buffer.asUint8List();
      await tempFile.writeAsBytes(audioBytes);
    }

    await _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(DeviceFileSource(tempFile.path));
  }

  void _initForgroundService(VCallDto dto) async {
    await VChatCallServiceIntegration.instance.initialize();
    if (dto.isCaller) {
      // For outgoing calls, start service as dialing
      VChatCallServiceIntegration.instance.startOutgoingCall(
        callData: dto,
        callerName: dto.peerUser.fullName,
      );
    } else {
      // For incoming calls, start service as ringing
      VChatCallServiceIntegration.instance.startIncomingCall(
        callData: dto,
        callerName: dto.peerUser.fullName,
      );
    }
    // Note: onCallConnected() will be called when remote user actually joins
  }
}
