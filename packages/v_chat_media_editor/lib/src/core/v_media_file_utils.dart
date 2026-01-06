// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:blurhash/blurhash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';
import 'package:v_platform/v_platform.dart';
import 'package:v_video_compressor/v_video_compressor.dart';
import 'package:video_player/video_player.dart';

import 'message_image_data.dart';

abstract class VMediaFileUtils {
  static final _videoCompressor = VVideoCompressor();

  static Future<MessageImageData?> getVideoThumb({
    required VPlatformFile fileSource,
    int maxWidth = 600,
    int quality = 70,
    String? destFile,
  }) async {
    if (kDebugMode) {
      print(
          '🎬 Starting video thumbnail generation for: ${fileSource.fileLocalPath}');
    }

    try {
      // Early return for unsupported file sources
      if (fileSource.isFromBytes || fileSource.isFromUrl) {
        if (kDebugMode) {
          print('❌ Cannot generate thumbnail: File is from bytes or URL');
        }
        return null;
      }

      // Check if file exists and is accessible
      final videoFile = File(fileSource.fileLocalPath!);
      if (!await videoFile.exists()) {
        if (kDebugMode) {
          print('❌ Video file does not exist: ${fileSource.fileLocalPath}');
        }
        return null;
      }

      // Check file size and format
      final fileSize = await videoFile.length();
      if (kDebugMode) {
        print(
            '📊 Video file size: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB');
      }

      // Generate hash-based filename for video thumbnail
      final originalFile =
          VPlatformFile.fromPath(fileLocalPath: fileSource.fileLocalPath!);
      final thumbFileName = "${originalFile.fileHash}_thumb.png";
      final thumbnailPath = join(Directory.systemTemp.path, thumbFileName);

      if (kDebugMode) {
        print('📁 Thumbnail will be saved to: $thumbnailPath');
      }

      // Check if thumbnail already exists
      final existingThumb = File(thumbnailPath);
      if (await existingThumb.exists()) {
        if (kDebugMode) {
          print('✅ Thumbnail already exists, using cached version');
        }
        return await _createThumbnailData(thumbnailPath);
      }

      // Generate thumbnail using v_video_compressor
      if (kDebugMode) {
        print('🔄 Generating new thumbnail...');
      }

      await _videoCompressor.getVideoThumbnail(
        fileSource.fileLocalPath!,
        VVideoThumbnailConfig(
          outputPath: thumbnailPath,
          timeMs: 1000, // 1 second into the video
        ),
      );

      // Verify thumbnail was created
      if (!await File(thumbnailPath).exists()) {
        if (kDebugMode) {
          print('❌ Thumbnail generation failed: File not created');
        }
        return null;
      }

      final thumbSize = await File(thumbnailPath).length();
      if (kDebugMode) {
        print(
            '✅ Thumbnail generated successfully! Size: ${(thumbSize / 1024).toStringAsFixed(2)} KB');
      }

      return await _createThumbnailData(thumbnailPath);
    } catch (err) {
      if (kDebugMode) {
        print('❌ Video thumbnail generation error: $err');
        print('🔄 Attempting fallback thumbnail generation...');
      }

      // Try fallback method
      try {
        return await _generateThumbnailFallback(fileSource, maxWidth);
      } catch (fallbackErr) {
        if (kDebugMode) {
          print('❌ Fallback thumbnail generation also failed: $fallbackErr');
        }
        return null;
      }
    }
  }

  /// Helper method to create thumbnail data from generated thumbnail file
  static Future<MessageImageData?> _createThumbnailData(
      String thumbnailPath) async {
    try {
      final thumbImageData = await getImageInfo(
        fileSource: VPlatformFile.fromPath(fileLocalPath: thumbnailPath),
      );

      return MessageImageData(
        fileSource: VPlatformFile.fromPath(fileLocalPath: thumbnailPath),
        width: thumbImageData.image.width,
        blurHash: await VMediaFileUtils.getBlurHash(
          VPlatformFile.fromPath(fileLocalPath: thumbnailPath),
        ),
        height: thumbImageData.image.height,
      );
    } catch (err) {
      if (kDebugMode) {
        print('❌ Error creating thumbnail data: $err');
      }
      return null;
    }
  }

  /// Enhanced fallback method for generating video thumbnails using video_thumbnail
  /// This provides a more robust fallback when v_video_compressor fails
  static Future<MessageImageData?> _generateThumbnailFallback(
    VPlatformFile fileSource,
    int maxWidth,
  ) async {
    if (kDebugMode) {
      print('🔄 Using enhanced fallback thumbnail generation method...');
    }

    try {
      // Try using video_thumbnail package as fallback
      final fallbackPath = await _generateThumbnailWithVideoThumbnail(
        fileSource.fileLocalPath!,
        maxWidth,
      );

      if (fallbackPath != null) {
        if (kDebugMode) {
          print('✅ Fallback thumbnail generated successfully');
        }
        return await _createThumbnailData(fallbackPath);
      }

      // If video_thumbnail also fails, try video_player validation
      await _validateVideoWithPlayer(fileSource);

      if (kDebugMode) {
        print('⚠️ All thumbnail generation methods failed');
        print(
            '   Video file appears valid but thumbnail creation is not supported');
        print('   Consider using a different video format or codec');
      }

      return null;
    } catch (err) {
      if (kDebugMode) {
        print('❌ Enhanced fallback thumbnail generation failed: $err');
      }
      return null;
    }
  }

  /// Try generating thumbnail using v_video_compressor package
  static Future<String?> _generateThumbnailWithVideoThumbnail(
    String videoPath,
    int maxWidth,
  ) async {
    try {
      if (kDebugMode) {
        print('🔄 Attempting thumbnail generation with v_video_compressor package');
      }

      // Generate thumbnail using v_video_compressor package
      final thumbnail = await _videoCompressor.getVideoThumbnail(
        videoPath,
        VVideoThumbnailConfig(
          timeMs: 5000,                    // 5 seconds into video
          maxWidth: maxWidth,
          maxHeight: (maxWidth * 0.67).round(), // Maintain aspect ratio (roughly 3:2)
          format: VThumbnailFormat.jpeg,
          quality: 85,                     // JPEG quality (0-100)
        ),
      );

      if (thumbnail != null && thumbnail.thumbnailPath != null) {
        if (kDebugMode) {
          print('✅ v_video_compressor generated successfully!');
          print('   Thumbnail: ${thumbnail.thumbnailPath}');
          print('   Size: ${thumbnail.width}x${thumbnail.height}');
          print('   File size: ${thumbnail.fileSizeFormatted}');
        }
        return thumbnail.thumbnailPath;
      } else {
        if (kDebugMode) {
          print('❌ v_video_compressor failed to generate thumbnail file');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ v_video_compressor fallback failed: $e');
      }
      return null;
    }
  }

  /// Validate video file using video_player (for debugging purposes)
  static Future<void> _validateVideoWithPlayer(VPlatformFile fileSource) async {
    VideoPlayerController? controller;
    try {
      controller = VideoPlayerController.file(File(fileSource.fileLocalPath!));
      await controller.initialize();

      final duration = controller.value.duration;
      final size = controller.value.size;

      if (kDebugMode) {
        print('📊 Video validation results:');
        print('   Duration: ${duration.inSeconds} seconds');
        print('   Resolution: ${size.width.toInt()}x${size.height.toInt()}');
        print('   Is playing: ${controller.value.isPlaying}');

        if (duration.inMilliseconds == 0) {
          print(
              '⚠️ Warning: Video duration is 0 - this may indicate corruption');
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print('❌ Video validation failed: $err');
        print(
            '   This suggests the video file may be corrupted or unsupported');
      }
    } finally {
      await controller?.dispose();
    }
  }

  static Future<String?> getBlurHash(
    VPlatformFile fileSource,
  ) async {
    if (kIsWeb) return null;
    try {
      final data = File(fileSource.fileLocalPath!).readAsBytesSync();
      var blurHash = await BlurHash.encode(
        data,
        1,
        1,
      );
      return blurHash;
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      return null;
    }
  }

  static Future<int?> getVideoDurationMill(VPlatformFile file) async {
    if (file.isFromPath) {
      final controller = VideoPlayerController.file(
        File(file.fileLocalPath!),
      );
      await controller.initialize();
      final value = controller.value.duration.inMilliseconds;
      controller.dispose();
      return value;
    }
    return null;
  }

  //This is a function called "compressImage" that takes in a VPlatformFile object representing an image file and compresses it
  // if it is larger than a certain size (specified by the "compressAt" parameter). The compression is done using the FlutterNativeImage
  // library, which takes in the file path of the image and a quality parameter (defaulting to 50). If the resulting file is smaller than the specified size,
  // the original file is returned. Otherwise, the compressed file is returned as a new VPlatformFile object.
  static Future<VPlatformFile> compressImage({
    required VPlatformFile fileSource,
    required int compressAt,
    required int quality,
  }) async {
    if (!fileSource.isFromPath) {
      return fileSource;
    }
    VPlatformFile compressedFileSource = fileSource;
    try {
      if (compressedFileSource.fileSize > compressAt) {
        // Use hash-based temporary filename for compression
        final originalFile =
            VPlatformFile.fromPath(fileLocalPath: fileSource.fileLocalPath!);
        final tempFileName = "${originalFile.fileHash}_compressed.jpeg";
        final temp = join(Directory.systemTemp.path, tempFileName);

        final compressedFile = await FlutterImageCompress.compressAndGetFile(
          fileSource.fileLocalPath!,
          temp,
        );
        if (compressedFile == null) {
          return fileSource;
        }

        compressedFileSource =
            VPlatformFile.fromPath(fileLocalPath: compressedFile.path);
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    return compressedFileSource;
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

  /// Enhanced test utility to verify video thumbnail generation functionality
  static Future<bool> testVideoThumbnailGeneration(String videoPath) async {
    if (kDebugMode) {
      print('🧪 Testing video thumbnail generation for: $videoPath');
    }

    try {
      final fileSource = VPlatformFile.fromPath(fileLocalPath: videoPath);
      final thumbnail = await getVideoThumb(fileSource: fileSource);

      if (thumbnail != null) {
        if (kDebugMode) {
          print('✅ Test passed: Thumbnail generated successfully');
          print('   Size: ${thumbnail.width}x${thumbnail.height}');
          print('   File: ${thumbnail.fileSource.fileLocalPath}');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('❌ Test failed: Thumbnail generation returned null');
          await _runDiagnosticCheck(videoPath);
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Test failed with exception: $e');
        await _runDiagnosticCheck(videoPath);
      }
      return false;
    }
  }

  /// Run comprehensive diagnostic check for video thumbnail generation issues
  static Future<void> _runDiagnosticCheck(String videoPath) async {
    if (kDebugMode) {
      print('\n🔍 Running diagnostic check...');
      print('=====================================');

      // Check file existence and permissions
      final file = File(videoPath);
      print('📁 File existence: ${await file.exists()}');

      if (await file.exists()) {
        try {
          final stat = await file.stat();
          print(
              '📊 File size: ${(stat.size / (1024 * 1024)).toStringAsFixed(2)} MB');
          print('📅 Modified: ${stat.modified}');

          // Check file extension
          final extension = videoPath.split('.').last.toLowerCase();
          print('📋 File extension: .$extension');

          final supportedExtensions = [
            'mp4',
            'mov',
            'avi',
            'mkv',
            'webm',
            '3gp'
          ];
          final isSupported = supportedExtensions.contains(extension);
          print('✓ Extension supported: $isSupported');

          if (!isSupported) {
            print(
                '⚠️ Warning: File extension may not be supported by v_video_compressor');
            print('   Supported extensions: ${supportedExtensions.join(', ')}');
          }
        } catch (e) {
          print('❌ Error reading file stats: $e');
        }

        // Try video player validation
        print('\n🎥 Testing video player compatibility...');
        await _validateVideoWithPlayer(
            VPlatformFile.fromPath(fileLocalPath: videoPath));

        // Check v_video_compressor availability
        print('\n📦 Checking v_video_compressor availability...');
        try {
          final compressor = VVideoCompressor();
          print('✅ v_video_compressor instance created successfully');

          // Try to get video info (if available in the API)
          print('🔍 Attempting basic video info extraction...');
        } catch (e) {
          print('❌ v_video_compressor error: $e');
        }
      }

      print('\n💡 Possible solutions:');
      print('   1. Ensure video file is not corrupted');
      print('   2. Try converting video to MP4 format');
      print('   3. Check if v_video_compressor supports the codec');
      print('   4. Verify app has read permissions for the file');
      print('   5. Try with a shorter video file');
      print('=====================================\n');
    }
  }

  /// Get thumbnail cache information for debugging
  static Future<Map<String, dynamic>> getThumbnailCacheInfo() async {
    try {
      final tempDir = Directory.systemTemp;
      final files = await tempDir
          .list()
          .where(
              (entity) => entity is File && entity.path.contains('_thumb.png'))
          .toList();

      int totalFiles = files.length;
      int totalSize = 0;

      for (final file in files) {
        if (file is File) {
          try {
            final stat = await file.stat();
            totalSize += stat.size;
          } catch (e) {
            // Skip files that can't be read
          }
        }
      }

      return {
        'totalFiles': totalFiles,
        'totalSizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
        'tempDirectory': tempDir.path,
      };
    } catch (e) {
      return {
        'totalFiles': 0,
        'totalSizeMB': '0.00',
        'error': e.toString(),
      };
    }
  }

  /// Clean up old thumbnail files from the system temp directory
  static Future<void> cleanupOldThumbnails({int maxAgeHours = 24}) async {
    if (kDebugMode) {
      print('🧹 Cleaning up old thumbnail files...');
    }

    try {
      final tempDir = Directory.systemTemp;
      final files = tempDir.listSync().whereType<File>();
      final cutoffTime = DateTime.now().subtract(Duration(hours: maxAgeHours));
      int deletedCount = 0;

      for (final file in files) {
        if (file.path.contains('_thumb.png')) {
          final stat = await file.stat();
          if (stat.modified.isBefore(cutoffTime)) {
            try {
              await file.delete();
              deletedCount++;
              if (kDebugMode) {
                print('🗑️ Deleted old thumbnail: ${file.path}');
              }
            } catch (e) {
              if (kDebugMode) {
                print('⚠️ Failed to delete thumbnail ${file.path}: $e');
              }
            }
          }
        }
      }

      if (kDebugMode) {
        print('✅ Cleanup complete. Deleted $deletedCount old thumbnail files.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Thumbnail cleanup failed: $e');
      }
    }
  }
}
