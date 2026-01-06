// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../../core/api_service/auth/auth_api_service.dart';
import '../../../../../core/api_service/profile/profile_api_service.dart';
import '../../../../../core/app_nav/app_navigation.dart';
import '../../../../chats_search/views/chats_search_view.dart';
import '../../../../create_broadcast/mobile/sheet_for_create_broadcast.dart';
import '../../../../create_group/mobile/sheet_for_create_group.dart';
import '../../../mobile/settings_tab/views/settings_tab_view.dart';
import '../../../mobile/users_tab/views/users_tab_view.dart';
import '../../../mobile/calls_tab/views/calls_tab_view.dart';

class HomeWideController implements SBaseController {
  final ProfileApiService profileApiService;
  final AuthApiService authApiService;

  final vRoomController = VRoomController();

  HomeWideController(this.profileApiService, this.authApiService);

  @override
  void onClose() {
    vRoomController.dispose();
  }

  VRoom? currentRoom;

  @override
  void onInit() {}

  void onRoomItemPress(VRoom room, BuildContext c) {
    if (currentRoom == room) {
      return;
    }
    _handleMessageInfoForWide(room, c);
    currentRoom = room;
    vRoomController.setRoomSelected(room.id);
    VChatController.I.vNavigator.messageNavigator.toMessagePage(c, room);
  }

  void setVisit() {
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

  void newChat(BuildContext context) {
    AppNavigation.toPage(
      context,
      const UsersTabView(),
      withAnimation: false,
      appNavigationType: AppNavigationType.chatRoom,
    );
  }

  void createNewGroup(BuildContext context) async {
    final groupRoom = await showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SheetForCreateGroup(),
    ) as VRoom?;
    if (groupRoom == null) {
      return;
    }
    VChatController.I.vNavigator.messageNavigator
        .toMessagePage(context, groupRoom);
  }

  void createNewBroadcast(BuildContext context) async {
    final broadcastRoom = await showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SheetForCreateBroadcast(),
    );
    if (broadcastRoom == null) {
      return;
    }
    VChatController.I.vNavigator.messageNavigator
        .toMessagePage(context, broadcastRoom);
  }

  void onShowSettings(BuildContext context) {
    AppNavigation.toPage(
      context,
      const SettingsTabView(),
      appNavigationType: AppNavigationType.chatRoom,
    );
  }

  void _handleMessageInfoForWide(VRoom room, BuildContext c) {
    if (AppNavigation.wideMessagesInfoNotifier.value) {
      if (room.roomType.isSingle) {
        VChatController.I.vNavigator.messageNavigator.toSingleSettings!(
          c,
          VToChatSettingsModel(
            title: room.realTitle,
            image: room.thumbImage,
            roomId: room.id,
            room: room,
          ),
          room.peerId!,
        );
      }
      if (room.roomType.isGroup) {
        VChatController.I.vNavigator.messageNavigator.toGroupSettings!(
          c,
          VToChatSettingsModel(
            title: room.realTitle,
            image: room.thumbImage,
            roomId: room.id,
            room: room,
          ),
        );
      }
      if (room.roomType.isBroadcast) {
        VChatController.I.vNavigator.messageNavigator.toBroadcastSettings!(
          c,
          VToChatSettingsModel(
            title: room.realTitle,
            image: room.thumbImage,
            roomId: room.id,
            room: room,
          ),
        );
      }
    }
  }

  void onSearchClicked(BuildContext context) {
    AppNavigation.toPage(
      context,
      const ChatsSearchView(),
      appNavigationType: AppNavigationType.chatRoom,
    );
  }

  void onOpenCallLogs(BuildContext context) {
    AppNavigation.toPage(
      context,
      const CallsTabView(),
      appNavigationType: AppNavigationType.chatRoom,
    );
  }
}
