// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:super_up_core/super_up_core.dart';

class ChatSettingsListSection extends StatelessWidget {
  const ChatSettingsListSection({
    super.key,
    required this.icon,
    required this.title,
    this.iconWidget,
    required this.onPressed,
  });

  final IconData icon;
  final Widget? iconWidget;
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: CupertinoListSection(
        hasLeading: false,
        topMargin: 0,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: context.isDark
              ? CupertinoColors.secondarySystemGroupedBackground.darkColor
              : null,
        ),
        dividerMargin: 0,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                onPressed: onPressed,
                child: Column(
                  children: [
                    iconWidget ??
                        Icon(
                          icon,
                          color: CupertinoColors.activeBlue,
                          size: 30,
                        ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
