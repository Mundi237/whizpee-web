// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_up/app/modules/home/mobile/settings_tab/widgets/settings_list_item_tile.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import 'package:v_platform/v_platform.dart';

import '../../../../core/app_config/app_config_controller.dart';
import '../../widgets/chat_settings_navigation_bar.dart';
import '../../widgets/language_tile.dart';
import '../controllers/group_room_settings_controller.dart';
import '../states/group_room_setting_state.dart';

class GroupRoomSettingsView extends StatefulWidget {
  final VToChatSettingsModel settingsModel;

  const GroupRoomSettingsView({super.key, required this.settingsModel});

  @override
  State<GroupRoomSettingsView> createState() => _GroupRoomSettingsViewState();
}

class _GroupRoomSettingsViewState extends State<GroupRoomSettingsView> {
  late final GroupRoomSettingsController controller;

  @override
  void initState() {
    super.initState();
    controller = GroupRoomSettingsController(widget.settingsModel);
    controller.onInit();
    AdsBannerWidget.loadAd(
      VPlatforms.isAndroid
          ? SConstants.androidInterstitialId
          : SConstants.iosInterstitialId,
      enableAds: VAppConfigController.appConfig.enableAds,
    );
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
        middle: S.of(context).groupInfo,
        previousPageTitle: S.of(context).back,
      ),
      body: SafeArea(
        child: ValueListenableBuilder<SLoadingState<GroupRoomSettingState>>(
          valueListenable: controller,
          builder: (context, value, child) => SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () => controller.openFullImage(context),
                  child: ValueListenableBuilder<
                      SLoadingState<GroupRoomSettingState>>(
                    valueListenable: controller,
                    builder: (context, value, child) {
                      if (value.loadingState != VChatLoadingState.success) {
                        return VCircleAvatar(
                          vFileSource: VPlatformFile.fromUrl(
                            networkUrl: controller.settingsModel.image,
                          ),
                          radius: 90,
                        );
                      }
                      if (controller.groupInfo!.isMeOut) {
                        return VCircleAvatar(
                          vFileSource: VPlatformFile.fromUrl(
                            networkUrl: controller.settingsModel.image,
                          ),
                          radius: 90,
                        );
                      }
                      return Stack(
                        children: [
                          VCircleAvatar(
                            vFileSource: VPlatformFile.fromUrl(
                              networkUrl: controller.settingsModel.image,
                            ),
                            radius: 90,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => controller.openEditImage(context),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: context.isDark
                                      ? Colors.brown
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  CupertinoIcons.camera,
                                  color: Colors.green,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    if (value.loadingState != VChatLoadingState.success) {
                      return Text(
                        controller.settingsModel.room.title,
                        style:
                            context.cupertinoTextTheme.navLargeTitleTextStyle,
                      );
                    }
                    if (controller.groupInfo!.isMeOut) {
                      return Text(
                        controller.settingsModel.room.title,
                        style:
                            context.cupertinoTextTheme.navLargeTitleTextStyle,
                      );
                    }
                    return GestureDetector(
                      onTap: () => controller.openEditTitle(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.settingsModel.room.title,
                            style: context
                                .cupertinoTextTheme.navLargeTitleTextStyle,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ValueListenableBuilder<SLoadingState<GroupRoomSettingState>>(
                  valueListenable: controller,
                  builder: (_, value, __) {
                    return VAsyncWidgetsBuilder(
                      loadingState: value.loadingState,
                      onRefresh: controller.getData,
                      successWidget: () {
                        final isMeAdminOrSuper = controller.isMeAdminOrSuper;
                        if (value.data.groupInfo!.isMeOut) {
                          return ChatSettingsTileInfo(
                            title: Text(
                              S.of(context).youNotParticipantInThisGroup,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => controller
                                    .onChangeGroupDescriptionClicked(context),
                                child: _getGroupBio(
                                    context, controller.getGroupDesc),
                              ),
                              CupertinoListSection.insetGrouped(
                                hasLeading: false,
                                margin: const EdgeInsets.all(10),
                                dividerMargin: 0,
                                topMargin: 0,
                                children: [
                                  SettingsListItemTile(
                                    color: Colors.lightGreen,
                                    icon: CupertinoIcons.search,
                                    title: S.of(context).search,
                                    onTap: () {
                                      controller.openSearch(context);
                                    },
                                  ),
                                  SettingsListItemTile(
                                    color: Colors.cyan,
                                    icon: CupertinoIcons.person_2,
                                    title: S.of(context).members,
                                    onTap: () {
                                      controller.onGoShowMembers(context);
                                    },
                                    additionalInfo: Text(controller
                                        .groupInfo!.membersCount
                                        .toString()),
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
                                  if (isMeAdminOrSuper)
                                    SettingsListItemTile(
                                      color: Colors.green,
                                      onTap: () {
                                        controller
                                            .addParticipantsToGroup(context);
                                      },
                                      icon: CupertinoIcons.add,
                                      title: S.of(context).addMembers,
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
                                    color: Colors.blue,
                                    icon: CupertinoIcons.photo,
                                    onTap: () {
                                      controller.openChatMedia(context);
                                    },
                                    title: S.of(context).mediaLinksAndDocs,
                                  ),
                                  SettingsListItemTile(
                                    color: Colors.amber,
                                    icon: CupertinoIcons.star_fill,
                                    title: S.of(context).starredMessage,
                                    onTap: () {
                                      controller.openStarredMessages(context);
                                    },
                                  ),
                                  SettingsListItemTile(
                                    color: Colors.deepOrangeAccent,
                                    icon: CupertinoIcons.person,
                                    title: S.of(context).nickname,
                                    onTap: () {
                                      controller.toUpdateNickName(context);
                                    },
                                    additionalInfo: value.data.settingsModel
                                                .room.nickName ==
                                            null
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
                                    color: Colors.green,
                                    isLoading: value.data.isUpdatingMute,
                                    icon: CupertinoIcons.speaker_2,
                                    title: S.of(context).mute,
                                    onTap: () {
                                      controller.updateMute(context);
                                    },
                                    additionalInfo:
                                        value.data.settingsModel.room.isMuted
                                            ? Text(S.of(context).yes)
                                            : Text(S.of(context).no),
                                  ),
                                  SettingsListItemTile(
                                    color: Colors.red,
                                    isLoading: value.data.isUpdatingExitGroup,
                                    textColor: Colors.red,
                                    onTap: () => controller.leaveGroup(context),
                                    title: S.of(context).exitGroup,
                                    icon: CupertinoIcons.ant_circle,
                                  ),
                                  // SettingsListItemTile(
                                  //   color: Colors.red,
                                  //   textColor: Colors.red,
                                  //   onTap: () => controller.reportGroup(context),
                                  //   title: "Report Group",
                                  //   icon: PhosphorIcons.bug,
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getGroupBio(BuildContext context, String? desc) {
    if (desc == null) {
      return ChatSettingsTileInfo(
        title: Text(
          S.of(context).clickToAddGroupDescription,
          style: const TextStyle(
            color: CupertinoColors.systemBlue,
          ),
        ),
      );
    }
    return ChatSettingsTileInfo(
      title: Text(desc),
    );
  }
}
