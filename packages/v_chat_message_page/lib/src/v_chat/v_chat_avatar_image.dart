// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

class VChatAvatarImage extends StatelessWidget {
  final String imageUrl;
  final bool isOnline;
  final String chatTitle;
  final int size;

  const VChatAvatarImage({
    super.key,
    required this.imageUrl,
    required this.isOnline,
    required this.chatTitle,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return AdvancedAvatar(
      size: size.toDouble(),
      statusColor: isOnline ? CupertinoColors.systemGreen : null,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
      foregroundDecoration:
          BoxDecoration(borderRadius: BorderRadius.circular(100)),
      name: chatTitle,
      child: VCircleAvatar(
        vFileSource: VPlatformFile.fromUrl(networkUrl: imageUrl),
      ),
    );
  }
}
