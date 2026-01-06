// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:v_chat_call_service/v_chat_call_service.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

/// Integration service for connecting v_chat calls with foreground service
class VChatCallServiceIntegration {
  VChatCallServiceIntegration._();

  static final VChatCallServiceIntegration _instance =
      VChatCallServiceIntegration._();
  static VChatCallServiceIntegration get instance => _instance;

  final CallServiceManager _callServiceManager = CallServiceManager.instance;
  String? _currentCallId;
  VCallDto? _currentCallData;
  Timer? _durationTimer;
  int _callDurationSeconds = 0;
  bool _isServiceRunning = false;

  /// Whether foreground service is currently active
  bool get isServiceRunning => _isServiceRunning;

  /// Current call duration in seconds
  int get callDuration => _callDurationSeconds;

  /// Initialize the call service integration
  Future<void> initialize() async {
    if (!VPlatforms.isAndroid) return;

    try {
      await _callServiceManager.initialize();
      if (kDebugMode) {
        print('VChatCallServiceIntegration: Initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('VChatCallServiceIntegration: Failed to initialize - $e');
      }
    }
  }

  /// Start call foreground service for outgoing call
  Future<void> startOutgoingCall({
    required VCallDto callData,
    required String callerName,
    String? callerAvatarUrl,
  }) async {
    if (!VPlatforms.isAndroid) return;

    try {
      _currentCallData = callData;
      _currentCallId = DateTime.now().millisecondsSinceEpoch.toString();
      _callDurationSeconds = 0;

      final callNotificationData = CallNotificationData(
        callId: _currentCallId!,
        callerName: callerName,
        callerAvatarUrl: callerAvatarUrl,
        callState: CallState.dialing,
        callDuration: _callDurationSeconds,
        isVideoCall: callData.isVideoEnable,
        isMuted: false,
        isSpeakerOn: callData.isVideoEnable, // Video calls default to speaker
        isIncoming: false,
      );

      final success = await _callServiceManager.startCallService(
        callData: callNotificationData,
        onCallAction: _handleCallAction,
      );

      if (success) {
        _isServiceRunning = true;
        if (kDebugMode) {
          print('VChatCallServiceIntegration: Outgoing call service started');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            'VChatCallServiceIntegration: Failed to start outgoing call - $e');
      }
    }
  }

  /// Start call foreground service for incoming call
  Future<void> startIncomingCall({
    required VCallDto callData,
    required String callerName,
    String? callerAvatarUrl,
  }) async {
    if (!VPlatforms.isAndroid) return;

    try {
      _currentCallData = callData;
      _currentCallId =
          callData.callId ?? DateTime.now().millisecondsSinceEpoch.toString();
      _callDurationSeconds = 0;

      final callNotificationData = CallNotificationData(
        callId: _currentCallId!,
        callerName: callerName,
        callerAvatarUrl: callerAvatarUrl,
        callState: CallState.ringing,
        callDuration: _callDurationSeconds,
        isVideoCall: callData.isVideoEnable,
        isMuted: false,
        isSpeakerOn: callData.isVideoEnable, // Video calls default to speaker
        isIncoming: true,
      );

      final success = await _callServiceManager.startCallService(
        callData: callNotificationData,
        onCallAction: _handleCallAction,
      );

      if (success) {
        _isServiceRunning = true;
        if (kDebugMode) {
          print('VChatCallServiceIntegration: Incoming call service started');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            'VChatCallServiceIntegration: Failed to start incoming call - $e');
      }
    }
  }

  /// Update call state when call connects
  Future<void> onCallConnected() async {
    if (!VPlatforms.isAndroid || !_isServiceRunning) return;

    try {
      // Start duration timer
      _startDurationTimer();

      await _updateCallState(CallState.connected);

      if (kDebugMode) {
        print('VChatCallServiceIntegration: Call connected');
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            'VChatCallServiceIntegration: Failed to update call connected - $e');
      }
    }
  }

  /// Update mute state
  Future<void> onMuteToggled(bool isMuted) async {
    if (!VPlatforms.isAndroid || !_isServiceRunning) return;

    try {
      await _callServiceManager.toggleMute(isMuted);

      if (kDebugMode) {
        print('VChatCallServiceIntegration: Mute toggled - $isMuted');
      }
    } catch (e) {
      if (kDebugMode) {
        print('VChatCallServiceIntegration: Failed to toggle mute - $e');
      }
    }
  }

  /// Update speaker state
  Future<void> onSpeakerToggled(bool isSpeakerOn) async {
    if (!VPlatforms.isAndroid || !_isServiceRunning) return;

    try {
      await _callServiceManager.toggleSpeaker(isSpeakerOn);

      if (kDebugMode) {
        print('VChatCallServiceIntegration: Speaker toggled - $isSpeakerOn');
      }
    } catch (e) {
      if (kDebugMode) {
        print('VChatCallServiceIntegration: Failed to toggle speaker - $e');
      }
    }
  }

  /// End the call and stop foreground service
  Future<void> endCall() async {
    if (!VPlatforms.isAndroid || !_isServiceRunning) return;

    try {
      _durationTimer?.cancel();
      _durationTimer = null;

      await _callServiceManager.endCall();

      _isServiceRunning = false;
      _currentCallId = null;
      _currentCallData = null;
      _callDurationSeconds = 0;

      if (kDebugMode) {
        print('VChatCallServiceIntegration: Call ended');
      }
    } catch (e) {
      if (kDebugMode) {
        print('VChatCallServiceIntegration: Failed to end call - $e');
      }
    }
  }

  /// Handle call actions from notification
  void _handleCallAction(String action) {
    if (kDebugMode) {
      print('VChatCallServiceIntegration: Received action - $action');
    }

    // These actions will be handled by the actual call controller
    // The integration just logs them for debugging
    switch (action) {
      case 'answerCall':
        // Will be handled by ImprovedVCallController._acceptCall()
        break;
      case 'declineCall':
      case 'endCall':
        // Will be handled by call controller's end call method
        break;
      case 'toggleMute':
        // Will be handled by call controller's toggle mute method
        break;
      case 'toggleSpeaker':
        // Will be handled by call controller's toggle speaker method
        break;
    }
  }

  /// Start duration timer for connected calls
  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _callDurationSeconds++;
      _updateCallDuration();
    });
  }

  /// Update call duration in service
  void _updateCallDuration() {
    if (!_isServiceRunning || _currentCallData == null) return;

    final callNotificationData = CallNotificationData(
      callId: _currentCallId!,
      callerName: _getCallerName(),
      callerAvatarUrl: _getCallerAvatarUrl(),
      callState: CallState.connected,
      callDuration: _callDurationSeconds,
      isVideoCall: _currentCallData!.isVideoEnable,
      isMuted: false, // Will be updated by actual mute state
      isSpeakerOn: _currentCallData!.isVideoEnable,
      isIncoming: !_currentCallData!.isCaller,
    );

    _callServiceManager.updateCall(callNotificationData);
  }

  /// Update call state
  Future<void> _updateCallState(CallState newState) async {
    if (!_isServiceRunning || _currentCallData == null) return;

    final callNotificationData = CallNotificationData(
      callId: _currentCallId!,
      callerName: _getCallerName(),
      callerAvatarUrl: _getCallerAvatarUrl(),
      callState: newState,
      callDuration: _callDurationSeconds,
      isVideoCall: _currentCallData!.isVideoEnable,
      isMuted: false,
      isSpeakerOn: _currentCallData!.isVideoEnable,
      isIncoming: !_currentCallData!.isCaller,
    );

    await _callServiceManager.updateCall(callNotificationData);
  }

  /// Get caller name from current call data
  String _getCallerName() {
    if (_currentCallData == null) return 'Unknown';

    // Try to get the room name or participant name
    return _currentCallData!.roomId.isNotEmpty
        ? _currentCallData!.roomId
        : 'Call Participant';
  }

  /// Get caller avatar URL from current call data
  String? _getCallerAvatarUrl() {
    // This would be retrieved from the call participant data
    // For now, return null as we don't have direct access
    return null;
  }

  /// Dispose resources
  void dispose() {
    _durationTimer?.cancel();
    _durationTimer = null;
    _callServiceManager.dispose();
    _currentCallId = null;
    _currentCallData = null;
    _callDurationSeconds = 0;
    _isServiceRunning = false;
  }
}

/// Extension methods for easier integration with call controllers
extension VCallDtoIntegration on VCallDto {
  /// Get display name for the call
  String get displayName {
    return roomId.isNotEmpty ? roomId : 'Call';
  }

  /// Whether this is an incoming call
  bool get isIncomingCall => !isCaller;

  /// Whether this is an outgoing call
  bool get isOutgoingCall => isCaller;
}
