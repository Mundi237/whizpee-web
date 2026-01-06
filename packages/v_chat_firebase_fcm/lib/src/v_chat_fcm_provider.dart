// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:eraser/eraser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import 'app_pref.dart';

class VChatFcmProver extends VChatPushProviderBase {
  StreamSubscription? _onTokenRefresh;
  StreamSubscription? _onNewMessage;
  StreamSubscription? _onMsgClicked;
  final _vEventBusSingleton = VEventBusSingleton.vEventBus;

  @override
  Future<void> deleteToken() async {
    try {
      await cleanAll();
      _onTokenRefresh?.cancel();
      await FirebaseMessaging.instance.deleteToken();
    } catch (err) {
      //
    }
    return;
  }

  @override
  Future<String?> getToken([String? vapidKey]) async {
    try {
      final x = await FirebaseMessaging.instance.getToken(vapidKey: vapidKey);
      print(x);
      return x;
    } catch (err) {
      //
    }
    return null;
  }

  @override
  Future<bool> init() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      FirebaseMessaging.onBackgroundMessage(
        vFirebaseMessagingBackgroundHandler,
      );
      final status =
          (await FirebaseMessaging.instance.getNotificationSettings())
              .authorizationStatus;
      if (status == AuthorizationStatus.authorized) {
        _initStreams();
      }
      return true;
    } catch (err, trac) {
      if (kDebugMode) {
        print("-----");
      }
      if (kDebugMode) {
        print(err.toString() ==
            "Google Play services missing or without correct permission.");
      }
      log("", stackTrace: trac, error: err, name: "V_CHAT_FCM");
    }
    return false;
  }

  @override
  VChatPushService serviceName() {
    return VChatPushService.firebase;
  }

  @override
  Future<void> askForPermissions() async {
    try {
      final status = (await FirebaseMessaging.instance.requestPermission(
        sound: true,
        badge: true,
        alert: true,
        criticalAlert: true,
      ))
          .authorizationStatus;
      if (status == AuthorizationStatus.authorized) {
        _initStreams();
      }
    } catch (err) {
      //
    }
  }

  void _initStreams() {
    close();
    _onTokenRefresh = FirebaseMessaging.instance.onTokenRefresh.listen(
      (event) {
        _vEventBusSingleton.fire(VOnUpdateNotificationsToken(event));
      },
    );
    _onNewMessage = FirebaseMessaging.onMessage.listen((remoteMsg) async {
      final String? fromVChat = remoteMsg.data['fromVChat'];
      final String? message = remoteMsg.data['vMessage'];
      final String? typeStr = remoteMsg.data['type'];
      final String? callData = remoteMsg.data['callData'];

      if (fromVChat != null && typeStr != null) {
        final type =
            EnumToString.fromString(VNotificationType.values, typeStr)!;
        if (type.isMessage) {
          final msg = MessageFactory.createBaseMessage(
            jsonDecode(message!),
          );
          if (msg.isMeSender) return;
          _vEventBusSingleton.fire(VOnMessageNotifications(
            message: msg,
          ));
          return;
        }
        if (type == VNotificationType.call) {
          if (callData == null)
            throw "callData in FirebaseMessaging.onMessage.listen is null";
          final model = VCallNotificationModel.fromMap(jsonDecode(callData));
          final call = CallKeepHandler.I;
          if (model.callStatus == VCallStatus.ring) {
            await call.startShowCallKeep(
              model: model,
              fromBackground: false,
            );
          } else {
            await call.onServerCancelOrTimeout(
              model: model,
              fromBackground: false,
            );
          }
          _vEventBusSingleton.fire(VOnCallNotificationsEvent(model: model));
          return;
        }
      } else {
        /// notification out of v chat sdk
        _vEventBusSingleton.fire(VOnNewNotifications(
          body: remoteMsg.notification!.body ?? "",
          title: remoteMsg.notification!.title ?? "",
        ));
      }
    });
    _onMsgClicked =
        FirebaseMessaging.onMessageOpenedApp.listen((remoteMsg) async {
      final String? fromVChat = remoteMsg.data['fromVChat'];
      final String? message = remoteMsg.data['vMessage'];

      if (fromVChat != null && message != null) {
        final msg = MessageFactory.createBaseMessage(
          jsonDecode(message),
        );
        final room = await _getRoom(msg.roomId);
        if (room == null) return;
        _vEventBusSingleton
            .fire(VOnNotificationsClickedEvent(message: msg, room: room));
      }
    });
  }

  Future<VRoom?> _getRoom(String roomId) async {
    return VChatController.I.nativeApi.local.room
        .getOneWithLastMessageByRoomId(roomId);
  }

  Future<VBaseMessage?> _checkIfAppOpenFromNotification() async {
    final remoteMsg = await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMsg == null) return null;
    final String? fromVChat = remoteMsg.data['fromVChat'];
    final String? message = remoteMsg.data['vMessage'];
    if (fromVChat != null && message != null) {
      final msg = MessageFactory.createBaseMessage(jsonDecode(message));
      if (msg.messageType.isCall) return null;
      return msg;
    }
    return null;
  }

  @override
  void close() {
    _onTokenRefresh?.cancel();
    _onNewMessage?.cancel();
    _onMsgClicked?.cancel();
  }

  @override
  Future<VBaseMessage?> getOpenAppNotification() {
    return _checkIfAppOpenFromNotification();
  }

  @override
  Future<void> cleanAll({int? notificationId}) async {
    await Eraser.clearAllAppNotifications();
    await AppBadgePlus.updateBadge(0);
  }
}

@pragma('vm:entry-point')
Future<void> vFirebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final nativeLocal = VLocalNativeApi();
  await nativeLocal.init();
  final number = await nativeLocal.room.getTotalUnReadCount();
  if (VPlatforms.isMobile) {
    await AppBadgePlus.updateBadge(number);
  }

  await VAppPref.init();
  final String? fromVChat = message.data['fromVChat'];
  final String? vMessage = message.data['vMessage'];
  final String? typeStr = message.data['type'];
  final String? callData = message.data['callData'];
  final type = EnumToString.fromString(VNotificationType.values, typeStr ?? "");
  if (fromVChat == null || type == null) return Future<void>.value();
  if (vMessage != null) {
    final msg = MessageFactory.createBaseMessage(
      jsonDecode(vMessage) as Map<String, dynamic>,
    );
    final token = VAppPref.getHashedString(key: "vAccessToken");
    if (token != null) {
      try {
        await setDeliverForThisRoom(msg.roomId, token);
      } catch (err) {
        if (kDebugMode) {
          print(err);
        }
      }
    }
    final insertRes = await nativeLocal.message.safeInsertMessage(msg);
    if (insertRes == 1) {
      await nativeLocal.room.updateRoomUnreadCountAddOne(msg.roomId);
    }
    return;
  }
  if (type == VNotificationType.call) {
    if (callData == null)
      throw "callData in vFirebaseMessagingBackgroundHandler is null";
    final model = VCallNotificationModel.fromMap(jsonDecode(callData));
    final call = CallKeepHandler.I;
    if (model.callStatus == VCallStatus.ring) {
      await call.startShowCallKeep(
        model: model,
        fromBackground: true,
        nativeLocal: nativeLocal,
      );
    } else {
      await call.onServerCancelOrTimeout(
        model: model,
        fromBackground: true,
        nativeLocal: nativeLocal,
      );
    }
  }
  return Future<void>.value(null);
}

@pragma('vm:entry-point')
Future setDeliverForThisRoom(String roomId, String token) async {
  final baseUrl = VAppPref.getStringOrNullKey("vBaseUrl");
  final res = await patch(
    Uri.parse(
      "$baseUrl/channel/$roomId/deliver",
    ),
    headers: {
      'authorization': "Bearer $token",
      "clint-version": "2.0.0",
      "Accept-Language": "en"
    },
  );
  if (res.statusCode != 200) {
    throw "cant deliver the message status in background for ${VPlatforms.currentPlatform}";
  }
}
