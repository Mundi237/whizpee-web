// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../v_chat_message_page.dart';
import 'message_group_status_controller.dart';

class VMessageGroupStatusPage extends StatefulWidget {
  final VBaseMessage message;
  final String messageInfoLabel;
  final String readLabel;
  final String deliveredLabel;
  final VMessageLocalization vMessageLocalization;

  const VMessageGroupStatusPage({
    super.key,
    required this.message,
    required this.messageInfoLabel,
    required this.readLabel,
    required this.deliveredLabel,
    required this.vMessageLocalization,
  });

  @override
  State<VMessageGroupStatusPage> createState() =>
      _VMessageGroupStatusPageState();
}

class _VMessageGroupStatusPageState extends State<VMessageGroupStatusPage> {
  late final MessageGroupStatusController controller;

  @override
  void initState() {
    controller = MessageGroupStatusController(widget.message);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDark ? null : CupertinoColors.systemGrey6,
      appBar: AppBar(
        title: Text(
          widget.messageInfoLabel,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: VMessageItem(
                  language: widget.vMessageLocalization,
                  voiceController: controller.getVoiceController,
                  message: widget.message,
                  roomType: VRoomType.g,
                  onSwipe: null,
                  onReSend: (message) {},
                  onHighlightMessage: (message) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    MessageStatusIcon(
                      model: MessageStatusIconDataModel(
                        isDeliver: false,
                        isSeen: true,
                        emitStatus: widget.message.emitStatus,
                        isMeSender: widget.message.isMeSender,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    widget.readLabel.text,
                  ],
                ),
              ),
              ValueListenableBuilder<MessageStatusState>(
                  valueListenable: controller,
                  builder: (__, value, _) {
                    return VAsyncWidgetsBuilder(
                      loadingState: controller.state,
                      onRefresh: controller.getData,
                      successWidget: () {
                        final seen = value.seen;
                        if (seen.isEmpty) {
                          return ChatSettingsTileInfo(
                            title: Center(child: Text(S.of(context).noData)),
                          );
                        }
                        return Container(
                          color: context.isDark
                              ? CupertinoColors.secondaryLabel
                              : Colors.white,
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(10),
                            itemBuilder: (context, index) => CupertinoListTile(
                              padding: EdgeInsets.zero,
                              onTap: () {
                                VChatController.I.vNavigator.messageNavigator
                                        .toUserProfilePage!(
                                    context, seen[index].peerUser.id);
                              },
                              leadingSize: 40,
                              leading: VCircleAvatar(
                                radius: 20,
                                vFileSource: VPlatformFile.fromUrl(
                                    networkUrl:
                                        value.seen[index].peerUser.userImage),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      widget.readLabel.text,
                                      format(value.seen[index].seen!)
                                          .text
                                          .color(Colors.grey),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      widget.deliveredLabel.text,
                                      format(value.seen[index].delivered)
                                          .text
                                          .color(Colors.grey),
                                    ],
                                  ),
                                ],
                              ),
                              title: value.seen[index].peerUser.fullName.text,
                            ),
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: value.seen.length,
                          ),
                        );
                      },
                    );
                  }),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    MessageStatusIcon(
                      model: MessageStatusIconDataModel(
                        isDeliver: true,
                        isSeen: false,
                        emitStatus: widget.message.emitStatus,
                        isMeSender: widget.message.isMeSender,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    widget.deliveredLabel.text,
                  ],
                ),
              ),
              ValueListenableBuilder<MessageStatusState>(
                  valueListenable: controller,
                  builder: (__, value, _) {
                    return VAsyncWidgetsBuilder(
                      loadingState: controller.state,
                      successWidget: () {
                        final deliver = value.deliver;
                        if (deliver.isEmpty) {
                          return ChatSettingsTileInfo(
                              title: Center(child: Text(S.of(context).noData)));
                        }

                        return Container(
                          color: context.isDark
                              ? CupertinoColors.secondaryLabel
                              : Colors.white,
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(10),
                            itemBuilder: (context, index) => CupertinoListTile(
                              padding: EdgeInsets.zero,
                              onTap: () {
                                VChatController.I.vNavigator.messageNavigator
                                    .toUserProfilePage!(
                                  context,
                                  deliver[index].peerUser.id,
                                );
                              },
                              leadingSize: 40,
                              subtitle: format(value.deliver[index].delivered)
                                  .text
                                  .color(Colors.grey),
                              leading: VCircleAvatar(
                                radius: 20,
                                vFileSource: VPlatformFile.fromUrl(
                                  networkUrl:
                                      value.deliver[index].peerUser.userImage,
                                ),
                              ),
                              title:
                                  value.deliver[index].peerUser.fullName.text,
                            ),
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: value.deliver.length,
                          ),
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }
}
