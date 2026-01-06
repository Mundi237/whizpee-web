import 'call_state.dart';

/// Data class containing all information needed for call notifications
class CallNotificationData {
  const CallNotificationData({
    required this.callId,
    required this.callerName,
    required this.callerAvatarUrl,
    required this.callState,
    required this.callDuration,
    this.isVideoCall = false,
    this.isMuted = false,
    this.isSpeakerOn = false,
    this.isIncoming = false,
  });

  /// Unique identifier for the call
  final String callId;

  /// Display name of the caller/callee
  final String callerName;

  /// URL to caller's avatar image
  final String? callerAvatarUrl;

  /// Current state of the call
  final CallState callState;

  /// Duration of the call in seconds
  final int callDuration;

  /// Whether this is a video call
  final bool isVideoCall;

  /// Whether the call is muted
  final bool isMuted;

  /// Whether speaker is on
  final bool isSpeakerOn;

  /// Whether this is an incoming call
  final bool isIncoming;

  /// Creates a copy with updated values
  CallNotificationData copyWith({
    String? callId,
    String? callerName,
    String? callerAvatarUrl,
    CallState? callState,
    int? callDuration,
    bool? isVideoCall,
    bool? isMuted,
    bool? isSpeakerOn,
    bool? isIncoming,
  }) {
    return CallNotificationData(
      callId: callId ?? this.callId,
      callerName: callerName ?? this.callerName,
      callerAvatarUrl: callerAvatarUrl ?? this.callerAvatarUrl,
      callState: callState ?? this.callState,
      callDuration: callDuration ?? this.callDuration,
      isVideoCall: isVideoCall ?? this.isVideoCall,
      isMuted: isMuted ?? this.isMuted,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      isIncoming: isIncoming ?? this.isIncoming,
    );
  }

  /// Formats call duration as MM:SS
  String get formattedDuration {
    final minutes = callDuration ~/ 60;
    final seconds = callDuration % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  /// Gets the notification title based on call state
  String get notificationTitle {
    if (callState == CallState.ringing && isIncoming) {
      return 'Incoming call from $callerName';
    } else if (callState == CallState.dialing) {
      return 'Calling $callerName';
    } else if (callState.isActive) {
      return 'Call with $callerName';
    }
    return callerName;
  }

  /// Gets the notification content based on call state and duration
  String get notificationContent {
    if (callState == CallState.ringing) {
      return isIncoming ? 'Incoming call' : 'Ringing...';
    } else if (callState == CallState.dialing) {
      return 'Dialing...';
    } else if (callState.isActive) {
      final callType = isVideoCall ? 'Video' : 'Voice';
      final status = isMuted ? 'Muted' : 'Active';
      return '$callType call • $status • $formattedDuration';
    }
    return callState.displayName;
  }

  @override
  String toString() {
    return 'CallNotificationData('
        'callId: $callId, '
        'callerName: $callerName, '
        'callState: $callState, '
        'duration: $formattedDuration, '
        'isVideoCall: $isVideoCall, '
        'isMuted: $isMuted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CallNotificationData &&
        other.callId == callId &&
        other.callerName == callerName &&
        other.callerAvatarUrl == callerAvatarUrl &&
        other.callState == callState &&
        other.callDuration == callDuration &&
        other.isVideoCall == isVideoCall &&
        other.isMuted == isMuted &&
        other.isSpeakerOn == isSpeakerOn &&
        other.isIncoming == isIncoming;
  }

  @override
  int get hashCode {
    return Object.hash(
      callId,
      callerName,
      callerAvatarUrl,
      callState,
      callDuration,
      isVideoCall,
      isMuted,
      isSpeakerOn,
      isIncoming,
    );
  }
}
