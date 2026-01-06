// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class VLinkPreviewData {
  final String? image;
  final String title;
  final String description;
  final String link;

  const VLinkPreviewData({
    this.image,
    required this.title,
    required this.description,
    required this.link,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'title': title,
      'description': description,
      'link': link,
    };
  }

  @override
  String toString() {
    return 'LinkPreviewData{image: $image, title: $title, desc: $description, link: $link}';
  }

  factory VLinkPreviewData.fromMap(Map<String, dynamic> map) {
    return VLinkPreviewData(
      image: map['image'] as String?,
      title: (map['title'] as String?) ?? "title",
      description: (map['description'] as String?) ?? map['link'] as String,
      link: map['link'] as String,
    );
  }
}
