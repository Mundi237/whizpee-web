// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/src/exceptions/http/v_chat_http_exception.dart';
import 'package:v_chat_sdk_core/src/models/v_chat_base_exception.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

class VMessageUploaderQueue {
  final _uploadQueue = <VMessageUploadModel>[];
  final _localStorage = VChatController.I.nativeApi.local.message;
  final _localRoom = VChatController.I.nativeApi.local.room;
  final _remoteStorage = VChatController.I.nativeApi.remote;
  final _log = Logger("VMessageUploaderQueue");

  /// Singleton pattern
  VMessageUploaderQueue._();

  /// Singleton instance
  static final _instance = VMessageUploaderQueue._();

  /// Getter for singleton instance
  static VMessageUploaderQueue get instance {
    return _instance;
  }

  void removeFromQueue(String localId) {
    _uploadQueue.removeWhere((e) => e.msgLocalId == localId);
  }

  /// Add a message to the queue and send it to the API
  /// [uploadModel] is the model of the message to be uploaded
  Future<void> addToQueue(VMessageUploadModel uploadModel) async {
    if (VPlatforms.isMobile) {
      await _moveFile(uploadModel.baseMessage);
    }
    if (!_uploadQueue.contains(uploadModel)) {
      _uploadQueue.add(uploadModel);
      if (VPlatforms.isMobile && uploadModel.baseMessage is VUploadMessage) {
        await _sendToMobileApi(uploadModel);
        return;
      }
      await _sendToWebApi(uploadModel);
    }
  }

  Future<void> _moveFile(VBaseMessage localMsg) async {
    if (localMsg.isForward) return;
    if (localMsg is VDownloadableMessage) {
      final dMessage = localMsg as VDownloadableMessage;
      await VFileUtils.copyFileToAppFolder(
        localFilePathWithExt: dMessage.localFilePathWithExt,
        pickedFilePath: dMessage.fileSource.fileLocalPath!,
      );
    }
  }

  /// Send the message to the API, handle errors and remove message from queue
  /// [uploadModel] is the model of the message to be sent
  Future<void> _sendToWebApi(VMessageUploadModel uploadModel) async {
    await _setSending(uploadModel);

    try {
      // Determine the room type to route to the correct API
      final room =
          await _localRoom.getOneWithLastMessageByRoomId(uploadModel.roomId);
      final VBaseMessage msg;

      if (room?.roomType == VRoomType.a) {
        // Route to announcement room API for announcement conversations
        msg = await _remoteStorage.announcementRoom
            .createAnnouncementMessage(uploadModel);
      } else {
        // Route to standard VChat API for normal conversations
        msg = await _remoteStorage.message.createMessage(uploadModel);
      }

      await _onSuccessToSend(msg);
    } catch (e) {
      if (e is VChatHttpForbidden) {
        if (kDebugMode) {
          print(e);
        }
        _log.warning("VChatBaseHttpException", e);
        await _deleteTheMessage(uploadModel);
      } else if (e is VChatBaseHttpException) {
        _log.info("VChatBaseHttpException", e);
        await _setErrorToMessage(uploadModel);
      } else if (e is VUserInternetException) {
        _log.info("UserInternetExceptionUserInternetException", e);
        await _setErrorToMessage(uploadModel);
      } else {
        _log.warning("_onUnknownException", e);
        // await _deleteTheMessage(uploadModel);
      }
    } finally {
      _uploadQueue.remove(uploadModel);
    }
  }

  Future<void> _sendToMobileApi(VMessageUploadModel uploadModel) async {
    _setSending(uploadModel);
    final base = uploadModel.baseMessage;
    final message = uploadModel.baseMessage as VUploadMessage;
    final oldTask = await FileDownloader().taskForId(base.localId);
    if (oldTask != null) {
      //this means this task already run!!
      _log.warning("This means this task already run!!");
      return;
    }
    final access = VAppPref.getHashedString(
      key: SStorageKeys.vAccessToken.name,
    );

    // Determine the room type to route to the correct API endpoint
    final room =
        await _localRoom.getOneWithLastMessageByRoomId(uploadModel.roomId);
    final String apiUrl;

    if (room?.roomType == VRoomType.a) {
      // Route to announcement room API for announcement conversations
      apiUrl =
          "${VAppConstants.baseUri}/announcement-rooms/${base.roomId}/messages";
    } else {
      // Route to standard VChat API for normal conversations
      apiUrl = "${VAppConstants.baseUri}/channel/${base.roomId}/message";
    }

    final task = UploadTask(
      url: apiUrl,
      filename: message.localFilePathWithExt,
      displayName: _getUploadGroupName(base),
      group: _getUploadGroupName(base),
      updates: Updates.statusAndProgress,
      // retries: 5,
      //add meta data here
      fields: uploadModel.getMapFromPartValuesUsingMap(),
      //add access token
      headers: {
        "authorization": "Bearer $access",
      },
      httpRequestMethod: "POST",
      metaData: base.roomId,
      directory: "media",
      taskId: base.localId,
    );
    FileDownloader().enqueue(task);
  }

  /// Delete a message by its local id
  /// [localId] is the local id of the message to be deleted
  Future<void> _deleteMessage(String localId) async {
    final baseMessage = await _localStorage.getMessageByLocalId(localId);
    if (baseMessage != null && !baseMessage.emitStatus.isServerConfirm) {
      await _localStorage.deleteMessageByLocalId(baseMessage);
    }
  }

  /// Set the message status to error
  /// [uploadModel] is the model of the message with an error
  Future _setErrorToMessage(VMessageUploadModel uploadModel) async {
    final VBaseMessage? baseMessage =
        await _localStorage.getMessageByLocalId(uploadModel.msgLocalId);
    if (baseMessage != null) {
      baseMessage.emitStatus = VMessageEmitStatus.error;
      await _localStorage.updateMessageSendingStatus(
        VUpdateMessageStatusEvent(
          roomId: baseMessage.roomId,
          localId: baseMessage.localId,
          emitState: baseMessage.emitStatus,
        ),
      );
    }
  }

  /// Delete a message from the queue
  /// [uploadModel] is the model of the message to be deleted
  Future _deleteTheMessage(VMessageUploadModel uploadModel) async {
    await _deleteMessage(uploadModel.msgLocalId);
  }

  /// Update the local message status to success upon successful send
  /// [messageModel] is the model of the successfully sent message
  Future _onSuccessToSend(VBaseMessage messageModel) async {
    await _localStorage.updateFullMessage(messageModel);
  }

  /// Clear the queue of all messages
  void clearQueue() {
    _uploadQueue.clear();
  }

  /// Set the message status to sending
  /// [uploadModel] is the model of the message that is being sent
  Future<void> _setSending(VMessageUploadModel uploadModel) async {
    await _localStorage.updateMessageSendingStatus(
      VUpdateMessageStatusEvent(
        roomId: uploadModel.roomId,
        localId: uploadModel.msgLocalId,
        emitState: VMessageEmitStatus.sending,
      ),
    );
  }

  String _getUploadGroupName(VBaseMessage base) {
    if (base is VFileMessage) return "files";
    if (base is VVideoMessage) return "files";
    return "images";
  }
}
