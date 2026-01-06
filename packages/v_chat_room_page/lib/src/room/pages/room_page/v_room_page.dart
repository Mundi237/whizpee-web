// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

library v_room_page;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_room_page/src/room/pages/room_page/room_provider.dart';
import 'package:v_chat_room_page/src/room/pages/room_page/states/room_state_controller.dart';
import 'package:v_chat_room_page/src/room/room.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../shared/stream_mixin.dart';
import 'room_item_controller.dart';

part './v_room_controller.dart';

/// A [StatefulWidget] that represents a page for displaying and managing video chat rooms.
/// /// The [VChatPage] requires a [VRoomController] instance to manage and display rooms.
/// The controller is passed in through the [controller] parameter.
/// /// The [onRoomItemPress] parameter is an optional callback that is called when a room item is pressed.
/// The callback provides a [VRoom] instance representing the room that was pressed.
/// /// The [showDisconnectedWidget] parameter determines whether to show a widget when the user is disconnected from the server.
/// If set to true (which is the default), a [VDisconnectedWidget] will be displayed. Otherwise, nothing will be displayed.
/// /// The [useIconForRoomItem] parameter is an optional parameter that, if set to true, will cause the room list items to display an icon instead of a thumbnail image.
/// /// The [appBar] and [floatingActionButton] parameters are optional, and allow customization of the app bar and action button displayed on the page
class VChatPage extends StatefulWidget {
  const VChatPage({
    super.key,
    required this.controller,
    required this.onCreateNewBroadcast,
    required this.onCreateNewGroup,
    this.appBar,
    required this.language,
    required this.onSearchClicked,
    this.onRoomItemPress,
    this.showDisconnectedWidget = true,
    this.useIconForRoomItem = false,
  });

  final VRoomController controller;
  final Function(VRoom room)? onRoomItemPress;
  final bool showDisconnectedWidget;
  final Widget? appBar;
  final VRoomLanguage language;
  final bool useIconForRoomItem;
  final GestureTapCallback? onCreateNewGroup;
  final GestureTapCallback onSearchClicked;
  final GestureTapCallback? onCreateNewBroadcast;

  @override
  State<VChatPage> createState() => _VChatPageState();
}

class _VChatPageState extends State<VChatPage> {
  @override
  void initState() {
    super.initState();
    widget.controller._init(context, widget.language);
  }

  String tab = "All";
  List<String> tabs = [
    'All',
    "CTA",
    "Groups",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ValueListenableBuilder<VPaginationModel<VRoom>>(
        valueListenable: widget.controller._roomState,
        builder: (_, value, __) {
          return LoadMore(
            onLoadMore: widget.controller._onLoadMore,
            isFinish: widget.controller._getIsFinishLoadMore,
            textBuilder: (status) {
              return "";
            },
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: CustomScrollView(
                cacheExtent: 300,
                slivers: <Widget>[
                  widget.useIconForRoomItem
                      ? SliverList.list(
                          children: const [],
                        )
                      : SliverList.list(
                          children: [
                            widget.appBar ?? Container(),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: widget.onSearchClicked,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: context.isDark
                                            ? CupertinoColors.secondaryLabel
                                            : CupertinoColors.systemGrey5,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(7),
                                      margin: EdgeInsets.zero,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            CupertinoIcons.search,
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            S.of(context).search,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  minSize: 0,
                                  onPressed: () {
                                    widget.controller.sortRoomsByUnReadCount();
                                  },
                                  child: Icon(
                                    CupertinoIcons.line_horizontal_3_decrease,
                                    size: 22,
                                    color: widget.controller.isSortByUnreadCount
                                        ? Colors.green
                                        : context.isDark
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: widget.onCreateNewGroup,
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                      const EdgeInsets.symmetric(
                                        horizontal: 0,
                                        vertical: 5,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    S.of(context).newGroup,
                                    style: CupertinoTheme.of(context)
                                        .textTheme
                                        .textStyle
                                        .copyWith(
                                          color: widget.onCreateNewGroup == null
                                              ? Colors.grey
                                              : Colors.blue,
                                        ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: widget.onCreateNewBroadcast,
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                      const EdgeInsets.symmetric(
                                        horizontal: 0,
                                        vertical: 5,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    S.of(context).newBroadcast,
                                    style: CupertinoTheme.of(context)
                                        .textTheme
                                        .textStyle
                                        .copyWith(
                                          color: widget.onCreateNewBroadcast ==
                                                  null
                                              ? Colors.grey
                                              : Colors.blue,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ...tabs.map(
                                  (tab) => InkWell(
                                    onTap: () {
                                      setState(() {
                                        this.tab = tab;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 700),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 20),
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: this.tab == tab
                                            ? Colors.grey.shade600
                                            : Colors.grey.shade900,
                                      ),
                                      child: Text(
                                        tab,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                  SliverList.separated(
                    itemBuilder: (context, index) {
                      final room = value.data[index];

                      return StreamBuilder<VRoom>(
                        key: UniqueKey(),
                        stream: widget
                            .controller._roomState.roomStateStream.stream
                            .where((e) => e.id == room.id),
                        initialData: room,
                        builder: (context, snapshot) {
                          final vRommWidget = VRoomItem(
                            isIconOnly: widget.useIconForRoomItem,
                            isSelected: snapshot.data!.id ==
                                widget.controller.selectedRoomId,
                            room: snapshot.data!,
                            onRoomItemLongPress: (room) => widget.controller
                                ._onRoomItemLongPress(room, context),
                            onRoomItemPress: (room) {
                              if (widget.onRoomItemPress == null) {
                                widget.controller
                                    ._onRoomItemPress(room, context);
                              } else {
                                widget.onRoomItemPress!(room);
                              }
                            },
                          );

                          if (room.isCta && tab == "CTA") {
                            return vRommWidget;
                          }
                          if (!room.isCta && tab == "CTA") {
                            return const SizedBox.shrink();
                          }
                          if (!room.isCta && tab != "CTA") {
                            return vRommWidget;
                          }
                          return const SizedBox.shrink();
                        },
                      );
                    },
                    itemCount: value.data.length,
                    separatorBuilder: (context, index) {
                      final room = value.data[index];
                      if (room.isDeleted) return const SizedBox.shrink();
                      return Divider(
                        thickness: .7,
                        color: Colors.transparent,
                        height: 15,
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
