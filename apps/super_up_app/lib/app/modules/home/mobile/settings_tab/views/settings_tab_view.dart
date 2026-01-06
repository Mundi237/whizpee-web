// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_up/app/modules/chat_settings/chat_star_messages/views/chat_star_messages_page.dart';
import 'package:super_up/app/modules/home/home_controller/widgets/chat_un_read_counter.dart';
import 'package:super_up/app/modules/home/mobile/settings_tab/states/setting_state.dart';
import 'package:super_up/app/modules/home/mobile/settings_tab/widgets/settings_list_item_tile.dart';
import 'package:super_up/app/modules/home/settings_modules/blocked_contacts/views/blocked_contacts_page.dart';
import 'package:super_up/app/modules/home/settings_modules/devices/linked_devices/views/linked_devices_page.dart';
import 'package:super_up/app/modules/home/settings_modules/my_account/views/my_account_page.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_platform/v_platform.dart';

import '../../../settings_modules/admin_notification/views/admin_notification_page.dart';
import '../../../settings_modules/help_tab/help/views/help_page.dart';
import '../../../settings_modules/my_privacy/my_privacy_page.dart';
import '../controllers/settings_tab_controller.dart';

class SettingsTabView extends StatefulWidget {
  const SettingsTabView({super.key});

  @override
  State<SettingsTabView> createState() => _SettingsTabViewState();
}

class _SettingsTabViewState extends State<SettingsTabView> {
  final SettingsTabController controller = SettingsTabController();

  @override
  void initState() {
    super.initState();
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            CupertinoSliverNavigationBar(
              largeTitle: Text(
                S.of(context).settings,
              ),
              backgroundColor: context.isDark ? Colors.black : Colors.white,
            )
          ],
          body: SingleChildScrollView(
            child: ValueListenableBuilder<SLoadingState<SettingState>>(
              valueListenable: controller,
              builder: (_, value, ___) {
                return Column(
                  children: [
                    CupertinoListSection(
                      dividerMargin: 0,
                      hasLeading: false,
                      children: [
                        CustomListTile(
                          //add is verified to image
                          title: AppAuth.myProfile.baseUser.fullName,
                          padding: const EdgeInsets.all(10),
                          leading: AppAuth.myProfile.isPrime
                              ? VCircleVerifiedAvatar(
                                  vFileSource: VPlatformFile.fromUrl(
                                    networkUrl:
                                        AppAuth.myProfile.baseUser.userImage,
                                  ),
                                )
                              : VCircleAvatar(
                                  vFileSource: VPlatformFile.fromUrl(
                                    networkUrl:
                                        AppAuth.myProfile.baseUser.userImage,
                                  ),
                                ),
                          subtitle: AppAuth.myProfile.bio,
                          trailing: GestureDetector(
                            onTap: () => controller.onThemeChange(context),
                            child: Icon(
                              controller.data.isDarkMode
                                  ? CupertinoIcons.sun_min
                                  : CupertinoIcons.moon_fill,
                              color: controller.data.isDarkMode
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        // SettingsListItemTile(
                        //   color: Colors.blue,
                        //   title: S.of(context).account,
                        //   onTap: () async {
                        //     await context.toPage(const MyAccountPage());
                        //     controller.update();
                        //   },
                        //   icon: CupertinoIcons.profile_circled,
                        // )
                      ],
                    ),
                    CupertinoListSection(
                      dividerMargin: 0,
                      topMargin: 30,
                      hasLeading: false,
                      children: [
                        SettingsListItemTile(
                          color: Colors.amber,
                          title: S.of(context).starredMessages,
                          onTap: () =>
                              context.toPage(const ChatStarMessagesPage()),
                          icon: CupertinoIcons.star_fill,
                        ),
                        SettingsListItemTile(
                          hide: !VPlatforms.isMobile,
                          color: Colors.grey,
                          title: S.of(context).linkedDevices,
                          onTap: () =>
                              context.toPage(const LinkedDevicesPage()),
                          icon: CupertinoIcons.device_laptop,
                        ),
                        SettingsListItemTile(
                          color: Colors.deepOrange,
                          title: S.of(context).language,
                          onTap: () => controller.onLanguageChange(context),
                          additionalInfo: value.data.language.text,
                          icon: Icons.language,
                        ),
                        SettingsListItemTile(
                          color: Colors.amber,
                          title: S.of(context).adminNotification,
                          onTap: () =>
                              context.toPage(const AdminNotificationPage()),
                          icon: CupertinoIcons.app_badge_fill,
                        ),
                      ],
                    ),
                    CupertinoListSection(
                      dividerMargin: 0,
                      topMargin: 30,
                      hasLeading: false,
                      children: [
                        SettingsListItemTile(
                          color: Colors.indigo,
                          title: S.of(context).myPrivacy,
                          onTap: () => context.toPage(const MyPrivacyPage()),
                          icon: Icons.privacy_tip_outlined,
                        ),
                        SettingsListItemTile(
                          color: Colors.red,
                          title: S.of(context).blockedUsers,
                          onTap: () =>
                              context.toPage(const BlockedContactsPage()),
                          icon: CupertinoIcons.ant,
                        ),
                        SettingsListItemTile(
                          color: Colors.grey,
                          title: S.of(context).inAppAlerts,
                          onTap: () =>
                              controller.onChangeAppNotifications(context),
                          icon: CupertinoIcons.app_badge,
                          additionalInfo: value.data.inAppAlerts
                              ? Text(S.of(context).on)
                              : Text(S.of(context).off),
                        ),
                        if (VPlatforms.isMobile)
                          SettingsListItemTile(
                            color: Colors.green,
                            title: S.of(context).storageAndData,
                            onTap: () => controller.onStorageClick(context),
                            icon: CupertinoIcons.wifi,
                          ),
                      ],
                    ),
                    CupertinoListSection(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      dividerMargin: 0,
                      topMargin: 30,
                      hasLeading: false,
                      children: [
                        SettingsListItemTile(
                          color: Colors.blue,
                          title: S.of(context).help,
                          onTap: () => context.toPage(const HelpPage()),
                          icon: CupertinoIcons.question,
                        ),
                        SettingsListItemTile(
                          color: Colors.grey,
                          title: S.of(context).tellAFriend,
                          onTap: () => controller.tellAFriend(context),
                          icon: CupertinoIcons.heart_fill,
                        ),
                        SettingsListItemTile(
                          color: Colors.green,
                          title: S.of(context).checkForUpdates,
                          onTap: () => controller.checkForUpdates(context),
                          icon: CupertinoIcons.refresh_thick,
                          trailing: controller
                                  .versionCheckerController.value.isNeedUpdates
                              ? Row(
                                  children: [
                                    const ChatUnReadWidget(
                                      unReadCount: 1,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Icon(context.isRtl
                                        ? CupertinoIcons.chevron_back
                                        : CupertinoIcons.chevron_forward),
                                  ],
                                )
                              : null,
                        ),
                        SettingsListItemTile(
                          color: Colors.red,
                          title: S.of(context).logOut,
                          onTap: () => controller.logout(context),
                          icon: CupertinoIcons.arrow_right_circle,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
