// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_message_page/src/page/message_pages/pages/group/group_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../../v_chat_message_page.dart';
import '../../../../v_chat/v_socket_status_widget.dart';
import '../../../../widgets/app_bare/v_message_app_bare.dart';
import '../../controllers/v_message_item_controller.dart';
import '../../providers/message_provider.dart';
import '../../states/input_state_controller.dart';
import '../../widget_states/input_widget_state.dart';
import 'group_app_bar_controller.dart';

class VGroupView extends StatefulWidget {
  const VGroupView({
    super.key,
    required this.vRoom,
    required this.language,
    required this.vMessageConfig,
  });
  final VRoom vRoom;
  final VMessageConfig vMessageConfig;
  final VMessageLocalization language;

  @override
  State<VGroupView> createState() => _VGroupViewState();
}

class _VGroupViewState extends State<VGroupView> {
  late final VGroupController controller;
  StreamSubscription? _wallpaperSub;

  @override
  void initState() {
    super.initState();
    final provider = MessageProvider();
    controller = VGroupController(
      vRoom: widget.vRoom,
      vMessageConfig: widget.vMessageConfig,
      messageProvider: provider,
      scrollController: AutoScrollController(
        axis: Axis.vertical,
        suggestedRowHeight: 200,
      ),
      inputStateController: InputStateController(widget.vRoom),
      itemController: VMessageItemController(
        messageProvider: provider,
        context: context,
        vMessageConfig: widget.vMessageConfig,
      ),
      groupAppBarController: GroupAppBarController(
        messageProvider: provider,
        vRoom: widget.vRoom,
      ),
    );
    _wallpaperSub = VEventBusSingleton.vEventBus
        .on<VUpdateRoomWallpaperEvent>()
        .where((e) => e.roomId == widget.vRoom.id)
        .listen((event) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    controller.close();
    _wallpaperSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final roomSpecificTheme = isDark 
        ? VMessageTheme.darkWithRoomId(widget.vRoom.id)
        : VMessageTheme.lightWithRoomId(widget.vRoom.id);
    
    return Container(
      decoration: roomSpecificTheme.scaffoldDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: ObstructingBarWrapper(
          child: ValueListenableBuilder<GroupAppBarStateModel>(
            valueListenable: controller.groupAppBarController,
            builder: (_, value, __) {
              if (value.isSearching) {
                return VSearchAppBare(
                  onClose: controller.onCloseSearch,
                  onSearch: controller.onSearch,
                  searchLabel: widget.language.search,
                );
              }
              return VMessageAppBare(
                room: widget.vRoom,
                isCallAllowed: widget.vMessageConfig.isCallsAllowed,
                memberCount: value.myGroupInfo.membersCount,
                onCreateCall: (isVideo) {
                  controller.onCreateCall(context, isVideo);
                },
                totalOnline: value.myGroupInfo.totalOnline,
                inTypingText: (context) => _inGroupText(value.typingModel),
                language: widget.language,
                onTitlePress: controller.onTitlePress,
              );
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.vMessageConfig.showDisconnectedWidget)
                VSocketStatusWidget(
                  connectingLabel: widget.language.connecting,
                  delay: Duration.zero,
                ),
              AdsBannerWidget(
                isEnableAds: widget.vMessageConfig.isEnableAds,
                adsId: VPlatforms.isAndroid
                    ? SConstants.androidBannerAdsUnitId
                    : SConstants.iosBannerAdsUnitId,
              ),
              Expanded(
                child: MessageBodyStateWidget(
                  language: widget.language,
                  controller: controller,
                  roomType: widget.vRoom.roomType,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              InputWidgetState(
                controller: controller,
                language: widget.language,
                isAllowSendMedia: widget.vMessageConfig.isSendMediaAllowed,
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Returns a string representation of the typing status in a group.
  String? _inGroupText(VSocketRoomTypingModel value) {
    if (_statusInText(value) == null) return null;
    return "${value.userName} ${_statusInText(value)!}";
  }

  /// Converts the typing status to a localized text.
  String? _statusInText(VSocketRoomTypingModel value) {
    switch (value.status) {
      case VRoomTypingEnum.stop:
        return null;
      case VRoomTypingEnum.typing:
        return widget.language.typing;
      case VRoomTypingEnum.recording:
        return widget.language.recording;
    }
  }
}
