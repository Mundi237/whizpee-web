// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:v_platform/v_platform.dart';
import 'package:super_up_core/super_up_core.dart';

abstract class VAppPick {
  static bool isPicking = false;

  static Future<VPlatformFile?> getCroppedImage({
    bool isFromCamera = false,
    required BuildContext context,
  }) async {
    final img = await getImage(isFromCamera: isFromCamera);
    if (img != null) {
      if (VPlatforms.isMobile) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: img.fileLocalPath!,
          compressQuality: 70,
          compressFormat: ImageCompressFormat.png,
          uiSettings: CropperUIHelper.getAllPlatformSettings(context),
        );

        if (croppedFile == null) {
          return null;
        }
        return VPlatformFile.fromPath(fileLocalPath: croppedFile.path);
      }
      return img;
    }
    return null;
  }

  static Future<VPlatformFile?> getImage({
    bool isFromCamera = false,
  }) async {
    isPicking = true;
    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    isPicking = false;
    if (pickedFile == null) return null;
    final file = pickedFile.files.first;
    if (file.bytes != null) {
      return VPlatformFile.fromBytes(name: file.name, bytes: file.bytes!);
    }
    return VPlatformFile.fromPath(fileLocalPath: file.path!);
  }

  static Future<List<VPlatformFile>?> getImages() async {
    isPicking = true;
    final FilePickerResult? pickedFile = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: true);
    isPicking = false;
    if (pickedFile == null) return null;
    return pickedFile.files.map((e) {
      if (e.bytes != null) {
        return VPlatformFile.fromBytes(
          name: e.name,
          bytes: e.bytes!,
        );
      }
      return VPlatformFile.fromPath(fileLocalPath: e.path!);
    }).toList();
  }

  static Future<List<VPlatformFile>?> getMedia() async {
    isPicking = true;
    final xFiles = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: true,
    );
    isPicking = false;
    if (xFiles == null) return null;
    if (xFiles.files.isEmpty) return null;
    return xFiles.files.map((e) {
      if (e.bytes != null) {
        return VPlatformFile.fromBytes(
          name: e.name,
          bytes: e.bytes!,
        );
      }
      return VPlatformFile.fromPath(fileLocalPath: e.path!);
    }).toList();
  }

  static Future<VPlatformFile?> getVideo() async {
    isPicking = true;
    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    isPicking = false;
    if (pickedFile == null) return null;
    final e = pickedFile.files.first;
    if (e.bytes != null) {
      return VPlatformFile.fromBytes(
        name: e.name,
        bytes: e.bytes!,
      );
    }
    return VPlatformFile.fromPath(fileLocalPath: e.path!);
  }

  static Future<List<VPlatformFile>?> getFiles() async {
    isPicking = true;
    final FilePickerResult? xFiles = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    isPicking = false;
    if (xFiles == null) return null;
    if (xFiles.files.isEmpty) return null;
    return xFiles.files.map((e) {
      if (e.bytes != null) {
        return VPlatformFile.fromBytes(
          name: e.name,
          bytes: e.bytes!,
        );
      }
      return VPlatformFile.fromPath(fileLocalPath: e.path!);
    }).toList();
  }

  static Future clearPickerCache() async {
    await FilePicker.platform.clearTemporaryFiles();
  }

  static Future<VPlatformFile?> croppedImage({
    required VPlatformFile file,
    required BuildContext context,
    List<CropAspectRatioPreset>? aspectRatioPresets,
  }) async {
    if (!file.isContentImage) return null;
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.fileLocalPath!,
      uiSettings: CropperUIHelper.getAllPlatformSettings(context),

    );
    if (croppedFile != null) {
      return VPlatformFile.fromPath(
        fileLocalPath: croppedFile.path,
      );
    }
    return null;
  }
}
