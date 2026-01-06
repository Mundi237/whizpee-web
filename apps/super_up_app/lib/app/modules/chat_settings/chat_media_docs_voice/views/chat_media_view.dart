// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:super_up/app/modules/chat_settings/chat_media_docs_voice/controllers/chat_media_controller.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class ChatMediaView extends StatefulWidget {
  const ChatMediaView({super.key, required this.roomId});
  final String roomId;

  @override
  State<ChatMediaView> createState() => _ChatMediaViewState();
}

class _ChatMediaViewState extends State<ChatMediaView> {
  late final ChatMediaController controller;

  @override
  void initState() {
    super.initState();
    controller = ChatMediaController(widget.roomId);
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  int sharedValue = 0;
  final Map<int, Widget> logoWidgets = <int, Widget>{
    0: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(S.current.media),
    ),
    1: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(S.current.docs),
    ),
    2: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(S.current.links),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SegmentedButton<int>(
          segments: [
            ButtonSegment<int>(
              value: 0,
              label: Text(S.current.media),
            ),
            ButtonSegment<int>(
              value: 1,
              label: Text(S.current.docs),
            ),
            ButtonSegment<int>(
              value: 2,
              label: Text(S.current.links),
            ),
          ],
          selected: {sharedValue},
          onSelectionChanged: (Set<int> newSelection) {
            setState(() {
              sharedValue = newSelection.first;
            });
          },
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) => VAsyncWidgetsBuilder(
            loadingState: controller.loadingState,
            successWidget: () {
              if (sharedValue == 0) {
                //create grid view builder
                return GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: controller.data.media.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) {
                    if (controller.data.media[index].messageType.isImage) {
                      return ImageMessageItem(
                        message: controller.data.media[index] as VImageMessage,
                        fit: BoxFit.cover,
                      );
                    }
                    return VideoMessageItem(
                      message: controller.data.media[index] as VVideoMessage,
                    );
                  },
                );
              } else if (sharedValue == 1) {
                return ListView.separated(
                  padding: const EdgeInsets.all(10.0),
                  itemBuilder: (context, index) {
                    return FileMessageItem(
                      message: controller.data.files[index] as VFileMessage,
                      backgroundColor: controller.data.files[index].isMeSender
                          ? context.vMessageTheme.senderBubbleColor
                          : context.vMessageTheme.receiverBubbleColor,
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(color: Colors.grey),
                  itemCount: controller.data.files.length,
                );
              } else {
                return ListView.separated(
                  padding: const EdgeInsets.all(10.0),
                  itemBuilder: (context, index) {
                    return LinkViewerWidget(
                      data: controller.data.links[index].linkAtt,
                      isMeSender: controller.data.links[index].isMeSender,
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(color: Colors.grey),
                  itemCount: controller.data.links.length,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
