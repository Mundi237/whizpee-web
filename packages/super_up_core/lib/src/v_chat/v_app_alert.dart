// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:adaptive_dialog/adaptive_dialog.dart' as adaptive_dialog;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'custom_message_options_sheet.dart';

import '../../super_up_core.dart';

abstract class VAppAlert {
  static Future showLoading({
    String? message,
    bool isDismissible = false,
    required BuildContext context,
  }) async {
    return adaptive_dialog.showAlertDialog(
      context: context,
      style: adaptive_dialog.AdaptiveStyle.iOS,
      builder: (context, child) {
        return CupertinoAlertDialog(
          content: PopScope(
            canPop: isDismissible,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CupertinoActivityIndicator(radius: 15),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> showOkAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
  }) async {
    await adaptive_dialog.showOkAlertDialog(
      context: context,
      title: title,
      message: content,
      style: adaptive_dialog.AdaptiveStyle.iOS,
      okLabel: S.of(context).ok,
    );
    return;
  }

  static void showErrorSnackBarWithoutContext({
    required String message,
  }) {
    showToast(message, context: VChatController.I.navigationContext, backgroundColor: Colors.red);
  }

  static void showSuccessSnackBarWithoutContext({
    required String message,
    Duration? duration,
  }) {
    showToast(message,
        context: VChatController.I.navigationContext,
        duration: duration,
        position: const ToastPosition(align: Alignment.bottomCenter));
  }

  static Future<bool> showTextAnswerDialog({
    required BuildContext context,
    required String title,
    required String content,
  }) async {
    return await adaptive_dialog.showTextAnswerDialog(
      context: context,
      title: title,
      message: content,
      style: adaptive_dialog.AdaptiveStyle.iOS,
      cancelLabel: S.of(context).cancel,
      okLabel: S.of(context).ok,
      keyword: 'xx@xx.com',
    );
  }

  static Future<List<String>?> showTextInputDialog({
    required BuildContext context,
    String? title,
    String? content,
    required List<adaptive_dialog.DialogTextField> textFields,
  }) async {
    return await adaptive_dialog.showTextInputDialog(
      context: context,
      title: title,
      message: content,
      style: adaptive_dialog.AdaptiveStyle.iOS,
      okLabel: S.of(context).ok,
      cancelLabel: S.of(context).cancel,
      textFields: textFields,
    );
  }

  static Future<List<MediaDownloadOptions>> chooseAlertDialog({
    required BuildContext context,
    required List<MediaDownloadOptions> inChoose,
  }) async {
    final list = <MediaDownloadOptions>[];
    list.addAll(inChoose);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: context.pop,
              child: S.of(context).cancel.text,
            ),
            TextButton(onPressed: context.pop, child: S.of(context).ok.text),
          ],
          content: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                  value: list.contains(MediaDownloadOptions.images),
                  title: S.of(context).images.text,
                  onChanged: (value) {
                    if (value == true) {
                      list.add(MediaDownloadOptions.images);
                    } else {
                      list.remove(MediaDownloadOptions.images);
                    }
                    setState(() {});
                  },
                ),
                CheckboxListTile(
                  value: list.contains(MediaDownloadOptions.files),
                  title: S.of(context).files.text,
                  onChanged: (value) {
                    if (value == true) {
                      list.add(MediaDownloadOptions.files);
                    } else {
                      list.remove(MediaDownloadOptions.files);
                    }
                    setState(() {});
                  },
                ),
                CheckboxListTile(
                  value: list.contains(MediaDownloadOptions.videos),
                  title: S.of(context).video.text,
                  onChanged: (value) {
                    if (value == true) {
                      list.add(MediaDownloadOptions.videos);
                    } else {
                      list.remove(MediaDownloadOptions.videos);
                    }
                    setState(() {});
                  },
                )
              ],
            ),
          ),
        );
      },
    );
    return list;
  }

  static Future<int> showAskYesNoDialog({
    required BuildContext context,
    required String title,
    required String content,
  }) async {
    final x = await adaptive_dialog.showOkCancelAlertDialog(
      context: context,
      title: title,
      style: adaptive_dialog.AdaptiveStyle.iOS,
      message: content,
      cancelLabel: S.of(context).cancel,
      okLabel: S.of(context).ok,
    );
    if (x == adaptive_dialog.OkCancelResult.ok) {
      return 1;
    }
    return 0;
  }

  static Future<T?> showAskListDialog<T>({
    required String title,
    required List<T> content,
    required BuildContext context,
  }) async {
    return showDialog<T?>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: content
                  .map((e) => ListTile(
                        title: e.toString().text,
                        onTap: () {
                          Navigator.pop(context, e);
                        },
                      ))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: S.of(context).cancel.text,
            ),
          ],
        );
      },
    );
  }

  static Future<ModelSheetItem?> showModalSheet<T>({
    String? title,
    String? cancelLabel,
    required BuildContext context,
  }) async {
    return await adaptive_dialog.showModalActionSheet<ModelSheetItem?>(
      context: context,
      title: title,
      style: adaptive_dialog.AdaptiveStyle.iOS,
      isDismissible: true,
    );
  }

  static Future<ModelSheetItem?> showModalSheetWithActions<T>({
    String? title,
    String? cancelLabel,
    required List<ModelSheetItem> content,
    required BuildContext context,
    List<String>? quickReactions,
    ValueChanged<String>? onReactionSelected,
    String? currentUserEmoji,
  }) async {
    // Use custom modern UI for message options
    final options = content
        .map((item) => MessageOptionItem(
              id: item.id,
              title: item.title,
              icon: _getIconDataFromIcon(item.iconData),
              isDestructive: _isDestructiveAction(item.title),
            ))
        .toList();

    final result = await showCustomMessageOptionsSheet(
      context: context,
      options: options,
      title: title,
      cancelLabel: cancelLabel ?? S.of(context).cancel,
      quickReactions: quickReactions ?? const ['❤️', '😂', '😮', '😢', '😡', '👍'],
      onReactionSelected: onReactionSelected,
      currentUserEmoji: currentUserEmoji,
    );

    return result != null ? content.firstWhere((item) => item.id == result.id) : null;
  }

  static IconData _getIconDataFromIcon(Icon? icon) {
    if (icon?.icon != null) {
      return icon!.icon!;
    }
    return Icons.help_outline; // Default fallback icon
  }

  static bool _isDestructiveAction(String title) {
    final destructiveActions = [
      S.current.delete,
      'Delete',
      'Remove',
      'Clear',
    ];
    return destructiveActions.any((action) => title.toLowerCase().contains(action.toLowerCase()));
  }

  static void showSuccessSnackBar({
    required String message,
    required BuildContext context,
    Duration? duration,
  }) {
    showToast(message,
        context: context,
        duration: duration,
        position: const ToastPosition(align: Alignment.bottomCenter));
  }



  static void showErrorSnackBar({
    required String message,
    required BuildContext context,
  }) {
    showToast(message, context: context, backgroundColor: Colors.red);
  }


}

class ModelSheetItem<T> {
  final T id;
  final String title;
  final Icon? iconData;
  final String? moreData;

  ModelSheetItem({
    required this.title,
    required this.id,
    this.iconData,
    this.moreData,
  });

  @override
  String toString() {
    return 'ModelSheetItem{id: $id, title: $title, iconData: $iconData, moreData: $moreData}';
  }
}
