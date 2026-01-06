// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';
import 'package:path/path.dart' as p;
import "package:universal_html/html.dart" as html;

abstract class VFileUtils {
  static Future<String> _downloadPath() async {
    final path = (await getApplicationDocumentsDirectory()).path;

    ///data/user/0/com.xxx.xxx/app_flutter/media
    return join(path, "media");
  }

  static String downloadPath() {
    return VAppPref.getStringOrNullKey(SStorageKeys.appRootPath.name)!;
  }

  static bool isFileExists(String filePath) {
    final rootPath = VAppPref.getStringOrNullKey(SStorageKeys.appRootPath.name);
    if (rootPath == null) {
      if (kDebugMode) {
        print(
          "WORKING isFileExists method getStringOrNullKey return null !!!! in abstract class VFileUtils ",
        );
      }
      return false;
    }
    return File(join(rootPath, filePath)).existsSync();
  }

  static String getLocalPath(String hashIdWithExt) {
    final rootPath = VAppPref.getStringOrNullKey(SStorageKeys.appRootPath.name);
    return join(rootPath!, hashIdWithExt);
  }

  static Future<void> copyFileToAppFolder({
   required String localFilePathWithExt,
    required String pickedFilePath,
  }) async {
    final rootPath = await _downloadPath();
    final newPath = join(rootPath, localFilePathWithExt);
    await File(pickedFilePath).copy(newPath);
  }

  /// Saves file bytes to app directory using hash-based naming
  /// Returns the VPlatformFile with proper hash-based name
  static Future<VPlatformFile> saveBytesWithHashName({
    required List<int> bytes,
    required String originalExtension,
    String? customName,
  }) async {
    // Create VPlatformFile from bytes to get proper SHA-256 hash
    final tempFile = VPlatformFile.fromBytes(
      name: customName ?? "temp$originalExtension",
      bytes: bytes,
    );

    // Create hash-based filename
    final hashBasedName = "${tempFile.fileHash}$originalExtension";

    // Get app directory path
    final rootPath = await _downloadPath();

    // Save file with hash-based name
    final filePath = join(rootPath, hashBasedName);
    await File(filePath).writeAsBytes(bytes);

    // Return VPlatformFile with proper path and hash
    return VPlatformFile.fromPath(fileLocalPath: filePath);
  }



  static Future<void> refreshAppPath() async {
    final rootPath = await _downloadPath();
    if (!await Directory(rootPath).exists()) {
      await Directory(rootPath).create(recursive: true);
    }
    await VAppPref.setStringKey(SStorageKeys.appRootPath.name, rootPath);
  }

  static Future<ImageInfo> getImageInfo({
    required VPlatformFile fileSource,
  }) async {
    final Image image = fileSource.isFromBytes
        ? Image.memory(Uint8List.fromList(fileSource.bytes!))
        : Image.file(File(fileSource.fileLocalPath!));
    final completer = Completer<ImageInfo>();
    final listener = ImageStreamListener((info, _) => completer.complete(info));
    image.image.resolve(const ImageConfiguration()).addListener(listener);
    return completer.future;
  }

  static Future<String> _downloadFileForWeb(
    VPlatformFile fileSource,
  ) async {
    if (VPlatforms.isWeb) {
      html.AnchorElement anchorElement =
          html.AnchorElement(href: fileSource.fullNetworkUrl!);
      anchorElement.download = basename(fileSource.fullNetworkUrl!);
      anchorElement.target = "black";
      anchorElement.click();
      return "";
    }

    return await FileSaver.instance.saveFile(
      name: fileSource.name,
      link: LinkDetails(link: fileSource.fullNetworkUrl!),
      fileExtension: p.extension(fileSource.name),
      mimeType: EnumToString.fromString(
            MimeType.values,
            fileSource.getMimeType ?? "xx",
          ) ??
          MimeType.other,
    );
  }

  /// make sure you ask for storage permissions
  ///make sure you ask for storage permissions
  static Future<String> saveFileToPublicPath({
    required VPlatformFile fileAttachment,
  }) async {
    if (VPlatforms.isMobile) {
      await FileSaver.instance.saveAs(
        name: basename(fileAttachment.name),
        mimeType: EnumToString.fromString(
              MimeType.values,
              fileAttachment.getMimeType ?? "xx",
            ) ??
            MimeType.other,
        link: LinkDetails(link: fileAttachment.fullNetworkUrl!),
        fileExtension: extension(fileAttachment.name).substring(1),
      );
    }
    return _downloadFileForWeb(fileAttachment);
  }
}
