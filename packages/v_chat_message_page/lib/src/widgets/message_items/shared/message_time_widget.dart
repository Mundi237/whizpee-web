// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTimeWidget extends StatefulWidget {
  final DateTime dateTime;

  const MessageTimeWidget({
    super.key,
    required this.dateTime,
  });

  @override
  State<MessageTimeWidget> createState() => _MessageTimeWidgetState();
}

class _MessageTimeWidgetState extends State<MessageTimeWidget>
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        DateFormat.jm(Localizations.localeOf(context).languageCode)
            .format(widget.dateTime.toLocal()),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
