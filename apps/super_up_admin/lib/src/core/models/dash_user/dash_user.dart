// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:super_up_core/super_up_core.dart';

import 'dash_country.dart';

class DashUser {
  final DashCountry? country;
  final String id;
  final String emailX;
  final String fullName;
  final String fullNameEn;
  final String? bio;
  final String? verifiedAt;
  final String userImage;
  final bool isOnline;
  final bool isPrime;
  final bool hasBadge;
  final String registerStatus;
  final String registerMethod;
  final String? banTo;
  final String? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

//<editor-fold desc="Data Methods">
  const DashUser({
    this.country,
    required this.id,
    required this.emailX,
    required this.isPrime,
    required this.hasBadge,
    required this.fullName,
    required this.isOnline,
    required this.fullNameEn,
    this.bio,
    this.verifiedAt,
    required this.userImage,
    required this.registerStatus,
    required this.registerMethod,
    this.banTo,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  String get email => VAppPref.getBool(SStorageKeys.isViewer.name) == true
      ? "xxxxxx@xxx.xxxx"
      : emailX;

  DashUser.empty()
      : country = null,
        id = "------",
        emailX = "------",
        fullName = "------",
        fullNameEn = "------",
        isOnline = false,
        bio = null,
        verifiedAt = null,
        isPrime = false,
        hasBadge = false,
        userImage = "default_user_image.png",
        registerStatus = RegisterStatus.accepted.name,
        registerMethod = RegisterMethod.email.name,
        banTo = null,
        deletedAt = null,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  @override
  String toString() {
    return 'DashUser{ countryId: $country, id: $id, email: $emailX, fullName: $fullName, fullNameEn: $fullNameEn, bio: $bio, verifiedAt: $verifiedAt, userImage: $userImage, registerStatus: $registerStatus, registerMethod: $registerMethod, banTo: $banTo, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'countryId': country?.toMap(),
      '_id': id,
      'email': emailX,
      'isOnline': isOnline,
      'fullName': fullName,
      'fullNameEn': fullNameEn,
      'bio': bio,
      'isPrime': isPrime,
      'hasBadge': hasBadge,
      'verifiedAt': verifiedAt,
      'userImage': userImage,
      'registerStatus': registerStatus,
      'registerMethod': registerMethod,
      'banTo': banTo,
      'deletedAt': deletedAt,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }

  factory DashUser.fromMap(Map<String, dynamic> map) {
    return DashUser(
      country: map['countryId'] == null
          ? null
          : DashCountry.fromMap(map['countryId']),
      id: map['_id'] as String,
      emailX: (map['email'] as String?)??"NOT",
      isOnline: map['isOnline'] as bool? ?? false,
      isPrime: map['isPrime'] as bool? ?? false,
      hasBadge: map['hasBadge'] as bool? ?? false,
      fullName: map['fullName'] as String,
      fullNameEn: map['fullNameEn'] as String,
      bio: map['bio'] as String?,
      verifiedAt: map['verifiedAt'] as String?,
      userImage: map['userImage'] as String,
      registerStatus: map['registerStatus'] as String,
      registerMethod: map['authMethods'][0]['type'] as String,
      banTo: map['banTo'] as String?,
      deletedAt: map['deletedAt'] as String?,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

//</editor-fold>
}
