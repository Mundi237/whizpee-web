// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:v_chat_sdk_core/src/utils/regex.dart';
import 'package:v_chat_sdk_core/src/widgets/auto_direction.dart';

///use this widget to make sure that the text is parsed correctly
class VTextParserWidget extends StatefulWidget {
  final Function(String email)? onEmailPress;
  final Function(String userId)? onMentionPress;
  final Function(String phone)? onPhonePress;
  final Function(String link)? onLinkPress;
  final bool enableTabs;
  final String text;
  final bool isOneLine;
  final TextStyle? textStyle;
  final TextStyle? emailTextStyle;
  final TextStyle? phoneTextStyle;
  final TextStyle? mentionTextStyle;

  const VTextParserWidget({
    super.key,
    this.onEmailPress,
    this.onMentionPress,
    this.onPhonePress,
    this.onLinkPress,
    this.enableTabs = false,
    this.isOneLine = false,
    required this.text,
    this.textStyle,
    this.emailTextStyle,
    this.phoneTextStyle,
    this.mentionTextStyle,
  });

  @override
  State<VTextParserWidget> createState() => _VTextParserWidgetState();
}

class _VTextParserWidgetState extends State<VTextParserWidget> {
  late String _firstHalf;
  late String _secondHalf;
  static const int _maxChars = 400;
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    final text = widget.text;
    if (text.length > _maxChars) {
      _firstHalf = text.substring(0, _maxChars);
      _secondHalf = text.substring(_maxChars);
      _isCollapsed = true;
    } else {
      _firstHalf = text;
      _secondHalf = '';
      _isCollapsed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultLinkStyle = const TextStyle(
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w400,
      color: Colors.blue
    );

    if (widget.isOneLine) {
      return _buildParsedText(
        linkStyle: defaultLinkStyle,
        text: _firstHalf,
        maxLine: 1,
      );
    }

    if (_secondHalf.isEmpty) {
      return _buildParsedText(
        linkStyle: defaultLinkStyle,
        text: _firstHalf,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildParsedText(
          linkStyle: defaultLinkStyle,
          text: _isCollapsed ? '$_firstHalf ...' : widget.text,
        ),
        GestureDetector(
          onTap: () => setState(() => _isCollapsed = !_isCollapsed),
          child: Icon(
            _isCollapsed ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildParsedText({
    required TextStyle linkStyle,
    required String text,
    int? maxLine,
  }) {
    final textStyle = widget.textStyle;
    final emailStyle = widget.emailTextStyle ?? linkStyle;
    final phoneStyle = widget.phoneTextStyle ?? linkStyle;
    final mentionStyle = widget.mentionTextStyle ?? linkStyle;

    // Build parse list once for this render to avoid recreating closures repeatedly
    final List<MatchText> parseList = [
      MatchText(
        pattern: r"\[(@[^:]+):([^\]]+)\]",
        style: mentionStyle,
        renderText: ({required String str, required String pattern}) {
          final display = vMentionRegExp.firstMatch(str)?.group(1);
          return display == null ? <String, String>{} : <String, String>{'display': display};
        },
        onTap: (url) {
          final userId = vMentionRegExp.firstMatch(url)?.group(2);
          if (userId != null) {
            widget.onMentionPress?.call(userId);
          }
        },
      ),
      if (widget.onEmailPress != null)
        MatchText(
          pattern: regexEmail,
          style: emailStyle,
          onTap: (url) => widget.onEmailPress?.call(url),
        ),
      if (widget.onPhonePress != null)
        MatchText(
          type: ParsedType.PHONE,
          style: phoneStyle,
          onTap: (url) => widget.onPhonePress?.call(url),
        ),
      if (widget.onLinkPress != null)
        MatchText(
          pattern: regexLink,
          style: linkStyle,
          onTap: (rawUrl) {
            var url = rawUrl;
            final protocolIdentifierRegex = RegExp(r'^((http|ftp|https):\/\/)', caseSensitive: false);
            if (!url.startsWith(protocolIdentifierRegex)) {
              url = 'https://$url';
            }
            widget.onLinkPress?.call(url);
          },
        ),
    ];

    return IgnorePointer(
      ignoring: !widget.enableTabs,
      child: AutoDirection(
        text: text,
        child: ParsedText(
          text: text,
          maxLines: maxLine,
          style: textStyle,
          regexOptions: const RegexOptions(multiLine: true, dotAll: true),
          textWidthBasis: TextWidthBasis.longestLine,
          parse: parseList,
        ),
      ),
    );
  }
}
