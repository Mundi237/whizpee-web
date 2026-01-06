// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// Immutable model representing the state of a call participant
@immutable
class AgoraUser {
  const AgoraUser({
    required this.uid,
    this.name,
    this.isAudioEnabled,
    this.isVideoEnabled,
    this.view,
    this.connectionQuality = ConnectionQuality.unknown,
  });

  final int uid;
  final String? name;
  final bool? isAudioEnabled;
  final bool? isVideoEnabled;
  final Widget? view;
  final ConnectionQuality connectionQuality;

  AgoraUser copyWith({
    int? uid,
    String? name,
    bool? isAudioEnabled,
    bool? isVideoEnabled,
    Widget? view,
    ConnectionQuality? connectionQuality,
  }) {
    return AgoraUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      view: view ?? this.view,
      connectionQuality: connectionQuality ?? this.connectionQuality,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AgoraUser && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;

  @override
  String toString() {
    return 'AgoraUser{uid: $uid, name: $name, isAudioEnabled: $isAudioEnabled, isVideoEnabled: $isVideoEnabled, connectionQuality: $connectionQuality}';
  }
}

/// Enumeration representing connection quality levels
enum ConnectionQuality {
  unknown,
  excellent,
  good,
  poor,
  bad,
  veryBad,
  down,
}

/// Extension to provide UI-friendly properties for ConnectionQuality
extension ConnectionQualityExtension on ConnectionQuality {
  String get displayName {
    switch (this) {
      case ConnectionQuality.unknown:
        return 'Unknown';
      case ConnectionQuality.excellent:
        return 'Excellent';
      case ConnectionQuality.good:
        return 'Good';
      case ConnectionQuality.poor:
        return 'Poor';
      case ConnectionQuality.bad:
        return 'Bad';
      case ConnectionQuality.veryBad:
        return 'Very Bad';
      case ConnectionQuality.down:
        return 'Disconnected';
    }
  }

  Color get color {
    switch (this) {
      case ConnectionQuality.unknown:
        return const Color(0xFF9E9E9E);
      case ConnectionQuality.excellent:
        return const Color(0xFF4CAF50);
      case ConnectionQuality.good:
        return const Color(0xFF8BC34A);
      case ConnectionQuality.poor:
        return const Color(0xFFFF9800);
      case ConnectionQuality.bad:
        return const Color(0xFFFF5722);
      case ConnectionQuality.veryBad:
        return const Color(0xFFF44336);
      case ConnectionQuality.down:
        return const Color(0xFF424242);
    }
  }

  int get signalBars {
    switch (this) {
      case ConnectionQuality.unknown:
        return 0;
      case ConnectionQuality.excellent:
        return 4;
      case ConnectionQuality.good:
        return 3;
      case ConnectionQuality.poor:
        return 2;
      case ConnectionQuality.bad:
        return 1;
      case ConnectionQuality.veryBad:
        return 1;
      case ConnectionQuality.down:
        return 0;
    }
  }
}

/// Call statistics for monitoring call quality
@immutable
class CallStatistics {
  const CallStatistics({
    this.duration = Duration.zero,
    this.totalBytes = 0,
    this.audioPacketsLost = 0,
    this.videoPacketsLost = 0,
    this.networkDelay = 0,
  });

  final Duration duration;
  final int totalBytes;
  final int audioPacketsLost;
  final int videoPacketsLost;
  final int networkDelay;

  CallStatistics copyWith({
    Duration? duration,
    int? totalBytes,
    int? audioPacketsLost,
    int? videoPacketsLost,
    int? networkDelay,
  }) {
    return CallStatistics(
      duration: duration ?? this.duration,
      totalBytes: totalBytes ?? this.totalBytes,
      audioPacketsLost: audioPacketsLost ?? this.audioPacketsLost,
      videoPacketsLost: videoPacketsLost ?? this.videoPacketsLost,
      networkDelay: networkDelay ?? this.networkDelay,
    );
  }

  @override
  String toString() {
    return 'CallStatistics{duration: $duration, totalBytes: $totalBytes, audioPacketsLost: $audioPacketsLost, videoPacketsLost: $videoPacketsLost, networkDelay: $networkDelay}';
  }
}

/// Immutable model representing the complete state of a call
@immutable
class ImprovedCallState {
  const ImprovedCallState({
    required this.status,
    this.callId,
    required this.isMicEnabled,
    required this.isSpeakerEnabled,
    required this.isVideoEnabled,
    required this.users,
    this.currentUid,
    this.statistics = const CallStatistics(),
    this.error,
  });

  final VCallStatus status;
  final String? callId;
  final bool isMicEnabled;
  final bool isSpeakerEnabled;
  final bool isVideoEnabled;
  final Set<AgoraUser> users;
  final int? currentUid;
  final CallStatistics statistics;
  final String? error;

  /// Factory constructor for initial state
  factory ImprovedCallState.initial() {
    return const ImprovedCallState(
      status: VCallStatus.ring,
      isMicEnabled: true,
      isSpeakerEnabled: false,
      isVideoEnabled: false,
      users: <AgoraUser>{},
      statistics: CallStatistics(),
    );
  }

  /// Computed properties
  bool get hasUsers => users.isNotEmpty;
  bool get isInCall => status == VCallStatus.inCall;
  bool get isActive =>
      status == VCallStatus.inCall || status == VCallStatus.ring;
  int get userCount => users.length;
  bool get hasError => error != null;

  /// Get current user
  AgoraUser? get currentUser {
    if (currentUid == null) return null;
    try {
      return users.firstWhere((user) => user.uid == currentUid);
    } catch (e) {
      return null;
    }
  }

  /// Get remote users (excluding current user)
  Set<AgoraUser> get remoteUsers {
    if (currentUid == null) return users;
    return users.where((user) => user.uid != currentUid).toSet();
  }

  /// Get users with video enabled
  Set<AgoraUser> get videoEnabledUsers {
    return users.where((user) => user.isVideoEnabled == true).toSet();
  }

  /// Get users with audio enabled
  Set<AgoraUser> get audioEnabledUsers {
    return users.where((user) => user.isAudioEnabled == true).toSet();
  }

  /// Create a copy with updated values
  ImprovedCallState copyWith({
    VCallStatus? status,
    String? callId,
    bool? isMicEnabled,
    bool? isSpeakerEnabled,
    bool? isVideoEnabled,
    Set<AgoraUser>? users,
    int? currentUid,
    CallStatistics? statistics,
    String? error,
  }) {
    return ImprovedCallState(
      status: status ?? this.status,
      callId: callId ?? this.callId,
      isMicEnabled: isMicEnabled ?? this.isMicEnabled,
      isSpeakerEnabled: isSpeakerEnabled ?? this.isSpeakerEnabled,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      users: users ?? this.users,
      currentUid: currentUid ?? this.currentUid,
      statistics: statistics ?? this.statistics,
      error: error,
    );
  }

  /// Create a copy with cleared error
  ImprovedCallState clearError() {
    return copyWith(error: null);
  }

  /// Create a copy with updated user
  ImprovedCallState updateUser(AgoraUser updatedUser) {
    final updatedUsers = users.map((user) {
      return user.uid == updatedUser.uid ? updatedUser : user;
    }).toSet();

    return copyWith(users: updatedUsers);
  }

  /// Create a copy with added user
  ImprovedCallState addUser(AgoraUser newUser) {
    return copyWith(users: {...users, newUser});
  }

  /// Create a copy with removed user
  ImprovedCallState removeUser(int uid) {
    final updatedUsers = users.where((user) => user.uid != uid).toSet();
    return copyWith(users: updatedUsers);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImprovedCallState &&
        other.status == status &&
        other.callId == callId &&
        other.isMicEnabled == isMicEnabled &&
        other.isSpeakerEnabled == isSpeakerEnabled &&
        other.isVideoEnabled == isVideoEnabled &&
        setEquals(other.users, users) &&
        other.currentUid == currentUid &&
        other.statistics == statistics &&
        other.error == error;
  }

  @override
  int get hashCode {
    return Object.hash(
      status,
      callId,
      isMicEnabled,
      isSpeakerEnabled,
      isVideoEnabled,
      users,
      currentUid,
      statistics,
      error,
    );
  }

  @override
  String toString() {
    return 'ImprovedCallState{status: $status, callId: $callId, isMicEnabled: $isMicEnabled, isSpeakerEnabled: $isSpeakerEnabled, isVideoEnabled: $isVideoEnabled, users: ${users.length}, currentUid: $currentUid, hasError: $hasError}';
  }
}

/// State management extension for validation
extension ImprovedCallStateValidation on ImprovedCallState {
  /// Validate if the current state is valid
  bool get isValid {
    // Basic validation rules
    if (isInCall && users.isEmpty) return false;
    if (currentUid != null && currentUser == null) return false;
    return true;
  }

  /// Get validation errors
  List<String> get validationErrors {
    final errors = <String>[];

    if (isInCall && users.isEmpty) {
      errors.add('Call is active but no users present');
    }

    if (currentUid != null && currentUser == null) {
      errors.add('Current user ID set but user not found');
    }

    return errors;
  }
}
