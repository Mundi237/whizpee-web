// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class SVersion {
  final bool isNeedUpdates;
  final bool isCritical;
  final String clientVersion;
  final String? notes;
  final String serverVersion;
  final String platform;

  SVersion({
    required this.isNeedUpdates,
    required this.isCritical,
    required this.clientVersion,
    required this.notes,
    required this.serverVersion,
    required this.platform,
  });

  SVersion.empty()
      : isNeedUpdates = false,
        isCritical = false,
        clientVersion = "",
        notes = "",
        platform = "",
        serverVersion = "1.0.0";

  Map<String, dynamic> toMap() {
    return {
      'isNeedUpdates': isNeedUpdates,
      'isCritical': isCritical,
      'clientVersion': clientVersion,
      'notes': notes,
      'serverVersion': serverVersion,
      'platform': platform,
    };
  }

  @override
  String toString() {
    return 'SVersion{isNeedUpdates: $isNeedUpdates, isCritical: $isCritical, clientVersion: $clientVersion, notes: $notes, serverVersion: $serverVersion, platform: $platform}';
  }

  factory SVersion.fromMap(Map<String, dynamic> map) {
    return SVersion(
      isNeedUpdates: map['isNeedUpdates'] as bool,
      isCritical: map['isCritical'] as bool,
      clientVersion: map['clientVersion'] as String,
      notes: map['notes'] as String?,
      serverVersion: map['serverVersion'] as String,
      platform: map['platform'] as String,
    );
  }
}
