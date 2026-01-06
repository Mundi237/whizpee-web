// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:v_platform/v_platform.dart';
import 'package:v_chat_media_editor/src/core/v_media_file_utils.dart';

/// Test function to verify video_thumbnail package integration
/// This demonstrates how the enhanced thumbnail generation works
Future<void> testVideoThumbnailGeneration(String videoPath) async {
  if (kDebugMode) {
    print('🧪 Testing video thumbnail generation with video_thumbnail package');
    print('📹 Video path: $videoPath');
  }

  try {
    // Check if video file exists
    final videoFile = File(videoPath);
    if (!await videoFile.exists()) {
      if (kDebugMode) {
        print('❌ Video file does not exist: $videoPath');
      }
      return;
    }

    // Create VPlatformFile from video path
    final platformFile = VPlatformFile.fromPath(fileLocalPath: videoPath);
    
    if (kDebugMode) {
      print('📊 Video file size: ${(await videoFile.length() / (1024 * 1024)).toStringAsFixed(2)} MB');
    }

    // Generate thumbnail using the enhanced method
    final thumbnailData = await VMediaFileUtils.getVideoThumb(
      fileSource: platformFile,
      maxWidth: 600,
      quality: 75,
    );

    if (thumbnailData != null) {
      if (kDebugMode) {
        print('✅ Thumbnail generated successfully!');
        print('📁 Thumbnail path: ${thumbnailData.fileSource.fileLocalPath}');
        print('📐 Thumbnail dimensions: ${thumbnailData.width}x${thumbnailData.height}');
        if (thumbnailData.blurHash != null) {
          print('🎨 BlurHash: ${thumbnailData.blurHash}');
        }
      }
    } else {
      if (kDebugMode) {
        print('❌ Failed to generate thumbnail');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('❌ Error during thumbnail generation test: $e');
    }
  }
}

/// Example usage:
/// ```dart
/// await testVideoThumbnailGeneration('/path/to/your/video.mp4');
/// ```