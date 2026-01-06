// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_platform/v_platform.dart';

class VMessageImageData {
  VPlatformFile fileSource;
  int width;
  int height;
  String? blurHash;
//<editor-fold desc="Data Methods">

  VMessageImageData({
    required this.fileSource,
    required this.width,
    required this.height,
    required this.blurHash,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VMessageImageData &&
          runtimeType == other.runtimeType &&
          fileSource == other.fileSource &&
          width == other.width &&
          height == other.height);

  @override
  int get hashCode => fileSource.hashCode ^ width.hashCode ^ height.hashCode;

  @override
  String toString() {
    return 'MessageImageData{ fileSource: $fileSource, width: $width, height: $height,}';
  }

  bool get isFromPath => fileSource.fileLocalPath != null;

  bool get isFromBytes => fileSource.bytes != null;

  Map<String, dynamic> toMap() {
    return {
      ...fileSource.toMap(),
      'width': width,
      'height': height,
      'blurHash': blurHash,
    };
  }

  factory VMessageImageData.fromMap(
    Map<String, dynamic> map, {
    String? baseUrl,
  }) {
    return VMessageImageData(
      fileSource: VPlatformFile.fromMap(
        map,
      ),
      width: map['width'] as int,
      height: map['height'] as int,
      blurHash: map['blurHash'] as String?,
    );
  }

  factory VMessageImageData.fromFakeData({
    required int high,
    required int width,
  }) {
    return VMessageImageData(
      fileSource: VPlatformFile.fromUrl(
        networkUrl: "https://picsum.photos/$width/$high",
      ),
      width: width,
      height: high,
      blurHash: null,
    );
  }

//</editor-fold>
}
