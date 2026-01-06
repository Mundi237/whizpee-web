// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

class EmojiKeyboard extends StatelessWidget {
  final bool isEmojiShowing;
  final TextEditingController controller;

  const EmojiKeyboard({
    super.key,
    required this.isEmojiShowing,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = context.isDark;
    return Offstage(
      offstage: !isEmojiShowing,
      child: SizedBox(
          height: VPlatforms.isWeb ? MediaQuery.of(context).size.height / 3 : 250,
          child: EmojiPicker(
            textEditingController: controller,
            config: Config(
              height: 256,
              emojiViewConfig: EmojiViewConfig(
                backgroundColor: isDark ? Colors.black : Colors.white,
              ),
              viewOrderConfig: const ViewOrderConfig(
                top: EmojiPickerItem.categoryBar,
                middle: EmojiPickerItem.emojiView,
                bottom: EmojiPickerItem.searchBar,
              ),
              skinToneConfig: const SkinToneConfig(),
              categoryViewConfig: CategoryViewConfig(
                backgroundColor: isDark ? Colors.black : Colors.white,
                indicatorColor: isDark ? Colors.white : Colors.black,
                iconColor: isDark ? Colors.white : Colors.black,
                iconColorSelected: isDark ? Colors.blueAccent : Colors.blue,
              ),
              bottomActionBarConfig: BottomActionBarConfig(
                backgroundColor: isDark ? Colors.black : Colors.white,
                buttonIconColor: isDark ? Colors.white : Colors.black,
              ),
              searchViewConfig: SearchViewConfig(
                backgroundColor: isDark ? Colors.black : Colors.white,
                buttonIconColor: isDark ? Colors.white : Colors.black,
                hintText: 'Search',
              ),
            ),
          )
      ),
    );
  }
}