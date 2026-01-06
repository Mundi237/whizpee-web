// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class PaginateModel<T> {
  List<T> values;
  int totalDocs;
  int limit;
  int totalPages;
  int page;
  int pagingCounter;
  bool hasPrevPage;
  bool hasNextPage;

//<editor-fold desc="Data Methods">
  PaginateModel({
    required this.totalDocs,
    required this.values,
    required this.limit,
    required this.totalPages,
    required this.page,
    required this.pagingCounter,
    required this.hasPrevPage,
    required this.hasNextPage,
  });

  PaginateModel.empty()
      : totalDocs = 0,
        values = [],
        limit = 0,
        totalPages = 0,
        page = 0,
        pagingCounter = 0,
        hasPrevPage = false,
        hasNextPage = false;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaginateModel &&
          runtimeType == other.runtimeType &&
          totalDocs == other.totalDocs &&
          limit == other.limit &&
          totalPages == other.totalPages &&
          page == other.page &&
          pagingCounter == other.pagingCounter &&
          hasPrevPage == other.hasPrevPage &&
          hasNextPage == other.hasNextPage);

  @override
  int get hashCode =>
      totalDocs.hashCode ^
      limit.hashCode ^
      totalPages.hashCode ^
      page.hashCode ^
      pagingCounter.hashCode ^
      hasPrevPage.hashCode ^
      hasNextPage.hashCode;

  @override
  String toString() {
    return 'PaginateModel{ totalDocs: $totalDocs, limit: $limit, totalPages: $totalPages, page: $page, pagingCounter: $pagingCounter, hasPrevPage: $hasPrevPage, hasNextPage: $hasNextPage,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'totalDocs': totalDocs,
      'limit': limit,
      'totalPages': totalPages,
      'page': page,
      'pagingCounter': pagingCounter,
      'hasPrevPage': hasPrevPage,
      'hasNextPage': hasNextPage,
    };
  }

  factory PaginateModel.fromCustomMap({
    required List<T> values,
    required Map<String, dynamic> map,
  }) {
    return PaginateModel(
      values: values,
      totalDocs: map['totalDocs'] as int,
      limit: map['limit'] as int,
      totalPages: map['totalPages'] as int,
      page: map['page'] as int,
      pagingCounter: map['pagingCounter'] as int,
      hasPrevPage: map['hasPrevPage'] as bool,
      hasNextPage: map['hasNextPage'] as bool,
    );
  }

//</editor-fold>
}
