// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:ui';

import 'package:s_translation/generated/l10n.dart';

import '../../../super_up_core.dart';

class AuthMethod {
  final RegisterMethod type;
  final String identifier;

//<editor-fold desc="Data Methods">
  const AuthMethod({
    required this.type,
    required this.identifier,
  });

  @override
  String toString() {
    return 'AuthMethod{ type: $type, identifier: $identifier,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'identifier': identifier,
    };
  }

  factory AuthMethod.fromMap(Map<String, dynamic> map) {
    return AuthMethod(
      type: RegisterMethod.values.byName(map['type'] as String),
      identifier: map['identifier'] as String,
    );
  }

//</editor-fold>
}

class SMyProfile {
  final SBaseUser baseUser;
  final RegisterStatus registerStatus;
  final Locale language;
  final String deviceId;
  final String? bio;
  final List<UserRoles> roles;
  final AuthMethod? authMethod;
  final UserPrivacy userPrivacy;

  ///getters
  bool get isPrime => roles.contains(UserRoles.prime);

  bool get hasBadge => roles.contains(UserRoles.hasBadge);

//<editor-fold desc="Data Methods">

  const SMyProfile({
    required this.baseUser,
    required this.registerStatus,
    required this.language,
    required this.deviceId,
    this.authMethod,
    required this.bio,
    required this.roles,
    required this.userPrivacy,
  });

  String get userBio {
    if (bio == null) return "${S.current.hiIamUse} ${SConstants.appName}";
    return bio!;
  }

  @override
  String toString() {
    return 'SMyProfile{baseUser: $baseUser, registerStatus: $registerStatus, language: $language, deviceId: $deviceId, bio: $bio, roles: $roles, }';
  }

  Map<String, dynamic> toMap() {
    return {
      'me': {
        ...baseUser.toMap(),
        'registerStatus': registerStatus.name,
        'bio': bio,
        'authMethod': authMethod?.toMap(),
        'roles': roles.map((e) => e.name).toList(),
        'isPrime': isPrime,
        'hasBadge': hasBadge,
        'userPrivacy': userPrivacy.toMap(),
      },
      'currentDevice': {
        "_id": deviceId,
        "language": language.toString(),
      },
    };
  }

  factory SMyProfile.fromMap(Map<String, dynamic> map) {
    return SMyProfile(
      baseUser: SBaseUser.fromMap(map['me'] as Map<String, dynamic>),
      bio: map['me']['bio'] as String?,
      userPrivacy: (map['me']['userPrivacy'] as Map<String, dynamic>?) == null
          ? const UserPrivacy.defaults()
          : UserPrivacy.fromMap(map['me']['userPrivacy']),
      roles: (map['me']['roles'] as List?)
              ?.map((e) => UserRoles.values.byName(e.toString()))
              .toList() ??
          [],
      language: Locale(
        (map['currentDevice'] as Map<String, dynamic>)['language'] as String,
      ),
      authMethod: map['me']['authMethod'] is Map
          ? AuthMethod.fromMap(map['me']['authMethod'] as Map<String, dynamic>)
          : null,
      deviceId: (map['currentDevice'] as Map<String, dynamic>)['_id'] as String,
      registerStatus:
          RegisterStatus.values.byName(map['me']['registerStatus'] as String),
    );
  }

  SMyProfile copyWith({
    SBaseUser? baseUser,
    RegisterStatus? registerStatus,
    Locale? language,
    String? deviceId,
    List<UserRoles>? roles,
    String? bio,
    AuthMethod? authMethod,
    UserPrivacy? userPrivacy,
  }) {
    return SMyProfile(
      baseUser: baseUser ?? this.baseUser,
      registerStatus: registerStatus ?? this.registerStatus,
      language: language ?? this.language,
      deviceId: deviceId ?? this.deviceId,
      userPrivacy: userPrivacy ?? this.userPrivacy,
      roles: roles ?? this.roles,
      authMethod: authMethod ?? this.authMethod,
      bio: bio ?? this.bio,
    );
  }
//</editor-fold>
}
