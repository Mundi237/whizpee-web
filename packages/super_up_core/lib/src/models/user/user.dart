// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:enum_to_string/enum_to_string.dart';
import 'package:s_translation/generated/l10n.dart';

import '../../../super_up_core.dart';

enum SUserRole { prime, admin, hasBadge, bug }

class SBaseUser {
  final String id;
  final String userImage;
  final String fullName;

//<editor-fold desc="Data Methods">

  const SBaseUser({
    required this.id,
    required this.fullName,
    required this.userImage,
  });

  bool get isMe => id == AppAuth.myId;

  String get userImageS3 => SConstants.baseMediaUrl + userImage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SBaseUser && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User{'
        ' id: $id,'
        ' fullName: $fullName,'
        ' userImage: $userImage,'
        '}';
  }

  static const myUser = SBaseUser(
    id: "1",
    fullName: "user 1",
    userImage:
        "https://www.kindpng.com/picc/m/24-248253_user-profile-default-image-png-clipart-png-download.png",
  );

  SBaseUser copyWith({
    String? id,
    String? email,
    String? fullName,
    String? userImage,
  }) {
    return SBaseUser(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      userImage: userImage ?? this.userImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'fullName': fullName,
      'userImage': userImage,
    };
  }

  factory SBaseUser.fromMap(Map<String, dynamic> map) {
    return SBaseUser(
      id: map['_id'] as String,
      fullName: map['fullName'] as String,
      userImage: map['userImage'] as String,
    );
  }

//</editor-fold>
}

class SSearchUser {
  final SBaseUser baseUser;
  final String? bio;
  final String createdAt;
  final List<SUserRole> roles;

//<editor-fold desc="Data Methods">

  const SSearchUser({
    required this.baseUser,
    required this.bio,
    required this.roles,
    required this.createdAt,
  });

  bool get isPrime => roles.contains(SUserRole.prime);

  bool get hasBadge => roles.contains(SUserRole.hasBadge);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SSearchUser &&
          runtimeType == other.runtimeType &&
          baseUser == other.baseUser &&
          bio == other.bio &&
          createdAt == other.createdAt);

  @override
  int get hashCode => baseUser.hashCode ^ bio.hashCode ^ createdAt.hashCode;

  @override
  String toString() {
    return 'SSearchUser{ baseUser: $baseUser, bio: $bio, createdAt: $createdAt,}';
  }

  String get getUserBio {
    if (bio == null) return "${S.current.hiIamUse} ${SConstants.appName}";
    return bio!;
  }

  Map<String, dynamic> toMap() {
    return {
      ...baseUser.toMap(),
      'bio': bio,
      'createdAt': createdAt,
      'roles': roles.map((e) => e.name).toList(),
    };
  }

  factory SSearchUser.fromMap(Map<String, dynamic> map) {
    return SSearchUser(
      baseUser: SBaseUser.fromMap(map),
      bio: map['bio'] as String?,
      roles: map['roles'] == null
          ? []
          : (map['roles'] as List)
              .map((e) =>
                  EnumToString.fromString(SUserRole.values, e) ?? SUserRole.bug)
              .toList(),
      createdAt: map['createdAt'] as String,
    );
  }

//</editor-fold>
}

class SSelectableUser {
  final SSearchUser searchUser;
  bool isSelected = false;

  SSelectableUser({
    required this.searchUser,
    this.isSelected = false,
  });
}
