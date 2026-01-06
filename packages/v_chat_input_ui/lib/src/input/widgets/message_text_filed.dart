// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_input_ui/src/models/v_input_theme.dart';
import 'package:v_chat_mention_controller/v_chat_mention_controller.dart';
import 'package:v_platform/v_platform.dart';

import '../../v_widgets/auto_direction.dart';

final urlDetectReg = RegExp(
  r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)",
  caseSensitive: false,
  dotAll: true,
);

class MessageTextFiled extends StatefulWidget {
  final VChatTextMentionController textEditingController;
  final FocusNode focusNode;
  final bool isTyping;
  final bool autofocus;
  final bool isAllowSendMedia;
  final String hint;
  final VoidCallback onShowEmoji;
  final VoidCallback onCameraPress;
  final VoidCallback onAttachFilePress;
  final Function(String value) onSubmit;
  final Function(List<Uri> urls) onDetectLink;

  const MessageTextFiled({
    super.key,
    required this.textEditingController,
    required this.focusNode,
    required this.isAllowSendMedia,
    required this.onShowEmoji,
    required this.onCameraPress,
    required this.onAttachFilePress,
    required this.onDetectLink,
    required this.isTyping,
    required this.autofocus,
    required this.hint,
    required this.onSubmit,
  });

  @override
  State<MessageTextFiled> createState() => _MessageTextFiledState();
}

class _MessageTextFiledState extends State<MessageTextFiled> {
  String txt = "";
  int lines = 1;

  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(_lineListener);
  }

  @override
  void dispose() {
    widget.textEditingController.removeListener(_lineListener);
    super.dispose();
  }

  bool get isMultiLine => lines != 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          isMultiLine ? CrossAxisAlignment.end : CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: widget.onShowEmoji,
          child: Padding(
            padding: isMultiLine
                ? const EdgeInsets.only(bottom: 8)
                : EdgeInsets.zero,
            child: context.vInputTheme.emojiIcon,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: AutoDirection(
            text: txt,
            child: TextField(
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                hintText: widget.hint,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey.shade600),
              ),
              textCapitalization: TextCapitalization.sentences,
              controller: widget.textEditingController,
              focusNode: widget.focusNode,
              autofocus: widget.autofocus,
              maxLines: 5,
              onChanged: (value) {
                setState(() {
                  txt = value;
                });
                if (value.isNotEmpty) {
                  _urlMatcher(widget.textEditingController.text);
                }
              },
              style: context.vInputTheme.textFieldTextStyle,
              minLines: 1,
              textAlignVertical: TextAlignVertical.top,
              onSubmitted: VPlatforms.isMobile
                  ? null
                  : (value) {
                      if (value.isNotEmpty) {
                        widget.onSubmit(value);
                      }
                      widget.focusNode.requestFocus();
                      widget.textEditingController.clear();
                    },
              textInputAction:
                  !VPlatforms.isMobile ? null : TextInputAction.newline,
              keyboardType: VPlatforms.isMobile
                  ? TextInputType.multiline
                  : TextInputType.text,
            ),
          ),
        ),
        const SizedBox(
          width: 3,
        ),
        Visibility(
          visible: !widget.isTyping,
          child: Padding(
            padding: isMultiLine
                ? const EdgeInsets.only(bottom: 8)
                : EdgeInsets.zero,
            child: Row(
              children: [
                if (VPlatforms.isMobile)
                  GestureDetector(
                    onTap:
                        !widget.isAllowSendMedia ? null : widget.onCameraPress,
                    child: context.vInputTheme.cameraIcon,
                  ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: !widget.isAllowSendMedia ? null : widget.onAttachFilePress,
          child: Padding(
            padding: isMultiLine
                ? const EdgeInsets.only(bottom: 8)
                : EdgeInsets.zero,
            child: context.vInputTheme.fileIcon,
          ),
        ),
      ],
    );
  }

  void _lineListener() {
    final count = widget.textEditingController.text.split('\n').length;
    if (lines != count) {
      setState(() {
        lines = count;
      });
    }
  }

  void _urlMatcher(String txt) {
    final allMatches = urlDetectReg.allMatches(txt);
    if (allMatches.isEmpty) {
      widget.onDetectLink(<Uri>[]);
      return;
    }
    final list = <Uri>[];
    for (final e in allMatches) {
      final group = e.group(0);
      if (group != null && Uri.tryParse(group) != null) {
        list.add(Uri.parse(ensureHttpPrefix(group)));
      }
    }
    widget.onDetectLink(list);
  }

  String ensureHttpPrefix(String url) {
    if (!url.startsWith(RegExp(r'https?:\/\/'))) {
      return 'https://$url';
    }
    return url;
  }
}
