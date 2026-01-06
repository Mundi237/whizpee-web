// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:v_platform/v_platform.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import './cropper_ui_helper.dart';

/// Utility class for picking files, images, videos with enhanced UX
abstract class VAppPick {
  static bool isPicking = false;
  static bool _enableHapticFeedback = true;

  /// Enable or disable haptic feedback for picker actions
  static void setHapticFeedback(bool enabled) {
    _enableHapticFeedback = enabled;
  }

  static void _triggerHaptic() {
    if (_enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }
  }

  static Future<VPlatformFile?> getCroppedImage({
    bool isFromCamera = false,
    required BuildContext context,
  }) async {
    _triggerHaptic();
    final img = await getImage(isFromCamera: isFromCamera);
    if (img != null) {
      if (VPlatforms.isMobile) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: img.fileLocalPath!,
          compressQuality: 70,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: CropperUIHelper.getAllPlatformSettings(context),
        );

        if (croppedFile == null) {
          _triggerHaptic();
          return null;
        }
        if (_enableHapticFeedback) {
          HapticFeedback.mediumImpact();
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
    if (isPicking) return null; // Prevent multiple simultaneous picks
    
    _triggerHaptic();
    isPicking = true;
    
    try {
      if (isFromCamera) {
        final picker = ImagePicker();
        final image = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );
        isPicking = false;
        if (image == null) {
          _triggerHaptic();
          return null;
        }
        if (_enableHapticFeedback) {
          HapticFeedback.mediumImpact();
        }
        return VPlatformFile.fromPath(fileLocalPath: image.path);
      }
      
      final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      isPicking = false;
      
      if (pickedFile == null) {
        _triggerHaptic();
        return null;
      }
      
      if (_enableHapticFeedback) {
        HapticFeedback.mediumImpact();
      }
      
      final file = pickedFile.files.first;
      if (file.bytes != null) {
        return VPlatformFile.fromBytes(name: file.name, bytes: file.bytes!);
      }
      return VPlatformFile.fromPath(fileLocalPath: file.path!);
    } catch (e) {
      isPicking = false;
      if (_enableHapticFeedback) {
        HapticFeedback.heavyImpact();
      }
      rethrow;
    }
  }

  static Future<List<VPlatformFile>?> getImages() async {
    if (isPicking) return null;
    
    _triggerHaptic();
    isPicking = true;
    
    try {
      final FilePickerResult? pickedFile = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: true);
      isPicking = false;
      
      if (pickedFile == null) {
        _triggerHaptic();
        return null;
      }
      
      if (_enableHapticFeedback) {
        HapticFeedback.mediumImpact();
      }
      
      return pickedFile.files.map((e) {
        if (e.bytes != null) {
          return VPlatformFile.fromBytes(
            name: e.name,
            bytes: e.bytes!,
          );
        }
        return VPlatformFile.fromPath(fileLocalPath: e.path!);
      }).toList();
    } catch (e) {
      isPicking = false;
      if (_enableHapticFeedback) {
        HapticFeedback.heavyImpact();
      }
      rethrow;
    }
  }

  static Future<List<VPlatformFile>?> getMedia() async {
    if (isPicking) return null;
    
    _triggerHaptic();
    isPicking = true;
    
    try {
      final xFiles = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
      );
      isPicking = false;
      
      if (xFiles == null || xFiles.files.isEmpty) {
        _triggerHaptic();
        return null;
      }
      
      if (_enableHapticFeedback) {
        HapticFeedback.mediumImpact();
      }
      
      return xFiles.files.map((e) {
        if (e.bytes != null) {
          return VPlatformFile.fromBytes(
            name: e.name,
            bytes: e.bytes!,
          );
        }
        return VPlatformFile.fromPath(fileLocalPath: e.path!);
      }).toList();
    } catch (e) {
      isPicking = false;
      if (_enableHapticFeedback) {
        HapticFeedback.heavyImpact();
      }
      rethrow;
    }
  }

  static Future<VPlatformFile?> getVideo() async {
    if (isPicking) return null;
    
    _triggerHaptic();
    isPicking = true;
    
    try {
      final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.video,
      );
      isPicking = false;
      
      if (pickedFile == null) {
        _triggerHaptic();
        return null;
      }
      
      if (_enableHapticFeedback) {
        HapticFeedback.mediumImpact();
      }
      
      final e = pickedFile.files.first;
      if (e.bytes != null) {
        return VPlatformFile.fromBytes(
          name: e.name,
          bytes: e.bytes!,
        );
      }
      return VPlatformFile.fromPath(fileLocalPath: e.path!);
    } catch (e) {
      isPicking = false;
      if (_enableHapticFeedback) {
        HapticFeedback.heavyImpact();
      }
      rethrow;
    }
  }

  static Future<List<VPlatformFile>?> getFiles() async {
    if (isPicking) return null;
    
    _triggerHaptic();
    isPicking = true;
    
    try {
      final FilePickerResult? xFiles = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );
      isPicking = false;
      
      if (xFiles == null || xFiles.files.isEmpty) {
        _triggerHaptic();
        return null;
      }
      
      if (_enableHapticFeedback) {
        HapticFeedback.mediumImpact();
      }
      
      return xFiles.files.map((e) {
        if (e.bytes != null) {
          return VPlatformFile.fromBytes(
            name: e.name,
            bytes: e.bytes!,
          );
        }
        return VPlatformFile.fromPath(fileLocalPath: e.path!);
      }).toList();
    } catch (e) {
      isPicking = false;
      if (_enableHapticFeedback) {
        HapticFeedback.heavyImpact();
      }
      rethrow;
    }
  }

  static Future<VPlatformFile?> pickFromWeAssetCamera({
    XFileCapturedCallback? onXFileCaptured,
    required BuildContext context,
    int videoSeconds = 45,
  }) async {
    final AssetEntity? entity = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: CameraPickerConfig(
        enableRecording: true,
        enableTapRecording: true,
        maximumRecordingDuration: Duration(seconds: videoSeconds),
        textDelegate: const EnglishCameraPickerTextDelegate(),
        onXFileCaptured: onXFileCaptured,
        shouldAutoPreviewVideo: true,
      ),
    );
    if (entity == null) {
      return null;
    }
    final f = (await entity.file)!;
    return VPlatformFile.fromPath(fileLocalPath: f.path);
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
    
    _triggerHaptic();
    
    try {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: file.fileLocalPath!,
        uiSettings: CropperUIHelper.getAllPlatformSettings(context),
      );
      
      if (croppedFile != null) {
        if (_enableHapticFeedback) {
          HapticFeedback.mediumImpact();
        }
        return VPlatformFile.fromPath(
          fileLocalPath: croppedFile.path,
        );
      }
      _triggerHaptic();
      return null;
    } catch (e) {
      if (_enableHapticFeedback) {
        HapticFeedback.heavyImpact();
      }
      rethrow;
    }
  }
}
