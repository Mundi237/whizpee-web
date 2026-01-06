// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/core/app_config/app_config_controller.dart';
import 'package:super_up/v_chat_v2/translations.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';
import '../controllers/rooms_tab_controller.dart';

class RoomsTabView extends StatefulWidget {
  const RoomsTabView({super.key});

  @override
  State<RoomsTabView> createState() => _RoomsTabViewState();
}

class _RoomsTabViewState extends State<RoomsTabView> {
  late final RoomsTabController controller;
  final config = VAppConfigController.appConfig;

  @override
  void initState() {
    super.initState();
    controller = GetIt.I.get<RoomsTabController>();
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              padding: const EdgeInsetsDirectional.only(start: 7, end: 12),
              largeTitle: Text(
                S.of(context).chats,
              ),
              trailing: CupertinoButton(
                onPressed: () => controller.onCameraPress(context),
                padding: EdgeInsets.zero,
                minSize: 0,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.camera,
                      size: 28,
                    ),
                  ],
                ),
              ),
              middle: StreamBuilder<VSocketStatusEvent>(
                  stream:
                      VChatController.I.nativeApi.streams.socketStatusStream,
                  builder: (context, snapshot) {
                    if (snapshot.data == null || snapshot.data!.isConnected) {
                      if (innerBoxIsScrolled) {
                        return Text(
                          S.of(context).chats,
                        );
                      }
                      return const SizedBox.shrink();
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CupertinoActivityIndicator(),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).connecting,
                          style: context.cupertinoTextTheme.textStyle,
                        ),
                      ],
                    );
                  }),
              backgroundColor: innerBoxIsScrolled
                  ? context.isDark
                      ? CupertinoColors.secondarySystemFill
                      : CupertinoColors.quaternarySystemFill
                  : CupertinoTheme.of(context).scaffoldBackgroundColor,
              border: innerBoxIsScrolled
                  ? const Border(
                      bottom: BorderSide(
                        color: Color(0x4D000000),
                        width: 0.0, // 0.0 means one physical pixel
                      ),
                    )
                  : null,
            ),
            // if (VPlatforms.isMobile)
            //   SliverToBoxAdapter(
            //     child: InkWell(
            //       onTap: () {
            //         // VChatController.I.vNavigator.callNavigator.toCall(
            //         //   context,
            //         //   value.callDto!,
            //         //   true,
            //         // );
            //       },
            //       child: Container(
            //         height: 70, // Customize as needed
            //         color: CupertinoColors.systemRed, // Example color
            //         child: Center(
            //           child: Text(
            //             'Call is active now',
            //             style: CupertinoTheme.of(context)
            //                 .textTheme
            //                 .pickerTextStyle
            //                 .copyWith(color: Colors.white),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
          ];
        },
        body: VChatPage(
          language: vRoomLanguageModel(context),
          onCreateNewBroadcast: config.allowCreateBroadcast
              ? () {
                  controller.createNewBroadcast(this.context);
                }
              : null,
          onSearchClicked: () {
            controller.onSearchClicked(this.context);
          },
          onCreateNewGroup: config.allowCreateGroup
              ? () {
                  controller.createNewGroup(this.context);
                }
              : null,
          appBar: null,
          showDisconnectedWidget: false,
          controller: controller.vRoomController,
        ),
      ),
    );
  }
}
