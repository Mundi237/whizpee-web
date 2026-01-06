// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:super_up_core/super_up_core.dart';

class VMessageStatusModel {
  final String deliveredAt;
  final String? seenAt;
  final SBaseUser peerUser;

//<editor-fold desc="Data Methods">
  const VMessageStatusModel({
    required this.deliveredAt,
    this.seenAt,
    required this.peerUser,
  });

  DateTime get delivered => DateTime.parse(deliveredAt).toLocal();
  DateTime? get seen =>
      seenAt == null ? null : DateTime.parse(seenAt!).toLocal();
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VMessageStatusModel &&
          runtimeType == other.runtimeType &&
          deliveredAt == other.deliveredAt &&
          seenAt == other.seenAt &&
          peerUser == other.peerUser);

  @override
  int get hashCode =>
      deliveredAt.hashCode ^ seenAt.hashCode ^ peerUser.hashCode;

  @override
  String toString() {
    return 'VMessageStatusModel{deliveredAt: $deliveredAt, seenAt: $seenAt,  identifierUser: $peerUser}';
  }

  Map<String, dynamic> toMap() {
    return {
      'dAt': deliveredAt,
      'sAt': seenAt,
      'userData': peerUser.toMap(),
    };
  }

  factory VMessageStatusModel.fromMap(Map<String, dynamic> map) {
    return VMessageStatusModel(
      deliveredAt: map['dAt'] as String,
      seenAt: map['sAt'] as String?,
      peerUser: SBaseUser.fromMap(map['userData'] as Map<String, dynamic>),
    );
  }

//</editor-fold>
}
