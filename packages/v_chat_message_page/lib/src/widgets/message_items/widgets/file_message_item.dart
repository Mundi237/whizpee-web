// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_message_page/src/theme/theme.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../shared/download_upload_widgets/message_downloader_circular_widget.dart';
import '../shared/download_upload_widgets/message_downloader_widget.dart';

class FileMessageItem extends StatelessWidget {
  final VFileMessage message;
  final Color backgroundColor;

  const FileMessageItem({
    super.key,
    required this.message,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    if (!VPlatforms.isMobile) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: CupertinoListTile(
          leadingSize: 50,
          backgroundColor: backgroundColor,
          leadingToTitle: 10,
          onTap: () => _handleDownloadForWeb(message, context),
          padding: const EdgeInsets.all(10),
          leading: const Icon(
            CupertinoIcons.arrow_down_to_line_alt,
            size: 40,
          ),
          title: message.data.fileSource.name.text
              .styled(
                style: message.isMeSender
                    ? context.vMessageTheme.senderTextStyle
                    : context.vMessageTheme.receiverTextStyle,
              )
              .size(14)
              .maxLine(2),
          subtitle: message.data.fileSource.readableSize.text
              .styled(
                style: message.isMeSender
                    ? context.vMessageTheme.senderTextStyle
                    : context.vMessageTheme.receiverTextStyle,
              )
              .size(14),
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: CupertinoListTile(
        leadingSize: 50,
        backgroundColor: backgroundColor,
        leadingToTitle: 10,
        onTap: () => _handleDownloadForMobile(message),
        padding: const EdgeInsets.all(10),
        leading: Builder(builder: (context) {
          if (message.isMessageHasProgress) {
            return MessageProgressCircularWidget(
              downloadProgress: message.progress,
              onCancel: () {
                FileDownloader().cancelTaskWithId(message.localId);
              },
            );
          } else if (!message.isFileDownloaded) {
            return MessageDownloaderWidget(message: message);
          } else {
            return const Icon(
              CupertinoIcons.arrow_down_to_line_alt,
              size: 40,
            );
          }
        }),
        title: message.data.fileSource.name.text
            .styled(
              style: message.isMeSender
                  ? context.vMessageTheme.senderTextStyle
                  : context.vMessageTheme.receiverTextStyle,
            )
            .size(14)
            .maxLine(2),
        subtitle: message.data.fileSource.readableSize.text
            .styled(
              style: message.isMeSender
                  ? context.vMessageTheme.senderTextStyle
                  : context.vMessageTheme.receiverTextStyle,
            )
            .size(14),
      ),
    );
  }

  void _handleDownloadForMobile(VFileMessage message) async {
    if (!message.emitStatus.isServerConfirm) {
      return;
    }
    if (message.isFileDownloaded) {
      await OpenFilex.open(
        VFileUtils.getLocalPath(message.localFilePathWithExt),
      );
      return;
    }
    VDownloaderService.instance.addToMobileQueue(message);
  }

  void _handleDownloadForWeb(VBaseMessage message, BuildContext context) async {
    if (!message.emitStatus.isServerConfirm) {
      return;
    }

    await vSafeApiCall<String>(
      onLoading: () {
        VAppAlert.showSuccessSnackBar(
          context: context,
          message: S.of(context).downloading,
        );
      },
      request: () async {
        return VDownloaderService.instance.addToQueue(message);
      },
      onSuccess: (url) async {
        if (VPlatforms.isMobile) {
          await OpenFilex.open(url);
        }
        VAppAlert.showSuccessSnackBar(
          message: S.of(context).success,
          context: context,
        );
      },
      onError: (exception) {},
    );
  }
}
