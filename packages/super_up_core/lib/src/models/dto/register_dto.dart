// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:super_up_core/src/utils/enums.dart';
import 'package:v_platform/v_platform.dart';

class RegisterDto {
  //for all
  final String authId;

  //for email and gmail and apple
  String? email;

  //for phone only
  String? phone;

  //for apple
  String? identifier;

  //for email login
  String? password;

  final String fullName;
  final String deviceId;
  final RegisterMethod method;
  final String language;
  final Map<String, dynamic> deviceInfo;
  String? pushKey;
  final String platform;
  final VPlatformFile? image;

//<editor-fold desc="Data Methods">

  RegisterDto({
    required this.authId,
    required this.email,
    required this.phone,
    required this.identifier,
      this.password,
    required this.method,
    required this.fullName,
    required this.deviceId,
    required this.language,
    required this.pushKey,
    required this.deviceInfo,
    required this.platform,
    this.image,
  });

  List<PartValue> toListOfPartValue() {
    return [
      PartValue('authId', authId),
      if (email != null) PartValue('email', email),
      if (phone != null) PartValue('phone', phone),
      if (identifier != null) PartValue('identifier', identifier),
      if (password != null) PartValue('password', password),
      PartValue('method', method.name),
      PartValue('fullName', fullName),
      PartValue('deviceId', deviceId),
      PartValue('language', language),
      PartValue('pushKey', pushKey),
      PartValue('deviceInfo', jsonEncode(deviceInfo)),
      PartValue('platform', platform),
    ];
  }

//</editor-fold>
}
