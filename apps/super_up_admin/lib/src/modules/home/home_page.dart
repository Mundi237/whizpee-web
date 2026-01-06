// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:super_up_admin/src/modules/home/widgets/home_slider.dart';
import 'package:super_up_admin/src/modules/home_tabs/notifications/notifications_page.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:super_up_admin/src/modules/home/widgets/sheet_for_choose_language.dart';
import 'package:super_up_admin/src/modules/splash.dart';

import '../home_tabs/dashboard/dashboard_page.dart';
import '../home_tabs/settings/settings_page.dart';
import '../home_tabs/users/users_page.dart';
import 'home_controller.dart';
import 'widgets/admin_header_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController(0);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final sidebarXController = controller.sidebarXController;
    return SafeArea(
      child: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return Scaffold(
            key: _key,
            appBar: isSmallScreen
                ? AppBar(
                    title: Text(
                      controller.currentTab.label!,
                    ),
                    leading: IconButton(
                      onPressed: () {
                        _key.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                    actions: [
                      _buildQuickActionsMenu(context),
                    ],
                  )
                : AppBar(
                    title: Row(
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          height: 32,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          S.of(context).admin,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      AdminHeaderWidget(
                        onLanguageChanged: () => setState(() {}),
                      ),
                    ],
                    elevation: 0,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
            drawer: HomeSlider(
              controller: sidebarXController,
              items: controller.tabs,
            ),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isSmallScreen)
                  HomeSlider(
                    controller: sidebarXController,
                    items: controller.tabs,
                  ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (_, value, __) {
                      if (value == 0) {
                        return const DashboardPage();
                      }
                      if (value == 1) {
                        return const UsersTabNavigation();
                      }
                      if (value == 2) {
                        return const NotificationsPage();
                      }
                      if (value == 3) {
                        return const SettingsPage();
                      }
                      return const Scaffold();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionsMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) async {
        switch (value) {
          case 'language':
            await _showLanguageSelector(context);
            break;
          case 'settings':
            controller.sidebarXController.selectIndex(3);
            break;
          case 'logout':
            await _showLogoutDialog(context);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'language',
          child: Row(
            children: [
              const Icon(Icons.language),
              const SizedBox(width: 12),
              Text(S.of(context).language),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              const Icon(Icons.settings),
              const SizedBox(width: 12),
              Text(S.of(context).settings),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout, color: Colors.red),
              const SizedBox(width: 12),
              Text(
                S.of(context).logOut,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showLanguageSelector(BuildContext context) async {
    final res = await showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SheetForChooseLanguage(),
    ) as ModelSheetItem?;
    if (res == null) return;
    await VLanguageListener.I.setLocal(Locale(res.id.toString()));
    await VAppPref.setStringKey(
      SStorageKeys.appLanguageTitle.name,
      res.title,
    );
    setState(() {});
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).logOut,
      content: S.of(context).areYouSure,
    );
    if (res == 1) {
      await VAppPref.removeKey(SStorageKeys.isLogin.name);
      await VAppPref.removeKey(SStorageKeys.adminAccessPassword.name);
      if (mounted) {
        context.toPage(
          const Splash(),
          removeAll: true,
          withAnimation: false,
        );
      }
    }
  }
}
