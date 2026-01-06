// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:super_up_core/super_up_core.dart';

class StoryViewerModel {
  final String viewedAt;
  final SBaseUser viewerInfo;

//<editor-fold desc="Data Methods">
  const StoryViewerModel({
    required this.viewedAt,
    required this.viewerInfo,
  });

  DateTime get viewedAtLocal => DateTime.parse(viewedAt).toLocal();

  @override
  String toString() {
    return 'StoryViewerModel{viewedAt: $viewedAt, viewerInfo: $viewerInfo,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'viewedAt': viewedAt,
      'viewerInfo': viewerInfo.toMap(),
    };
  }

  factory StoryViewerModel.fromMap(Map<String, dynamic> map) {
    final viewerInfoMap = map['viewerInfo'] as Map<String, dynamic>;
    // Map the backend fields to SBaseUser expected format
    final baseUserMap = {
      '_id': viewerInfoMap['_id'],
      'fullName': viewerInfoMap['fullName'],
      'userImage': viewerInfoMap['userImage'],
    };

    return StoryViewerModel(
      viewedAt: map['viewedAt'] as String,
      viewerInfo: SBaseUser.fromMap(baseUserMap),
    );
  }

//</editor-fold>
}
