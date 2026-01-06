import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';


/// Handles iOS-specific call functionality through method channels
class IOSCallHandler {
  IOSCallHandler._();

  static final IOSCallHandler instance = IOSCallHandler._();

  static const _channel = MethodChannel('com.superup.call/navigation');

  // Track if we're currently navigating to prevent duplicates
  static bool _isNavigatingToCall = false;
  static String? _currentCallId;

  /// Initialize the iOS call handler and set up method call handlers
  Future<void> initialize() async {
    if (!VPlatforms.isIOS) return;

    _channel.setMethodCallHandler(_handleMethodCall);
    debugPrint('IOSCallHandler: Initialized');
  }

  /// Handle method calls from iOS native code
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    debugPrint('IOSCallHandler: Received method call: ${call.method}');

    switch (call.method) {
      case 'navigateToCall':
        return _handleNavigateToCall(call.arguments);

      case 'handlePendingCall':
        return _handlePendingCall(call.arguments);

      case 'callDeclined':
        return _handleCallDeclined(call.arguments);

      case 'callEnded':
        return _handleCallEnded(call.arguments);

      case 'callTimeout':
        return _handleCallTimeout(call.arguments);

      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'IOSCallHandler: ${call.method} is not implemented',
        );
    }
  }

  /// Handle navigation to call screen
  Future<bool> _handleNavigateToCall(dynamic arguments) async {
    try {
      debugPrint(
          'IOSCallHandler: Navigating to call with arguments: $arguments');

      if (arguments == null || arguments is! Map) {
        debugPrint('IOSCallHandler: Invalid arguments for navigateToCall');
        return false;
      }

      final Map<String, dynamic> callData =
          Map<String, dynamic>.from(arguments);

      final callId = callData['callId'] as String? ?? '';

      // Check if we're already navigating to this call
      if (_isNavigatingToCall && _currentCallId == callId) {
        debugPrint(
            'IOSCallHandler: Already navigating to call $callId, skipping duplicate');
        return false;
      }

      // Check if we're navigating to a different call
      if (_isNavigatingToCall && _currentCallId != callId) {
        debugPrint(
            'IOSCallHandler: Already navigating to different call $_currentCallId, ignoring new call $callId');
        return false;
      }

      // Set navigation flags
      _isNavigatingToCall = true;
      _currentCallId = callId;

      try {
        // Create VCallNotificationModel from the data
        final model = VCallNotificationModel(
          callId: callId,
          userName: callData['userName'] as String? ?? 'Unknown',
          userImage: callData['userImage'] as String? ?? '',
          roomId: callData['roomId'] as String? ?? '',
          withVideo: callData['withVideo'] as bool? ?? false,
          roomType: VRoomType.values.firstWhere(
            (e) => e.name == (callData['roomType'] as String? ?? 's'),
            orElse: () => VRoomType.s,
          ),
          callStatus: VCallStatus.values.firstWhere(
            (e) => e.name == (callData['callStatus'] as String? ?? 'ring'),
            orElse: () => VCallStatus.ring,
          ),
          groupName: callData['groupName'] as String?,
        );

        // Navigate to call screen using CallKeepHandler
        await CallKeepHandler.I.acceptCall(model);

        // Reset navigation flag after a delay
        Future.delayed(const Duration(seconds: 2), () {
          _isNavigatingToCall = false;
          _currentCallId = null;
        });

        return true;
      } catch (e) {
        // Reset flags on error
        _isNavigatingToCall = false;
        _currentCallId = null;
        rethrow;
      }
    } catch (e) {
      debugPrint('IOSCallHandler: Error navigating to call: $e');
      return false;
    }
  }

  /// Handle pending call from background
  Future<bool> _handlePendingCall(dynamic arguments) async {
    try {
      debugPrint(
          'IOSCallHandler: Handling pending call with arguments: $arguments');

      // Add a small delay to ensure app is fully initialized
      await Future.delayed(const Duration(milliseconds: 500));

      // Use the same logic as navigateToCall
      return _handleNavigateToCall(arguments);
    } catch (e) {
      debugPrint('IOSCallHandler: Error handling pending call: $e');
      return false;
    }
  }

  /// Handle call declined event
  Future<void> _handleCallDeclined(dynamic arguments) async {
    try {
      debugPrint('IOSCallHandler: Call declined with arguments: $arguments');

      if (arguments == null || arguments is! Map) return;

      final Map<String, dynamic> data = Map<String, dynamic>.from(arguments);
      final callData = data['data'] as Map<String, dynamic>?;

      if (callData != null && callData['extra'] != null) {
        final extra = callData['extra'] as Map<String, dynamic>;

        // Create VCallNotificationModel from the extra data
        final model = VCallNotificationModel.fromMap(extra);

        // End the call on server with zero duration (never connected)
        await _endCallOnServer(model, durationSeconds: 0);
      }
    } catch (e) {
      debugPrint('IOSCallHandler: Error handling call declined: $e');
    }
  }

  /// Handle call ended event
  Future<void> _handleCallEnded(dynamic arguments) async {
    try {
      debugPrint('IOSCallHandler: Call ended with arguments: $arguments');

      // End any active calls in the app
      await CallKeepHandler.I.endCalls(null);
    } catch (e) {
      debugPrint('IOSCallHandler: Error handling call ended: $e');
    }
  }

  /// Handle call timeout event
  Future<void> _handleCallTimeout(dynamic arguments) async {
    try {
      debugPrint('IOSCallHandler: Call timeout with arguments: $arguments');

      if (arguments == null || arguments is! Map) return;

      final Map<String, dynamic> data = Map<String, dynamic>.from(arguments);
      final callData = data['data'] as Map<String, dynamic>?;

      if (callData != null && callData['extra'] != null) {
        final extra = callData['extra'] as Map<String, dynamic>;

        // Create VCallNotificationModel from the extra data
        final model = VCallNotificationModel.fromMap(extra);

        // Show missed call notification
        await CallKeepHandler.I.showMissedCallNotification(
          model: model,
          fromBackground: true,
        );
      }
    } catch (e) {
      debugPrint('IOSCallHandler: Error handling call timeout: $e');
    }
  }

  /// End call on server (similar to Android implementation)
  Future<void> _endCallOnServer(VCallNotificationModel model, {required int durationSeconds}) async {
    try {
      // Initialize preferences to get API configuration
      await VAppPref.init();
      final baseUrl = VAppPref.getStringOrNullKey(SStorageKeys.vBaseUrl.name);

      if (baseUrl == null) {
        debugPrint('IOSCallHandler: Base URL not found in preferences');
        return;
      }

      // Try to use VChatController's API service if available
      try {
        await VChatController.I.nativeApi.remote.calls.endCallV2(model.callId);
      } catch (e) {
        // Fallback: Make direct HTTP request if controller not available
        final client = Client();
        try {
          final response = await client.post(
            Uri.parse("$baseUrl/call/end/v2/${model.callId}"),
            headers: {
              'authorization':
                  "Bearer ${VAppPref.getHashedString(key: "accessToken")}",
              "clint-version": "2.0.0",
              "Accept-Language": "en",
              'Content-Type': 'application/json',
            },
            body: '{"durationSeconds": $durationSeconds}',
          );

          if (response.statusCode != 200) {
            debugPrint(
                'IOSCallHandler: Failed to end call on server: ${response.statusCode}');
          }
        } finally {
          client.close();
        }
      }
    } catch (e) {
      debugPrint('IOSCallHandler: Error ending call on server: $e');
    }
  }

  /// Check for deep links (for launching app with call data)
  Future<void> handleDeepLink(String? link) async {
    if (link == null || !link.startsWith('superup://call')) return;

    try {
      final uri = Uri.parse(link);
      final dataParam = uri.queryParameters['data'];

      if (dataParam != null) {
        final decodedData = Uri.decodeComponent(dataParam);
        final callData = jsonDecode(decodedData) as Map<String, dynamic>;

        // Handle the call navigation
        await _handleNavigateToCall(callData);
      }
    } catch (e) {
      debugPrint('IOSCallHandler: Error handling deep link: $e');
    }
  }
}
