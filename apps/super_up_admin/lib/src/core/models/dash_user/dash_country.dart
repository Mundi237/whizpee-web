// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class DashCountry {
  final String id;
  final String code;
  final String emoji;
  final String unicode;
  final String name;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

//<editor-fold desc="Data Methods">
  const DashCountry({
    required this.id,
    required this.code,
    required this.emoji,
    required this.unicode,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DashCountry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          code == other.code &&
          emoji == other.emoji &&
          unicode == other.unicode &&
          name == other.name &&
          image == other.image &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt);

  @override
  int get hashCode =>
      id.hashCode ^
      code.hashCode ^
      emoji.hashCode ^
      unicode.hashCode ^
      name.hashCode ^
      image.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() {
    return 'DashCountry{ id: $id, code: $code, emoji: $emoji, unicode: $unicode, name: $name, image: $image, createdAt: $createdAt, updatedAt: $updatedAt,}';
  }

  DashCountry copyWith({
    String? id,
    String? code,
    String? emoji,
    String? unicode,
    String? name,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DashCountry(
      id: id ?? this.id,
      code: code ?? this.code,
      emoji: emoji ?? this.emoji,
      unicode: unicode ?? this.unicode,
      name: name ?? this.name,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'code': code,
      'emoji': emoji,
      'unicode': unicode,
      'name': name,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DashCountry.fromMap(Map<String, dynamic> map) {
    return DashCountry(
      id: map['_id'] as String,
      code: map['code'] as String,
      emoji: map['emoji'] as String,
      unicode: map['unicode'] as String,
      name: map['name'] as String,
      image: map['image'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

//</editor-fold>
}
