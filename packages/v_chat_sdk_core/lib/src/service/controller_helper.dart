// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:super_up_core/super_up_core.dart' hide Level;
import 'package:v_chat_sdk_core/src/logger/v_logger.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

class VChatControllerHelper {
  final _config = VChatController.I.vChatConfig;
  final _log = Logger('ControllerHelper');
  Timer? _timer;

  ///singleton
  VChatControllerHelper._privateConstructor();

  static final instance = VChatControllerHelper._privateConstructor();

  VChatControllerHelper._();

  Future<VChatControllerHelper> init() async {
    _initLogger(_config.enableLog);
    _setupTimeAgo();
    await VAppPref.setStringKey(
      SStorageKeys.vBaseUrl.name,
      VAppConstants.baseUri.toString(),
    );

    return VChatControllerHelper._();
  }

  void _initLogger(bool enableLog) {
    Logger.root.level = enableLog ? Level.ALL : Level.OFF;
    Logger.root.onRecord.listen((record) {
      if (record.loggerName.startsWith("socket_io")) {
        return;
      }
      if (Level.WARNING == record.level) {
        VChatLogger.red(
          'V_CHAT_SDK (LEVEL: ${record.level.name}) (File: ${record.loggerName}) Message:${record.message}',
        );
      } else if (Level.SHOUT == record.level) {
        // ignore this log because it represent user api timeout exception
        //or user don't have internet connection
      } else {
        VChatLogger.blue(
          'V_CHAT_SDK (LEVEL: ${record.level.name}) (File: ${record.loggerName}) Message:${record.message}',
        );
      }
    });
  }

  Future<void> initPushService() async {
    final current = await _config.currentPushProviderService;
    if (current == null) {
      _log.fine("init the sdk without push notification service!");
      return;
    }
    final isInit = await current.init();
    if (isInit == false) {
      _log.warning("Notification permission not accepted");
      return;
    }
    if (current.serviceName() == VChatPushService.firebase) {
      _log.fine("init the sdk with fcm done successfully through V_CHAT_SDK");
    } else {
      _log.fine(
        "init the sdk with OneSignal done successfully through V_CHAT_SDK",
      );
    }
  }

  Future<String?> getPushToken() async {
    if (!_config.isPushEnable ||
        _config.isCurrentPlatformsNotSupportBackgroundPush) {
      return null;
    }
    final token = await (await _config.currentPushProviderService)?.getToken(
      VPlatforms.isWeb ? SConstants.webVapidKey : null,
    );
    if (token == null) {
      _log.warning(
        "FCM value is null this device will not receive notifications this may be bad network or this device not support google play service",
      );
    }
    return token;
  }

  void initSocketTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) {
        VEventBusSingleton.vEventBus.fire(VSocketIntervalEvent());
      },
    );
  }

  void _setupTimeAgo() {
    setLocaleMessages('ar', ArMessages());
    setLocaleMessages('bs', BsMessages());
    setLocaleMessages('cs', CsMessages());
    setLocaleMessages('fi', FiMessages());
    setLocaleMessages('da', DaMessages());
    setLocaleMessages('fr', FiMessages());
    setLocaleMessages('mn', MnMessages());
    setLocaleMessages('it', ItMessages());
    setLocaleMessages('rw', RwMessages());
    setLocaleMessages('ko', KoMessages());
    setLocaleMessages('uk', UkMessages());
    setLocaleMessages('vi', ViMessages());
    setLocaleMessages('pt', PtBrMessages());
    setLocaleMessages('hi', HiMessages());
    setLocaleMessages('ru', RuMessages());
    setLocaleMessages('gr', GrMessages());
    setLocaleMessages('he', HeMessages());
    setLocaleMessages('hi', HiMessages());
    setLocaleMessages('ja', JaMessages());
    setLocaleMessages('ko', KoMessages());
    setLocaleMessages('tr', TrMessages());
    setLocaleMessages('uk', UkMessages());
    setLocaleMessages('zh', ZhMessages());
    setLocaleMessages('es', EsMessages());
  }
}
