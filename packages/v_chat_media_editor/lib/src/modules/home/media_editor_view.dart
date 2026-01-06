// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_chat_media_editor/src/modules/home/widgets/horz_media_item.dart';
import 'package:v_chat_media_editor/src/modules/home/widgets/media_item.dart';
import 'package:v_platform/v_platform.dart';

import '../../core/core.dart';
import "widgets/enhanced_video_compression_progress.dart";
import 'media_editor_controller.dart';

class VMediaEditorView extends StatefulWidget {
  final List<VPlatformFile> files;
  final VMediaEditorConfig config;

  const VMediaEditorView({
    super.key,
    required this.files,
    this.config = const VMediaEditorConfig(),
  });

  @override
  State<VMediaEditorView> createState() => _VMediaEditorViewState();
}

class _VMediaEditorViewState extends State<VMediaEditorView> {
  late final MediaEditorController controller;

  @override
  void initState() {
    controller = MediaEditorController(widget.files, widget.config);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        return Scaffold(
          floatingActionButton: controller.isLoading
              ? null
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Compression settings summary (if any)
                    if (controller.getCompressionSettingsSummary(context) !=
                        S.of(context).noCustomSettings)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          controller.getCompressionSettingsSummary(context),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    // Main send button
                    FloatingActionButton.small(
                      elevation: 0,
                      onPressed: () => controller.onSubmitData(context),
                      child: controller.isCompressing
                          ? const CupertinoActivityIndicator()
                          : const Icon(Icons.send),
                    ),
                  ],
                ),
          backgroundColor: Colors.black26,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        onPageChanged: controller.changeImageIndex,
                        controller: controller.pageController,
                        itemBuilder: (BuildContext context, int index) {
                          return MediaItem(
                            mediaFile: controller.mediaFiles[index],
                            onCloseClicked: () =>
                                controller.onEmptyPress(context),
                            onDelete: (item) =>
                                controller.onDelete(item, context),
                            onCrop: (item) => controller.onCrop(
                                item as VMediaImageRes, context),
                            onPlayVideo: (item) =>
                                controller.onPlayVideo(item, context),
                            onCompressVideo: (item) =>
                                controller.onCompressVideo(item, context),
                            onStartDraw: (item) {
                              if (item is VMediaVideoRes) {
                                return controller.onStartEditVideo(
                                    item, context);
                              } else if (item is VMediaImageRes) {
                                return controller.onStartDraw(item, context);
                              }
                            },
                            isProcessing: controller.isLoading,
                            hasCustomCompressionSettings: (item) {
                              if (item is VMediaVideoRes) {
                                return controller
                                    .hasCustomCompressionSettings(item);
                              }
                              return false;
                            },
                            getCompressionQualityDisplay: (item) {
                              if (item is VMediaVideoRes) {
                                return controller
                                    .getCompressionQualityDisplay(item);
                              }
                              return null;
                            },
                          );
                        },
                        itemCount: controller.mediaFiles.length,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .08,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(5),
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 5,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              controller.changeImageIndex(index);
                            },
                            child: HorizontalMediaItem(
                              mediaFile: controller.mediaFiles[index],
                              isLoading: controller.isLoading,
                            ),
                          );
                        },
                        itemCount: controller.mediaFiles.length,
                      ),
                    )
                  ],
                ),
                // Compression progress overlay
                if (controller.isCompressing &&
                    controller.currentCompressingFile != null)
                  _buildCompressionOverlay(context, controller),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompressionOverlay(
    BuildContext context,
    MediaEditorController controller,
  ) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: EnhancedVideoCompressionProgress(
            progress: controller.compressionProgress,
            fileName: controller.currentCompressingFile ?? 'Video',
            onCancel: () => controller.cancelCompression(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }
}
