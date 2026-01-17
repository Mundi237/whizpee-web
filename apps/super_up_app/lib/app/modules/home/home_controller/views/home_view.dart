// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late final HomeController controller;
  final sizer = GetIt.I.get<AppSizeHelper>();
  late CupertinoTabController _tabController;
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _tabController = CupertinoTabController(initialIndex: 0);
    _tabController.addListener(_onTabChanged);
    controller = HomeController(
      GetIt.I.get<ProfileApiService>(),
      context,
    );
    controller.onInit();
  }

  void _onTabChanged() {
    HapticFeedback.selectionClick();
    _currentIndex.value = _tabController.index;
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _currentIndex.dispose();
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (sizer.isWide(context)) {
      return const HomeWideView();
    }
    final isDark = VThemeListener.I.isDarkMode;
    return ValueListenableBuilder<SLoadingState<int>>(
      valueListenable: controller,
      builder: (_, value, __) {
        return Scaffold(
          extendBody: false,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        const Color(0xFF0D0D0D),
                        const Color(0xFF1A0E2E),
                        const Color(0xFF2D1B4E),
                      ]
                    : [
                        const Color(0xFF000000),
                        const Color(0xFF1A0E2E),
                        const Color(0xFF3D2257),
                      ],
              ),
            ),
            child: Stack(
              children: [
                // Static background circles (no animation)
                Positioned(
                  top: -120,
                  right: -100,
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.primaryGreen.withValues(alpha: 0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -150,
                  left: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.purple.withValues(alpha: 0.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Tab Content
                CupertinoTabScaffold(
                  controller: _tabController,
                  backgroundColor: Colors.transparent,
                  tabBar: CupertinoTabBar(
                    height: 65,
                    backgroundColor: Colors.black.withValues(alpha: 0.85),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.08),
                        width: 0.5,
                      ),
                    ),
                    activeColor: AppTheme.primaryGreen,
                    inactiveColor: Colors.white.withValues(alpha: 0.6),
                    iconSize: 26,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.campaign_outlined),
                        label: S.of(context).annonces,
                      ),
                      BottomNavigationBarItem(
                        icon: ValueListenableBuilder<SLoadingState<int>>(
                          valueListenable: controller,
                          builder: (context, value, child) {
                            return _buildIconWithBadge(
                              icon: CupertinoIcons.chat_bubble_2,
                              badge: ChatUnReadWidget(
                                unReadCount: controller.totalChatUnRead,
                                width: 15,
                                height: 15,
                              ),
                            );
                          },
                        ),
                        label: S.of(context).chats,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(CupertinoIcons.add_circled),
                        label: "Create",
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(CupertinoIcons.phone),
                        label: S.of(context).phone,
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(CupertinoIcons.play_circle),
                        label: S.of(context).stories,
                      ),
                      BottomNavigationBarItem(
                        icon: ValueListenableBuilder<SVersion>(
                          valueListenable: controller.versionCheckerController,
                          builder: (context, value, child) {
                            return _buildIconWithBadge(
                              icon: CupertinoIcons.profile_circled,
                              badge: ChatUnReadWidget(
                                unReadCount: value.isNeedUpdates ? 1 : 0,
                                width: 15,
                                height: 15,
                              ),
                            );
                          },
                        ),
                        label: S.of(context).settings,
                      ),
                    ],
                  ),
                  tabBuilder: (context, index) {
                    if (index == 0) {
                      return const AnnouncementsPage();
                    }
                    if (index == 1) {
                      return const RoomsTabView();
                    }
                    if (index == 2) {
                      return const CreateAnnouncementPage();
                    }
                    if (index == 3) {
                      return const CallsTabView();
                    }
                    if (index == 4) {
                      return const StoryTabView();
                    }
                    if (index == 5) {
                      return const ProfileScreen();
                    }
                    throw Exception("Not found");
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Lightweight icon builder for badges only - no animations
  Widget _buildIconWithBadge({
    required IconData icon,
    Widget? badge,
  }) {
    if (badge == null) {
      return Icon(icon);
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        PositionedDirectional(
          end: -4,
          top: -4,
          child: badge,
        ),
      ],
    );
  }
}
