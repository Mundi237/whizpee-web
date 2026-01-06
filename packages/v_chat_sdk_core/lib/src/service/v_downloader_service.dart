// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:background_downloader/background_downloader.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

class VDownloaderService {
  VDownloaderService._();

  final _mediaService = AutoDownloadMediaService();

  static final instance = VDownloaderService._();

  Future<String> addToQueue(VBaseMessage message) async {
    if (message is VFileMessage) {
      return _startDownload(message.data.fileSource);
      // _downloadQueue.removeWhere((e) => e.localId == message.localId);
    } else if (message is VVoiceMessage) {
      return _startDownload(message.data.fileSource);
    }
    return "";
  }

  Future<void> addToMobileQueue(VBaseMessage message) async {
    await VChatController.I.nativeApi.local.message.updateIsDownloadingMessage(
      VUpdateIsDownloadMessageEvent(
        roomId: message.roomId,
        localId: message.localId,
        isDownloading: true,
      ),
    );
    if (message is VDownloadableMessage) {
      _addToDownloaderPackage(message as VDownloadableMessage);
    }
  }

  Future<void> checkIfCanAutoDownloadFor(List<VBaseMessage> messages) async {
    if (!VPlatforms.isMobile) return;
    final connectivityResult = await Connectivity().checkConnectivity();
    final isMobile = connectivityResult.contains(ConnectivityResult.mobile);
    final isWifi = connectivityResult.contains(ConnectivityResult.wifi);
    for (final message in messages) {
      if (message is! VDownloadableMessage) continue;
      final dMessage = message as VDownloadableMessage;
      if (dMessage.isFileDownloaded) continue;
      if (message is VImageMessage) _imageCheck(isWifi, isMobile, message);
      if (message is VVideoMessage) _videoCheck(isWifi, isMobile, message);
      if (message is VFileMessage) _fileCheck(isWifi, isMobile, message);
    }
  }

  Future<String> _startDownload(VPlatformFile source) async {
    return await VFileUtils.saveFileToPublicPath(
      fileAttachment: source,
    );
  }

  Future<void> _addToDownloaderPackage(VDownloadableMessage message) async {
    ///How can i stop show Notification for some tasks iam download images but i want to stop show notifications for images
    ///but it should be for files and videos
    final base = message as VBaseMessage;
    final oldTask = await FileDownloader().taskForId(base.localId);
    if (oldTask != null) {
      //this means this task already run!!
      return;
    }
    final task = DownloadTask(
      url: message.fileSource.fullNetworkUrl!,
      filename: message.localFilePathWithExt,
      displayName: _getDownloadGroupName(base),
      group: _getDownloadGroupName(base),
      updates: Updates.statusAndProgress,
      retries: 5,
      metaData: base.roomId,
      directory: "media",
      taskId: base.localId,
    );
    FileDownloader().enqueue(task);
  }

  String _getDownloadGroupName(VBaseMessage base) {
    if (base is VFileMessage) return "files";
    if (base is VVideoMessage) return "files";
    return "images";
  }

  void _imageCheck(bool isWifi, bool isMobile, VImageMessage message) {
    ///image check for wifi
    if (isWifi && _mediaService.wifiImage) addToMobileQueue(message);

    ///image check for mobile
    if (isMobile && _mediaService.mobileImage) addToMobileQueue(message);
  }

  void _videoCheck(bool isWifi, bool isMobile, VVideoMessage message) {
    ///video check for wifi
    if (isWifi && _mediaService.wifiVideo) addToMobileQueue(message);

    ///video check for mobile
    if (isMobile && _mediaService.mobileVideo) addToMobileQueue(message);
  }

  void _fileCheck(bool isWifi, bool isMobile, VFileMessage message) {
    ///file check for wifi
    if (isWifi && _mediaService.wifiFile) addToMobileQueue(message);

    ///file check for mobile
    if (isMobile && _mediaService.mobileFile) addToMobileQueue(message);
  }
}
