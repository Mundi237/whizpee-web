// Copyright 2025, the hatemragab project.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:meta/meta.dart';

/// Model representing a reaction sample with emoji and count
@immutable
class ReactionSample {
  final String emoji;
  final int count;

  const ReactionSample({
    required this.emoji,
    required this.count,
  });

  ReactionSample copyWith({
    String? emoji,
    int? count,
  }) {
    return ReactionSample(
      emoji: emoji ?? this.emoji,
      count: count ?? this.count,
    );
  }

  factory ReactionSample.fromJson(Map<String, dynamic> json) {
    return ReactionSample(
      emoji: json['emoji'] as String,
      count: (json['count'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'count': count,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReactionSample && 
           other.emoji == emoji && 
           other.count == count;
  }

  @override
  int get hashCode => emoji.hashCode ^ count.hashCode;

  @override
  String toString() => 'ReactionSample(emoji: $emoji, count: $count)';
}