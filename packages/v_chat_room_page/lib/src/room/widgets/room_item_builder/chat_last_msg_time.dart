// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatLastMsgTime extends StatefulWidget {
  /// The [DateTime] object representing the last time a message was sent in a chat.
  final DateTime lastMessageTime;
  final String yesterdayLabel;

  /// Creates a new instance of [ChatLastMsgTime].
  const ChatLastMsgTime({
    super.key,
    required this.lastMessageTime,
    required this.yesterdayLabel,
  });

  @override
  State<ChatLastMsgTime> createState() => _ChatLastMsgTimeState();
}

class _ChatLastMsgTimeState extends State<ChatLastMsgTime>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(ChatLastMsgTime oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lastMessageTime != widget.lastMessageTime) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toLocal();
    final difference = now.difference(widget.lastMessageTime).inDays;
    
    String timeText;
    if (difference == 0) {
      //same day
      timeText = DateFormat.jm(Localizations.localeOf(context).languageCode)
          .format(widget.lastMessageTime);
    } else if (difference == 1) {
      timeText = widget.yesterdayLabel;
    } else if (difference <= 7) {
      timeText = DateFormat.E(Localizations.localeOf(context).languageCode)
          .format(widget.lastMessageTime);
    } else {
      timeText = DateFormat.yMd(Localizations.localeOf(context).languageCode)
          .format(widget.lastMessageTime);
    }
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        timeText,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
