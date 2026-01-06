// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../../v_chat_v2/translations.dart';
import '../../../../core/app_config/app_config_controller.dart';
import '../../home_controller/widgets/chat_un_read_counter.dart';
import 'no_animation_page_route.dart';

class WideRoomsNavigation extends StatelessWidget {
  final VoidCallback onShowSettings;
  final VoidCallback onNewChat;
  final VoidCallback onOpenStory;
  final VoidCallback onOpenCallLogs;
  final VoidCallback onCreateNewBroadcast;
  final VoidCallback onCreateNewGroup;
  final VoidCallback onSearchClicked;
  final VRoomController vRoomController;

  final Function(VRoom room)? onRoomItemPress;

  WideRoomsNavigation({
    super.key,
    required this.onShowSettings,
    required this.onNewChat,
    required this.onCreateNewBroadcast,
    required this.onCreateNewGroup,
    required this.onOpenStory,
    required this.onOpenCallLogs,
    required this.onSearchClicked,
    required this.vRoomController,
    this.onRoomItemPress,
  });

  static final navKey = GlobalKey<NavigatorState>();
  final sizer = GetIt.I.get<AppSizeHelper>();
  final config = VAppConfigController.appConfig;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navKey,
      initialRoute: 'chats',
      onGenerateRoute: (settings) {
        return NoAnimationPageRoute(
          builder: (context) {
            return Builder(
              builder: (context) {
                final isSmall = sizer.isSmall(context);
                return VChatPage(
                  appBar: CupertinoListTile(
                    padding: const EdgeInsets.all(0),
                    title: Row(
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: onShowSettings,
                              child: VCircleAvatar(
                                vFileSource: VPlatformFile.fromUrl(
                                  networkUrl:
                                      AppAuth.myProfile.baseUser.userImage,
                                ),
                                radius: 21,
                              ),
                            ),
                            PositionedDirectional(
                              end: 0,
                              child: StreamBuilder<VTotalUnReadRoomsCount>(
                                  stream: VChatController.I.nativeApi.streams
                                      .totalUnreadRoomsCountStream,
                                  builder: (context, snapshot) {
                                    var totalChatUnRead = 0;
                                    if (snapshot.hasData) {
                                      totalChatUnRead = snapshot.data!.count;
                                    }
                                    return ChatUnReadWidget(
                                      unReadCount: totalChatUnRead,
                                    );
                                  }),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    trailing: Row(
                      children: [
                        CupertinoButton(
                          onPressed: onShowSettings,
                          child: const Icon(CupertinoIcons.settings),
                        ),
                        CupertinoButton(
                          onPressed: onNewChat,
                          child: const Icon(CupertinoIcons.chat_bubble_text),
                        ),
                        CupertinoButton(
                          onPressed: onOpenStory,
                          child: const Icon(Icons.history_toggle_off_rounded),
                        ),
                        CupertinoButton(
                          onPressed: onOpenCallLogs,
                          child: const Icon(CupertinoIcons.phone),
                        ),
                      ],
                    ),
                  ),
                  onSearchClicked: onSearchClicked,
                  language: vRoomLanguageModel(context),
                  onCreateNewBroadcast:
                      config.allowCreateBroadcast ? onCreateNewBroadcast : null,
                  onCreateNewGroup:
                      config.allowCreateGroup ? onCreateNewGroup : null,
                  controller: vRoomController,
                  useIconForRoomItem: isSmall,
                  onRoomItemPress: onRoomItemPress,
                );
              },
            );
          },
        );
      },
    );
  }
}
