// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VGroupMember {
  final SBaseUser userData;
  final VGroupMemberRole role;
  final String createdAt;

//<editor-fold desc="Data Methods">
  const VGroupMember({
    required this.userData,
    required this.role,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VGroupMember &&
          runtimeType == other.runtimeType &&
          userData == other.userData &&
          role == other.role);

  @override
  int get hashCode => userData.hashCode ^ role.hashCode;
  DateTime get createdAtLocal => DateTime.parse(createdAt).toLocal();
  @override
  String toString() {
    return 'VGroupMember{userData: $userData, role: $role}';
  }

  VGroupMember copyWith({
    SBaseUser? user,
    VGroupMemberRole? role,
    String? createdAt,
  }) {
    return VGroupMember(
      userData: user ?? userData,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userData': userData,
      'gR': role.name,
      'createdAt': createdAt,
    };
  }

  factory VGroupMember.fromMap(Map<String, dynamic> map) {
    return VGroupMember(
      userData: SBaseUser.fromMap(map['userData'] as Map<String, dynamic>),
      role: VGroupMemberRole.values.byName(map['gR'] as String),
      createdAt: map['createdAt'] as String,
    );
  }

//</editor-fold>
}
