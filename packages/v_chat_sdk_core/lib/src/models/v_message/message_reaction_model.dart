// Copyright 2025, the hatemragab project.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:super_up_core/super_up_core.dart';

@immutable
class MessageReactionModel {
  final String emoji;
  final SBaseUser reactor;

  const MessageReactionModel({
    required this.emoji,
    required this.reactor,
  });

  MessageReactionModel copyWith({
    String? emoji,
    SBaseUser? reactor,
  }) {
    return MessageReactionModel(
      emoji: emoji ?? this.emoji,
      reactor: reactor ?? this.reactor,
    );
  }

  factory MessageReactionModel.fromMap(Map<String, dynamic> map) {
    return MessageReactionModel(
      emoji: map['emoji'] as String,
      reactor: SBaseUser.fromMap(map['reactor'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'emoji': emoji,
      'reactor': reactor.toMap(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MessageReactionModel && other.emoji == emoji && other.reactor == reactor;
  }

  @override
  int get hashCode => emoji.hashCode ^ reactor.hashCode;
}
