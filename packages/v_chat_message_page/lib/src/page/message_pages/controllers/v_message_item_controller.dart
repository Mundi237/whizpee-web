// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:open_filex/open_filex.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:share_plus/share_plus.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../v_chat_message_page.dart';
import '../../../controllers/reaction_controller.dart';
import '../providers/message_provider.dart';

class VMessageItemController {
  final MessageProvider messageProvider;
  final BuildContext context;
  final _localStorage = VChatController.I.nativeApi.local;
  final VMessageConfig vMessageConfig;

  VMessageItemController({
    required this.messageProvider,
    required this.context,
    required this.vMessageConfig,
  });

  ModelSheetItem<VMessageItemClickRes> _deleteItem() {
    return ModelSheetItem(
      id: VMessageItemClickRes.delete,
      title: S.current.delete,
      iconData: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
    );
  }

  ModelSheetItem<VMessageItemClickRes> _downloadItem() {
    return ModelSheetItem(
      id: VMessageItemClickRes.download,
      title: S.current.download,
      iconData: Icon(
        CupertinoIcons.cloud_download,
      ),
    );
  }


  ModelSheetItem<VMessageItemClickRes> _copyItem() {
    return ModelSheetItem(
        id: VMessageItemClickRes.copy, title: S.current.copy, iconData: const Icon(Icons.copy));
  }

  ModelSheetItem<VMessageItemClickRes> _infoItem() {
    return ModelSheetItem(
      id: VMessageItemClickRes.info,
      title: S.current.info,
      iconData: const Icon(CupertinoIcons.info),
    );
  }

  ModelSheetItem<VMessageItemClickRes> _shareItem() {
    return ModelSheetItem(
      id: VMessageItemClickRes.share,
      title: S.current.share,
      iconData: const Icon(CupertinoIcons.share),
    );
  }

  ModelSheetItem<VMessageItemClickRes> _forwardItem() {
    return ModelSheetItem(
      id: VMessageItemClickRes.forward,
      title: S.current.forward,
      iconData: const Icon(CupertinoIcons.arrow_right),
    );
  }

  ModelSheetItem<VMessageItemClickRes> _replyItem() {
    return ModelSheetItem(
      id: VMessageItemClickRes.reply,
      title: S.current.reply,
      iconData: const Icon(CupertinoIcons.reply),
    );
  }

  ModelSheetItem<VMessageItemClickRes> _starItem() {
    return ModelSheetItem(
      id: VMessageItemClickRes.star,
      title: S.current.star,
      iconData: const Icon(CupertinoIcons.star_fill),
    );
  }

  ModelSheetItem<VMessageItemClickRes> _unStarItem() {
    return ModelSheetItem(
      id: VMessageItemClickRes.unStar,
      title: S.current.unStar,
      iconData: const Icon(CupertinoIcons.star_slash_fill),
    );
  }

  void onMessageItemLongPress(
    VBaseMessage message,
    VRoom room,
    Function(VBaseMessage p1) onSwipe,
  ) async {
    if (vMessageConfig.onMessageLongPress != null) {
      await vMessageConfig.onMessageLongPress!(message);
      return;
    }
    FocusScope.of(context).unfocus();
    final items = <ModelSheetItem<VMessageItemClickRes>>[];
    if (message.emitStatus.isServerConfirm) {
      items.add(_forwardItem());
      items.add(_replyItem());
      items.add(_shareItem());
      if (message.isMeSender) {
        items.add(_infoItem());
      }
      if (message.messageType.isFile) {
        items.add(_downloadItem());
      }
      if (message.messageType.isVoice) {
        items.add(_downloadItem());
      }
      if (message.isStared) {
        items.add(_unStarItem());
      } else {
        items.add(_starItem());
      }
    }
    items.add(
      _deleteItem(),
    );
    if (message.messageType.isText) {
      items.add(_copyItem());
    }
    if (message.allDeletedAt != null || (message.isOneSeen && !message.isMeSender)) {
      items.clear();
      //solution
      items.add(_deleteItem());
    }
    if (message.messageType.isCall) {
      items.clear();
      //solution
      items.add(_deleteItem());
      items.add(_replyItem());
    }

    final res = await VAppAlert.showModalSheetWithActions(
      content: items,
      cancelLabel: S.current.cancel,
      context: context,
      currentUserEmoji: message.currentUserEmoji,
      onReactionSelected: (value) async {
        await ReactionController.toggleReaction(message, value);
      },
    );
    if (res == null) return;
    switch (res.id as VMessageItemClickRes) {
      case VMessageItemClickRes.forward:
        _handleForward(message);
        break;
      case VMessageItemClickRes.reply:
        onSwipe(message);
        break;
      case VMessageItemClickRes.share:
        _handleShare(message);
        break;
      case VMessageItemClickRes.info:
        _handleInfo(message, room);
        break;
      case VMessageItemClickRes.delete:
        _handleDelete(message);
        break;
      case VMessageItemClickRes.copy:
        _handleCopy(message);
        break;
      case VMessageItemClickRes.download:
        _handleDownload(message);
        break;
      case VMessageItemClickRes.star:
        _handleStar(message);
        break;
      case VMessageItemClickRes.unStar:
        _handleUnStar(message);
        break;
    }
  }

  void _handleForward(VBaseMessage baseMessage) async {
    final ids =
        await VChatController.I.vNavigator.roomNavigator.toForwardPage(context, baseMessage.roomId);
    if (ids != null) {
      for (final roomId in ids) {
        VBaseMessage? message;
        switch (baseMessage.messageType) {
          case VMessageType.text:
            message = VTextMessage.buildMessage(
              content: baseMessage.realContent,
              roomId: roomId,
              linkAtt: baseMessage.linkAtt,
              forwardId: baseMessage.localId,
              isEncrypted: baseMessage.isEncrypted,
            );
            break;
          case VMessageType.image:
            message = VImageMessage.buildMessage(
              data: (baseMessage as VImageMessage).data,
              roomId: roomId,
              forwardId: baseMessage.localId,
            );
            break;
          case VMessageType.file:
            message = VFileMessage.buildMessage(
              data: (baseMessage as VFileMessage).data,
              roomId: roomId,
              forwardId: baseMessage.localId,
            );
            break;
          case VMessageType.video:
            message = VVideoMessage.buildMessage(
              data: (baseMessage as VVideoMessage).data,
              roomId: roomId,
              forwardId: baseMessage.localId,
            );
            break;
          case VMessageType.voice:
            message = VVoiceMessage.buildMessage(
              data: (baseMessage as VVoiceMessage).data,
              roomId: roomId,
              content: baseMessage.realContent,
              forwardId: baseMessage.localId,
            );
            break;
          case VMessageType.location:
            message = VLocationMessage.buildMessage(
              data: (baseMessage as VLocationMessage).data,
              roomId: roomId,
              forwardId: baseMessage.localId,
            );
            break;
          case VMessageType.call:
            break;
          case VMessageType.custom:
            message = VCustomMessage.buildMessage(
              data: (baseMessage as VCustomMessage).data,
              content: baseMessage.realContent,
              roomId: roomId,
            );
            break;
          case VMessageType.info:
            break;
          case VMessageType.bug:
            break;
        }
        if (message != null) {
          await _localStorage.message.insertMessage(message);
          VMessageUploaderQueue.instance.addToQueue(
            await MessageFactory.createForwardUploadMessage(message),
          );
        }
      }
    }
  }

  void _handleShare(VBaseMessage message) async {
    if (message.emitStatus.isServerConfirm) {
      if (message is VTextMessage) {
        await SharePlus.instance.share(ShareParams(text: message.realContent));
        return;
      }
      if (message is VLocationMessage) {
        await SharePlus.instance
            .share(ShareParams(text: message.data.linkPreviewData.link.toString()));
        return;
      }
      late final VPlatformFile pFile;
      if (message is VImageMessage) {
        pFile = message.data.fileSource;
      } else if (message is VVoiceMessage) {
        pFile = message.data.fileSource;
      } else if (message is VFileMessage) {
        pFile = message.data.fileSource;
      } else if (message is VVideoMessage) {
        pFile = message.data.fileSource;
      }
      final file = await DefaultCacheManager().getSingleFile(
        pFile.fullNetworkUrl!,
      );
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
    }
  }

  void _handleInfo(VBaseMessage message, VRoom room) {
    FocusScope.of(context).unfocus();
    if (room.roomType.isSingleOrOrder) {
      VChatController.I.vNavigator.messageNavigator.toSingleChatMessageInfo(
        context,
        message,
      );
      return;
    } else if (room.roomType.isGroup) {
      VChatController.I.vNavigator.messageNavigator.toGroupChatMessageInfo(
        context,
        message,
      );
      return;
    } else if (room.roomType.isBroadcast) {
      VChatController.I.vNavigator.messageNavigator.toBroadcastChatMessageInfo(
        context,
        message,
      );
      return;
    }
  }

  void handleInfo2(BuildContext context, VBaseMessage message, VRoom room) {
    FocusScope.of(context).unfocus();
    if (room.roomType.isSingleOrOrder) {
      VChatController.I.vNavigator.messageNavigator.toSingleChatMessageInfo(
        context,
        message,
      );
      return;
    } else if (room.roomType.isGroup) {
      VChatController.I.vNavigator.messageNavigator.toGroupChatMessageInfo(
        context,
        message,
      );
      return;
    } else if (room.roomType.isBroadcast) {
      VChatController.I.vNavigator.messageNavigator.toBroadcastChatMessageInfo(
        context,
        message,
      );
      return;
    }
  }

  void _handleDelete(VBaseMessage message) async {
    final l = <ModelSheetItem>[];
    if (message.isMeSender && !message.isAllDeleted && message.emitStatus.isServerConfirm) {
      l.add(ModelSheetItem(title: S.current.deleteFromAll, id: 1));
    }

    l.add(ModelSheetItem(title: S.current.deleteFromMe, id: 2));
    final res = await VAppAlert.showModalSheetWithActions(
      content: l,
      context: context,
      cancelLabel: S.current.cancel,
    );
    if (res == null) return;
    if (res.id == 1) {
      await vSafeApiCall(
        request: () async {
          return messageProvider.deleteMessageFromAll(
            message.roomId,
            message.id,
          );
        },
        onSuccess: (response) {},
      );
    }
    if (res.id == 2) {
      await vSafeApiCall(
        request: () async {
          return messageProvider.deleteMessageFromMe(message);
        },
        onSuccess: (response) {},
      );
    }
  }

  void _handleCopy(VBaseMessage message) async {
    await Clipboard.setData(
      ClipboardData(
        text: message.realContentMentionParsedWithAt,
      ),
    );
  }

  void _handleDownload(VBaseMessage message) async {
    if (!message.emitStatus.isServerConfirm) {
      return;
    }

    await vSafeApiCall<String>(
      onLoading: () {
        VAppAlert.showSuccessSnackBar(
          message: S.current.downloading,
          context: context,
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
          message: S.current.fileHasBeenSavedTo + url,
          context: context,
        );
      },
      onError: (exception) {},
    );
  }

  void _handleStar(VBaseMessage message) async {
    await vSafeApiCall<void>(
      request: () async {
        await VChatController.I.nativeApi.remote.message.starMessage(
          message.roomId,
          message.id,
        );
        await VChatController.I.nativeApi.local.message.updateMessageStar(
          VUpdateMessageStarEvent(
            roomId: message.roomId,
            localId: message.localId,
            isStar: true,
          ),
        );
      },
      onSuccess: (url) async {},
    );
  }

  void _handleUnStar(VBaseMessage message) async {
    await vSafeApiCall<void>(
      request: () async {
        await VChatController.I.nativeApi.remote.message.unStarMessage(
          message.roomId,
          message.id,
        );
        await VChatController.I.nativeApi.local.message.updateMessageStar(
          VUpdateMessageStarEvent(
            roomId: message.roomId,
            localId: message.localId,
            isStar: false,
          ),
        );
      },
      onSuccess: (url) async {},
    );
  }
}
