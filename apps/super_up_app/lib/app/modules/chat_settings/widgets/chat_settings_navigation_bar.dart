import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up_core/super_up_core.dart';

import '../../../core/app_nav/app_navigation.dart';
import '../../home/home_wide_modules/wide_navigation/wide_messages_navigation.dart';

class ChatSettingsNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String middle;
  final String previousPageTitle;

  ChatSettingsNavigationBar({
    super.key,
    required this.middle,
    required this.previousPageTitle,
  });

  final sizer = GetIt.I.get<AppSizeHelper>();

  @override
  Widget build(BuildContext context) {
    final isWide = sizer.isWide(context);
    return AppBar(
      title: Text(middle),
      automaticallyImplyLeading: false,
      leading: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          if (isWide) {
            AppNavigation.popKey(WideMessagesNavigation.navKey);
            AppNavigation.setWideMessagesInfoNotifier(false);
          } else {
            context.pop();
          }
        },
        icon: isWide
            ? Container(
                decoration: BoxDecoration(
                  color: context.isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 27,
                ),
              )
            : const Icon(
                Icons.arrow_back,
                color: Colors.red,
                size: 27,
              ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
