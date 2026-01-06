// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gal/gal.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:share_plus/share_plus.dart';
import 'package:v_platform/v_platform.dart';
import 'package:photo_view/photo_view.dart';

import '../v_chat/v_file.dart';
import 'v_app_alert.dart';
import 'v_safe_api_call.dart';

class VImageViewer extends StatefulWidget {
  final VPlatformFile platformFileSource;
  final String downloadingLabel;
  final String successfullyDownloadedInLabel;
  final bool showDownload;

  const VImageViewer({
    super.key,
    required this.platformFileSource,
    required this.downloadingLabel,
    required this.showDownload,
    required this.successfullyDownloadedInLabel,
  });

  @override
  State<VImageViewer> createState() => _VImageViewerState();
}

class _VImageViewerState extends State<VImageViewer> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.platformFileSource.isContentImage) {
      return Material(child: Text(S.of(context).fileMustBeImage));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.3),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Colors.white),
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
        ),
        actions: widget.showDownload
            ? [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _isLoading
                      ? Container(
                          padding: const EdgeInsets.all(12),
                          child: const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.file_download, color: Colors.white),
                          ),
                          onPressed: _downloadImage,
                          tooltip: S.of(context).downloadImage,
                        ),
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.share, color: Colors.white),
                  ),
                  onPressed: _shareImage,
                  tooltip: S.of(context).shareImage,
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.info_outline, color: Colors.white),
                  ),
                  onPressed: _showImageInfo,
                  tooltip: S.of(context).imageInfo,
                ),
              ]
            : [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.info_outline, color: Colors.white),
                  ),
                  onPressed: _showImageInfo,
                  tooltip: S.of(context).imageInfo,
                ),
              ],
      ),
      body: _buildPhotoView(),
    );
  }

  Widget _buildPhotoView() {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null &&
            details.primaryVelocity! > 800 &&
            details.velocity.pixelsPerSecond.dy > 1000) {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();
        }
      },
      child: Center(
        child: PhotoView(
          imageProvider: _getImageProvider(),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          heroAttributes: PhotoViewHeroAttributes(
            tag: widget.platformFileSource.getCachedUrlKey,
          ),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3.0,
          filterQuality: FilterQuality.high,
          loadingBuilder: (context, event) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  value: event?.expectedTotalBytes != null
                      ? (event!.cumulativeBytesLoaded /
                          (event.expectedTotalBytes ?? 1))
                      : null,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).loading,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          errorBuilder: (context, error, stackTrace) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                S.of(context).errorLoadingImage,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _downloadImage() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    await vSafeApiCall(
      onLoading: () {
        VAppAlert.showSuccessSnackBar(
          message: widget.downloadingLabel,
          context: context,
        );
      },
      request: () async {
        if (VPlatforms.isMobile) {
          if (!await Gal.hasAccess()) {
            await Gal.requestAccess();
          }
          final path = await DefaultCacheManager()
              .getSingleFile(widget.platformFileSource.fullNetworkUrl!);
          await Gal.putImage(path.path);
          return " ${S.current.currentDevice}";
        }
        return VFileUtils.saveFileToPublicPath(
          fileAttachment: widget.platformFileSource,
        );
      },
      onSuccess: (url) async {
        VAppAlert.showSuccessSnackBar(
          message: widget.successfullyDownloadedInLabel + url,
          context: context,
        );
      },
      onError: (exception) {
        VAppAlert.showErrorSnackBar(
          message: S.of(context).errorDownloadingImage,
          context: context,
        );
        if (kDebugMode) {
          print(exception);
        }
      },
    );

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _shareImage() async {
    HapticFeedback.selectionClick();

    try {
      if (widget.platformFileSource.isFromPath) {
        await SharePlus.instance.share(ShareParams(
            files: [XFile(widget.platformFileSource.fileLocalPath!)]));
      } else if (widget.platformFileSource.fullNetworkUrl != null) {
        final path = await DefaultCacheManager()
            .getSingleFile(widget.platformFileSource.fullNetworkUrl!);
        await SharePlus.instance.share(ShareParams(files: [XFile(path.path)]));
      }
    } catch (e) {
      if (mounted) {
        VAppAlert.showErrorSnackBar(
          message: S.of(context).errorSharingImage,
          context: context,
        );
      }
      if (kDebugMode) {
        print('Error sharing image: $e');
      }
    }
  }

  void _showImageInfo() {
    HapticFeedback.selectionClick();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(S.of(context).imageInfo),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
                S.of(context).fileName, widget.platformFileSource.name),
            const SizedBox(height: 8),
            _buildInfoRow(S.of(context).fileType, 'Image'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              S.of(context).close,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider() {
    if (widget.platformFileSource.isFromPath) {
      return FileImage(File(widget.platformFileSource.fileLocalPath!));
    }
    if (widget.platformFileSource.isFromBytes) {
      return MemoryImage(Uint8List.fromList(widget.platformFileSource.bytes!));
    }
    return CachedNetworkImageProvider(
      widget.platformFileSource.fullNetworkUrl!,
      cacheKey: widget.platformFileSource.getCachedUrlKey,
    );
  }
}
