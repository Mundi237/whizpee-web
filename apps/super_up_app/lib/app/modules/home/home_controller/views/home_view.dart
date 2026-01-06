// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/modules/annonces/presentation/announcements_page.dart';
import 'package:super_up/app/modules/annonces/presentation/create_announcement_page.dart';
import 'package:super_up/app/modules/annonces/presentation/profile_screen.dart';

import 'package:super_up/app/modules/home/mobile/calls_tab/views/calls_tab_view.dart';
import 'package:super_up/app/modules/home/mobile/rooms_tab/views/rooms_tab_view.dart';
import 'package:super_up/app/modules/home/mobile/users_tab/views/users_tab_view.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import '../../../../core/api_service/profile/profile_api_service.dart';
import '../../home_wide_modules/home/view/home_wide_view.dart';
import '../../mobile/settings_tab/views/settings_tab_view.dart';
import '../../mobile/story_tab/views/story_tab_view.dart';
import '../controllers/home_controller.dart';
import '../widgets/chat_un_read_counter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final HomeController controller;
  final sizer = GetIt.I.get<AppSizeHelper>();

  @override
  void initState() {
    super.initState();
    controller = HomeController(
      GetIt.I.get<ProfileApiService>(),
      context,
    );
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (sizer.isWide(context)) {
      return const HomeWideView();
    }
    return ValueListenableBuilder<SLoadingState<int>>(
      valueListenable: controller,
      builder: (_, value, __) {
        return Scaffold(
          body: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const Icon(Icons.campaign_outlined),
                  label: S.of(context).annonces,
                  tooltip: S.of(context).annonces,
                ),
                BottomNavigationBarItem(
                  icon: ValueListenableBuilder<SLoadingState<int>>(
                    valueListenable: controller,
                    builder: (context, value, child) {
                      return Stack(
                        children: [
                          const Icon(CupertinoIcons.chat_bubble_2),
                          PositionedDirectional(
                            end: 0,
                            child: ChatUnReadWidget(
                              unReadCount: controller.totalChatUnRead,
                              width: 15,
                              height: 15,
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  label: S.of(context).chats,
                  tooltip: S.of(context).chats,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(CupertinoIcons.add_circled),
                  label: "Create", // S.of(context).create,
                  tooltip: "Create", // S.of(context).create,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(CupertinoIcons.phone),
                  label: S.of(context).phone,
                  tooltip: S.of(context).phone,
                ),
                BottomNavigationBarItem(
                  //rays
                  icon: const Icon(CupertinoIcons.play_circle),
                  label: S.of(context).stories,
                  tooltip: S.of(context).stories,
                ),

                // BottomNavigationBarItem(
                //   icon: const Icon(CupertinoIcons.person_2),
                //   label: S.of(context).users,
                //   tooltip: S.of(context).users,
                // ),
                BottomNavigationBarItem(
                  icon: ValueListenableBuilder<SVersion>(
                    valueListenable: controller.versionCheckerController,
                    builder: (context, value, child) {
                      return Stack(
                        children: [
                          const Icon(CupertinoIcons.profile_circled),
                          PositionedDirectional(
                            end: 0,
                            child: ChatUnReadWidget(
                              unReadCount: value.isNeedUpdates ? 1 : 0,
                              width: 15,
                              height: 15,
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  label: S.of(context).settings,
                  tooltip: S.of(context).settings,
                ),
              ],
            ),
            tabBuilder: (context, index) {
              if (index == 0) {
                return const AnnouncementsPage();
                // return const RoomsTabView();
              }
              if (index == 1) {
                return const RoomsTabView();
                // return const StoryTabView();
              }
              if (index == 2) {
                return const CreateAnnouncementPage();
                // return const CallsTabView();
              }
              if (index == 3) {
                // return const UsersTabView();
                return const CallsTabView();
              }
              if (index == 4) {
                // return const UsersTabView();
                return const StoryTabView();
              }
              // if (index == 5) {
              //   // return const SettingsTabView();
              //   return const UsersTabView();
              // }
              if (index == 5) {
                //return const SettingsTabView();
                return const ProfileScreen();
              }
              throw Exception("Not found");
            },
          ),
        );
      },
    );
  }
}
