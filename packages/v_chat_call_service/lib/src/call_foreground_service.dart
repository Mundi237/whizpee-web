import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'call_notification_data.dart';
import 'call_state.dart';

/// Foreground service task handler for phone calls
class CallForegroundService extends TaskHandler {
  static const String _isolatePortName = 'call_isolate_port';

  Timer? _callTimer;
  CallNotificationData? _currentCallData;
  int _callDurationSeconds = 0;

  /// Initialize the service
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // Register isolate port for communication
    final receivePort = ReceivePort();
    IsolateNameServer.registerPortWithName(
      receivePort.sendPort,
      _isolatePortName,
    );

    // Listen for messages from the main isolate
    receivePort.listen(_handleMessage);

    if (kDebugMode) {
      print(
          'CallForegroundService: Service started (starter: ${starter.name})');
    }
  }

  /// Handle repeat events (required by TaskHandler)
  @override
  void onRepeatEvent(DateTime timestamp) {
    // Update call timer if call is active
    if (_currentCallData?.callState.isActive == true) {
      _callDurationSeconds++;

      // Update notification with new duration
      if (_currentCallData != null) {
        final updatedData = _currentCallData!.copyWith(
          callDuration: _callDurationSeconds,
        );
        _updateNotification(updatedData);
      }
    }
  }

  /// Handle service destruction
  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    _callTimer?.cancel();
    _callTimer = null;
    _currentCallData = null;
    _callDurationSeconds = 0;

    // Unregister isolate port
    IsolateNameServer.removePortNameMapping(_isolatePortName);

    if (kDebugMode) {
      print('CallForegroundService: Service destroyed (timeout: $isTimeout)');
    }
  }

  /// Handle messages from main isolate
  void _handleMessage(dynamic message) {
    if (message is Map<String, dynamic>) {
      final action = message['action'] as String?;

      switch (action) {
        case 'updateCall':
          _handleCallUpdate(message);
          break;
        case 'endCall':
          _handleCallEnd();
          break;
        case 'muteCall':
          _handleMuteToggle(message['isMuted'] as bool? ?? false);
          break;
        case 'speakerToggle':
          _handleSpeakerToggle(message['isSpeakerOn'] as bool? ?? false);
          break;
      }
    }
  }

  /// Handle call data update
  void _handleCallUpdate(Map<String, dynamic> data) {
    try {
      final callData = CallNotificationData(
        callId: data['callId'] as String,
        callerName: data['callerName'] as String,
        callerAvatarUrl: data['callerAvatarUrl'] as String?,
        callState: CallState.values[data['callStateIndex'] as int],
        callDuration: data['callDuration'] as int? ?? _callDurationSeconds,
        isVideoCall: data['isVideoCall'] as bool? ?? false,
        isMuted: data['isMuted'] as bool? ?? false,
        isSpeakerOn: data['isSpeakerOn'] as bool? ?? false,
        isIncoming: data['isIncoming'] as bool? ?? false,
      );

      _currentCallData = callData;
      _callDurationSeconds = callData.callDuration;

      // Start timer if call becomes active
      if (callData.callState.isActive && _callTimer == null) {
        _startCallTimer();
      }

      _updateNotification(callData);

      if (kDebugMode) {
        print('CallForegroundService: Call updated - $callData');
      }
    } catch (e) {
      if (kDebugMode) {
        print('CallForegroundService: Error updating call data - $e');
      }
    }
  }

  /// Handle call end
  void _handleCallEnd() {
    _callTimer?.cancel();
    _callTimer = null;

    if (_currentCallData != null) {
      final endedCallData = _currentCallData!.copyWith(
        callState: CallState.ended,
      );
      _updateNotification(endedCallData);
    }

    // Stop the foreground service after a short delay
    Timer(const Duration(seconds: 2), () {
      FlutterForegroundTask.stopService();
    });

    if (kDebugMode) {
      print('CallForegroundService: Call ended');
    }
  }

  /// Handle mute toggle
  void _handleMuteToggle(bool isMuted) {
    if (_currentCallData != null) {
      _currentCallData = _currentCallData!.copyWith(isMuted: isMuted);
      _updateNotification(_currentCallData!);
    }
  }

  /// Handle speaker toggle
  void _handleSpeakerToggle(bool isSpeakerOn) {
    if (_currentCallData != null) {
      _currentCallData = _currentCallData!.copyWith(isSpeakerOn: isSpeakerOn);
      _updateNotification(_currentCallData!);
    }
  }

  /// Start the call timer
  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Timer logic is handled in onEvent
    });
  }

  /// Update the foreground notification
  void _updateNotification(CallNotificationData callData) {
    FlutterForegroundTask.updateService(
      notificationTitle: callData.notificationTitle,
      notificationText: callData.notificationContent,
    );
  }

  /// Handle incoming data from main isolate
  @override
  void onReceiveData(Object data) {
    if (data is Map<String, dynamic>) {
      _handleMessage(data);
    }
  }

  /// Handle notification button press
  @override
  void onNotificationButtonPressed(String id) {
    if (kDebugMode) {
      print('CallForegroundService: Notification button pressed - $id');
    }

    // Send action back to main isolate
    FlutterForegroundTask.sendDataToMain({'action': id});
  }

  /// Handle notification press
  @override
  void onNotificationPressed() {
    if (kDebugMode) {
      print('CallForegroundService: Notification pressed');
    }
    FlutterForegroundTask.sendDataToMain({'action': 'openApp'});
  }

  /// Handle notification dismissal (won't be called for non-dismissible notifications)
  @override
  void onNotificationDismissed() {
    if (kDebugMode) {
      print('CallForegroundService: Notification dismissed');
    }
  }
}

/// Create notification action button IDs based on call state
List<String> createCallNotificationButtonIds(
  CallNotificationData callData,
) {
  final buttonIds = <String>[];

  if (callData.callState == CallState.ringing && callData.isIncoming) {
    // Incoming call buttons
    buttonIds.addAll(['answer_call', 'decline_call']);
  } else if (callData.callState.isActive) {
    // Active call buttons
    buttonIds.addAll(['mute_call', 'speaker_call', 'end_call']);
  }

  return buttonIds;
}
