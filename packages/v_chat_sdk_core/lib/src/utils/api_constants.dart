// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

abstract class VAppConstants {
  static String clintVersion = "1.0.0";
  static const appName = "VChatSdkV2";
  static const dbName = "VChatSdkV2.db";
  static const apiVersion = "v1";
  static const dbVersion = 10;
  static const socketInterval = 10; //10sec
  static String get baseServerIp {
    final uri = VChatController.I.vChatConfig.baseUrl;
    if (uri.hasPort) {
      //https         api.example
      return "${uri.scheme}://${uri.host}:${uri.port}";
    }
    return "${uri.scheme}://${uri.host}";
  }

  static Uri get baseUri {
    return Uri.parse("$baseServerIp/api/$apiVersion");
  }

  static SBaseUser get myProfile {
    return AppAuth.myProfile.baseUser;
  }

  static String get myId {
    return myProfile.id;
  }
}
