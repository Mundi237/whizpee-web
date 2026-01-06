// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/src/http/api_service/profile/profile_api.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';

class VProfileApiService {
  static ProfileApi? _profileApi;

  VProfileApiService._();

  Future<bool> addPushKey({
    required String? fcm,
    required String? voipKey,
  }) async {
    final res = await _profileApi!.addNotificationPush(
      {
        'pushKey': fcm,
        'voipKey': voipKey,
      },
    );
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> deleteFcm() async {
    final res = await _profileApi!.deleteNotificationPush();
    throwIfNotSuccess(res);
    return true;
  }

  Future<DateTime?> getUserLastSeenAt(String peerId) async {
    final res = await _profileApi!.getLastSeenAt(peerId);
    throwIfNotSuccess(res);
    final str = (res.body as Map<String, dynamic>)['data'] as String?;
    if (str == null) return null;
    return DateTime.parse(str);
  }

  static VProfileApiService init({Uri? baseUrl, String? accessToken}) {
    _profileApi ??= ProfileApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? VAppConstants.baseUri,
    );
    return VProfileApiService._();
  }
}
