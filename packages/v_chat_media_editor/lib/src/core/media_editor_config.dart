// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_video_compressor/v_video_compressor.dart';

class VMediaEditorConfig {
  const VMediaEditorConfig({
    this.maxVideoSizeMb = 100,
    this.imageQuality = 50,
    this.startCompressAt = 1500 * 1000,
    this.destVideoThumbFile,
    this.videoCompressionQuality = VVideoCompressQuality.medium,
    this.enableVideoCompressionDialog = true,
    this.autoCompressVideos = true,
  });

  /// Maximum video size in MB for compression
  final int maxVideoSizeMb;

  /// Compress image quality (0-100)
  final int imageQuality;

  /// File size threshold for starting compression (in bytes)
  /// Default: 1.5MB - compression starts if image is bigger than this
  final int startCompressAt;

  /// Destination path for video thumbnail files
  final String? destVideoThumbFile;

  /// Default video compression quality
  final VVideoCompressQuality videoCompressionQuality;

  /// Whether to show compression options dialog for videos
  final bool enableVideoCompressionDialog;

  /// Whether to automatically compress videos without asking
  final bool autoCompressVideos;
}
