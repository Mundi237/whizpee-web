// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:textless/textless.dart';

class MessageTypingWidget extends StatelessWidget {
  final String text;
  const MessageTypingWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return text.text.color(CupertinoColors.systemGreen).size(12);
  }
}
