// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

// import 'package:flutter/foundation.dart';
// import 'package:v_platform/v_platform.dart';
//
// abstract class SConstants {
//   ///your super up base domain url
//   ///like this (example.com) not start https// or any sub domains
//   ///if you not setup production leave it empty
//   static const _productionBaseUrl = "superupdev.online";
//   static const appName = "Superup";
//   static const googlePlayUrl =
//       "https://play.google.com/store/apps/details?id=com.app.superup";
//   static const appleStoreUrl = "https://testflight.apple.com/join/F4tAbW5J";
//   static const vChatAdminPassword = "v-chat-sdk-v2-strong-password";
//   static const otpInterval = 60 * 2; //2 minutes
//   static const maxMediaSize = 50 * 1000 * 1000; // 50 mb
//
//   static Uri get vChatBaseUrl {
//     if (kDebugMode) {
//       if (VPlatforms.isAndroid) {
//         ///android emulator only for real device you need to get your ipv4 network address
//         return Uri.parse("http://10.0.2.2:3001");
//       }
//       return Uri.parse("http://localhost:3001");
//     } //
//     return Uri.parse("https://vchat.$_productionBaseUrl");
//   } //https://superupdev.online/apps/appcast.xml
//
//   static String get feedUrl => "https://$_productionBaseUrl/apps/appcast.xml";
//
//   static Uri get sApiBaseUrl {
//     if (kDebugMode) {
//       if (VPlatforms.isAndroid) {
//         ///android emulator only for real device you need to get your ipv4 network address
//         return Uri.parse("http://10.0.2.2:3000/api/v1");
//       }
//       return Uri.parse("http://localhost:3000/api/v1");
//     }
//     return Uri.parse("https://api.$_productionBaseUrl/api/v1");
//   }
// }
