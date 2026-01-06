// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_message_page/src/core/core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../message_items/shared/message_typing_widget.dart';

class VMessageAppBare extends StatelessWidget {
  final Function(BuildContext context) onTitlePress;

  final Function(bool isVideo)? onCreateCall;
  final Function(bool isBlocked)? onUpdateBlock;
  final VRoom room;
  final VMessageLocalization language;
  final int? memberCount;
  final int? totalOnline;
  final DateTime? lastSeenAt;
  final String? Function(BuildContext context) inTypingText;
  final bool isCallAllowed;

  const VMessageAppBare({
    super.key,
    required this.onTitlePress,
    required this.room,
    required this.language,
    required this.inTypingText,
    this.onCreateCall,
    this.memberCount,
    required this.isCallAllowed,
    this.totalOnline,
    this.lastSeenAt,
    this.onUpdateBlock,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      elevation: 1,
      centerTitle: false,
      backgroundColor: context.isDark ? Color(0xff272727) : Colors.white,
      surfaceTintColor: context.isDark ? Color(0xff272727) : Colors.white,
      title: ChatListTile(
        title: room.realTitle,
        leading: VCircleAvatar(
          vFileSource: VPlatformFile.fromUrl(networkUrl: room.thumbImage),
          radius: 18,
        ),
        onTap: () => onTitlePress.call(context),
        subtitle: inTypingText(context) != null
            ? MessageTypingWidget(
                text: inTypingText(context)!,
              )
            : _getSubTitle(context)
                ?.text
                .color(CupertinoColors.systemGreen)
                .size(12),
      ),
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [_getCallIcon],
        )
      ],
    );
  }

  String? _getSubTitle(BuildContext context) {
    if (room.roomType.isSingleOrOrder) {
      if (room.isOnline) {
        return language.online;
      }
      if (lastSeenAt == null) {
        return null;
      } else {
        return format(
          lastSeenAt!.toLocal(),
          locale: Localizations.localeOf(context).languageCode,
        );
      }
    } else if (memberCount != null) {
      if (totalOnline != null) {
        return "${language.members} $memberCount";
      }
      return "${language.members} $memberCount";
    }
    return null;
  }

  Widget get _getCallIcon {
    if (isCallAllowed) {
      return Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              PhosphorIcons.videoCamera(),
              size: 30,
              color: isCallAllowed ? null : Colors.grey,
            ),
            onPressed: () {
              if (!isCallAllowed) return;
              onCreateCall?.call(true);
            },
          ),
          const SizedBox(
            width: 5,
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              CupertinoIcons.phone,
              size: 28,
              color: isCallAllowed ? null : Colors.grey,
            ),
            onPressed: () {
              if (!isCallAllowed) return;
              onCreateCall?.call(false);
            },
          ),
        ],
      );
    }
    return const SizedBox();
  }
}
