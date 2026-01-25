// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class UserFilterDto {
  int limit;
  int page;
  String? fullName;
  String? phone;

//<editor-fold desc="Data Methods">

  UserFilterDto({
    required this.limit,
    required this.page,
    this.fullName,
    this.phone,
  });

  UserFilterDto.init()
      : limit = 45,
        page = 1,
        fullName = null,
        phone = null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserFilterDto &&
          runtimeType == other.runtimeType &&
          limit == other.limit &&
          page == other.page &&
          fullName == other.fullName &&
          phone == other.phone);

  @override
  int get hashCode =>
      limit.hashCode ^ page.hashCode ^ fullName.hashCode ^ phone.hashCode;

  @override
  String toString() {
    return 'UserFilterDto{ limit: $limit, page: $page, fullName: $fullName, phone: $phone,}';
  }

  UserFilterDto copyWith({
    int? limit,
    int? page,
    String? fullName,
    String? phone,
  }) {
    return UserFilterDto(
      limit: limit ?? this.limit,
      page: page ?? this.page,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'limit': limit,
      'page': page,
      'fullName': fullName,
      'phone': phone,
    };
  }

  factory UserFilterDto.fromMap(Map<String, dynamic> map) {
    return UserFilterDto(
      limit: map['limit'] as int,
      page: map['page'] as int,
      fullName: map['fullName'] as String?,
      phone: map['phone'] as String?,
    );
  }

//</editor-fold>
}
