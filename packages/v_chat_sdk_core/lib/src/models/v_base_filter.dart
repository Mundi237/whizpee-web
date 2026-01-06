// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class VBaseFilter {
  int limit;
  int page;
  String? fullName;

//<editor-fold desc="Data Methods">
  VBaseFilter({
    this.limit = 30,
    this.page = 1,
    this.fullName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VBaseFilter &&
          runtimeType == other.runtimeType &&
          limit == other.limit &&
          page == other.page &&
          fullName == other.fullName);

  @override
  int get hashCode => limit.hashCode ^ page.hashCode ^ fullName.hashCode;

  @override
  String toString() {
    return 'VBaseFilter{ limit: $limit, page: $page, name: $fullName,}';
  }

  VBaseFilter copyWith({
    int? limit,
    int? page,
    String? fullName,
  }) {
    return VBaseFilter(
      limit: limit ?? this.limit,
      page: page ?? this.page,
      fullName: fullName ?? this.fullName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'limit': limit,
      'page': page,
      'fullName': fullName,
    };
  }

//</editor-fold>
}
