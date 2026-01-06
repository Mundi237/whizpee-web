// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
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
class VRoomItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (room.isDeleted) return const SizedBox.shrink();
    final theme = context.vRoomTheme;
    return GestureDetector(
      onTap: () {
        onRoomItemPress(room);
      },
      onLongPress: () {
        onRoomItemLongPress(room);
      },
      child: Container(
        height: 65,
        width: 65,
        alignment: AlignmentDirectional.topStart,
        decoration: BoxDecoration(
          color: isSelected ? theme.selectedRoomColor : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: isIconOnly
            ? theme.getChatAvatar(
                imageUrl: room.thumbImageS3,
                chatTitle: room.realTitle,
                isOnline: room.isOnline,
                size: 60,
              )
            : Row(
                children: [
                  theme.getChatAvatar(
                    imageUrl: room.thumbImageS3,
                    chatTitle: room.realTitle,
                    isOnline: room.isOnline,
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
                              child: ChatTitle(title: room.realTitle),
                            ),
                            ChatLastMsgTime(
                              yesterdayLabel: S.of(context).yesterday,
                              lastMessageTime: room.lastMessageTime,
                            )
                          ],
                        ),
                        const SizedBox.shrink(),

                        ///message and icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_roomTypingText(room.typingStatus) != null)
                              ChatTypingWidget(
                                text: _roomTypingText(room.typingStatus)!,
                              )
                            else if (room.lastMessage.isMeSender)

                              ///icon
                              Flexible(
                                child: Row(
                                  children: [
                                    //status
                                    MessageStatusIcon(
                                      model: MessageStatusIconDataModel(
                                        isAllDeleted:
                                            room.lastMessage.allDeletedAt !=
                                                null,
                                        isSeen: room.lastMessage.seenAt != null,
                                        isDeliver:
                                            room.lastMessage.deliveredAt !=
                                                null,
                                        emitStatus: room.lastMessage.emitStatus,
                                        isMeSender: room.lastMessage.isMeSender,
                                      ),
                                    ),
                                    //grey
                                    Flexible(
                                      child: RoomItemMsg(
                                        messageHasBeenDeletedLabel:
                                            S.of(context).messageHasBeenDeleted,
                                        message: room.lastMessage,
                                        isBold: false,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            else if (room.isRoomUnread)
                              //bold
                              Flexible(
                                child: RoomItemMsg(
                                  isBold: true,
                                  message: room.lastMessage,
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
                                  message: room.lastMessage,
                                ),
                              ),
                            Row(
                              children: [
                                Visibility(
                                  visible: room.isRoomUnread,
                                  child: MentionIcon(
                                    mentionsCount: room.mentionsCount,
                                    isMeSender: room.lastMessage.isMeSender,
                                  ),
                                ),
                                ChatMuteWidget(isMuted: room.isMuted),
                                ChatUnReadWidget(unReadCount: room.unReadCount),
                                if (room.isOneSeen)
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
    );
  }

  String? _roomTypingText(VSocketRoomTypingModel value) {
    if (room.roomType.isSingle) {
      return _inSingleText(value);
    }
    if (room.roomType.isGroup) {
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
    switch (room.typingStatus.status) {
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
