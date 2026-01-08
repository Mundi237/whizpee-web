// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_chat_room_page/src/room/shared/shared.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../room_item_builder/chat_last_msg_time.dart';
import '../room_item_builder/chat_mute_widget.dart';
import '../room_item_builder/chat_title.dart';
import '../room_item_builder/chat_typing_widget.dart';
import '../room_item_builder/chat_un_read_counter.dart';
import '../room_item_builder/mention_icon_widget.dart';
import '../room_item_builder/room_item_msg.dart';
import 'message_status_icon.dart';

/// A widget representing an individual virtual room item.
/// /// This widget handles rendering the room information and can be configured
/// to either show only an icon representation of the room or include additional
/// information. /// /// Required fields:
/// * [room] – The virtual room object that this item represents.
/// * [onRoomItemPress] – Callback function that is triggered when this item is pressed.
/// * [onRoomItemLongPress] – Callback function that is triggered when this item is long pressed.
/// /// Optional fields:
/// * [isIconOnly] – Flag indicating whether to show only the icon representation of the room.
/// ///
/// Example usage:
/// /// dart /// VRoomItem( /// room: myVirtualRoom, /// isIconOnly: true, /// onRoomItemPress: (room) { /// // Handle press event /// }, /// onRoomItemLongPress: (room) { /// // Handle long press event /// }, /// ) ///
class VRoomItem extends StatefulWidget {
  /// The virtual room object that this item represents.
  final VRoom room;

  /// Flag indicating whether to show only the icon representation of the room.
  final bool isIconOnly;

  /// Callback function that is triggered when this item is pressed.

  /// Callback function that is triggered when this item is long pressed.
  final Function(VRoom room) onRoomItemPress;

  /// Callback function that is triggered when this item is long pressed.
  final Function(VRoom room) onRoomItemLongPress;
  final bool isSelected;

  /// Creates a new instance of [VRoomItem].
  const VRoomItem({
    required this.room,
    super.key,
    this.isSelected = false,
    required this.onRoomItemPress,
    this.isIconOnly = false,
    required this.onRoomItemLongPress,
  });

  @override
  State<VRoomItem> createState() => _VRoomItemState();
}

class _VRoomItemState extends State<VRoomItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.room.isDeleted) return const SizedBox.shrink();
    final theme = context.vRoomTheme;
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
        HapticFeedback.selectionClick();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onRoomItemPress(widget.room);
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        widget.onRoomItemLongPress(widget.room);
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 65,
          width: 65,
          alignment: AlignmentDirectional.topStart,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? theme.selectedRoomColor
                : _isPressed
                    ? Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.03)
                    : null,
            borderRadius: BorderRadius.circular(4),
          ),
          child: widget.isIconOnly
              ? theme.getChatAvatar(
                  imageUrl: widget.room.thumbImageS3,
                  chatTitle: widget.room.realTitle,
                  isOnline: widget.room.isOnline,
                  size: 60,
                )
              : Row(
                  children: [
                    theme.getChatAvatar(
                      imageUrl: widget.room.thumbImageS3,
                      chatTitle: widget.room.realTitle,
                      isOnline: widget.room.isOnline,
                      size: 60,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ///header and time
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: ChatTitle(title: widget.room.realTitle),
                              ),
                              ChatLastMsgTime(
                                yesterdayLabel: S.of(context).yesterday,
                                lastMessageTime: widget.room.lastMessageTime,
                              )
                            ],
                          ),
                          const SizedBox.shrink(),

                          ///message and icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_roomTypingText(widget.room.typingStatus) !=
                                  null)
                                ChatTypingWidget(
                                  text:
                                      _roomTypingText(widget.room.typingStatus)!,
                                )
                              else if (widget.room.lastMessage.isMeSender)

                                ///icon
                                Flexible(
                                  child: Row(
                                    children: [
                                      //status
                                      MessageStatusIcon(
                                        model: MessageStatusIconDataModel(
                                          isAllDeleted: widget.room.lastMessage
                                                  .allDeletedAt !=
                                              null,
                                          isSeen:
                                              widget.room.lastMessage.seenAt !=
                                                  null,
                                          isDeliver: widget.room.lastMessage
                                                  .deliveredAt !=
                                              null,
                                          emitStatus:
                                              widget.room.lastMessage.emitStatus,
                                          isMeSender:
                                              widget.room.lastMessage.isMeSender,
                                        ),
                                      ),
                                      //grey
                                      Flexible(
                                        child: RoomItemMsg(
                                          messageHasBeenDeletedLabel:
                                              S.of(context).messageHasBeenDeleted,
                                          message: widget.room.lastMessage,
                                          isBold: false,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              else if (widget.room.isRoomUnread)
                                //bold
                                Flexible(
                                  child: RoomItemMsg(
                                    isBold: true,
                                    message: widget.room.lastMessage,
                                    messageHasBeenDeletedLabel:
                                        S.of(context).messageHasBeenDeleted,
                                  ),
                                )
                              else
                                //normal gray
                                Flexible(
                                  child: RoomItemMsg(
                                    isBold: false,
                                    messageHasBeenDeletedLabel:
                                        S.of(context).messageHasBeenDeleted,
                                    message: widget.room.lastMessage,
                                  ),
                                ),
                              Row(
                                children: [
                                  Visibility(
                                    visible: widget.room.isRoomUnread,
                                    child: MentionIcon(
                                      mentionsCount: widget.room.mentionsCount,
                                      isMeSender:
                                          widget.room.lastMessage.isMeSender,
                                    ),
                                  ),
                                  ChatMuteWidget(isMuted: widget.room.isMuted),
                                  ChatUnReadWidget(
                                      unReadCount: widget.room.unReadCount),
                                  if (widget.room.isOneSeen)
                                    const Icon(
                                      CupertinoIcons.eye,
                                      size: 16,
                                    )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  String? _roomTypingText(VSocketRoomTypingModel value) {
    if (widget.room.roomType.isSingle) {
      return _inSingleText(value);
    }
    if (widget.room.roomType.isGroup) {
      return _inGroupText(value);
    }
    return null;
  }

  /// Returns a string representation of the typing status.
  String? _inSingleText(VSocketRoomTypingModel value) {
    return _statusInText(value);
  }

  /// Converts the typing status to a localized text.
  String? _statusInText(VSocketRoomTypingModel value) {
    switch (widget.room.typingStatus.status) {
      case VRoomTypingEnum.stop:
        return null;
      case VRoomTypingEnum.typing:
        return S
            .of(VChatController.I.navigatorKey.currentState!.context)
            .typing;
      case VRoomTypingEnum.recording:
        return S
            .of(VChatController.I.navigatorKey.currentState!.context)
            .recording;
    }
  }

  /// Returns a string representation of the typing status in a group.
  String? _inGroupText(VSocketRoomTypingModel value) {
    if (_statusInText(value) == null) return null;
    return "${value.userName} ${_statusInText(value)!}";
  }
}
