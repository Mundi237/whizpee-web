import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/modules/annonces/presentation/announcements_page.dart';
import 'package:super_up/app/modules/annonces/presentation/create_announcement_page.dart';
import 'package:super_up/app/modules/annonces/presentation/profile_screen.dart';
import 'package:super_up/app/modules/home/mobile/calls_tab/views/calls_tab_view.dart';
import 'package:super_up/app/modules/home/mobile/story_tab/views/story_tab_view.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';

import '../../../../../core/api_service/auth/auth_api_service.dart';
import '../../../../../core/api_service/profile/profile_api_service.dart';
import '../../../../../core/app_nav/app_navigation.dart';
import '../../wide_navigation/wide_chat_info_navigation.dart';
import '../../wide_navigation/wide_messages_navigation.dart';
import '../../wide_navigation/wide_rooms_navigation.dart';
import '../controller/home_wide_controller.dart';
import '../model/home_wide_section.dart';

class HomeWideView extends StatefulWidget {
  const HomeWideView({super.key});

  @override
  State<HomeWideView> createState() => _HomeWideViewState();
}

class _HomeWideViewState extends State<HomeWideView> {
  late final HomeWideController controller;
  final sizer = GetIt.I.get<AppSizeHelper>();

  @override
  void initState() {
    super.initState();
    controller = HomeWideController(
      GetIt.I.get<ProfileApiService>(),
      GetIt.I.get<AuthApiService>(),
    );
    controller.onInit();
    if (!GetIt.I.isRegistered<HomeWideController>()) {
      GetIt.I.registerSingleton<HomeWideController>(controller);
    }
  }

  @override
  void dispose() {
    if (GetIt.I.isRegistered<HomeWideController>()) {
      GetIt.I.unregister<HomeWideController>();
    }
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered (handle hot reload cases)
    if (!GetIt.I.isRegistered<HomeWideController>()) {
      GetIt.I.registerSingleton<HomeWideController>(controller);
    }
    final isDark = context.isDark;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // 1. Navigation Rail (Far Left)
            ValueListenableBuilder<HomeWideSection>(
              valueListenable: controller.activeSection,
              builder: (context, section, _) {
                return Container(
                  width: 72,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0D0D0D) : Colors.grey[100],
                    border: Border(
                      right: BorderSide(
                        color: isDark ? Colors.white12 : Colors.black12,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildRailItem(
                        icon: Icons.campaign_outlined,
                        activeIcon: Icons.campaign,
                        label: S.of(context).annonces,
                        isSelected: section == HomeWideSection.annonces,
                        onTap: () =>
                            controller.changeSection(HomeWideSection.annonces),
                      ),
                      _buildRailItem(
                        icon: CupertinoIcons.chat_bubble_2,
                        activeIcon: CupertinoIcons.chat_bubble_2_fill,
                        label: S.of(context).chats,
                        isSelected: section == HomeWideSection.chats,
                        onTap: () =>
                            controller.changeSection(HomeWideSection.chats),
                      ),
                      _buildRailItem(
                        icon: CupertinoIcons.add_circled,
                        activeIcon: CupertinoIcons.add_circled,
                        label: "Create",
                        isSelected: section == HomeWideSection.create,
                        onTap: () =>
                            controller.changeSection(HomeWideSection.create),
                      ),
                      _buildRailItem(
                        icon: CupertinoIcons.phone,
                        activeIcon: CupertinoIcons.phone_fill,
                        label: S.of(context).phone,
                        isSelected: section == HomeWideSection.calls,
                        onTap: () =>
                            controller.changeSection(HomeWideSection.calls),
                      ),
                      _buildRailItem(
                        icon: CupertinoIcons.play_circle,
                        activeIcon: CupertinoIcons.play_circle_fill,
                        label: S.of(context).stories,
                        isSelected: section == HomeWideSection.stories,
                        onTap: () =>
                            controller.changeSection(HomeWideSection.stories),
                      ),
                      const Spacer(),
                      _buildRailItem(
                        icon: CupertinoIcons.profile_circled,
                        activeIcon: CupertinoIcons.profile_circled,
                        label: S.of(context).settings,
                        isSelected: section == HomeWideSection.settings,
                        onTap: () =>
                            controller.changeSection(HomeWideSection.settings),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
            // 2. Middle Column (List/Sidebar)
            ValueListenableBuilder<HomeWideSection>(
              valueListenable: controller.activeSection,
              builder: (context, section, _) {
                final isSmall = sizer.isSmall(context);
                final screenWidth = MediaQuery.of(context).size.width;
                // Proportional width: 30% of screen, between 360 and 500 for wide mode
                final columnWidth =
                    isSmall ? 90.0 : (screenWidth * 0.30).clamp(360.0, 500.0);

                return SizedBox(
                  width: columnWidth,
                  child: Padding(
                    padding:
                        isSmall ? EdgeInsets.zero : const EdgeInsets.all(8.0),
                    child: ValueListenableBuilder<Widget?>(
                      valueListenable: controller.detailWidget,
                      builder: (context, detail, child) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child:
                              detail ?? _buildSectionContent(section, isSmall),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: isDark ? Colors.black12 : Colors.white,
            ),
            // 3. Right Column (Messages/Details)
            Expanded(child: WideMessagesNavigation()),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: isDark ? Colors.black12 : Colors.white,
            ),
            // 4. Info Panel (Optional Far Right)
            ValueListenableBuilder<bool>(
              valueListenable: AppNavigation.wideMessagesInfoNotifier,
              builder: (context, value, child) {
                if (value) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 360,
                      minWidth: 200,
                    ),
                    child: const WideMessageInfoNavigation(),
                  );
                }
                return const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRailItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? AppTheme.primaryGreen : Colors.grey;
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 72,
          height: 64,
          alignment: Alignment.center,
          child: Icon(
            isSelected ? activeIcon : icon,
            color: color,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContent(HomeWideSection section, bool isSmall) {
    switch (section) {
      case HomeWideSection.annonces:
        return const AnnouncementsPage();
      case HomeWideSection.chats:
        return WideRoomsNavigation(
          onSearchClicked: () => controller.onSearchClicked(context),
          onOpenStory: () => controller.changeSection(HomeWideSection.stories),
          onOpenCallLogs: () => controller.changeSection(HomeWideSection.calls),
          onCreateNewBroadcast: () => controller.createNewBroadcast(
              WideRoomsNavigation.navKey.currentState!.context),
          onCreateNewGroup: () => controller
              .createNewGroup(WideRoomsNavigation.navKey.currentState!.context),
          onNewChat: () => controller.newChat(context),
          onShowSettings: () =>
              controller.changeSection(HomeWideSection.settings),
          vRoomController: controller.vRoomController,
          onRoomItemPress: (room) => controller.onRoomItemPress(room, context),
        );
      case HomeWideSection.create:
        return const CreateAnnouncementPage();
      case HomeWideSection.calls:
        return const CallsTabView();
      case HomeWideSection.stories:
        return const StoryTabView();
      case HomeWideSection.settings:
        return const ProfileScreen();
    }
  }
}
