// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:super_up_admin/src/modules/home/widgets/sheet_for_choose_language.dart';
import 'package:super_up_admin/src/modules/splash.dart';

class AdminHeaderWidget extends StatefulWidget {
  final VoidCallback? onLanguageChanged;

  const AdminHeaderWidget({
    super.key,
    this.onLanguageChanged,
  });

  @override
  State<AdminHeaderWidget> createState() => _AdminHeaderWidgetState();
}

class _AdminHeaderWidgetState extends State<AdminHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageSelector(),
          const SizedBox(width: 12),
          _buildThemeToggle(),
          const SizedBox(width: 12),
          _buildUserMenu(),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    final currentLanguage = VAppPref.getStringOrNullKey(
          SStorageKeys.appLanguageTitle.name,
        ) ??
        "English";

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: InkWell(
        onTap: () => _onLanguageChange(context),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.language,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                currentLanguage,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle() {
    return ValueListenableBuilder(
      valueListenable: VThemeListener.I,
      builder: (context, themeMode, _) {
        final isDark = themeMode == ThemeMode.dark;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            ),
          ),
          child: InkWell(
            onTap: () {
              VThemeListener.I.setTheme(
                isDark ? ThemeMode.light : ThemeMode.dark,
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserMenu() {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        ),
        child: Icon(
          Icons.admin_panel_settings,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
      ),
      onSelected: (value) async {
        switch (value) {
          case 'profile':
            _showProfileInfo(context);
            break;
          case 'logout':
            await _showLogoutDialog(context);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              const Icon(Icons.person_outline),
              const SizedBox(width: 12),
              Text(S.of(context).profile ?? 'Profile'),
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

  void _showProfileInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.admin_panel_settings),
            const SizedBox(width: 8),
            Text(S.of(context).admin),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Administrator Panel',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your application settings, users, and notifications from this admin panel.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).close ?? 'Close'),
          ),
        ],
      ),
    );
  }

  FutureOr<void> _onLanguageChange(BuildContext context) async {
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
    widget.onLanguageChanged?.call();
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
