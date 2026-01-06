// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import '../../../super_up_core.dart';

class LoginDto {
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

  final Map<String, dynamic> deviceInfo;
  final String deviceId;
  final String language;
  String? pushKey;
  final RegisterMethod method;
  final String platform;

  LoginDto({
    required this.authId,
      this.email,
      this.phone,
      this.password,
      this.identifier,

    required this.deviceId,
    required this.language,
    required this.method,
    required this.platform,
    required this.deviceInfo,
    this.pushKey,
  });

  Map<String, dynamic> toMap() {
    return {
      "authId": authId,
      "email": email,
      "phone": phone,
      "password": password,
      "identifier": identifier,
      "deviceId": deviceId,
      "deviceInfo": deviceInfo,
      "language": language,
      "pushKey": pushKey,
      "method": method.name,
      "platform": platform,
    };
  }
}
