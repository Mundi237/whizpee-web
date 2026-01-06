// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_message_page/src/v_chat/platform_cache_image_widget.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../core/types.dart';

class ReplyItemWidget extends StatelessWidget {
  final VBaseMessage? rToMessage;
  final VMessageCallback? onHighlightMessage;
  final bool isMeSender;
  final String repliedToYourSelf;

  const ReplyItemWidget({
    super.key,
    required this.rToMessage,
    required this.onHighlightMessage,
    required this.isMeSender,
    required this.repliedToYourSelf,
  });

  @override
  Widget build(BuildContext context) {
    if (rToMessage == null) {
      return const SizedBox.shrink();
    }
    final method =
        context.vMessageTheme.vMessageItemTheme.replyMessageItemBuilder;
    if (method != null) {
      return method(context, isMeSender, rToMessage!);
    }

    return InkWell(
      onLongPress: null,
      onTap: onHighlightMessage == null
          ? null
          : () => onHighlightMessage!(rToMessage!),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300, minWidth: 150),
        decoration: BoxDecoration(
          color: isMeSender
              ? context.vMessageTheme.senderReplyColor
              : context.vMessageTheme.receiverReplyColor,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VerticalDivider(
                  color: isMeSender ? Colors.green : Colors.red,
                  thickness: 3,
                  width: 2,
                  indent: 2,
                ),
                const SizedBox(
                  width: 11,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getTitle(context).text.color(Colors.red),
                      const SizedBox(
                        height: 4,
                      ),
                      rToMessage!.realContentMentionParsedWithAt.text
                          .maxLine(2)
                          .size(12).color(Colors.grey)
                          .light
                          .overflowEllipsis,
                    ],
                  ),
                ),
                _getImage()
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getTitle(BuildContext context) {
    if (rToMessage!.isMeSender && isMeSender) {
      return repliedToYourSelf;
    }
    return rToMessage!.senderName;
  }

  Widget _getImage() {
    if (rToMessage! is VImageMessage) {
      final msg = rToMessage! as VImageMessage;
      return VPlatformCacheImageWidget(
        source: msg.data.fileSource,
        borderRadius: BorderRadius.circular(9),
        size: const Size(40, 40),
      );
    }
    return const SizedBox.shrink();
  }
}
