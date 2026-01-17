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

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final HomeController controller;
  final sizer = GetIt.I.get<AppSizeHelper>();
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late AnimationController _badgeController;
  late CupertinoTabController _tabController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _badgeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

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

    // Pulse animation pour le nouvel onglet actif
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });

    // Badge bounce animation si notification
    if (_tabController.index == 1 && controller.totalChatUnRead > 0) {
      _badgeController.forward().then((_) {
        _badgeController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    _badgeController.dispose();
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
                // Floating background circles
                Positioned(
                  top: -120,
                  right: -100,
                  child: AnimatedBuilder(
                    animation: _floatController,
                    builder: (context, child) {
                      return Container(
                        width: 300 + (35 * _floatController.value),
                        height: 300 + (35 * _floatController.value),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.primaryGreen.withValues(alpha: 0.08),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: -150,
                  left: -100,
                  child: AnimatedBuilder(
                    animation: _floatController,
                    builder: (context, child) {
                      return Container(
                        width: 320 - (35 * _floatController.value),
                        height: 320 - (35 * _floatController.value),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.purple.withValues(alpha: 0.08),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      );
                    },
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
                        icon: _buildAnimatedIcon(
                          icon: Icons.campaign_outlined,
                          index: 0,
                        ),
                        label: S.of(context).annonces,
                      ),
                      BottomNavigationBarItem(
                        icon: ValueListenableBuilder<SLoadingState<int>>(
                          valueListenable: controller,
                          builder: (context, value, child) {
                            return _buildAnimatedIcon(
                              index: 1,
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
                        icon: _buildAnimatedIcon(
                          icon: CupertinoIcons.add_circled,
                          index: 2,
                        ),
                        label: "Create",
                      ),
                      BottomNavigationBarItem(
                        icon: _buildAnimatedIcon(
                          icon: CupertinoIcons.phone,
                          index: 3,
                        ),
                        label: S.of(context).phone,
                      ),
                      BottomNavigationBarItem(
                        icon: _buildAnimatedIcon(
                          icon: CupertinoIcons.play_circle,
                          index: 4,
                        ),
                        label: S.of(context).stories,
                      ),
                      BottomNavigationBarItem(
                        icon: ValueListenableBuilder<SVersion>(
                          valueListenable: controller.versionCheckerController,
                          builder: (context, value, child) {
                            return _buildAnimatedIcon(
                              index: 5,
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

  Widget _buildAnimatedIcon({
    required IconData icon,
    required int index,
    Widget? badge,
  }) {
    final isActive = _tabController.index == index;

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _badgeController]),
      builder: (context, child) {
        // Pulse effect pour l'onglet actif
        double pulseScale = 1.0;
        if (isActive && _pulseController.isAnimating) {
          pulseScale = 1.0 + (0.1 * _pulseController.value);
        }

        // Badge bounce effect
        double badgeOffset = 0.0;
        if (index == 1 && _badgeController.isAnimating) {
          badgeOffset = -3.0 * _badgeController.value;
        }

        return AnimatedScale(
          scale: (isActive ? 1.15 : 1.0) * pulseScale,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: isActive ? 1.0 : 0.75,
            duration: const Duration(milliseconds: 200),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Icon avec effet de brillance subtil
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color:
                                  AppTheme.primaryGreen.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            )
                          ]
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      icon,
                      shadows: isActive
                          ? [
                              Shadow(
                                color: AppTheme.primaryGreen
                                    .withValues(alpha: 0.5),
                                blurRadius: 4,
                              )
                            ]
                          : null,
                    ),
                  ),
                ),
                // Badge avec animation
                if (badge != null)
                  PositionedDirectional(
                    end: -2 + badgeOffset,
                    top: -2 + badgeOffset,
                    child: AnimatedScale(
                      scale: index == 1 && _badgeController.isAnimating
                          ? 1.0 + (0.2 * _badgeController.value)
                          : 1.0,
                      duration: const Duration(milliseconds: 100),
                      child: badge,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
