// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_up/app/modules/home/mobile/settings_tab/widgets/settings_list_item_tile.dart';
import 'package:super_up/app/modules/peer_profile/views/widgets/peer_profile_chat_row.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_platform/v_platform.dart';

import '../controllers/peer_profile_controller.dart';

class PeerProfileView extends StatefulWidget {
  final String peerId;

  const PeerProfileView({
    super.key,
    required this.peerId,
  });

  @override
  State<PeerProfileView> createState() => _PeerProfileViewState();
}

class _PeerProfileViewState extends State<PeerProfileView> {
  late final PeerProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = PeerProfileController(widget.peerId);
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
      appBar: AppBar(
        title: Text(S.of(context).contactInfo),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {
            return VAsyncWidgetsBuilder(
              loadingState: controller.loadingState,
              successWidget: () {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () => controller.openFullImage(context),
                          child: controller.data!.searchUser.hasBadge
                              ? VCircleVerifiedAvatar(
                                  vFileSource: VPlatformFile.fromUrl(
                                    networkUrl: controller
                                        .data!.searchUser.baseUser.userImage,
                                  ),
                                  radius: 90,
                                )
                              : VCircleAvatar(
                                  vFileSource: VPlatformFile.fromUrl(
                                    networkUrl: controller
                                        .data!.searchUser.baseUser.userImage,
                                  ),
                                  radius: 90,
                                ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          controller.data!.searchUser.baseUser.fullName,
                          style:
                              context.cupertinoTextTheme.navLargeTitleTextStyle,
                          maxLines: 2,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          controller.data!.searchUser.bio ??
                              "${S.of(context).hiIamUse} ${SConstants.appName}",
                          maxLines: 3,
                          style: const TextStyle(
                            color: CupertinoColors.systemGrey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        PeerProfileChatRow(
                          isLoading: controller.isLoading,
                          createGroupWith: () =>
                              controller.createGroupWith(context),
                          openChatWith: () => controller.openChatWith(context),
                          isMeBanner: controller.data!.isMeBanner,
                          isThereBan: value.data!.getIsThereBan,
                          updateBlock: () => controller.updateBlock(context),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CupertinoListSection.insetGrouped(
                          hasLeading: false,
                          dividerMargin: 0,
                          topMargin: 0,
                          margin: const EdgeInsets.all(10),
                          children: [
                            CupertinoListTile.notched(
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: value.data!.isOnline
                                        ? Colors.green
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    value.data!.isOnline
                                        ? S.of(context).online
                                        : S.of(context).offline,
                                    style: TextStyle(
                                        color: value.data!.isOnline
                                            ? Colors.green
                                            : Colors.grey),
                                  ),
                                ],
                              ),
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
                              color: Colors.red,
                              icon: CupertinoIcons.ant_circle_fill,
                              onTap: () {
                                controller.reportToAdmin(context);
                              },
                              title: S.of(context).reportUser,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              onRefresh: controller.getProfileData,
            );
          },
        ),
      ),
    );
  }
}
