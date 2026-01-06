// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class AppConfigModel {
  final String id;
  final int configVersion;
  final bool enableAds;
  final String feedbackEmail;
  final bool allowWebLogin;
  final bool allowMobileLogin;
  final bool allowCreateGroup;
  final bool allowCreateBroadcast;
  final bool allowDesktopLogin;
  final String privacyUrl;
  final String appName;
  final String? googlePayUrl;
  final String? appleStoreUrl;
  final String? windowsStoreUrl;
  final String? webChatUrl;
  final String? macStoreUrl;
  final int maxExpireEmailTime;
  final int maxForward;
  final String userRegisterStatus;
  final int callTimeout;
  final bool allowMessaging;
  final bool allowSendMedia;
  final int maxGroupMembers;
  final int maxBroadcastMembers;
  final int maxChatMediaSize;
  final bool allowCall;

  const AppConfigModel({
    required this.id,
    required this.configVersion,
    required this.enableAds,
    required this.feedbackEmail,
    required this.userRegisterStatus,
    required this.allowWebLogin,
    required this.allowMobileLogin,
    required this.allowCreateGroup,
    required this.allowCreateBroadcast,
    required this.allowDesktopLogin,
    required this.privacyUrl,
    required this.windowsStoreUrl,
    required this.webChatUrl,
    required this.googlePayUrl,
    required this.appleStoreUrl,
    required this.maxForward,
    required this.macStoreUrl,
    required this.maxExpireEmailTime,
    required this.callTimeout,
    required this.appName,
    required this.allowMessaging,
    required this.allowSendMedia,
    required this.maxGroupMembers,
    required this.maxBroadcastMembers,
    required this.maxChatMediaSize,
    required this.allowCall,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'configVersion': configVersion,
      'enableAds': enableAds,
      'feedbackEmail': feedbackEmail,
      'userRegisterStatus': userRegisterStatus,
      'macStoreUrl': macStoreUrl,
      'webChatUrl': webChatUrl,
      'appName': appName,
      'windowsStoreUrl': windowsStoreUrl,
      'allowWebLogin': allowWebLogin,
      'allowMobileLogin': allowMobileLogin,
      'allowCreateGroup': allowCreateGroup,
      'allowCreateBroadcast': allowCreateBroadcast,
      'allowDesktopLogin': allowDesktopLogin,
      'privacyUrl': privacyUrl,
      'googlePayUrl': googlePayUrl,
      'appleStoreUrl': appleStoreUrl,
      'maxExpireEmailTime': maxExpireEmailTime,
      'callTimeout': callTimeout,
      'maxForward': maxForward,
      'allowMessaging': allowMessaging,
      'allowSendMedia': allowSendMedia,
      'maxGroupMembers': maxGroupMembers,
      'maxBroadcastMembers': maxBroadcastMembers,
      'maxChatMediaSize': maxChatMediaSize,
      'allowCall': allowCall,
    };
  }

  factory AppConfigModel.fromMap(Map<String, dynamic> map) {
    return AppConfigModel(
      id: map['_id'] as String,
      configVersion: map['configVersion'] as int,
      enableAds: map['enableAds'] as bool,
      feedbackEmail: map['feedbackEmail'] as String,
      appName: map['appName'] as String,
      allowWebLogin: map['allowWebLogin'] as bool,
      allowMobileLogin: map['allowMobileLogin'] as bool,
      allowCreateGroup: map['allowCreateGroup'] as bool,
      allowCreateBroadcast: map['allowCreateBroadcast'] as bool,
      allowDesktopLogin: map['allowDesktopLogin'] as bool,
      maxForward: map['maxForward'] as int,
      privacyUrl: map['privacyUrl'] as String,
      googlePayUrl: map['googlePayUrl'] as String?,
      userRegisterStatus: map['userRegisterStatus'] as String,
      appleStoreUrl: map['appleStoreUrl'] as String?,
      macStoreUrl: map['macStoreUrl'] as String?,
      webChatUrl: map['webChatUrl'] as String?,
      windowsStoreUrl: map['windowsStoreUrl'] as String?,
      maxExpireEmailTime: map['maxExpireEmailTime'] as int,
      callTimeout: map['callTimeout'] as int,
      allowMessaging: map['allowMessaging'] as bool,
      allowSendMedia: map['allowSendMedia'] as bool,
      maxGroupMembers: map['maxGroupMembers'] as int,
      maxBroadcastMembers: map['maxBroadcastMembers'] as int,
      maxChatMediaSize: map['maxChatMediaSize'] as int,
      allowCall: map['allowCall'] as bool,
    );
  }

  AppConfigModel.init()
      : id = '',
        configVersion = 0,
        enableAds = false,
        feedbackEmail = '',
        allowWebLogin = true,
        allowMobileLogin = true,
        maxForward = 10,
        allowCreateGroup = true,
        allowCreateBroadcast = true,
        allowDesktopLogin = true,
        webChatUrl = null,
        macStoreUrl = null,
        privacyUrl = '',
        windowsStoreUrl = null,
        googlePayUrl = '',
        appName = '',
        appleStoreUrl = '',
        userRegisterStatus = '',
        maxExpireEmailTime = 5,
        // 5 minutes
        callTimeout = 60000,
        allowMessaging = true,
        allowSendMedia = true,
        maxGroupMembers = 512,
        maxBroadcastMembers = 512,
        maxChatMediaSize = 50,
        allowCall = true;

  @override
  String toString() {
    return 'AppConfigModel{id: $id, configVersion: $configVersion, enableAds: $enableAds, feedbackEmail: $feedbackEmail, allowWebLogin: $allowWebLogin, allowMobileLogin: $allowMobileLogin, allowCreateGroup: $allowCreateGroup, allowCreateBroadcast: $allowCreateBroadcast, allowDesktopLogin: $allowDesktopLogin, privacyUrl: $privacyUrl, googlePayUrl: $googlePayUrl, appleStoreUrl: $appleStoreUrl, windowsStoreUrl: $windowsStoreUrl, webChatUrl: $webChatUrl, macStoreUrl: $macStoreUrl, maxExpireEmailTime: $maxExpireEmailTime, maxForward: $maxForward, callTimeout: $callTimeout, allowMessaging: $allowMessaging, allowSendMedia: $allowSendMedia, maxGroupMembers: $maxGroupMembers, maxBroadcastMembers: $maxBroadcastMembers, maxChatMediaSize: $maxChatMediaSize, allowCall: $allowCall}';
  }

  AppConfigModel copyWith({
    String? id,
    int? configVersion,
    bool? enableAds,
    String? feedbackEmail,
    bool? allowWebLogin,
    bool? allowMobileLogin,
    bool? allowCreateGroup,
    bool? allowCreateBroadcast,
    bool? allowDesktopLogin,
    String? privacyUrl,
    String? appName,
    String? userRegisterStatus,
    String? googlePayUrl,
    String? appleStoreUrl,
    String? windowsStoreUrl,
    String? webChatUrl,
    String? macStoreUrl,
    int? maxExpireEmailTime,
    int? maxForward,
    int? callTimeout,
    bool? allowMessaging,
    bool? allowSendMedia,
    int? maxGroupMembers,
    int? maxBroadcastMembers,
    int? maxChatMediaSize,
    bool? allowCall,
  }) {
    return AppConfigModel(
      id: id ?? this.id,
      configVersion: configVersion ?? this.configVersion,
      enableAds: enableAds ?? this.enableAds,
      feedbackEmail: feedbackEmail ?? this.feedbackEmail,
      allowWebLogin: allowWebLogin ?? this.allowWebLogin,
      appName: appName ?? this.appName,
      allowMobileLogin: allowMobileLogin ?? this.allowMobileLogin,
      allowCreateGroup: allowCreateGroup ?? this.allowCreateGroup,
      allowCreateBroadcast: allowCreateBroadcast ?? this.allowCreateBroadcast,
      allowDesktopLogin: allowDesktopLogin ?? this.allowDesktopLogin,
      privacyUrl: privacyUrl ?? this.privacyUrl,
      userRegisterStatus: userRegisterStatus ?? this.userRegisterStatus,
      googlePayUrl: googlePayUrl ?? this.googlePayUrl,
      appleStoreUrl: appleStoreUrl ?? this.appleStoreUrl,
      windowsStoreUrl: windowsStoreUrl ?? this.windowsStoreUrl,
      webChatUrl: webChatUrl ?? this.webChatUrl,
      macStoreUrl: macStoreUrl ?? this.macStoreUrl,
      maxExpireEmailTime: maxExpireEmailTime ?? this.maxExpireEmailTime,
      maxForward: maxForward ?? this.maxForward,
      callTimeout: callTimeout ?? this.callTimeout,
      allowMessaging: allowMessaging ?? this.allowMessaging,
      allowSendMedia: allowSendMedia ?? this.allowSendMedia,
      maxGroupMembers: maxGroupMembers ?? this.maxGroupMembers,
      maxBroadcastMembers: maxBroadcastMembers ?? this.maxBroadcastMembers,
      maxChatMediaSize: maxChatMediaSize ?? this.maxChatMediaSize,
      allowCall: allowCall ?? this.allowCall,
    );
  }
}
