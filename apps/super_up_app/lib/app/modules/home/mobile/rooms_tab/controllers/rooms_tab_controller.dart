// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_media_editor/v_chat_media_editor.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import '../../../../chats_search/views/chats_search_view.dart';
import '../../../../choose_members/views/choose_members_view.dart';
import '../../../../create_broadcast/mobile/sheet_for_create_broadcast.dart';
import '../../../../create_group/mobile/sheet_for_create_group.dart';

class RoomsTabController extends ValueNotifier implements SBaseController {
  final vRoomController = VRoomController();

  RoomsTabController() : super(null);

  @override
  void onClose() {
    vRoomController.dispose();
  }

  @override
  void onInit() {}

  void createNewGroup(BuildContext context) async {
    if (kDebugMode) {
      print('🟢 createNewGroup called');
    }
    try {
      final groupRoom = await showCupertinoModalBottomSheet(
        expand: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => const SheetForCreateGroup(),
      ) as VRoom?;
      if (groupRoom == null) {
        if (kDebugMode) {
          print('⚠️ createNewGroup: groupRoom is null');
        }
        return;
      }
      if (kDebugMode) {
        print('✅ createNewGroup: groupRoom created, opening chat');
      }
      VChatController.I.vNavigator.messageNavigator
          .toMessagePage(context, groupRoom);
    } catch (e) {
      if (kDebugMode) {
        print('❌ createNewGroup error: $e');
      }
    }
  }

  void createNewBroadcast(BuildContext context) async {
    if (kDebugMode) {
      print('🟢 createNewBroadcast called');
    }
    try {
      final broadcastRoom = await showCupertinoModalBottomSheet(
        expand: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => const SheetForCreateBroadcast(),
      );
      if (broadcastRoom == null) {
        if (kDebugMode) {
          print('⚠️ createNewBroadcast: broadcastRoom is null');
        }
        return;
      }
      if (kDebugMode) {
        print('✅ createNewBroadcast: broadcastRoom created, opening chat');
      }
      VChatController.I.vNavigator.messageNavigator
          .toMessagePage(context, broadcastRoom);
    } catch (e) {
      if (kDebugMode) {
        print('❌ createNewBroadcast error: $e');
      }
    }
  }

  void onSearchClicked(BuildContext context) {
    context.toPage(const ChatsSearchView());
  }

  void createNewChat(BuildContext context) async {
    // Utiliser ChooseMembersView avec maxCount=1 pour sélectionner un seul contact
    final selectedUsers = await showCupertinoModalBottomSheet<List<SBaseUser>>(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Navigator(
        onGenerateRoute: (___) => CupertinoPageRoute(
          builder: (__) => ChooseMembersView(
            maxCount: 1,
            onCloseSheet: () {
              Navigator.of(context).pop();
            },
            onDone: (users) {
              Navigator.of(context).pop(users);
            },
          ),
        ),
      ),
    );

    if (selectedUsers == null || selectedUsers.isEmpty) return;

    final selectedUser = selectedUsers.first;

    // Créer ou récupérer la room pour ce contact
    try {
      final room = await VChatController.I.roomApi.getPeerRoom(
        peerId: selectedUser.id,
      );

      if (!context.mounted) return;

      // Ouvrir la conversation
      VChatController.I.vNavigator.messageNavigator
          .toMessagePage(context, room);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating peer room: $e');
      }
    }
  }

  void onCameraPress(BuildContext context) async {
    //  await PlatformNotifier.I.showChatNotification(
    //    userImage: "",
    //    context: context,
    //    model: ShowPluginNotificationModel(id: DateTime.now().microsecond.hashCode, title: "title", body: "body"),
    //    userName: 'xx',
    //    conversationTitle: 'xx',
    //  );
    // return;
    final fileSource = await VAppPick.getImage(isFromCamera: true);
    if (fileSource == null) return;
    final roomsIds = await VChatController.I.vNavigator.roomNavigator
        .toForwardPage(context, null);
    final data = await VFileUtils.getImageInfo(
      fileSource: fileSource,
    );
    if (roomsIds != null) {
      for (final roomId in roomsIds) {
        final message = VImageMessage.buildMessage(
          roomId: roomId,
          data: VMessageImageData(
            fileSource: fileSource,
            height: data.image.height,
            width: data.image.width,
            blurHash: await VMediaFileUtils.getBlurHash(fileSource),
          ),
        );
        await VChatController.I.nativeApi.local.message.insertMessage(message);
        try {
          VMessageUploaderQueue.instance.addToQueue(
            await MessageFactory.createUploadMessage(message),
          );
        } catch (err) {
          if (kDebugMode) {
            print(err);
          }
        }
      }
    }
  }
}
