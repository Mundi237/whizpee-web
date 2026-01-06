// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

enum StatusType { image, video }

class StatusModelItem {
  final String url;
  final StatusType statusType;
  final String statusText;
  final String statusColor;

  static const dummyStatusModelItem = StatusModelItem(
      url:
          'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png',
      statusType: StatusType.image,
      statusColor: "#00ff00",
      statusText:
          "we need to get the image from the server and then set the image url to the image url");

//<editor-fold desc="Data Methods">

  const StatusModelItem({
    required this.url,
    required this.statusType,
    required this.statusText,
    required this.statusColor,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StatusModelItem &&
          runtimeType == other.runtimeType &&
          url == other.url &&
          statusType == other.statusType &&
          statusText == other.statusText &&
          statusColor == other.statusColor);

  @override
  int get hashCode =>
      url.hashCode ^
      statusType.hashCode ^
      statusText.hashCode ^
      statusColor.hashCode;

  @override
  String toString() {
    return 'StatusModelItem{'
        ' url: $url,'
        ' statusType: $statusType,'
        ' statusText: $statusText,'
        ' statusColor: $statusColor,'
        '}';
  }

  StatusModelItem copyWith({
    String? url,
    StatusType? statusType,
    String? statusText,
    String? statusColor,
  }) {
    return StatusModelItem(
      url: url ?? this.url,
      statusType: statusType ?? this.statusType,
      statusText: statusText ?? this.statusText,
      statusColor: statusColor ?? this.statusColor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'statusType': statusType,
      'statusText': statusText,
      'statusColor': statusColor,
    };
  }

  factory StatusModelItem.fromMap(Map<String, dynamic> map) {
    return StatusModelItem(
      url: map['url'] as String,
      statusType: map['statusType'] as StatusType,
      statusText: map['statusText'] as String,
      statusColor: map['statusColor'] as String,
    );
  }

//</editor-fold>
}
