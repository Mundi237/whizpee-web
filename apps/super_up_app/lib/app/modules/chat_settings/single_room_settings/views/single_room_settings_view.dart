// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_up/app/modules/chat_settings/single_room_settings/states/single_room_setting_state.dart';
import 'package:super_up/app/modules/home/mobile/settings_tab/widgets/settings_list_item_tile.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../widgets/chat_settings_list_section.dart';
import '../../widgets/chat_settings_navigation_bar.dart';
import '../../widgets/language_tile.dart';
import '../controllers/single_room_settings_controller.dart';

class SingleRoomSettingsView extends StatefulWidget {
  const SingleRoomSettingsView({
    super.key,
    required this.settingsModel,
  });

  final VToChatSettingsModel settingsModel;

  @override
  State<SingleRoomSettingsView> createState() => _SingleRoomSettingsViewState();
}

class _SingleRoomSettingsViewState extends State<SingleRoomSettingsView> {
  late final SingleRoomSettingsController controller;

  @override
  void initState() {
    super.initState();
    controller = SingleRoomSettingsController(widget.settingsModel);
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatSettingsNavigationBar(
        middle: S.of(context).contactInfo,
        previousPageTitle: S.of(context).back,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ValueListenableBuilder<SLoadingState<SingleRoomSettingState>>(
            valueListenable: controller,
            builder: (context, value, child) {
              return Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () => controller.openFullImage(context),
                    child: VCircleAvatar(
                      vFileSource: VPlatformFile.fromUrl(
                        networkUrl: controller.data.settingsModel.image,
                      ),
                      radius: 90,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    value.data.settingsModel.room.realTitle,
                    style: context.cupertinoTextTheme.navLargeTitleTextStyle,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChatSettingsListSection(
                        icon: CupertinoIcons.phone_fill,
                        title: S.of(context).audio,
                        onPressed: !controller.isCallAllowed
                            ? null
                            : () {
                                controller.voiceCall(context);
                              },
                      ),
                      ChatSettingsListSection(
                        icon: CupertinoIcons.videocam_fill,
                        title: S.of(context).video,
                        onPressed: !controller.isCallAllowed
                            ? null
                            : () {
                                controller.videoCall(context);
                              },
                      ),
                      ChatSettingsListSection(
                        icon: CupertinoIcons.search,
                        title: S.of(context).search,
                        onPressed: () {
                          controller.openSearch(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        CupertinoListSection.insetGrouped(
                          hasLeading: false,
                          dividerMargin: 0,
                          topMargin: 0,
                          margin: const EdgeInsets.all(10),
                          children: [
                            ValueListenableBuilder(
                              valueListenable: controller,
                              builder: (context, value, child) {
                                if (value.data.user == null) {
                                  return const CupertinoListTile.notched(
                                    title: CupertinoActivityIndicator(),
                                  );
                                }
                                return CupertinoListTile.notched(
                                  title: Text(
                                    value.data.user!.searchUser.bio ??
                                        "${S.of(context).hiIamUse} ${SConstants.appName}",
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                        CupertinoListSection.insetGrouped(
                          hasLeading: false,
                          margin: const EdgeInsets.all(10),
                          dividerMargin: 0,
                          topMargin: 0,
                          children: [
                            SettingsListItemTile(
                              color: Colors.blue,
                              icon: CupertinoIcons.photo,
                              onTap: () {
                                controller.onShowMedia(context);
                              },
                              title: S.of(context).mediaLinksAndDocs,
                            ),
                            SettingsListItemTile(
                              color: Colors.amber,
                              onTap: () {
                                controller.starMessage(context);
                              },
                              icon: CupertinoIcons.star_fill,
                              title: S.of(context).starredMessages,
                            ),
                            if (VPlatforms.isMobile)
                              VWallpaperSettingsWidget(
                                roomId: widget.settingsModel.roomId,
                              ),
                            SettingsListItemTile(
                              color: Colors.green,
                              icon: CupertinoIcons.eye,
                              isLoading: value.data.isUpdatingOneSeen,

                              title: S.of(context).oneSeenMessage,
                              onTap: () {
                                controller.updateOneTimeSeen(context);
                              },
                              additionalInfo:
                                  value.data.settingsModel.room.isOneSeen
                                      ? Text(S.of(context).yes)
                                      : Text(S.of(context).no),
                            ),
                          ],
                        ),
                        CupertinoListSection.insetGrouped(
                          hasLeading: false,
                          margin: const EdgeInsets.all(10),
                          dividerMargin: 0,
                          topMargin: 0,
                          children: [
                            SettingsListItemTile(
                              color: Colors.green,
                              icon: CupertinoIcons.speaker_2,
                              title: S.of(context).mute,
                              isLoading: value.data.isUpdatingMute,
                              additionalInfo:
                                  value.data.settingsModel.room.isMuted
                                      ? Text(S.of(context).on)
                                      : Text(S.of(context).off),
                              onTap: () {
                                controller.updateMute(context);
                              },
                            ),
                            SettingsListItemTile(
                              color: Colors.deepOrangeAccent,
                              icon: CupertinoIcons.person,
                              onTap: () {
                                controller.toUpdateNickName(context);
                              },
                              title: S.of(context).nickname,
                              additionalInfo:
                                  value.data.settingsModel.room.nickName == null
                                      ? Text(S.of(context).none)
                                      : Text(
                                          value.data.settingsModel.room
                                              .nickName!,
                                        ),
                            ),
                          ],
                        ),
                        CupertinoListSection.insetGrouped(
                          hasLeading: false,
                          margin: const EdgeInsets.all(10),
                          dividerMargin: 0,
                          topMargin: 0,
                          children: [
                            SettingsListItemTile(
                              color: Colors.red,
                              icon: CupertinoIcons.arrow_right_arrow_left,
                              isLoading: value.data.isUpdatingBlock,
                              onTap: () {
                                controller.onBlockUser(context);
                              },
                              textColor: Colors.red,
                              title: value.loadingState ==
                                      VChatLoadingState.success
                                  ? value.data.user!.isMeBanner
                                      ? S.of(context).unBlock
                                      : S.of(context).block
                                  : S.of(context).loading,
                            ),
                            SettingsListItemTile(
                              color: Colors.red,
                              icon: CupertinoIcons.ant_circle,
                              title: S.of(context).report,
                              textColor: Colors.red,
                              onTap: () {
                                controller.onReportUser(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
