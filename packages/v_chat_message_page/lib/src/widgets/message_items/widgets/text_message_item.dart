// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class TextMessageItem extends StatelessWidget {
  final String message;
  final TextStyle textStyle;
  final Function(String email) onEmailPress;
  final Function(BuildContext context, String userId) onMentionPress;
  final Function(String phone) onPhonePress;
  final Function(String link) onLinkPress;

  const TextMessageItem({
    super.key,
    required this.message,
    required this.textStyle,
    required this.onEmailPress,
    required this.onMentionPress,
    required this.onPhonePress,
    required this.onLinkPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: VTextParserWidget(
        text: message,
        textStyle: textStyle,
        enableTabs: true,
        mentionTextStyle: const TextStyle(color: Colors.blue),
        onEmailPress: onEmailPress,
        onLinkPress: onLinkPress,
        onPhonePress: onPhonePress,
        onMentionPress: (userId) => onMentionPress(context, userId),
      ),
    );
  }
}
