// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:super_up_core/super_up_core.dart';

class UserReport {
  final String id;
  final String content;
  final String type;
  final String createdAt;
  final SBaseUser reporter;

//<editor-fold desc="Data Methods">
  const UserReport({
    required this.id,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.reporter,
  });

  UserReport.empty()
      : id = "-----",
        content = "-----",
        type = "------",
        createdAt = DateTime.now().toIso8601String(),
        reporter = SBaseUser.myUser;

  @override
  String toString() {
    return 'UserReport{ id: $id, content: $content, type: $type, createdAt: $createdAt, reporter: $reporter, createdAt: $createdAt,}';
  }

  UserReport copyWith({
    String? id,
    String? content,
    String? type,
    String? createdAt,
    SBaseUser? reporter,
  }) {
    return UserReport(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      reporter: reporter ?? this.reporter,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'content': content,
      'type': type,
      'createdAt': createdAt,
      'uId': reporter.toMap(),
    };
  }

  factory UserReport.fromMap(Map<String, dynamic> map) {
    return UserReport(
      id: map['_id'] as String,
      content: map['content'] as String,
      type: map['type'] as String,
      createdAt: map['createdAt'] as String,
      reporter: SBaseUser.fromMap(map['uId']),
    );
  }

//</editor-fold>
}
