// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/http/api_service/profile/profile_api_service.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_controller.dart';
import 'package:v_chat_sdk_core/src/service/controller_helper.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VProfileApi {
  final VNativeApi _vNativeApi;
  final VChatConfig _chatConfig;
  final _log = Logger('user_api.Auth');

  // Provides access to profile-related API services
  VProfileApiService get _profileApi => _vNativeApi.remote.profile;

  VProfileApi(
    this._vNativeApi,
    this._chatConfig,
  );

  // Handles actions required after a successful login
  Future<void> _connectSuccessLogin() async {
    SocketController.instance.connect();
    VChatControllerHelper.instance.initSocketTimer();
    if (VChatController.I.vChatConfig.isPushEnable) {
      await (await VChatController.I.vChatConfig.currentPushProviderService)
          ?.askForPermissions();
    }
    await VNotificationListener.init();
  }

  // Connect a user to the VChat system
  Future<void> connect() async {
    await VChatControllerHelper.instance.initPushService();
    _connectSuccessLogin();
  }

  // Logs out a user from the VChat SDK
  Future<void> logout() async {
    try {
      await (await _chatConfig.currentPushProviderService)?.deleteToken();
    } catch (err) {
      _log.warning(err);
    }
    try {
      await _vNativeApi.remote.profile.deleteFcm();
    } catch (err) {
      _log.warning(err);
    }
    SocketController.instance.disconnect();
    await _vNativeApi.local.reCreate();
  }
}
