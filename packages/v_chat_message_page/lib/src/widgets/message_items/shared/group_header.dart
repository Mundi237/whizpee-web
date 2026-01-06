// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

class GroupHeader extends StatelessWidget {
  final bool isGroup;
  final String senderName;
  final String senderImage;
  final VoidCallback onTab;

  const GroupHeader({
    super.key,
    required this.isGroup,
    required this.senderName,
    required this.senderImage,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    if (!isGroup) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: onTab,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VCircleAvatar(
              vFileSource: VPlatformFile.fromUrl(networkUrl: senderImage),
              radius: 10,
            ),
            const SizedBox(
              width: 5,
            ),
            senderName.text.size(12).color(Colors.blue).black,
          ],
        ),
      ),
    );
  }
}
