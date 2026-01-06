// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../shared/constraint_image.dart';
import '../shared/download_upload_widgets/message_downloader_circular_widget.dart';
import '../shared/download_upload_widgets/message_downloader_widget.dart';
import '../shared/rounded_container.dart';

class VideoMessageItem extends StatelessWidget {
  final VVideoMessage message;

  const VideoMessageItem({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (!VPlatforms.isMobile) {
      return GestureDetector(
        onTap: () => navigateToVideoPlayer(context, message),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 350,
            maxHeight: 350,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  getBackground(context),
                  getPlayIcon(),
                ],
              ),
              getVideoAttWidget(),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: message.isFileDownloaded
          ? () => navigateToVideoPlayer(context, message)
          : null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 350,
          maxHeight: 350,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                getBackground(context),
                if (message.isFileDownloaded &&
                    message.emitStatus.isServerConfirm)
                  getPlayIcon(),
              ],
            ),
            getVideoAttWidget(),

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
      ),
    );
  }

  Widget getBackground(BuildContext context) {
    if (message.data.thumbImage == null) {
      return Container(
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black,
        ),
      );
    }
    return VConstraintImage(
      data: message.data.thumbImage!,
      borderRadius: BorderRadius.circular(15),
      fit: BoxFit.contain,
    );
  }

  Widget getPlayIcon() {
    return RoundedContainer(
      height: 60,
      width: 60,
      color: Colors.blueGrey.withValues(alpha: .9),
      boxShape: BoxShape.circle,
      child: const Icon(
        Icons.play_arrow,
        size: 60,
        color: Colors.black,
      ),
    );
  }

  Positioned getVideoAttWidget() {
    return Positioned(
      bottom: 5,
      right: 5,
      child: RoundedContainer(
        borderRadius: BorderRadius.circular(5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: Colors.blueGrey.withValues(alpha: .5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            message.data.durationFormat == null
                ? const SizedBox.shrink()
                : Row(
                    children: [
                      const Icon(
                        Icons.videocam_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      message.data.durationFormat!.cap.color(Colors.white),
                    ],
                  ),
            Row(
              children: [
                const Icon(
                  Icons.photo_size_select_actual_outlined,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(
                  width: 4,
                ),
                message.data.fileSource.readableSize.cap.color(Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void navigateToVideoPlayer(
    BuildContext context,
    VVideoMessage message,
  ) {
    if (VPlatforms.isMobile) {
      VChatController.I.vNavigator.messageNavigator.toVideoPlayer(
          context,
          VPlatformFile.fromPath(
            fileLocalPath:
                VFileUtils.getLocalPath(message.localFilePathWithExt),
          ),
          !message.isOneSeen);
      return;
    }
    VChatController.I.vNavigator.messageNavigator.toVideoPlayer(
      context,
      message.data.fileSource,
      !message.isOneSeen,
    );
  }
}
