import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart' as c;
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:uuid/uuid.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../models/api_cache_model.dart';

/// Enum defining the types of permissions required for call functionality
enum _CallPermission { microphone, camera }

/// Constants for CallKit configuration
class _CallKitConstants {
  static const int callValidityDurationSeconds = 30;
  static const int callTimeoutDurationMs = 60000;
  static const String appName = SConstants.appName;
  static const String defaultBackgroundColor = '#0955fa';
  static const String defaultActionColor = '#4CAF50';
  static const String defaultTextColor = '#ffffff';
  static const String defaultRingtone = 'system_ringtone_default';
  static const String incomingCallChannelName = "Incoming_Call";
  static const String missedCallChannelName = "Missed_Call";
  static const String defaultIconName = 'LaunchImage';
  static const String defaultAudioSessionMode = 'default';
  static const double defaultSampleRate = 44100.0;
  static const double defaultIOBufferDuration = 0.005;
  static const int maxCallGroupsIOS = 2;
  static const int maxCallsPerGroupDefault = 1;
  static const int maxCallsPerGroupForGroup = 20;
}

/// CallKeepHandler manages incoming call notifications and CallKit integration
/// This singleton class handles:
/// - CallKit configuration and event handling
/// - Permission management for audio/video calls
/// - Call acceptance/decline logic
/// - Background call state management
/// - Navigation to call screens
class CallKeepHandler {
  CallKeepHandler._internal();

  static final CallKeepHandler _instance = CallKeepHandler._internal();

  static CallKeepHandler get I => _instance;

  /// Local native API instance for background operations
  VLocalNativeApi? _nativeLocal;

  /// Track current navigation to prevent duplicates
  static bool _isNavigatingToCall = false;
  static String? _currentNavigatingCallId;

  /// Track accepted calls to avoid showing missed notifications incorrectly
  final Set<String> _acceptedCallIds = <String>{};
  final Set<String> _missedNotifiedCallIds = <String>{};
  /// Track call connected timestamps to compute duration
  final Map<String, DateTime> _callStartTimes = <String, DateTime>{};

  // ==================== CallKeep Configuration and Event Handling ====================

  /// Configures Flutter CallKeep for incoming call handling
  /// [isBackground] - Whether the app is currently in background mode
  Future<void> configureFlutterCallKeep(bool isBackground) async {
    if (VPlatforms.isMobile) {
      await _setEventHandler(isBackground);
    }
  }

  /// Starts an outgoing call display
  Future<void> startOutgoingCall(VCallNotificationModel model) async {
    try {
      final callEvent = _createCallEvent(model);
      await FlutterCallkitIncoming.startCall(callEvent);
    } catch (e) {
      _handleError('Error starting outgoing call: $e');
    }
  }

  /// Handles accepting an incoming call
  /// Checks required permissions and navigates to call screen
  /// [model] - Call notification model containing call details
  Future<void> acceptCall(VCallNotificationModel model) async {
    try {
      // Check if we're already navigating to this call
      if (_isNavigatingToCall && _currentNavigatingCallId == model.callId) {
        _handleError(
            'Already navigating to call ${model.callId}, skipping duplicate');
        return;
      }

      // Check if we're navigating to a different call
      if (_isNavigatingToCall && _currentNavigatingCallId != model.callId) {
        _handleError(
            'Already navigating to different call $_currentNavigatingCallId, ignoring new call ${model.callId}');
        return;
      }

      // Set navigation flags
      _isNavigatingToCall = true;
      _currentNavigatingCallId = model.callId;

      try {
        // Check if required permissions are granted before accepting call
        if (!await _checkRequiredPermissions(model.withVideo)) {
          _isNavigatingToCall = false;
          _currentNavigatingCallId = null;
          return;
        }

        // Navigate to the appropriate call screen
        await _navigateToCallScreen(model);

        // Reset navigation flag after a delay
        Future.delayed(const Duration(seconds: 2), () {
          _isNavigatingToCall = false;
          _currentNavigatingCallId = null;
        });
      } catch (e) {
        // Reset flags on error
        _isNavigatingToCall = false;
        _currentNavigatingCallId = null;
        rethrow;
      }
    } catch (e) {
      _handleError('Error accepting call: $e');
    }
  }

// ==================== Permission Handling ====================

  /// Checks and requests required permissions for the call type
  /// [isVideoCall] - Whether this is a video call (requires camera + microphone)
  /// Returns true if all required permissions are granted
  Future<bool> _checkRequiredPermissions(bool isVideoCall) async {
    final requiredPermissions = isVideoCall
        ? [_CallPermission.microphone, _CallPermission.camera]
        : [_CallPermission.microphone];

    for (final permission in requiredPermissions) {
      if (!await _requestPermissionIfNeeded(permission)) {
        _showPermissionError(isVideoCall);
        return false;
      }
    }
    return true;
  }

  /// Requests permission if not already granted
  /// [permission] - The permission type to check and request
  /// Returns true if permission is granted (either already or after request)
  Future<bool> _requestPermissionIfNeeded(_CallPermission permission) async {
    final Permission permissionToCheck = permission == _CallPermission.camera
        ? Permission.camera
        : Permission.microphone;

    final status = await permissionToCheck.status;

    // If already granted, return true
    if (status.isGranted) {
      return true;
    }

    // If permanently denied, show settings dialog
    if (status.isPermanentlyDenied) {
      await _showPermissionSettingsDialog(permission);
      return false;
    }

    // If denied but can be requested, request it
    if (status.isDenied) {
      final result = await permissionToCheck.request();
      return result.isGranted;
    }

    // For any other status, try to request
    final result = await permissionToCheck.request();
    return result.isGranted;
  }

  /// Gets the VoIP push token for iOS
  /// Returns the device push token or null if not available
  Future<String?> getDevicePushTokenVoIP() async {
    try {
      return await FlutterCallkitIncoming.getDevicePushTokenVoIP() as String?;
    } catch (e) {
      _handleError('Error getting VoIP token: $e');
      return null;
    }
  }

  /// Shows a dialog to guide user to app settings for permanently denied permissions
  Future<void> _showPermissionSettingsDialog(_CallPermission permission) async {
    final permissionName = permission == _CallPermission.camera
        ? _getLocalizedText('camera')
        : _getLocalizedText('microphone');

    // Show dialog asking user to go to settings
    final shouldOpenSettings = await showDialog<bool>(
      context: VChatController.I.navigationContext,
      builder: (context) => AlertDialog(
        title: Text(_getLocalizedText('permissionRequired')),
        content: Text(
          _getLocalizedText('permissionPermanentlyDenied')
              .replaceAll('{permission}', permissionName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(_getLocalizedText('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(_getLocalizedText('openSettings')),
          ),
        ],
      ),
    );

    // Open app settings if user agrees
    if (shouldOpenSettings == true) {
      await openAppSettings();
    }
  }

  /// Shows an error message for permission denial
  /// [isVideoCall] - Whether this was for a video call
  void _showPermissionError(bool isVideoCall) {
    final message = isVideoCall
        ? _getLocalizedText('microphoneAndCameraPermissionRequired')
        : _getLocalizedText('microphonePermissionRequired');

    VAppAlert.showErrorSnackBar(
      message: message,
      context: VChatController.I.navigationContext,
    );
  }

  // ==================== CallKit Display Management ====================

  /// Shows a missed call notification
  Future<void> showMissedCallNotification({
    required VCallNotificationModel model,
    required bool fromBackground,
    VLocalNativeApi? nativeLocal,
  }) async {
    try {
      // Guard against duplicate missed-call notifications for the same callId
      if (_missedNotifiedCallIds.contains(model.callId)) return;
      if (fromBackground) await configureFlutterCallKeep(fromBackground);
      _nativeLocal = nativeLocal;
      final callEvent = _createCallEvent(model);
      await FlutterCallkitIncoming.showMissCallNotification(callEvent);
      _missedNotifiedCallIds.add(model.callId);
    } catch (e) {
      _handleError('Error showing missed call notification: $e');
    }
  }

  /// Displays the incoming call UI using CallKit
  /// [model] - Call notification model with call details
  /// [fromBackground] - Whether the call is being shown from background
  /// [nativeLocal] - Optional native API instance for background operations
  Future<void> startShowCallKeep({
    required VCallNotificationModel model,
    required bool fromBackground,
    VLocalNativeApi? nativeLocal,
  }) async {
    try {
      // Configure CallKeep if coming from background
      if (fromBackground) await configureFlutterCallKeep(fromBackground);

      _nativeLocal = nativeLocal;

      // Create the call event parameters
      final callEvent = _createCallEvent(model);

      // Show CallKit UI on Android (iOS handles this automatically)
      if (VPlatforms.isAndroid) {
        await FlutterCallkitIncoming.showCallkitIncoming(callEvent);
      }
    } catch (e) {
      _handleError('Error showing call: $e');
    }
  }

  /// Creates CallKit parameters for displaying the incoming call
  /// [model] - Call notification model containing call information
  /// Returns configured CallKitParams for the incoming call
  CallKitParams _createCallEvent(VCallNotificationModel model) {
    final isGroupCall = model.roomType == VRoomType.g;
    final isRejectedCall = model.callStatus == VCallStatus.rejected;

    return CallKitParams(
      // Generate unique ID for this call instance
      id: const Uuid().v4(),
      nameCaller: model.userName,
      appName: _CallKitConstants.appName,
      avatar: "https://d2tsezjta5unsu.cloudfront.net/${model.userImage}",

      // Create descriptive handle text based on call type
      handle: _buildCallHandleText(model, isGroupCall, isRejectedCall),

      // Call type: 1 = video, 0 = audio
      type: model.withVideo ? 1 : 0,
      textAccept: _getLocalizedText('accept'),
      textDecline: _getLocalizedText('decline'),

      // Configure call notifications
      callingNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
      ),
      missedCallNotification: NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: _getLocalizedText('missedCall'),
        callbackText: _getLocalizedText('callBack'),
      ),

      // Call timeout duration in milliseconds
      duration: _CallKitConstants.callTimeoutDurationMs,

      // Store call model data for event handling
      extra: model.toMap(),

      // Android-specific configuration
      android: _buildAndroidParams(model),

      // iOS-specific configuration
      ios: _buildIOSParams(model, isGroupCall),
    );
  }

  /// Builds Android-specific parameters
  AndroidParams _buildAndroidParams(VCallNotificationModel model) {
    return AndroidParams(
      isCustomNotification: false,
      isShowLogo: false,
      isShowFullLockedScreen: true,
      ringtonePath: _CallKitConstants.defaultRingtone,
      backgroundColor: _CallKitConstants.defaultBackgroundColor,
      backgroundUrl: model.userImageS3,
      actionColor: _CallKitConstants.defaultActionColor,
      textColor: _CallKitConstants.defaultTextColor,
      isImportant: true,
      incomingCallNotificationChannelName:
          _CallKitConstants.incomingCallChannelName,
      missedCallNotificationChannelName:
          _CallKitConstants.missedCallChannelName,
      isShowCallID: false,
    );
  }

  /// Builds iOS-specific parameters
  IOSParams _buildIOSParams(VCallNotificationModel model, bool isGroupCall) {
    return IOSParams(
      iconName: _CallKitConstants.defaultIconName,
      handleType: 'generic',
      supportsVideo: model.withVideo,
      maximumCallGroups: _CallKitConstants.maxCallGroupsIOS,
      maximumCallsPerCallGroup: isGroupCall
          ? _CallKitConstants.maxCallsPerGroupForGroup
          : _CallKitConstants.maxCallsPerGroupDefault,
      audioSessionMode: _CallKitConstants.defaultAudioSessionMode,
      audioSessionActive: true,
      audioSessionPreferredSampleRate: _CallKitConstants.defaultSampleRate,
      audioSessionPreferredIOBufferDuration:
          _CallKitConstants.defaultIOBufferDuration,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtonePath: _CallKitConstants.defaultRingtone,
      configureAudioSession: true,
    );
  }

  /// Builds the call handle text based on call type and status
  String _buildCallHandleText(
      VCallNotificationModel model, bool isGroupCall, bool isRejectedCall) {
    if (isRejectedCall) {
      return _getLocalizedText('rejected');
    }

    final callType = model.withVideo
        ? _getLocalizedText('videoCall')
        : _getLocalizedText('voiceCall');
    final groupName = isGroupCall ? model.groupName : '';

    return '${_getLocalizedText('incomingCall')} ${isGroupCall ? groupName : ''} $callType';
  }

  /// Gets localized text (placeholder - should be replaced with proper i18n)
  String _getLocalizedText(String key) {
    // TODO: Replace with proper localization
    const localizedTexts = {
      'accept': 'Accept',
      'decline': 'Decline',
      'missedCall': 'missed call',
      'callBack': 'Call back',
      'rejected': 'Rejected',
      'videoCall': 'video',
      'voiceCall': 'voice',
      'incomingCall': 'Incoming call',
      'callConnected': 'Call connected',
      'callEnded': 'Call ended',
      'callTimeout': 'Call timeout',
      'microphonePermissionRequired': 'Microphone permission must be accepted',
      'microphoneAndCameraPermissionRequired':
          'Microphone and Camera permission must be accepted',
    };
    return localizedTexts[key] ?? key;
  }

  // ==================== Call Status Checking ====================

  /// Checks for any stored call data from background operations
  /// Processes accepted calls that haven't been handled yet
  Future<void> checkLastCall() async {
    try {
      final callData = await _getStoredCallData();
      if (callData == null) return;

      // Process the call if it meets the criteria
      if (_shouldProcessCall(callData)) {
        await _processStoredCall(callData);
      }
    } catch (e) {
      _handleError('Error checking last call: $e');
    }
  }

  /// Determines if a stored call should be processed
  /// [model] - Background call model to evaluate
  /// Returns true if call should be processed
  bool _shouldProcessCall(CallKitBackgroundCallModel model) {
    return !model.isProcessed && model.isAccepted && _isCallValid(model.date);
  }

  /// Checks if a call is still within the valid time window
  /// [date] - The date when the call was received
  /// Returns true if call is still valid
  bool _isCallValid(DateTime date) {
    final callAge = DateTime.now().difference(date);
    return callAge.inSeconds <= _CallKitConstants.callValidityDurationSeconds;
  }

  // ==================== Background Call Handling ====================

  /// Handles call decline action when app is in background
  /// Makes API call to end the call on the server
  /// [event] - Event data containing call information
  Future<void> _handleCallDeclinedBackground(Map<String, dynamic> event) async {
    try {
      // Initialize native API for background operations
      final nativeLocal = VLocalNativeApi();
      await nativeLocal.init();

      // Extract call model from event data
      final model = VCallNotificationModel.fromMap(event);

      // Store the declined call data
      await _storeCallData(model, false);

      // Make API call to end the call on server with zero duration (not connected)
      await _endCallOnServer(model, durationSeconds: 0);
    } catch (e) {
      _handleError('Error handling declined call in background: $e');
    }
  }

  /// Makes API call to end the call on the server
  Future<void> _endCallOnServer(VCallNotificationModel model, {required int durationSeconds}) async {
    try {
      // Initialize preferences to get API configuration
      await VAppPref.init();
      final baseUrl = VAppPref.getStringOrNullKey(SStorageKeys.vBaseUrl.name);

      if (baseUrl == null) {
        _handleError('Base URL not found in preferences');
        return;
      }

      // Make API call to end the call on server
      final response = await post(
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
        _handleError('Failed to end call on server: ${response.statusCode}');
      }
    } catch (e) {
      _handleError('Error ending call on server: $e');
    }
  }

  /// Stores call data for later processing
  /// [vModel] - Call notification model
  /// [isAccepted] - Whether the call was accepted or declined
  Future<void> _storeCallData(
      VCallNotificationModel vModel, bool isAccepted) async {
    try {
      // Create background call model with current timestamp
      final model = CallKitBackgroundCallModel(
        date: DateTime.now(),
        isAccepted: isAccepted,
        // Mark declined calls as already processed
        isProcessed: !isAccepted,
        model: vModel,
      );

      // Store in local cache for later retrieval
      await _nativeLocal?.apiCache.insertToApiCache(
        ApiCacheModel(
          endPoint: SStorageKeys.lastAcceptedCall.name,
          value: model.toMap(),
        ),
      );
    } catch (e) {
      _handleError('Error storing call data: $e');
    }
  }

  /// Retrieves stored call data from local cache
  /// Returns null if no stored call data exists
  Future<CallKitBackgroundCallModel?> _getStoredCallData() async {
    try {
      final cacheModel = await VChatController.I.nativeApi.local.apiCache
          .getOneApiCache(SStorageKeys.lastAcceptedCall.name);
      if (cacheModel == null) return null;

      return CallKitBackgroundCallModel.fromMap(cacheModel.value);
    } catch (e) {
      _handleError('Error getting stored call data: $e');
      return null;
    }
  }

  /// Processes a stored call by accepting it and marking as processed
  /// [model] - Background call model to process
  Future<void> _processStoredCall(CallKitBackgroundCallModel model) async {
    try {
      // Check if we're already processing this call
      if (_isNavigatingToCall &&
          _currentNavigatingCallId == model.model.callId) {
        _handleError(
            'Already processing call ${model.model.callId}, skipping duplicate');
        return;
      }

      // Mark the call as processed to prevent duplicate handling
      await VChatController.I.nativeApi.local.apiCache.insertToApiCache(
        ApiCacheModel(
          endPoint: SStorageKeys.lastAcceptedCall.name,
          value: model.copyWith(isProcessed: true).toMap(),
        ),
      );

      // Accept the call using the stored model
      await acceptCall(model.model);
    } catch (e) {
      _handleError('Error processing stored call: $e');
    }
  }

  // ==================== Navigation and UI ====================

  /// Navigates to the call screen with the provided call details
  /// [model] - Call notification model containing call information
  Future<void> _navigateToCallScreen(VCallNotificationModel model) async {
    try {
      VChatController.I.vNavigator.callNavigator.toCall(
        VChatController.I.navigationContext,
        VCallDto(
          isVideoEnable: model.withVideo,
          roomId: model.roomId,
          callId: model.callId,
          peerUser: SBaseUser(
              id: model.callId,
              fullName: model.userName,
              userImage: model.userImage),
          isCaller: false, // This user is receiving the call
        ),
      );
    } catch (e) {
      _handleError('Error navigating to call screen: $e');
    }
  }

  /// Handles and logs errors throughout the class
  /// [message] - Error message to log
  void _handleError(String message) {
    debugPrint('CallKeepHandler Error: $message');
    // TODO: Add analytics and crash reporting here
  }

  // ==================== Public Methods ====================

  /// Ends all active calls
  /// [roomId] - Optional room ID (currently unused)
  Future<void> endCalls(String? roomId) async {
    try {
      await FlutterCallkitIncoming.endAllCalls();
    } catch (e) {
      _handleError('Error ending calls: $e');
    }
  }

  /// Handles server-side cancel/timeout updates.
  /// If the call was not accepted, show a missed call notification from the plugin,
  /// then end any active call UIs. Works for both foreground and background.
  Future<void> onServerCancelOrTimeout({
    required VCallNotificationModel model,
    required bool fromBackground,
    VLocalNativeApi? nativeLocal,
  }) async {
    try {
      if (fromBackground) await configureFlutterCallKeep(fromBackground);
      _nativeLocal = nativeLocal;

      final isAccepted = _acceptedCallIds.contains(model.callId);
      if (!isAccepted) {
        await showMissedCallNotification(
          model: model,
          fromBackground: fromBackground,
          nativeLocal: nativeLocal,
        );
        // Inform server with zero duration (never connected)
        await _endCallOnServer(model, durationSeconds: 0);
      }

      await endCalls(model.roomId);
      _acceptedCallIds.remove(model.callId);
    } catch (e) {
      _handleError('Error handling server cancel/timeout: $e');
    }
  }

  // ==================== Event Handling ====================

  /// Sets up event listeners for CallKit events
  /// [background] - Whether the app is in background mode
  Future<void> _setEventHandler(bool background) async {
    FlutterCallkitIncoming.onEvent.listen((c.CallEvent? event) async {
      if (event == null) return;

      try {
        await _handleCallEvent(event, background);
      } catch (e) {
        _handleError('Error handling call event ${event.event}: $e');
      }
    });
  }

  /// Handles individual call events
  Future<void> _handleCallEvent(c.CallEvent event, bool background) async {
    switch (event.event) {
      case c.Event.actionCallIncoming:
        await _handleIncomingCall(event);
        break;

      case c.Event.actionCallStart:
        await _handleCallStart(event);
        break;

      case c.Event.actionCallAccept:
        await _handleCallAccept(event, background);
        break;

      case c.Event.actionCallDecline:
        await _handleCallDecline(event, background);
        break;

      case c.Event.actionCallEnded:
        await _handleCallEnded(event);
        break;

      case c.Event.actionCallTimeout:
        await _handleCallTimeout(event);
        break;

      case c.Event.actionCallConnected:
        await _handleCallConnected(event);
        break;

      case c.Event.actionCallCallback:
        await _handleCallCallback(event);
        break;

      case c.Event.actionCallToggleHold:
        await _handleCallToggleHold(event);
        break;

      case c.Event.actionCallToggleMute:
        await _handleCallToggleMute(event);
        break;

      case c.Event.actionCallToggleDmtf:
        await _handleCallToggleDTMF(event);
        break;

      case c.Event.actionCallToggleGroup:
        await _handleCallToggleGroup(event);
        break;

      case c.Event.actionCallToggleAudioSession:
        await _handleCallToggleAudioSession(event);
        break;

      case c.Event.actionDidUpdateDevicePushTokenVoip:
        await _handleDevicePushTokenUpdate(event);
        break;

      case c.Event.actionCallCustom:
        await _handleCallCustom(event);
    }
  }

  /// Handles incoming call event
  Future<void> _handleIncomingCall(c.CallEvent event) async {
    debugPrint('Incoming call event received');
    // Additional handling for incoming call event if needed
  }

  /// Handles call start event
  Future<void> _handleCallStart(c.CallEvent event) async {
    debugPrint('Call start event received');
    // Show calling screen in Flutter if needed
  }

  /// Handles call accept event
  Future<void> _handleCallAccept(c.CallEvent event, bool background) async {
    // Extract call data from event
    final Map<String, dynamic> extraMap =
        (event.body['extra'] as Map).cast<String, dynamic>();
    final model = VCallNotificationModel.fromMap(extraMap);

    // Mark this call as accepted to avoid false missed notifications
    _acceptedCallIds.add(model.callId);

    // Handle call acceptance based on platform and background state
    if (VPlatforms.isIOS) {
      // For iOS, always accept the call immediately
      // The native side will handle app launching if needed
      await acceptCall(model);
    } else if (!background) {
      // Directly accept call for foreground Android
      await acceptCall(model);
    } else {
      // Store call data for background Android processing
      await _storeCallData(model, true);
    }
  }

  /// Handles call decline event
  Future<void> _handleCallDecline(c.CallEvent event, bool fromBackground) async {
    // Extract call data and handle decline
    final Map<String, dynamic> extraMap =
        (event.body['extra'] as Map).cast<String, dynamic>();
    final model = VCallNotificationModel.fromMap(extraMap);
    // You might want to show a missed call notification or update UI
    await showMissedCallNotification(
      model: model,
      fromBackground: fromBackground,
    );
    await _handleCallDeclinedBackground(extraMap);
  }

  /// Handles call ended event
  Future<void> _handleCallEnded(c.CallEvent event) async {
    debugPrint('Call ended event received');
    // Determine if this should be considered a missed call
    try {
      final Map<String, dynamic> extraMap =
          (event.body['extra'] as Map).cast<String, dynamic>();
      final model = VCallNotificationModel.fromMap(extraMap);

      final isAccepted = _acceptedCallIds.contains(model.callId);

      // If the call was never accepted, treat it as missed
      if (!isAccepted) {
        await showMissedCallNotification(
          model: model,
          fromBackground: true,
        );
        // Send zero duration for missed call
        await _endCallOnServer(model, durationSeconds: 0);
      } else {
        // Compute duration for accepted calls if we have a start time
        final start = _callStartTimes.remove(model.callId);
        final seconds = start != null
            ? DateTime.now().difference(start).inSeconds
            : 0;
        await _endCallOnServer(model, durationSeconds: seconds);
      }

      // Cleanup accepted flag for this call
      _acceptedCallIds.remove(model.callId);
    } catch (e) {
      _handleError('Error processing call ended event: $e');
    }
  }

  /// Handles call timeout event
  Future<void> _handleCallTimeout(c.CallEvent event) async {
    debugPrint('Call timeout event received');
    // Handle missed call scenario
    final Map<String, dynamic> extraMap =
        (event.body['extra'] as Map).cast<String, dynamic>();
    final model = VCallNotificationModel.fromMap(extraMap);

    // You might want to show a missed call notification or update UI
    await showMissedCallNotification(
      model: model,
      fromBackground: true,
    );
    // Inform server with zero duration
    await _endCallOnServer(model, durationSeconds: 0);
  }

  /// Handles call connected event - NOW IMPLEMENTED!
  Future<void> _handleCallConnected(c.CallEvent event) async {
    debugPrint('Call connected event received');

    // Extract call data from event
    final Map<String, dynamic> extraMap =
        (event.body['extra'] as Map).cast<String, dynamic>();
    final model = VCallNotificationModel.fromMap(extraMap);

    // Update call status to connected/in-call
    // This is where you'd typically update your call UI to show connected state
    debugPrint('Call with ${model.userName} is now connected');

    // Track start time for duration calculation
    _callStartTimes[model.callId] = DateTime.now();

    // You might want to notify your call controller about the connection
    // or update any UI elements to show the call is active
  }

  /// Handles call callback event (Android only)
  Future<void> _handleCallCallback(c.CallEvent event) async {
    debugPrint('Call callback event received (Android only)');
    // Handle callback action - typically for "call back" button on missed calls
  }

  /// Handles call hold toggle (iOS only)
  Future<void> _handleCallToggleHold(c.CallEvent event) async {
    debugPrint('Call hold toggle event received (iOS only)');
    // Handle hold/unhold functionality
  }

  /// Handles call mute toggle (iOS only)
  Future<void> _handleCallToggleMute(c.CallEvent event) async {
    debugPrint('Call mute toggle event received (iOS only)');
    // Handle mute/unmute functionality
  }

  /// Handles DTMF toggle (iOS only)
  Future<void> _handleCallToggleDTMF(c.CallEvent event) async {
    debugPrint('Call DTMF toggle event received (iOS only)');
    // Handle DTMF (dual-tone multi-frequency) functionality
  }

  /// Handles call group toggle (iOS only)
  Future<void> _handleCallToggleGroup(c.CallEvent event) async {
    debugPrint('Call group toggle event received (iOS only)');
    // Handle group call functionality
  }

  /// Handles audio session toggle (iOS only)
  Future<void> _handleCallToggleAudioSession(c.CallEvent event) async {
    debugPrint('Call audio session toggle event received (iOS only)');
    // Handle audio session management
  }

  /// Handles device push token update
  Future<void> _handleDevicePushTokenUpdate(c.CallEvent event) async {
    debugPrint('Device push token update event received');
    // Handle VoIP push token updates
  }

  /// Handles custom call actions
  Future<void> _handleCallCustom(c.CallEvent event) async {
    debugPrint('Custom call event received');
    // Handle any custom actions you might have defined
  }
}
