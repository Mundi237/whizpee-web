/// Represents the current state of a phone call
enum CallState {
  /// Call is being initiated/dialing
  dialing,

  /// Call is ringing (incoming call)
  ringing,

  /// Call is connected and active
  connected,

  /// Call is on hold
  onHold,

  /// Call is muted
  muted,

  /// Call has ended
  ended,

  /// Call failed or was rejected
  failed,
}

/// Extension to get user-friendly call state descriptions
extension CallStateExtension on CallState {
  String get displayName {
    switch (this) {
      case CallState.dialing:
        return 'Dialing...';
      case CallState.ringing:
        return 'Incoming Call';
      case CallState.connected:
        return 'Connected';
      case CallState.onHold:
        return 'On Hold';
      case CallState.muted:
        return 'Muted';
      case CallState.ended:
        return 'Call Ended';
      case CallState.failed:
        return 'Call Failed';
    }
  }

  bool get isActive =>
      this == CallState.connected ||
      this == CallState.onHold ||
      this == CallState.muted;

  bool get shouldShowForegroundService =>
      this != CallState.ended && this != CallState.failed;
}
