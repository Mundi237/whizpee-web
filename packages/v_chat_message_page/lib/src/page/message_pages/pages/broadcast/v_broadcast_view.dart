// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_message_page/src/page/message_pages/pages/broadcast/broadcast_app_bar_controller.dart';
import 'package:v_chat_message_page/src/page/message_pages/pages/broadcast/v_broadcast_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../../v_chat_message_page.dart';
import '../../../../v_chat/v_socket_status_widget.dart';
import '../../../../widgets/app_bare/v_message_app_bare.dart';
import '../../controllers/v_message_item_controller.dart';
import '../../providers/message_provider.dart';
import '../../states/input_state_controller.dart';
import '../../widget_states/input_widget_state.dart';

class VBroadcastView extends StatefulWidget {
  const VBroadcastView({
    super.key,
    required this.vRoom,
    required this.vMessageConfig,
    required this.language,
  });
  final VRoom vRoom;
  final VMessageConfig vMessageConfig;
  final VMessageLocalization language;

  @override
  State<VBroadcastView> createState() => _VBroadcastViewState();
}

class _VBroadcastViewState extends State<VBroadcastView> {
  late final VBroadcastController controller;

  @override
  void initState() {
    super.initState();
    final provider = MessageProvider();
    controller = VBroadcastController(
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
      broadcastAppBarController: BroadcastAppBarController(
        messageProvider: provider,
        vRoom: widget.vRoom,
      ),
    );
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
          child: ValueListenableBuilder<BroadcastAppBarStateModel>(
            valueListenable: controller.broadcastAppBarController,
            builder: (_, value, __) {
              if (value.isSearching) {
                return VSearchAppBare(
                  onClose: controller.onCloseSearch,
                  onSearch: controller.onSearch,
                  searchLabel: widget.language.search,
                );
              }
              return VMessageAppBare(
                isCallAllowed: false,
                language: widget.language,
                memberCount: value.members,
                room: widget.vRoom,
                inTypingText: (context) {
                  return null;
                },
                // onViewMedia: () => controller.onViewMedia(context, value.roomId),
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

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }
}
