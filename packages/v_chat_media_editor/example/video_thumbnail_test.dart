// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';

import 'package:v_chat_media_editor/src/core/v_media_file_utils.dart';

/// Simple test utility for debugging video thumbnail generation
/// Usage: dart run example/video_thumbnail_test.dart /path/to/video.mp4
void main(List<String> args) async {
  if (args.isEmpty) {
    print(
        '❌ Usage: dart run example/video_thumbnail_test.dart /path/to/video.mp4');
    return;
  }

  final videoPath = args[0];
  final videoFile = File(videoPath);

  // Check if video file exists
  if (!await videoFile.exists()) {
    print('❌ Video file not found: $videoPath');
    return;
  }

  print('🎬 Video Thumbnail Generation Test');
  print('=====================================');
  print('Video path: $videoPath');

  // Get file size
  final fileSize = await videoFile.length();
  print('File size: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB');

  print('\n🧪 Starting thumbnail generation test...\n');

  // Test thumbnail generation
  final success = await VMediaFileUtils.testVideoThumbnailGeneration(videoPath);

  if (success) {
    print('\n✅ SUCCESS: Video thumbnail generation is working correctly!');
  } else {
    print('\n❌ FAILED: Video thumbnail generation is not working.');
    print('   Check the debug logs above for more details.');
  }

  print('\n📊 Thumbnail cache information:');
  final cacheInfo = await VMediaFileUtils.getThumbnailCacheInfo();
  print('   Total thumbnail files: ${cacheInfo['totalFiles']}');
  print('   Total cache size: ${cacheInfo['totalSizeMB']} MB');

  if (cacheInfo['totalFiles'] > 0) {
    print('\n🧹 Cleaning up old thumbnails...');
    await VMediaFileUtils.cleanupOldThumbnails(
        maxAgeHours: 0); // Clean all for testing
  }

  print('\n🎯 Test completed!');
}
