// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:eraser/eraser.dart';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VChatOneSignalProver extends VChatPushProviderBase {
  final _vEventBusSingleton = VEventBusSingleton.vEventBus;
  final String appId;
  final OSLogLevel logLevel;
  String? _lastNotificationId; // To prevent duplicate notification handling

  VChatOneSignalProver({
    required this.appId,
    this.logLevel = OSLogLevel.none,
  });

  @override
  Future<void> deleteToken() async {
    try {
      cleanAll();
      await OneSignal.User.pushSubscription.optOut();
    } catch (err) {
      //
    }
    return;
  }

  @override
  Future<String?> getToken([String? webVapidKey]) async {
    try {
      final subscriptionId = OneSignal.User.pushSubscription.id;
      if (subscriptionId == null) {
        if (kDebugMode) {
          print("OneSignal push subscription ID is null!");
        }
        return null;
      }
      return subscriptionId;
    } catch (err) {
      //
    }
    return null;
  }

  Future<bool> _getIsAllow() async {
    try {
      // Handle nullable optedIn value
      final optedIn = OneSignal.User.pushSubscription.optedIn;
      return optedIn ?? false;
    } catch (e) {
      if (kDebugMode) {
        print("Error checking OneSignal permission status: $e");
      }
      return false;
    }
  }

  @override
  Future<bool> init() async {
    try {
      // Set log level
      if (kReleaseMode) {
        OneSignal.Debug.setLogLevel(OSLogLevel.none);
      } else {
        OneSignal.Debug.setLogLevel(logLevel);
      }

      // Initialize OneSignal
      OneSignal.initialize(appId);

      final status = await _getIsAllow();
      if (status) {
        _initStreams();
      }
      return true;
    } catch (err) {
      //
    }
    return false;
  }

  @override
  VChatPushService serviceName() {
    return VChatPushService.onesignal;
  }

  @override
  Future<void> askForPermissions() async {
    try {
      final allowed = await OneSignal.Notifications.requestPermission(true);
      if (allowed) {
        _initStreams();
      } else {
        log("user did not accept to send notifications!");
      }
    } catch (err) {
      //
    }
  }

  void _initStreams() {
    // Handle notifications received in foreground
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      // Debounce duplicate notifications using ID
      if (_lastNotificationId == event.notification.notificationId) {
        event.preventDefault();
        return;
      }

      _lastNotificationId = event.notification.notificationId;

      // Will be called whenever a notification is received in foreground
      final notification = event.notification;
      final data = notification.additionalData;
      if (data == null) return;
      final String? fromVChat = data['fromVChat'];
      final String? message = data['vMessage'];
      if (fromVChat != null && message != null) {
        final msg = MessageFactory.createBaseMessage(
          jsonDecode(message),
        );
        if (msg.isMeSender) return;
        _vEventBusSingleton.fire(VOnMessageNotifications(
          message: msg,
        ));
      }
      // Prevent the notification from displaying
      event.preventDefault();
    });

    // Handle subscription changes
    OneSignal.User.pushSubscription.addObserver((state) {
      if (state.current.id != null) {
        _vEventBusSingleton
            .fire(VOnUpdateNotificationsToken(state.current.id!));
      }
    });

    // Handle notification clicks
    OneSignal.Notifications.addClickListener((event) async {
      // Debounce duplicate clicks
      if (_lastNotificationId == event.notification.notificationId) {
        return;
      }

      _lastNotificationId = event.notification.notificationId;

      final data = event.notification.additionalData;
      if (data == null) return;
      final String? fromVChat = data['fromVChat'];
      final String? message = data['vMessage'];

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
    return null;
  }

  @override
  void close() {}

  @override
  Future<VBaseMessage?> getOpenAppNotification() {
    return _checkIfAppOpenFromNotification();
  }

  @override
  Future<void> cleanAll({int? notificationId}) async {
    if (notificationId != null) {
      await OneSignal.Notifications.removeNotification(notificationId);
      return;
    }
    await Eraser.clearAllAppNotifications();
    await AppBadgePlus.updateBadge(0);
  }
}
