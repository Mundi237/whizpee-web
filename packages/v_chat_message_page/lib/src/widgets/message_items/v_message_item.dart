// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/bubble/swipe_to_reply.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/center_item_holder.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/forward_item_widget.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/message_broadcast_icon.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/message_time_widget.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/reply_item_widget.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/star_item_widget.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/all_deleted_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/call_message_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/location_message_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/one_seen_widget.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/text_message_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/voice_message_item.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../core/types.dart';
import '../../v_chat/v_message_constants.dart';
import '../../controllers/reaction_controller.dart';
import 'shared/message_reactions_bar.dart';
import 'shared/reactions/emoji_reaction_overlay.dart';

class VMessageItem extends StatelessWidget {
  final VBaseMessage message;
  final VMessageCallback? onSwipe;

  final VMessageCallback? onLongTap;
  final VVoiceMessageController? Function(VBaseMessage message)? voiceController;
  final VMessageCallback? onHighlightMessage;
  final VMessageCallback? onReSend;
  final VRoomType roomType;
  final VMessageLocalization language;
  final bool forceSeen;
  final void Function(VBaseMessage, String)? onReactionSelected;

  const VMessageItem({
    super.key,
    this.onLongTap,
    required this.roomType,
    this.voiceController,
    required this.message,
    required this.language,
    this.onSwipe,
    this.forceSeen = false,
    this.onReSend,
    this.onHighlightMessage,
    this.onReactionSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (message.messageType.isCenter) {
      return CenterItemHolder(
        child: VMessageConstants.getMessageBody(message, language.vMessagesInfoTrans)
            .text
            .italic
            .medium,
      );
    }
    final width = MediaQuery.of(context).size.width;
    final maxWidth = VPlatforms.isMobile
        ? width * .75
        : width <= 600
            ? width * .75
            : width * .40;
    return GestureDetector(
      onLongPress: () {
        // Haptic feedback for better UX
        HapticFeedback.selectionClick();
        onLongTap?.call(message);
        // Show emoji reaction overlay first if reactions are supported
        // if (onReactionSelected != null) {
        //   final renderBox = context.findRenderObject() as RenderBox?;
        //   if (renderBox != null) {
        //     final rect = renderBox.localToGlobal(Offset.zero) & renderBox.size;
        //     EmojiReactionOverlay.show(
        //       context: context,
        //       targetRect: rect,
        //       currentUserEmoji: message.currentUserEmoji,
        //       onSelected: (emoji) async {
        //         try {
        //           await ReactionController.toggleReaction(message, emoji);
        //           onReactionSelected?.call(message, emoji);
        //         } catch (e) {
        //           // Handle error - could show snackbar
        //           ScaffoldMessenger.of(context).showSnackBar(
        //             SnackBar(content: Text('Failed to react: ${e.toString()}')),
        //           );
        //         }
        //       },
        //       onMore: () {
        //         onLongTap?.call(message);
        //       },
        //     );
        //   }
        // } else {
        //   // Fallback to regular long tap
        //   onLongTap?.call(message);
        // }
      },
      child: SwipeToReply(
        key: UniqueKey(),
        onRightSwipe: message.canNotSwipe
            ? null
            : () {
                onSwipe?.call(message);
              },
        child: Row(
          mainAxisAlignment: message.isMeSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _getGroupUserAvatar(context),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    message.isMeSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                    decoration: BoxDecoration(
                      color: message.isMeSender
                          ? context.vMessageTheme.senderBubbleColor
                          : context.vMessageTheme.receiverBubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(8),
                        topRight: const Radius.circular(8),
                        bottomLeft: Radius.circular(message.isMeSender ? 8 : 0),
                        bottomRight: Radius.circular(message.isMeSender ? 0 : 8),
                      ),
                    ),
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _getGroupUserTitle(context),

                          ///Reply
                          ReplyItemWidget(
                            rToMessage: message.isAllDeleted ? null : message.replyTo,
                            onHighlightMessage: onHighlightMessage,
                            isMeSender: message.isMeSender,
                            repliedToYourSelf: language.repliedToYourSelf,
                          ),

                          ///Link
                          LinkViewerWidget(
                            data: message.linkAtt,
                            isMeSender: message.isMeSender,
                          ),

                          ///real message
                          _getChild(context),

                          ///attachment
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // Spread out the elements
                            children: [
                              if (message.isMeSender) const Spacer(),
                              if (message.isMeSender) ..._getMessageActions,
                              if (!message.isMeSender) const Spacer(),
                              if (!message.isMeSender) ..._getMessageActions,
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Reactions bar positioned below bubble
                  if (message.reactionNumber > 0)
                    Padding(
                      padding: EdgeInsets.only(
                        top: 4,
                        left: message.isMeSender ? 0 : 8,
                        right: message.isMeSender ? 8 : 0,
                      ),
                      child: MessageReactionsBar(
                        reactionNumber: message.reactionNumber,
                        reactionSample: message.reactionSample,
                        isMeSender: message.isMeSender,
                        onTap: () {
                          // Show emoji reaction overlay for quick reaction toggle
                          if (onReactionSelected != null) {
                            final renderBox = context.findRenderObject() as RenderBox?;
                            if (renderBox != null) {
                              final rect = renderBox.localToGlobal(Offset.zero) & renderBox.size;
                              EmojiReactionOverlay.show(
                                context: context,
                                targetRect: rect,
                                currentUserEmoji: message.currentUserEmoji,
                                emojis: message.reactionSample.map((e) => e.emoji).toList(),
                                onSelected: (emoji) async {
                                  try {
                                    await ReactionController.toggleReaction(message, emoji);
                                    onReactionSelected?.call(message, emoji);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to react: ${e.toString()}')),
                                    );
                                  }
                                },
                                onMore: () {
                                  // Could show detailed reactions modal here
                                  onLongTap?.call(message);
                                },
                              );
                            }
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get _getMessageActions {
    return [
      MessageTimeWidget(
        dateTime: message.createdAtDate,
      ),
      const SizedBox(
        width: 3,
      ),
      StarItemWidget(
        isStar: message.isStared,
      ),
      const SizedBox(
        width: 1,
      ),
      MessageBroadcastWidget(
        isFromBroadcast: message.isFromBroadcast,
      ),
      const SizedBox(
        width: 1,
      ),
      ForwardItemWidget(
        isFroward: message.isForward,
      ),
      const SizedBox(
        width: 1,
      ),
      if (message.isOneSeen)
        const Icon(
          CupertinoIcons.eye_fill,
          size: 16,
        ),
      const SizedBox(
        width: 3,
      ),
      MessageStatusIcon(
        model: MessageStatusIconDataModel(
          isSeen: message.seenAt != null,
          isDeliver: message.deliveredAt != null,
          emitStatus: message.emitStatus,
          isMeSender: message.isMeSender,
        ),
        onReSend: () {
          onReSend?.call(message);
        },
      ),
      const SizedBox(
        width: 1,
      ),
    ];
  }

  Widget _getChild(BuildContext context) {
    if (message.allDeletedAt != null) {
      return AllDeletedItem(
        message: message,
        messageHasBeenDeletedLabel: language.messageHasBeenDeleted,
      );
    }
    if (!forceSeen) {
      if (message.isOneSeenByMe) {
        return const OneSeenWidget();
      }
      if (message.isOneSeen && !message.isMeSender && !message.isOneSeenByMe) {
        return ClickToSeenWidget(
          message: message,
          language: language,
        );
      }
    }

    switch (message.messageType) {
      case VMessageType.reaction:
        return SizedBox();
      case VMessageType.text:
        // Handle VEmptyMessage case - don't cast if it's empty message
        if (message is VEmptyMessage) {
          return TextMessageItem(
            message: message.realContent,
            textStyle: message.isMeSender
                ? context.vMessageTheme.senderTextStyle
                : context.vMessageTheme.receiverTextStyle,
            onLinkPress: (link) async {
              await VStringUtils.lunchLink(link);
            },
            onEmailPress: (email) async {
              await VStringUtils.lunchEmail(email);
            },
            onMentionPress: _onMentionPress,
            onPhonePress: (phone) async {
              await VStringUtils.lunchLink(phone);
            },
          );
        }
        // Safe cast only if it's actually a VTextMessage
        if (message is VTextMessage) {
          return TextMessageItem(
            message: message.realContent,
            textStyle: message.isMeSender
                ? context.vMessageTheme.senderTextStyle
                : context.vMessageTheme.receiverTextStyle,
            onLinkPress: (link) async {
              await VStringUtils.lunchLink(link);
            },
            onEmailPress: (email) async {
              await VStringUtils.lunchEmail(email);
            },
            onMentionPress: _onMentionPress,
            onPhonePress: (phone) async {
              await VStringUtils.lunchLink(phone);
            },
          );
        }
        // Fallback for any other text message types
        return TextMessageItem(
          message: message.realContent,
          textStyle: message.isMeSender
              ? context.vMessageTheme.senderTextStyle
              : context.vMessageTheme.receiverTextStyle,
          onLinkPress: (link) async {
            await VStringUtils.lunchLink(link);
          },
          onEmailPress: (email) async {
            await VStringUtils.lunchEmail(email);
          },
          onMentionPress: _onMentionPress,
          onPhonePress: (phone) async {
            await VStringUtils.lunchLink(phone);
          },
        );

      case VMessageType.image:
        if (message is VImageMessage) {
          return ImageMessageItem(
            message: message as VImageMessage,
            fit: BoxFit.cover,
          );
        }
        return const SizedBox();
      case VMessageType.file:
        if (message is VFileMessage) {
          return FileMessageItem(
            message: message as VFileMessage,
          );
        }
        return const SizedBox();
      case VMessageType.video:
        if (message is VVideoMessage) {
          return VideoMessageItem(
            message: message as VVideoMessage,
          );
        }
        return const SizedBox();
      case VMessageType.voice:
        if (message is VVoiceMessage) {
          return VoiceMessageItem(
            message: message as VVoiceMessage,
            voiceController: voiceController!,
          );
        }
        return const SizedBox();
      case VMessageType.location:
        if (message is VLocationMessage) {
          return LocationMessageItem(
            message: message as VLocationMessage,
          );
        }
        return const SizedBox();

      case VMessageType.call:
        if (message is VCallMessage) {
          final callMessage = message as VCallMessage;
          return CallMessageItem(
            message: callMessage,
            audioCallLabel: language.audioCall,
            callStatusLabel: language.transCallStatus(callMessage.data.callStatus),
          );
        }
        return const SizedBox();
      case VMessageType.custom:
        if (message is VCustomMessage) {
          final customMessage = message as VCustomMessage;
          return context.vMessageTheme.customMessageItem?.call(
                context,
                message.isMeSender,
                customMessage.data.data,
              ) ??
              const Text(
                "custom message not implemented you need to add this data inside VInheritedMessageTheme which should be at the top of your app material widget",
              );
        }
        return const SizedBox();

      case VMessageType.info:
        throw "MessageType.info should not render her it center render!";
      case VMessageType.bug:
        return const SizedBox.shrink();
    }
  }

  void _onMentionPress(BuildContext context, String peerId) {
    final method = VChatController.I.vNavigator.messageNavigator.toUserProfilePage;
    if (method != null) {
      method(context, peerId);
    }
  }

  Widget _getGroupUserAvatar(BuildContext context) {
    if (roomType.isGroup && !message.isMeSender) {
      return GestureDetector(
        onTap: () {
          _onMentionPress(context, message.senderId);
        },
        child: Row(
          children: [
            VCircleAvatar(
              vFileSource: VPlatformFile.fromUrl(networkUrl: message.senderImageThumb),
              radius: 14,
            ),
            const SizedBox(
              width: 5,
            )
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _getGroupUserTitle(BuildContext context) {
    if (roomType.isGroup && !message.isMeSender) {
      return GestureDetector(
        onTap: () {
          _onMentionPress(context, message.senderId);
        },
        child: message.senderName.text.color(Colors.grey).size(13),
      );
    }
    return const SizedBox.shrink();
  }
}
