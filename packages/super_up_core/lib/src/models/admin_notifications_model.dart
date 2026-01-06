// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class AdminNotificationsModel {
  final String id;
  final String content;
  final String title;
  final String? imageUrl;
  final String createdAt;

//<editor-fold desc="Data Methods">
  const AdminNotificationsModel({
    required this.id,
    required this.content,
    required this.title,
    this.imageUrl,
    required this.createdAt,
  });

  DateTime get startAtDate => DateTime.parse(createdAt).toLocal();

  @override
  String toString() {
    return 'AdminNotificationsModel{ id: $id, content: $content, title: $title, imageUrl: $imageUrl, createdAt: $createdAt,}';
  }

  AdminNotificationsModel copyWith({
    String? id,
    String? content,
    String? title,
    String? imageUrl,
    String? createdAt,
  }) {
    return AdminNotificationsModel(
      id: id ?? this.id,
      content: content ?? this.content,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'content': content,
      'title': title,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }

  factory AdminNotificationsModel.fromMap(Map<String, dynamic> map) {
    return AdminNotificationsModel(
      id: map['_id'] as String,
      content: map['content'] as String,
      title: map['title'] as String,
      imageUrl: map['imageUrl'] as String?,
      createdAt: map['createdAt'] as String,
    );
  }

//</editor-fold>
}
