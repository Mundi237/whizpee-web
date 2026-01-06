// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_message_page/src/page/message_pages/pages/single/single_app_bar_controller.dart';
import 'package:v_chat_message_page/src/page/message_pages/pages/single/v_single_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../../v_chat_message_page.dart';
import '../../../../v_chat/v_socket_status_widget.dart';
import '../../../../widgets/app_bare/v_message_app_bare.dart';
import '../../controllers/v_message_item_controller.dart';
import '../../providers/message_provider.dart';
import '../../states/input_state_controller.dart';
import '../../widget_states/input_widget_state.dart';

class VSingleView extends StatefulWidget {
  const VSingleView({
    super.key,
    required this.vRoom,
    required this.vMessageConfig,
    required this.language,
  });

  final VRoom vRoom;
  final VMessageConfig vMessageConfig;
  final VMessageLocalization language;

  @override
  State<VSingleView> createState() => _VSingleViewState();
}

class _VSingleViewState extends State<VSingleView> {
  late final VSingleController controller;
  StreamSubscription? _wallpaperSub;

  @override
  void initState() {
    super.initState();
    final provider = MessageProvider();
    controller = VSingleController(
      vRoom: widget.vRoom,
      language: widget.language,
      vMessageConfig: widget.vMessageConfig,
      singleAppBarController: SingleAppBarController(
        vRoom: widget.vRoom,
        messageProvider: provider,
      ),
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
    controller.close();
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
          child: ValueListenableBuilder<SingleAppBarStateModel>(
            valueListenable: controller.singleAppBarController,
            builder: (_, value, __) {
              if (value.isSearching) {
                //handle the search
                return VSearchAppBare(
                  onClose: controller.onCloseSearch,
                  onSearch: controller.onSearch,
                  searchLabel: widget.language.search,
                );
              }
              return VMessageAppBare(
                isCallAllowed: _getIsCallAllowed(),
                room: widget.vRoom,
                inTypingText: (context) => _inSingleText(value.typingModel),
                lastSeenAt: value.lastSeenAt,
                onUpdateBlock: controller.onUpdateBlock,
                onCreateCall: controller.onCreateCall,
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

  String? _inSingleText(VSocketRoomTypingModel value) {
    return _statusInText(value);
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



  bool _getIsCallAllowed() {
    bool isCallsAllowed = widget.vMessageConfig.isCallsAllowed;
    if (!isCallsAllowed) return false;
    if (widget.vRoom.peerPrivacy == null) return true;
    return widget.vRoom.peerPrivacy!.acceptCalls;
  }
}
