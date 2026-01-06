// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_message_page/src/core/core.dart';
import 'package:v_chat_message_page/src/page/message_pages/controllers/v_base_message_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../widgets/arrow_down.dart';
import '../../../widgets/drag_drop_if_web_desk.dart';
import '../../../widgets/message_items/v_message_item.dart';
import '../../../widgets/message_items/widgets/date_divider_item.dart';

class MessageBodyStateWidget extends StatelessWidget {
  final VBaseMessageController controller;
  final VRoomType roomType;
  final VMessageLocalization language;

  const MessageBodyStateWidget({
    super.key,
    required this.controller,
    required this.roomType,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DragDropIfWeb(
          onDragDone: (files) => controller.onSubmitMedia(context, files),
          child: ValueListenableBuilder<List<VBaseMessage>>(
            valueListenable: controller,
            builder: (_, value, __) {
              return Scrollbar(
                interactive: true,
                thickness: 5,
                controller: controller.scrollController,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: VPlatforms.isWeb ? 10 : 6,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  controller: controller.scrollController,
                  cacheExtent: 300,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Builder(
                      key: UniqueKey(),
                      builder: (context) {
                        final message = value[index];
                        final msgItem = StreamBuilder<VBaseMessage>(
                          stream: controller.messageStateStream.stream.where(
                            (e) => e.localId == message.localId,
                          ),
                          initialData: message,
                          builder: (context, snapshot) {
                            if (message.isDeleted) {
                              return const SizedBox.shrink();
                            }
                            return AutoScrollTag(
                              key: UniqueKey(),
                              controller: controller.scrollController,
                              index: index,
                              highlightColor: context.isDark
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.black.withValues(alpha: 0.2),
                              child: VMessageItem(
                                language: language,
                                roomType: roomType,
                                onLongTap: (message) =>
                                    controller.onMessageLongTap(context, message),
                                message: snapshot.data!,
                                onReactionSelected: (m, emoji) {
                                  print("emojiemoji $emoji");
                                  if (controller.vMessageConfig.onMessageReactionSelected != null) {
                                    controller.vMessageConfig.onMessageReactionSelected!(m, emoji);
                                  } else {
                                    controller.handleMessageReaction(m, emoji);
                                  }
                                },
                                voiceController: (message) {
                                  if (message is VVoiceMessage) {
                                    return controller.voiceControllers.getVoiceController(message);
                                  }
                                  return null;
                                },
                                onSwipe: controller.setReply,
                                onHighlightMessage: controller.onHighlightMessage,
                                onReSend: controller.onReSend,
                              ),
                            );
                          },
                        );

                        final isTopMessage = _isTopMessage(value.length, index);
                        final dividerDate = _getDateDiff(
                          bigDate: message.createdAtDate,
                          smallDate: isTopMessage
                              ? value[index].createdAtDate
                              : value[index + 1].createdAtDate,
                        );
                        if (dividerDate != null || isTopMessage) {
                          //set date divider
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              DateDividerItem(
                                dateTime: dividerDate ?? message.createdAtDate,
                                today: language.today,
                                yesterday: language.yesterday,
                              ),
                              msgItem,
                            ],
                          );
                        }
                        return msgItem;
                      },
                    );
                  },
                  itemCount: value.length,
                  reverse: true,
                ),
              );
            },
          ),
        ),
        PositionedDirectional(
          bottom: 10,
          end: 0,
          child: ListViewArrowDown(
            scrollController: controller.scrollController,
            onPress: controller.scrollDown,
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(),
        ),
      ],
    );
  }

  bool _isTopMessage(int listLength, int index) {
    return listLength - 1 == index;
  }

  DateTime? _getDateDiff({
    required DateTime bigDate,
    required DateTime smallDate,
  }) {
    final difference = bigDate.difference(smallDate);
    if (difference.isNegative) {
      return null;
    }
    if (difference.inHours < 24) {
      final d1 = bigDate.day;
      final d2 = smallDate.day;
      if (d1 == d2) {
        return null;
      } else {
        return bigDate;
      }
    }
    return bigDate;
  }
}
