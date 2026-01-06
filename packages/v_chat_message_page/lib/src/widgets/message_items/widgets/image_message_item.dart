// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:ui';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../shared/constraint_image.dart';
import '../shared/download_upload_widgets/message_downloader_circular_widget.dart';
import '../shared/download_upload_widgets/message_downloader_widget.dart';

class ImageMessageItem extends StatelessWidget {
  final VImageMessage message;
  final BoxFit? fit;

  const ImageMessageItem({
    super.key,
    this.fit,
    required this.message,
  });

  void _navigateToImageViewer(VImageMessage message, BuildContext context) {
    VChatController.I.vNavigator.messageNavigator.toImageViewer(
      context,
      message.data.fileSource,
      !message.isOneSeen,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!VPlatforms.isMobile) {
      return GestureDetector(
        onTap: () => _navigateToImageViewer(message, context),
        child: VConstraintImage(
          data: message.data,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(15),
        ),
      );
    }
    return GestureDetector(
      onTap: !message.isFileDownloaded
          ? null
          : () => _navigateToImageViewer(message, context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (message.isFileDownloaded)
            VConstraintImage(
              data: message.data,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(15),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 10,
                  sigmaY: 10,
                ),
                child: VConstraintImage(
                  data: message.data,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

          ///download widgets
          if (message.isMessageHasProgress)
            MessageProgressCircularWidget(
              downloadProgress: message.progress,
              onCancel: () {
                FileDownloader().cancelTaskWithId(message.localId);
              },
            )
          else if (!message.isFileDownloaded)
            MessageDownloaderWidget(message: message),
        ],
      ),
    );
  }
}
