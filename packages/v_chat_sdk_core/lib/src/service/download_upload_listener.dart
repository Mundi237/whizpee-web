// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:background_downloader/background_downloader.dart';
import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class DownloadUploadListener {
  final VNativeApi nativeApi;
  final VChatConfig vChatConfig;
  final VNavigator vNavigator;
  final _log = Logger("DownloadUploadListener");

  DownloadUploadListener(
    this.nativeApi,
    this.vChatConfig,
    this.vNavigator,
  ) {
    _init();
  }

  final _localStorage = VChatController.I.nativeApi.local.message;

  Future<void> _init() async {
    FileDownloader().updates.listen((update) {
      final task = update.task;
      if (task is UploadTask) {
        _handleResForUploadTask(update);
        return;
      }
      _handleResForDownloadTask(update);
    });
  }

  void emitUpdateDownload(Task task, bool isDownloading) {
    VChatController.I.nativeApi.local.message.updateIsDownloadingMessage(
      VUpdateIsDownloadMessageEvent(
        roomId: task.metaData,
        isDownloading: isDownloading,
        localId: task.taskId,
      ),
    );
  }

  void _handleResForUploadTask(TaskUpdate update) {
    final task = update.task;
    if (update is TaskStatusUpdate) {
      switch (update.status) {
        case TaskStatus.enqueued:
          break;
        case TaskStatus.running:
          break;
        case TaskStatus.complete:
          if (update.responseBody == null) return;
          _onSuccessToSendMessage(update.responseBody!);
          break;

        ///this not means 404 this means the file not found to start upload!! this happens when the plugin
        ///can not find the local file in the file in the upload path
        case TaskStatus.notFound:
          _deleteMessage(task.taskId);
          break;
        case TaskStatus.failed:
          _onFailedToUploadTask(task, update);
          break;
        case TaskStatus.canceled:
          _onCancelUploadTask(task);
          break;
        case TaskStatus.waitingToRetry:
        case TaskStatus.paused:
      }
    }
    if (update is TaskProgressUpdate) {
      VEventBusSingleton.vEventBus.fire(
        VUpdateProgressMessageEvent(
          roomId: update.task.metaData,
          progress: update.progress,
          localId: update.task.taskId,
        ),
      );
    }
  }

  void _handleResForDownloadTask(TaskUpdate update) {
    if (update is TaskStatusUpdate) {
      switch (update.status) {
        case TaskStatus.enqueued:
          break;
        case TaskStatus.running:
          emitUpdateDownload(update.task, true);
          break;
        case TaskStatus.complete:
          emitUpdateDownload(update.task, false);
          break;
        case TaskStatus.notFound:
          emitUpdateDownload(update.task, false);
          break;
        case TaskStatus.failed:
          emitUpdateDownload(update.task, false);
          break;
        case TaskStatus.canceled:
          emitUpdateDownload(update.task, false);
          break;
        case TaskStatus.waitingToRetry:
          emitUpdateDownload(update.task, true);
          break;
        case TaskStatus.paused:
          emitUpdateDownload(update.task, false);
      }
    }
    if (update is TaskProgressUpdate) {
      VEventBusSingleton.vEventBus.fire(
        VUpdateProgressMessageEvent(
          roomId: update.task.metaData,
          progress: update.progress,
          localId: update.task.taskId,
        ),
      );
    }
  }

  Future<void> _onSuccessToSendMessage(String res) async {
    final rowMessage = (jsonDecode(res) as Map<String, dynamic>)['data']
        as Map<String, dynamic>;
    final newMessage = MessageFactory.createBaseMessage(rowMessage);
    VMessageUploaderQueue.instance.removeFromQueue(newMessage.localId);
    await _localStorage.updateFullMessage(
      newMessage,
    );
  }

  Future<void> _deleteMessage(String localId) async {
    // final baseMessage = await _localStorage.getMessageByLocalId(localId);
    // if (baseMessage != null && !baseMessage.emitStatus.isServerConfirm) {
    //   await _localStorage.deleteMessageByLocalId(baseMessage);
    // }
    // VMessageUploaderQueue.instance.removeFromQueue(localId);
  }

  Future<void> _onFailedToUploadTask(Task task, TaskStatusUpdate update) async {
    final exception = update.exception!;
    print("----------");
    print(exception);
    print("----------");
    if (exception is TaskHttpException) {
      await _deleteMessage(task.taskId);
      _log.warning("TaskHttpException While Upload $exception");
    }
    if (exception is TaskUrlException) {
      await _deleteMessage(task.taskId);
      _log.warning("TaskUrlException While Upload $exception", exception);
    }
    if (exception is TaskConnectionException) {
      // here i should re send the message again!
      await _setErrorToMessage(task.taskId);
      _log.warning(
        "TaskConnectionException While Upload $exception",
        exception,
      );
    }
    if (exception is TaskFileSystemException) {
      await _deleteMessage(task.taskId);
      _log.warning(
        "TaskFileSystemException While Upload $exception",
        exception,
      );
    }
    if (exception is TaskResumeException) {
      await _deleteMessage(task.taskId);
      _log.warning("TaskResumeException While Upload $exception", exception);
    }
    VMessageUploaderQueue.instance.removeFromQueue(task.taskId);
  }

  void _onCancelUploadTask(Task task) {
    _setErrorToMessage(task.taskId);
    VMessageUploaderQueue.instance.removeFromQueue(task.taskId);
    FileDownloader().cancelTaskWithId(task.taskId);
  }

  Future _setErrorToMessage(String localId) async {
    final VBaseMessage? baseMessage =
        await _localStorage.getMessageByLocalId(localId);
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
}
