import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'call_foreground_service.dart';
import 'call_notification_data.dart';
import 'call_state.dart';

/// Callback for call actions from notification
typedef CallActionCallback = void Function(String action);

/// Manager class for handling call foreground services
class CallServiceManager {
  CallServiceManager._();

  static final CallServiceManager _instance = CallServiceManager._();

  static CallServiceManager get instance => _instance;

  bool _isServiceRunning = false;
  CallNotificationData? _currentCallData;
  CallActionCallback? _onCallAction;

  /// Initialize the call service manager
  Future<void> initialize() async {
    await _initializeForegroundTask();
    _setupMessageListener();
  }

  /// Start foreground service for a call
  Future<bool> startCallService({
    required CallNotificationData callData,
    CallActionCallback? onCallAction,
  }) async {
    try {
      if (_isServiceRunning) {
        await updateCall(callData);
        return true;
      }

      _currentCallData = callData;
      _onCallAction = onCallAction;

      // Enable wakelock for calls
      if (callData.callState.isActive) {
        await WakelockPlus.enable();
      }

      await FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: callData.notificationTitle,
        notificationText: callData.notificationContent,
        callback: _isolateCallback,
      );

      // Service started successfully
      _isServiceRunning = true;

      // Send initial call data to isolate
      FlutterForegroundTask.sendDataToTask({
        'action': 'updateCall',
        'callId': callData.callId,
        'callerName': callData.callerName,
        'callerAvatarUrl': callData.callerAvatarUrl,
        'callStateIndex': callData.callState.index,
        'callDuration': callData.callDuration,
        'isVideoCall': callData.isVideoCall,
        'isMuted': callData.isMuted,
        'isSpeakerOn': callData.isSpeakerOn,
        'isIncoming': callData.isIncoming,
      });

      if (kDebugMode) {
        print('CallServiceManager: Service started successfully');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('CallServiceManager: Error starting service - $e');
      }
      return false;
    }
  }

  /// Update call information
  Future<void> updateCall(CallNotificationData callData) async {
    if (!_isServiceRunning) return;

    _currentCallData = callData;

    // Enable/disable wakelock based on call state
    if (callData.callState.isActive) {
      await WakelockPlus.enable();
    } else {
      await WakelockPlus.disable();
    }

    FlutterForegroundTask.sendDataToTask({
      'action': 'updateCall',
      'callId': callData.callId,
      'callerName': callData.callerName,
      'callerAvatarUrl': callData.callerAvatarUrl,
      'callStateIndex': callData.callState.index,
      'callDuration': callData.callDuration,
      'isVideoCall': callData.isVideoCall,
      'isMuted': callData.isMuted,
      'isSpeakerOn': callData.isSpeakerOn,
      'isIncoming': callData.isIncoming,
    });
  }

  /// End the call and stop the service
  Future<void> endCall() async {
    if (!_isServiceRunning) return;

    await WakelockPlus.disable();

    FlutterForegroundTask.sendDataToTask({'action': 'endCall'});

    // Stop service after a delay to show "Call Ended" message
    Timer(const Duration(seconds: 2), () async {
      await stopService();
    });
  }

  /// Toggle mute state
  Future<void> toggleMute(bool isMuted) async {
    if (!_isServiceRunning || _currentCallData == null) return;

    _currentCallData = _currentCallData!.copyWith(isMuted: isMuted);

    FlutterForegroundTask.sendDataToTask({
      'action': 'muteCall',
      'isMuted': isMuted,
    });
  }

  /// Toggle speaker state
  Future<void> toggleSpeaker(bool isSpeakerOn) async {
    if (!_isServiceRunning || _currentCallData == null) return;

    _currentCallData = _currentCallData!.copyWith(isSpeakerOn: isSpeakerOn);

    FlutterForegroundTask.sendDataToTask({
      'action': 'speakerToggle',
      'isSpeakerOn': isSpeakerOn,
    });
  }

  /// Stop the foreground service
  Future<void> stopService() async {
    if (!_isServiceRunning) return;

    await WakelockPlus.disable();
    await FlutterForegroundTask.stopService();

    _isServiceRunning = false;
    _currentCallData = null;

    if (kDebugMode) {
      print('CallServiceManager: Service stopped');
    }
  }

  /// Get current call data
  CallNotificationData? get currentCallData => _currentCallData;

  /// Check if service is running
  bool get isServiceRunning => _isServiceRunning;

  /// Request necessary permissions
  Future<void> _requestPermissions() async {
    // Request notification permission
    await Permission.notification.request();

    // Request microphone permission for calls
    await Permission.microphone.request();
  }

  /// Initialize foreground task configuration
  Future<void> _initializeForegroundTask() async {
    // Initialize communication port
    FlutterForegroundTask.initCommunicationPort();

    // Initialize with configuration
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'call_service_channel',
        channelName: 'Phone Call Service',
        channelDescription: 'Notification for ongoing phone calls',
        enableVibration: false,
        playSound: false,
        showWhen: true,
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(1000), // 1 second
        autoRunOnBoot: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );

    if (kDebugMode) {
      print('CallServiceManager: Foreground task initialized');
    }
  }

  /// Setup message listener for isolate communication
  void _setupMessageListener() {
    // Add callback to receive data from task handler
    FlutterForegroundTask.addTaskDataCallback(_handleIsolateMessage);
  }

  /// Handle messages from isolate
  void _handleIsolateMessage(dynamic message) {
    if (message is Map<String, dynamic>) {
      final action = message['action'] as String?;

      if (action != null && _onCallAction != null) {
        _onCallAction!(action);
      }

      if (kDebugMode) {
        print('CallServiceManager: Received action from isolate - $action');
      }
    }
  }

  /// Clean up resources
  void dispose() {
    // Remove task data callback
    FlutterForegroundTask.removeTaskDataCallback(_handleIsolateMessage);
    WakelockPlus.disable();
  }
}

/// Isolate callback function for foreground task
@pragma('vm:entry-point')
void _isolateCallback() {
  FlutterForegroundTask.setTaskHandler(CallForegroundService());
}
