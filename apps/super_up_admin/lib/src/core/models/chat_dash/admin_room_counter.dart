// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class AdminRoomCounter {
  final int single;
  final int order;
  final int group;
  final int broadcast;

//<editor-fold desc="Data Methods">
  const AdminRoomCounter({
    required this.single,
    required this.order,
    required this.group,
    required this.broadcast,
  });

  AdminRoomCounter.empty()
      : single = 0,
        order = 0,
        group = 0,
        broadcast = 0;

  @override
  String toString() {
    return 'AdminRoomCounter{ single: $single, order: $order, group: $group, broadcast: $broadcast,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'single': single,
      'order': order,
      'group': group,
      'broadcast': broadcast,
    };
  }

  factory AdminRoomCounter.fromMap(Map<String, dynamic> map) {
    return AdminRoomCounter(
      single: map['single'] as int,
      order: map['order'] as int,
      group: map['group'] as int,
      broadcast: map['broadcast'] as int,
    );
  }

//</editor-fold>
}
