// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:super_up/app/core/utils/phone/contact_sync_service.dart';

import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_receive_share/v_chat_receive_share.dart';

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../../main.dart';
import '../../../../core/api_service/profile/profile_api_service.dart';
import '../../../../core/controllers/version_checker_controller.dart';
import '../../mobile/calls_tab/controllers/calls_tab_controller.dart';
import '../../mobile/rooms_tab/controllers/rooms_tab_controller.dart';
import '../../mobile/story_tab/controllers/story_tab_controller.dart';
import '../../mobile/users_tab/controllers/users_tab_controller.dart';

class HomeController extends SLoadingController<int> {
  int totalChatUnRead = 0;
  final versionCheckerController = GetIt.I.get<VersionCheckerController>();

  int get tabIndex => data;
  final ProfileApiService profileApiService;
  final BuildContext context;
  IconData fabIcon = Icons.message;

  HomeController(this.profileApiService, this.context)
      : super(SLoadingState(0));

  late final StreamSubscription _unReadStream;

  late final ContactSyncService _contactService =
      GetIt.I.get<ContactSyncService>();

  @override
  void onInit() {
    _registerLazySingletons();
    _connectToVChatSdk();
    _checkVersion();
    _updateProfile();
    _checkContactSync();
    _unReadStream = VChatController
        .I.nativeApi.streams.totalUnreadRoomsCountStream
        .listen((event) {
      totalChatUnRead = event.count;
      notifyListeners();
    });
    // PictureInPicture.startPiP(
    //
    //   pipWidget: PipTest(
    //
    //     onTap: () {
    //       AppNavigation.toPage(context, LoginView());
    //     },
    //   ),
    // );
  }

  @override
  void onClose() {
    _unregister();
    _unReadStream.cancel();
    _contactService.dispose();
  }

  void _connectToVChatSdk() async {
    await VChatController.I.profileApi.connect();
    vInitReceiveShareHandler();
    _setVisit();
    if (VPlatforms.isMobile) {
      vInitCallListener(context);
      CallKeepHandler.I.checkLastCall();
      _setVoipKey();
    }
  }

  void _setVisit() async {
    vSafeApiCall(
      request: () async {
        return profileApiService.setVisit();
      },
      onSuccess: (response) {},
      config: const VApiConfig(
        ignoreTimeoutErrors: true,
        ignoreNetworkErrors: true,
      ),
    );
  }

  void _checkVersion() async {
    await versionCheckerController.checkForUpdates(context, false);
  }

  void _registerLazySingletons() {
    GetIt.I.registerLazySingleton<CallsTabController>(
      () => CallsTabController(),
    );

    GetIt.I.registerLazySingleton<UsersTabController>(
      () => UsersTabController(GetIt.I.get<ProfileApiService>()),
    );

    GetIt.I.registerLazySingleton<StoryTabController>(
      () => StoryTabController(),
    );
    GetIt.I.registerLazySingleton<RoomsTabController>(
      () => RoomsTabController(),
    );
    // GetIt.I.registerLazySingleton<VBackgroundCallModel>(
    //   () => VBackgroundCallModel(),
    // );
    GetIt.I.registerLazySingleton(
      () => ContactSyncService(),
    );
  }

  void _unregister() {
    GetIt.I.get<RoomsTabController>().onClose();
    GetIt.I.get<CallsTabController>().onClose();
    GetIt.I.get<UsersTabController>().onClose();
    GetIt.I.unregister<CallsTabController>();
    GetIt.I.unregister<StoryTabController>();
    GetIt.I.unregister<UsersTabController>();
    GetIt.I.unregister<RoomsTabController>();
    GetIt.I.unregister<ContactSyncService>();
  }

  void _updateProfile() async {
    final newProfile = await profileApiService.getMyProfile();
    await VAppPref.setMap(SStorageKeys.myProfile.name, newProfile.toMap());
    AppAuth.setProfileNull();
  }

  Future _checkContactSync() async {
    if (_contactService.isPlatformSupported) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _contactService.initialize(context);
      });
    }
  }

  void _setVoipKey() async {
    if (VPlatforms.isIOS) {
      final token = await CallKeepHandler.I.getDevicePushTokenVoIP();
      // print("----------------------------------------------------------");
      // print(token);
      // print("----------------------------------------------------------");
      await VChatController.I.nativeApi.remote.profile
          .addPushKey(fcm: null, voipKey: token);
    }
  }
}
