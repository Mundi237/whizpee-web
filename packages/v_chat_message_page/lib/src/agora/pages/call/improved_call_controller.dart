// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

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

import '../../core/improved_call_state.dart';

/// Result wrapper for better error handling
class CallResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const CallResult.success(this.data)
      : error = null,
        isSuccess = true;

  const CallResult.failure(this.error)
      : data = null,
        isSuccess = false;
}

/// Service for handling audio playback during calls
class CallAudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  Future<CallResult<void>> playRingtone() async {
    try {
      if (_isPlaying) return const CallResult.success(null);

      final tempDir = await getTemporaryDirectory();
      final tempFile = File(join(tempDir.path, 'temp_audio.mp3'));

      if (!await tempFile.exists()) {
        final bytes = await rootBundle
            .load('packages/v_chat_message_page/assets/dialing.mp3');
        final audioBytes = bytes.buffer.asUint8List();
        await tempFile.writeAsBytes(audioBytes);
      }

      await _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(DeviceFileSource(tempFile.path));

      _isPlaying = true;
      return const CallResult.success(null);
    } catch (e) {
      return CallResult.failure('Failed to play ringtone: $e');
    }
  }

  Future<CallResult<void>> stopRingtone() async {
    try {
      if (!_isPlaying) return const CallResult.success(null);

      await _audioPlayer.stop();
      _isPlaying = false;
      return const CallResult.success(null);
    } catch (e) {
      return CallResult.failure('Failed to stop ringtone: $e');
    }
  }

  Future<void> dispose() async {
    await stopRingtone();
    await _audioPlayer.dispose();
  }
}

/// Service for managing Agora RTC Engine
class AgoraService {
  late final RtcEngine _engine;
  late final RtcEngineEventHandler _eventHandler;
  bool _isInitialized = false;

  static const _videoConfig = VideoEncoderConfiguration(
    orientationMode: OrientationMode.orientationModeAdaptive,
  );

  bool get isInitialized => _isInitialized;

  Future<CallResult<void>> initialize({
    required String appId,
    required RtcEngineEventHandler eventHandler,
  }) async {
    try {
      _engine = createAgoraRtcEngine();
      _eventHandler = eventHandler;

      await _engine.initialize(RtcEngineContext(appId: appId));
      await _engine
          .setChannelProfile(ChannelProfileType.channelProfileCommunication);
      _engine.registerEventHandler(_eventHandler);

      _isInitialized = true;
      return const CallResult.success(null);
    } catch (e) {
      return CallResult.failure('Failed to initialize Agora: $e');
    }
  }

  Future<CallResult<void>> joinChannel({
    required String token,
    required String channelId,
    required bool enableVideo,
    required bool enableAudio,
  }) async {
    try {
      if (!_isInitialized) {
        return const CallResult.failure('Agora not initialized');
      }

      if (enableVideo) {
        await _engine.enableVideo();
        await _engine.setVideoEncoderConfiguration(_videoConfig);
        await _engine.startPreview();
      }

      await _engine.enableAudio();

      await _engine.joinChannel(
        token: token,
        channelId: channelId,
        uid: 0,
        options: ChannelMediaOptions(
          autoSubscribeVideo: true,
          autoSubscribeAudio: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          publishCameraTrack: enableVideo,
          publishMicrophoneTrack: enableAudio,
        ),
      );

      return const CallResult.success(null);
    } catch (e) {
      return CallResult.failure('Failed to join channel: $e');
    }
  }

  Future<CallResult<void>> toggleVideo(bool enable) async {
    try {
      if (!_isInitialized) {
        return const CallResult.failure('Agora not initialized');
      }

      await _engine.muteLocalVideoStream(!enable);
      return const CallResult.success(null);
    } catch (e) {
      return CallResult.failure('Failed to toggle video: $e');
    }
  }

  Future<CallResult<void>> toggleAudio(bool enable) async {
    try {
      if (!_isInitialized) {
        return const CallResult.failure('Agora not initialized');
      }

      await _engine.muteLocalAudioStream(!enable);
      return const CallResult.success(null);
    } catch (e) {
      return CallResult.failure('Failed to toggle audio: $e');
    }
  }

  Future<CallResult<void>> toggleSpeaker(bool enable) async {
    try {
      if (!_isInitialized) {
        return const CallResult.failure('Agora not initialized');
      }

      await _engine.setEnableSpeakerphone(enable);
      return const CallResult.success(null);
    } catch (e) {
      return CallResult.failure('Failed to toggle speaker: $e');
    }
  }

  Future<CallResult<void>> switchCamera() async {
    try {
      if (!_isInitialized) {
        return const CallResult.failure('Agora not initialized');
      }

      await _engine.switchCamera();
      return const CallResult.success(null);
    } catch (e) {
      return CallResult.failure('Failed to switch camera: $e');
    }
  }

  Future<CallResult<void>> leaveChannel() async {
    try {
      if (!_isInitialized) {
        return const CallResult.success(null);
      }

      await _engine.leaveChannel();
      return const CallResult.success(null);
    } catch (e) {
      return CallResult.failure('Failed to leave channel: $e');
    }
  }

  Future<void> dispose() async {
    if (_isInitialized) {
      await leaveChannel();
      _engine.release();
      _isInitialized = false;
    }
  }
}

/// Improved Call Controller with better separation of concerns
class ImprovedVCallController extends ValueNotifier<ImprovedCallState> {
  ImprovedVCallController(this._callData) : super(ImprovedCallState.initial()) {
    _initialize();
  }

  final VCallDto _callData;
  final AgoraService _agoraService = AgoraService();
  final CallAudioService _audioService = CallAudioService();

  late BuildContext context;
  StreamSubscription? _callStreamSubscription;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  // Getters
  String get channelName => _callData.roomId;
  int get userCount => value.users.length;
  bool get isVideoCall => _callData.isVideoEnable;
  StopWatchTimer get stopWatchTimer => _stopWatchTimer;

  Future<void> _initialize() async {
    try {
      // Enable wakelock to prevent screen from sleeping
      await WakelockPlus.enable();

      // End any existing calls
      CallKeepHandler.I.endCalls(null);

      // Initialize services
      await _initializeAgora();
      _subscribeToCallEvents();
    } catch (e) {
      _handleError('Initialization failed: $e');
    }
  }

  Future<void> _initializeAgora() async {
    final eventHandler = RtcEngineEventHandler(
      onError: _handleAgoraError,
      onJoinChannelSuccess: _handleJoinChannelSuccess,
      onUserJoined: _handleUserJoined,
      onUserOffline: _handleUserOffline,
      onFirstLocalAudioFramePublished: _handleFirstLocalAudioFrame,
      onFirstLocalVideoFrame: _handleFirstLocalVideoFrame,
      onLeaveChannel: _handleLeaveChannel,
      onFirstRemoteAudioFrame: _handleFirstRemoteAudioFrame,
      onFirstRemoteVideoFrame: _handleFirstRemoteVideoFrame,
      onRemoteVideoStateChanged: _handleRemoteVideoStateChanged,
      onRemoteAudioStateChanged: _handleRemoteAudioStateChanged,
      onTokenPrivilegeWillExpire: _handleTokenExpiring,
    );

    final initResult = await _agoraService.initialize(
      appId: SConstants.agoraAppId,
      eventHandler: eventHandler,
    );

    if (!initResult.isSuccess) {
      throw Exception(initResult.error);
    }

    // Get access token and join channel
    final token = await VChatController.I.nativeApi.remote.calls
        .getAgoraAccess(channelName);

    final joinResult = await _agoraService.joinChannel(
      token: token,
      channelId: channelName,
      enableVideo: isVideoCall,
      enableAudio: true,
    );

    if (!joinResult.isSuccess) {
      throw Exception(joinResult.error);
    }

    // Set initial state
    value = value.copyWith(
      isVideoEnabled: isVideoCall,
      isSpeakerEnabled: isVideoCall,
    );

    // Handle call creation/acceptance
    if (_callData.isCaller) {
      await _createCall();
    } else if (_callData.callId != null) {
      await _acceptCall();
    }
  }

  void _subscribeToCallEvents() {
    _callStreamSubscription = VChatController.I.nativeApi.streams.callStream
        .listen(_handleCallEvent, onError: _handleStreamError);
  }

  void _handleCallEvent(dynamic event) {
    if (event is VCallAcceptedEvent) {
      _handleCallAccepted();
    } else if (event is VCallEndedEvent) {
      _handleCallEnded();
    } else if (event is VCallRejectedEvent) {
      _handleCallRejected();
    }
  }

  void _handleStreamError(dynamic error) {
    _handleError('Call stream error: $error');
  }

  // Agora Event Handlers
  void _handleAgoraError(ErrorCodeType code, String msg) {
    _handleError('Agora error $code: $msg');
  }

  void _handleJoinChannelSuccess(RtcConnection connection, int elapsed) async {
    value = value.copyWith(currentUid: connection.localUid);

    final localUser = AgoraUser(
      uid: connection.localUid!,
      isAudioEnabled: true,
      isVideoEnabled: isVideoCall,
      view: AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _agoraService._engine,
          canvas: const VideoCanvas(uid: 0),
        ),
      ),
    );

    value = value.copyWith(
      users: {...value.users, localUser},
    );
    notifyListeners();
  }

  void _handleUserJoined(RtcConnection connection, int remoteUid, int elapsed) {
    final remoteUser = AgoraUser(
      uid: remoteUid,
      view: AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _agoraService._engine,
          canvas: VideoCanvas(uid: remoteUid),
          connection: RtcConnection(
            channelId: channelName,
            localUid: value.currentUid!,
          ),
        ),
      ),
    );

    value = value.copyWith(
      users: {...value.users, remoteUser},
    );

    // Stop ringtone when someone joins
    _audioService.stopRingtone();

    // Start call timer if not already running
    if (!_stopWatchTimer.isRunning) {
      _stopWatchTimer.onStartTimer();
    }

    value = value.copyWith(status: VCallStatus.inCall);
    notifyListeners();
  }

  void _handleUserOffline(
      RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
    final updatedUsers =
        value.users.where((user) => user.uid != remoteUid).toSet();
    value = value.copyWith(users: updatedUsers);
    notifyListeners();
  }

  void _handleFirstLocalAudioFrame(RtcConnection connection, int elapsed) {
    _updateUserAudioStatus(value.currentUid!, true);
  }

  void _handleFirstLocalVideoFrame(
      VideoSourceType source, int width, int height, int elapsed) {
    _updateUserVideoStatus(value.currentUid!, value.isVideoEnabled);
  }

  void _handleLeaveChannel(RtcConnection connection, RtcStats stats) {
    value = value.copyWith(users: <AgoraUser>{});
    notifyListeners();
  }

  void _handleFirstRemoteAudioFrame(
      RtcConnection connection, int userId, int elapsed) {
    _updateUserAudioStatus(userId, true);
  }

  void _handleFirstRemoteVideoFrame(RtcConnection connection, int remoteUid,
      int width, int height, int elapsed) {
    _updateUserVideoStatus(remoteUid, true);

    // Update the user's video view
    final updatedUsers = value.users.map((user) {
      if (user.uid == remoteUid) {
        return user.copyWith(
          isVideoEnabled: true,
          view: AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: _agoraService._engine,
              canvas: VideoCanvas(uid: remoteUid),
              connection: connection,
            ),
          ),
        );
      }
      return user;
    }).toSet();

    value = value.copyWith(users: updatedUsers);
    notifyListeners();
  }

  void _handleRemoteVideoStateChanged(RtcConnection connection, int remoteUid,
      RemoteVideoState state, RemoteVideoStateReason reason, int elapsed) {
    final isVideoEnabled = state != RemoteVideoState.remoteVideoStateStopped;
    _updateUserVideoStatus(remoteUid, isVideoEnabled);
  }

  void _handleRemoteAudioStateChanged(RtcConnection connection, int remoteUid,
      RemoteAudioState state, RemoteAudioStateReason reason, int elapsed) {
    final isAudioEnabled = state != RemoteAudioState.remoteAudioStateStopped;
    _updateUserAudioStatus(remoteUid, isAudioEnabled);
  }

  void _handleTokenExpiring(RtcConnection connection, String token) {
    // Handle token refresh if needed
    debugPrint('Token expiring: $token');
  }

  // Call Event Handlers
  void _handleCallAccepted() {
    value = value.copyWith(status: VCallStatus.inCall);
    _stopWatchTimer.onStartTimer();
    notifyListeners();
  }

  void _handleCallEnded() {
    value = value.copyWith(status: VCallStatus.finished);
    notifyListeners();
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void _handleCallRejected() {
    value = value.copyWith(status: VCallStatus.rejected);
    notifyListeners();
    Navigator.pop(context);
  }

  // Helper Methods
  void _updateUserAudioStatus(int uid, bool isAudioEnabled) {
    final updatedUsers = value.users.map((user) {
      if (user.uid == uid) {
        return user.copyWith(isAudioEnabled: isAudioEnabled);
      }
      return user;
    }).toSet();

    value = value.copyWith(users: updatedUsers);
    notifyListeners();
  }

  void _updateUserVideoStatus(int uid, bool isVideoEnabled) {
    final updatedUsers = value.users.map((user) {
      if (user.uid == uid) {
        return user.copyWith(isVideoEnabled: isVideoEnabled);
      }
      return user;
    }).toSet();

    value = value.copyWith(users: updatedUsers);
    notifyListeners();
  }

  void _handleError(String error) {
    debugPrint('Call Controller Error: $error');
    if (context.mounted) {
      VAppAlert.showSuccessSnackBar(
        message: error,
        context: context,
      );
    }
  }

  // Public Methods
  Future<void> onToggleCamera() async {
    final newVideoState = !value.isVideoEnabled;
    final result = await _agoraService.toggleVideo(newVideoState);

    if (result.isSuccess) {
      value = value.copyWith(isVideoEnabled: newVideoState);
      _updateUserVideoStatus(value.currentUid!, newVideoState);
    } else {
      _handleError(result.error!);
    }
  }

  Future<void> onToggleMicrophone() async {
    final newMicState = !value.isMicEnabled;
    final result = await _agoraService.toggleAudio(newMicState);

    if (result.isSuccess) {
      value = value.copyWith(isMicEnabled: newMicState);
      _updateUserAudioStatus(value.currentUid!, newMicState);
    } else {
      _handleError(result.error!);
    }
  }

  Future<void> onToggleSpeaker() async {
    final newSpeakerState = !value.isSpeakerEnabled;
    final result = await _agoraService.toggleSpeaker(newSpeakerState);

    if (result.isSuccess) {
      value = value.copyWith(isSpeakerEnabled: newSpeakerState);
      notifyListeners();
    } else {
      _handleError(result.error!);
    }
  }

  Future<void> onSwitchCamera() async {
    final result = await _agoraService.switchCamera();
    if (!result.isSuccess) {
      _handleError(result.error!);
    }
  }

  Future<void> _createCall() async {
    try {
      final callResult = await _audioService.playRingtone();
      if (!callResult.isSuccess) {
        _handleError(callResult.error!);
      }

      final callId = await VChatController.I.nativeApi.remote.calls.createCall(
        roomId: _callData.roomId,
        withVideo: _callData.isVideoEnable,
      );

      value = value.copyWith(callId: callId);
    } catch (e) {
      _handleError('Failed to create call: $e');
      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _acceptCall() async {
    try {
      await VChatController.I.nativeApi.remote.calls.acceptCall(
        callId: _callData.callId!,
      );
      _stopWatchTimer.onStartTimer();
      value = value.copyWith(status: VCallStatus.inCall);
      notifyListeners();
    } catch (e) {
      _handleError('Failed to accept call: $e');
    }
  }

  Future<void> endCall() async {
    final callIdToEnd = _callData.callId ?? value.callId;
    if (callIdToEnd == null) return;

    try {
      await VChatController.I.nativeApi.remote.calls.endCallV2(callIdToEnd);
    } catch (e) {
      _handleError('Failed to end call: $e');
    }
  }

  @override
  Future<void> dispose() async {
    await _stopWatchTimer.dispose();
    await WakelockPlus.disable();
    await _callStreamSubscription?.cancel();
    await _audioService.dispose();
    await _agoraService.dispose();
    await endCall();
    super.dispose();
  }
}
