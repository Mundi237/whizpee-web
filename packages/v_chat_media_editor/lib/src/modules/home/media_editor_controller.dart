// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pro_image_editor/core/models/editor_callbacks/pro_image_editor_callbacks.dart';
import 'package:pro_image_editor/features/main_editor/main_editor.dart';

import 'package:v_platform/v_platform.dart';
import 'package:v_video_compressor/v_video_compressor.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart' as core;

import '../../core/core.dart';
import '../../core/message_image_data.dart';
import '../../core/message_video_data.dart';
import '../video_editor/v_video_player.dart' as local_video;
import '../video_editor/enhanced_video_trimmer_view.dart';
import '../video_editor/video_editor_view.dart';
import 'widgets/video_compression_options.dart';
import 'app_pick.dart' as local_pick;

class MediaEditorController extends ValueNotifier {
  MediaEditorController(this.platformFiles, this.config) : super(null) {
    _init();
  }

  final List<VPlatformFile> platformFiles;
  final mediaFiles = <VBaseMediaRes>[];
  final VMediaEditorConfig config;
  bool isLoading = true;
  bool isCompressing = false;
  double compressionProgress = 0.0;
  String? currentCompressingFile;
  final _compressor = VVideoCompressor();
  final Map<String, VVideoCompressQuality> _videoCompressionSettings = {};
  final Map<String, String> _videoCompressionSettingsDisplay =
      {}; // For storing display names
  int currentImageIndex = 0;

  final pageController = PageController();

  void onEmptyPress(BuildContext context) {
    Navigator.pop(context);
  }

  void onDelete(VBaseMediaRes item, BuildContext context) {
    mediaFiles.remove(item);
    if (mediaFiles.isEmpty) {
      return Navigator.pop(context);
    }
    _updateScreen();
  }

  Future<void> onCrop(VMediaImageRes item, BuildContext context) async {
    final res = await local_pick.VAppPick.croppedImage(
        file: item.data.fileSource, context: context);
    item.data.fileSource = res!;
    _updateScreen();
  }

  Future onStartEditVideo(
    VMediaVideoRes item,
    BuildContext context,
  ) async {
    if (item.data.isFromPath) {
      final outputPath = await Navigator.push(
        context,
        MaterialPageRoute<String?>(
          builder: (BuildContext context) =>
              TrimmerView(File(item.data.fileSource.fileLocalPath!)),
        ),
      );
      if (outputPath != null) {
        item.data.fileSource =
            VPlatformFile.fromPath(fileLocalPath: outputPath);
        _updateScreen();
      }
    }
  }

  Future<void> onStartDraw(
    VBaseMediaRes item,
    BuildContext context,
  ) async {
    if (item is VMediaImageRes) {
      if (item.data.isFromBytes) {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProImageEditor.memory(
                callbacks: ProImageEditorCallbacks(
                  onImageEditingComplete: (bytes) async {
                    item.data.fileSource = VPlatformFile.fromBytes(
                      name: item.data.fileSource.name,
                      bytes: bytes,
                    );
                    _updateScreen();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
                Uint8List.fromList(item.data.fileSource.bytes!),
              ),
            ),
          );
        }
      } else {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProImageEditor.file(
                File(item.data.fileSource.fileLocalPath!),
                callbacks: ProImageEditorCallbacks(
                  onImageEditingComplete: (bytes) async {
                    if (VPlatforms.isWeb) {
                      final savedFile = VPlatformFile.fromBytes(
                          name: "edited_image.png", bytes: bytes);
                      item.data.fileSource = savedFile;
                    } else {
                      // Save edited image with hash-based filename
                      final savedFile =
                          await core.VFileUtils.saveBytesWithHashName(
                        bytes: bytes,
                        originalExtension: '.png',
                        customName: 'edited_image.png',
                      );

                      item.data.fileSource = savedFile;
                    }

                    _updateScreen();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
          );
        }
      }
    }
  }

  void close() {
    pageController.dispose();
    // Only cleanup on mobile platforms (not web)
    if (VPlatforms.isMobile && !VPlatforms.isWeb) {
      _compressor.cleanup();
    }
  }

  void changeImageIndex(int index) {
    currentImageIndex = index;
    pageController.jumpToPage(index);
    for (final element in mediaFiles) {
      element.isSelected = false;
    }
    mediaFiles[index].isSelected = true;
    _updateScreen();
  }

  void _updateScreen() {
    notifyListeners();
  }

  Future _init() async {
    // Clean up old thumbnail files (older than 24 hours)
    VMediaFileUtils.cleanupOldThumbnails();

    for (final f in platformFiles) {
      if (f.getMediaType == VSupportedFilesType.image) {
        final mImage = VMediaImageRes(
          data: MessageImageData(
            fileSource: f,
            blurHash: null,
            width: -1,
            height: -1,
          ),
        );
        mediaFiles.add(mImage);
      } else if (f.getMediaType == VSupportedFilesType.video) {
        MessageImageData? thumb;
        if (f.fileLocalPath != null) {
          thumb = await _getThumb(f.fileLocalPath!);
        }
        final mFile = VMediaVideoRes(
          data: MessageVideoData(
            fileSource: f,
            duration: -1,
            thumbImage: thumb,
          ),
        );
        mediaFiles.add(mFile);
      } else {
        mediaFiles.add(VMediaFileRes(data: f));
      }
    }
    mediaFiles[0].isSelected = true;
    isLoading = false;
    _updateScreen();
    startCompressImagesIfNeed();
  }

  Future<MessageImageData?> _getThumb(String path) async {
    if (kDebugMode) {
      print('🎯 Generating thumbnail for video: ${path.split('/').last}');
    }

    final result = await VMediaFileUtils.getVideoThumb(
      fileSource: VPlatformFile.fromPath(
        fileLocalPath: path,
      ),
    );

    if (kDebugMode) {
      if (result != null) {
        print(
            '✅ Thumbnail generated successfully for: ${path.split('/').last}');
      } else {
        print('❌ Failed to generate thumbnail for: ${path.split('/').last}');
      }
    }

    return result;
  }

  void onPlayVideo(VBaseMediaRes item, BuildContext context) {
    if (item is VMediaVideoRes) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => local_video.VVideoPlayer(
            platformFileSource: item.data.fileSource,
            appName: "media_editor",
          ),
        ),
      );
    }
  }

  Future<void> startCompressImagesIfNeed() async {
    for (final f in mediaFiles) {
      if (f is VMediaImageRes) {
        f.data.fileSource = (await VMediaFileUtils.compressImage(
          fileSource: f.data.fileSource,
          quality: config.imageQuality,
          compressAt: config.startCompressAt,
        ));
      }
      _updateScreen();
    }
  }

  /// Handle video compression options
  Future<void> onCompressVideo(VBaseMediaRes item, BuildContext context) async {
    if (item is! VMediaVideoRes || !item.data.isFromPath) return;
    if (!VPlatforms.isMobile || VPlatforms.isWeb) return;

    final videoPath = item.data.fileSource.fileLocalPath!;

    // Get current setting or use default
    final currentQuality =
        _videoCompressionSettings[videoPath] ?? config.videoCompressionQuality;

    // Show compression options
    final selectedQuality = await showVideoCompressionOptions(
      context,
      videoPath: videoPath,
      initialQuality: currentQuality,
    );

    if (selectedQuality != null) {
      // Store the compression setting for this video
      _videoCompressionSettings[videoPath] = selectedQuality;

      // Store display name for UI purposes
      final s = S.of(context);
      final qualityName = _getQualityDisplayName(selectedQuality, s);
      _videoCompressionSettingsDisplay[videoPath] = qualityName;

      // Mark video as having custom settings (trigger UI update)
      _updateScreen();

      // Show a confirmation message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    s.compressionQualitySetTo(qualityName),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: S.of(context).viewAll,
              textColor: Colors.white,
              onPressed: () => _showAllCompressionSettings(context),
            ),
          ),
        );
      }
    } else {
      // User cancelled - remove any existing setting to reset to default
      _videoCompressionSettings.remove(videoPath);
      _videoCompressionSettingsDisplay.remove(videoPath);
      _updateScreen();
    }
  }

  String _getQualityDisplayName(VVideoCompressQuality quality,
      [S? translations]) {
    final s = translations;
    switch (quality) {
      case VVideoCompressQuality.ultraLow:
        return s?.ultraLowQuality ?? 'Ultra Low';
      case VVideoCompressQuality.veryLow:
        return s?.veryLowQuality ?? 'Very Low';
      case VVideoCompressQuality.low:
        return s?.lowQuality ?? 'Low';
      case VVideoCompressQuality.medium:
        return s?.mediumQuality ?? 'Medium';
      case VVideoCompressQuality.high:
        return s?.highQuality ?? 'High';
    }
  }

  /// Cancel ongoing compression
  Future<void> cancelCompression() async {
    if (isCompressing) {
      await _compressor.cancelCompression();
      isCompressing = false;
      compressionProgress = 0.0;
      currentCompressingFile = null;
      _updateScreen();
    }
  }

  /// Check if a video has custom compression settings
  bool hasCustomCompressionSettings(VMediaVideoRes video) {
    if (!video.data.isFromPath) return false;
    final videoPath = video.data.fileSource.fileLocalPath!;
    return _videoCompressionSettings.containsKey(videoPath);
  }

  /// Get compression quality for a specific video
  VVideoCompressQuality? getCompressionQuality(VMediaVideoRes video) {
    if (!video.data.isFromPath) return null;
    final videoPath = video.data.fileSource.fileLocalPath!;
    return _videoCompressionSettings[videoPath];
  }

  /// Get compression quality display name for a specific video
  String? getCompressionQualityDisplay(VMediaVideoRes video) {
    if (!video.data.isFromPath) return null;
    final videoPath = video.data.fileSource.fileLocalPath!;
    return _videoCompressionSettingsDisplay[videoPath];
  }

  /// Remove compression settings for a video
  void removeCompressionSettings(VMediaVideoRes video) {
    if (!video.data.isFromPath) return;
    final videoPath = video.data.fileSource.fileLocalPath!;
    _videoCompressionSettings.remove(videoPath);
    _videoCompressionSettingsDisplay.remove(videoPath);
    _updateScreen();
  }

  /// Show all compression settings dialog
  void _showAllCompressionSettings(BuildContext context) {
    if (_videoCompressionSettings.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).compressionSettings),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _videoCompressionSettings.entries.map((entry) {
            final fileName = entry.key.split('/').last;
            final quality =
                _videoCompressionSettingsDisplay[entry.key] ?? entry.value.name;
            return ListTile(
              leading:
                  Icon(Icons.video_file, color: Theme.of(context).primaryColor),
              title: Text(fileName, style: const TextStyle(fontSize: 14)),
              subtitle: Text('Quality: $quality',
                  style: TextStyle(color: Colors.grey.shade600)),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () {
                  _videoCompressionSettings.remove(entry.key);
                  _videoCompressionSettingsDisplay.remove(entry.key);
                  Navigator.of(context).pop();
                  _updateScreen();
                },
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).close),
          ),
        ],
      ),
    );
  }

  /// Get summary of compression settings
  String getCompressionSettingsSummary(BuildContext context) {
    final count = _videoCompressionSettings.length;
    if (count == 0) return S.of(context).noCustomSettings;
    if (count == 1) return '1 video with custom settings';
    return '$count videos with custom settings';
  }

  Future<void> onSubmitData(BuildContext context) async {
    isCompressing = true;
    compressionProgress = 0.0;
    _updateScreen();

    try {
      // Process images first
      await _processImageFiles();

      // Process videos with compression
      await _processVideoFiles();

      if (context.mounted) {
        Navigator.pop(context, mediaFiles);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              S.of(context).errorProcessingMedia('$e'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      isCompressing = false;
      compressionProgress = 0.0;
      currentCompressingFile = null;
      _updateScreen();
    }
  }

  /// Process image files
  Future<void> _processImageFiles() async {
    for (final media in mediaFiles) {
      if (media is VMediaImageRes) {
        final data = await VMediaFileUtils.getImageInfo(
          fileSource: media.data.fileSource,
        );
        media.data.width = data.image.width;
        media.data.height = data.image.height;

        if (media.data.isFromPath) {
          media.data.blurHash = await VMediaFileUtils.getBlurHash(
            media.data.fileSource,
          );
        }
      }
      _updateScreen();
    }
  }

  /// Process video files with compression
  Future<void> _processVideoFiles() async {
    for (final media in mediaFiles) {
      if (media is VMediaVideoRes) {
        // Update duration for all videos
        media.data.duration = await VMediaFileUtils.getVideoDurationMill(
          media.data.fileSource,
        );

        // Compress video if on mobile (not web) and from path
        if (media.data.isFromPath && VPlatforms.isMobile && !VPlatforms.isWeb) {
          await _compressVideoIfNeeded(media);
        }
      }
      _updateScreen();
    }
  }

  /// Compress video based on user settings or config
  Future<void> _compressVideoIfNeeded(VMediaVideoRes media) async {
    final videoPath = media.data.fileSource.fileLocalPath!;
    final fileName = videoPath.split('/').last;

    // Determine compression quality
    VVideoCompressQuality? quality;

    // Check if user set specific compression for this video
    if (_videoCompressionSettings.containsKey(videoPath)) {
      quality = _videoCompressionSettings[videoPath];
    } else if (config.autoCompressVideos) {
      // Use default from config if auto-compress is enabled
      quality = config.videoCompressionQuality;
    }

    // Skip compression if no quality is set
    if (quality == null) return;

    try {
      currentCompressingFile = fileName;
      _updateScreen();

      final compressedFile = await _compressor.compressVideo(
        videoPath,
        VVideoCompressionConfig(quality: quality),
        onProgress: (progress) {
          compressionProgress = progress;
          _updateScreen();
        },
      );

      if (compressedFile != null) {
        media.data.fileSource = VPlatformFile.fromPath(
          fileLocalPath: compressedFile.compressedFilePath,
        );
      }
    } catch (e) {
      debugPrint('Video compression failed for $fileName: $e');
      // Show error message to user if context is still mounted
      // Note: We can't show error message here as we don't have context
      // This should be handled at a higher level
    } finally {
      currentCompressingFile = null;
      compressionProgress = 0.0;
    }
  }
}
