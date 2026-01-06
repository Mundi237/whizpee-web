// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

import '../../v_chat_message_page.dart';

typedef CustomMessageItemTypeDef = Widget Function(
  BuildContext context,
  bool isMeSender,
  Map<String, dynamic> data,
);
typedef ItemHolderColorTypeDef = Color Function(
  BuildContext context,
  bool isMeSender,
  bool isDarkMode,
);

const _darkMeSenderColor = Colors.indigo;
const _darkReceiverColor = Color(0xff515156);

const _lightReceiverColor = Color(0xffffffff);
const _lightMySenderColor = Colors.blue;

const _lightTextMeSenderColor = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);
const _lightTextMeReceiverColor = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

const _darkTextMeSenderColor = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);
const _darkTextReceiverColor = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

class VMessageTheme extends ThemeExtension<VMessageTheme> {
  final Color senderBubbleColor;
  final Color receiverBubbleColor;

  final Color senderReplyColor;
  final Color receiverReplyColor;
  final VMsgStatusTheme messageSendingStatus;
  final BoxDecoration scaffoldDecoration;
  final CustomMessageItemTypeDef? customMessageItem;
  final TextStyle receiverTextStyle;
  final TextStyle senderTextStyle;

  final VMessageItemTheme vMessageItemTheme;

  VMessageTheme._({
    required this.senderBubbleColor,
    required this.receiverBubbleColor,
    required this.senderReplyColor,
    required this.receiverReplyColor,
    required this.senderTextStyle,
    this.customMessageItem,
    required this.scaffoldDecoration,
    required this.messageSendingStatus,
    required this.receiverTextStyle,
    required this.vMessageItemTheme,
  });

  factory VMessageTheme.light() {
    return VMessageTheme._(
      senderBubbleColor: _lightMySenderColor,
      vMessageItemTheme: const VMessageItemTheme.light(),
      receiverBubbleColor: _lightReceiverColor,
      senderTextStyle: _lightTextMeSenderColor,
      receiverTextStyle: _lightTextMeReceiverColor,
      messageSendingStatus: const VMsgStatusTheme.light(),
      scaffoldDecoration: sMessageBackground(isDark: false),
      senderReplyColor: const Color(0xffD7F2C9),
      receiverReplyColor: const Color(0xffF2F2F2),
    );
  }

  factory VMessageTheme.dark() {
    return VMessageTheme._(
      senderBubbleColor: _darkMeSenderColor,
      receiverBubbleColor: _darkReceiverColor,
      vMessageItemTheme: const VMessageItemTheme.dark(),
      senderTextStyle: _darkTextMeSenderColor,
      receiverTextStyle: _darkTextReceiverColor,
      messageSendingStatus: const VMsgStatusTheme.dark(),
      scaffoldDecoration: sMessageBackground(isDark: true),
      senderReplyColor: const Color(0xff003C34),
      receiverReplyColor: const Color(0xff28282A),
    );
  }

  factory VMessageTheme.lightWithRoomId(String roomId) {
    return VMessageTheme._(
      senderBubbleColor: _lightMySenderColor,
      vMessageItemTheme: const VMessageItemTheme.light(),
      receiverBubbleColor: _lightReceiverColor,
      senderTextStyle: _lightTextMeSenderColor,
      receiverTextStyle: _lightTextMeReceiverColor,
      messageSendingStatus: const VMsgStatusTheme.light(),
      scaffoldDecoration: sMessageBackground(isDark: false, roomId: roomId),
      senderReplyColor: const Color(0xffD7F2C9),
      receiverReplyColor: const Color(0xffF2F2F2),
    );
  }

  factory VMessageTheme.darkWithRoomId(String roomId) {
    return VMessageTheme._(
      senderBubbleColor: _darkMeSenderColor,
      receiverBubbleColor: _darkReceiverColor,
      vMessageItemTheme: const VMessageItemTheme.dark(),
      senderTextStyle: _darkTextMeSenderColor,
      receiverTextStyle: _darkTextReceiverColor,
      messageSendingStatus: const VMsgStatusTheme.dark(),
      scaffoldDecoration: sMessageBackground(isDark: true, roomId: roomId),
      senderReplyColor: const Color(0xff003C34),
      receiverReplyColor: const Color(0xff28282A),
    );
  }

  @override
  ThemeExtension<VMessageTheme> lerp(
      ThemeExtension<VMessageTheme>? other, double t) {
    if (other is! VMessageTheme) {
      return this;
    }
    return this;
  }

  @override
  VMessageTheme copyWith({
    Color? senderBubbleColor,
    Color? receiverBubbleColor,
    Color? senderReplyColor,
    Color? receiverReplyColor,
    VMessageItemTheme? vMessageItemTheme,
    VMsgStatusTheme? messageSendingStatus,
    BoxDecoration? scaffoldDecoration,
    CustomMessageItemTypeDef? customMessageItem,
    TextStyle? receiverTextStyle,
    TextStyle? senderTextStyle,
  }) {
    return VMessageTheme._(
      senderBubbleColor: senderBubbleColor ?? this.senderBubbleColor,
      vMessageItemTheme: vMessageItemTheme ?? this.vMessageItemTheme,
      senderReplyColor: senderReplyColor ?? this.senderReplyColor,
      receiverReplyColor: receiverReplyColor ?? this.receiverReplyColor,
      receiverBubbleColor: receiverBubbleColor ?? this.receiverBubbleColor,
      messageSendingStatus: messageSendingStatus ?? this.messageSendingStatus,
      scaffoldDecoration: scaffoldDecoration ?? this.scaffoldDecoration,
      customMessageItem: customMessageItem ?? this.customMessageItem,
      receiverTextStyle: receiverTextStyle ?? this.receiverTextStyle,
      senderTextStyle: senderTextStyle ?? this.senderTextStyle,
    );
  }
}

extension VMessageThemeNewExt on BuildContext {
  VMessageTheme get vMessageTheme {
    return Theme.of(this).extension<VMessageTheme>()!;
  }

  Color getMessageItemHolderColor(bool isSender, BuildContext context) {
    if (isSender) {
      return context.vMessageTheme.senderBubbleColor;
    } else {
      return context.vMessageTheme.receiverBubbleColor;
    }
  }
}
