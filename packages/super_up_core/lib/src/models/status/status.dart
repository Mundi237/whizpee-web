// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:super_up_core/src/models/status/status_model_item.dart';

import '../user/user.dart';

class Status {
  final String id;
  final SBaseUser user;
  final String createdAt;

  final int seenIndex;
  final List<StatusModelItem> statusList;

//<editor-fold desc="Data Methods">

  const Status({
    required this.id,
    required this.user,
    required this.createdAt,
    required this.seenIndex,
    required this.statusList,
  });

  static final dummyStatus = <Status>[
    const Status(
      id: '2022-04-13T22:55:05.900+00:00',
      user: SBaseUser.myUser,
      createdAt: '2022-04-13T22:55:05.900+00:00',
      seenIndex: 0,
      statusList: [
        StatusModelItem.dummyStatusModelItem,
      ],
    ),
    const Status(
      id: '2022-04-13T22:55:05.900+00:00',
      user: SBaseUser.myUser,
      createdAt: '2022-04-13T22:55:05.900+00:00',
      seenIndex: 0,
      statusList: [
        StatusModelItem.dummyStatusModelItem,
        StatusModelItem.dummyStatusModelItem,
      ],
    ),
    const Status(
      id: '2022-04-13T22:55:05.900+00:00',
      user: SBaseUser.myUser,
      createdAt: '2022-04-13T22:55:05.900+00:00',
      seenIndex: 0,
      statusList: [
        StatusModelItem.dummyStatusModelItem,
        StatusModelItem.dummyStatusModelItem,
        StatusModelItem.dummyStatusModelItem,
        StatusModelItem.dummyStatusModelItem,
        StatusModelItem.dummyStatusModelItem,
        StatusModelItem.dummyStatusModelItem,
        StatusModelItem.dummyStatusModelItem,
        StatusModelItem.dummyStatusModelItem,
        StatusModelItem.dummyStatusModelItem,
      ],
    ),
    const Status(
      id: '2022-04-13T22:55:05.900+00:00',
      user: SBaseUser.myUser,
      createdAt: '2022-04-13T22:55:05.900+00:00',
      seenIndex: 0,
      statusList: [
        StatusModelItem.dummyStatusModelItem,
      ],
    ),
    const Status(
      id: '2022-04-13T22:55:05.900+00:00',
      user: SBaseUser.myUser,
      createdAt: '2022-04-13T22:55:05.900+00:00',
      seenIndex: 0,
      statusList: [
        StatusModelItem.dummyStatusModelItem,
        StatusModelItem.dummyStatusModelItem,
      ],
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Status &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          user == other.user &&
          createdAt == other.createdAt &&
          seenIndex == other.seenIndex &&
          statusList == other.statusList);

  @override
  int get hashCode =>
      id.hashCode ^
      user.hashCode ^
      createdAt.hashCode ^
      seenIndex.hashCode ^
      statusList.hashCode;

  @override
  String toString() {
    return 'Status{ id: $id, user: $user, createdAt: $createdAt, seenIndex: $seenIndex, statusList: $statusList,}';
  }

  Status copyWith({
    String? id,
    SBaseUser? user,
    String? createdAt,
    int? seenIndex,
    List<StatusModelItem>? statusList,
  }) {
    return Status(
      id: id ?? this.id,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      seenIndex: seenIndex ?? this.seenIndex,
      statusList: statusList ?? this.statusList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'createdAt': createdAt,
      'seenIndex': seenIndex,
      'statusList': statusList,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      id: map['id'] as String,
      user: map['user'] as SBaseUser,
      createdAt: map['createdAt'] as String,
      seenIndex: map['seenIndex'] as int,
      statusList: map['statusList'] as List<StatusModelItem>,
    );
  }

//</editor-fold>
}
