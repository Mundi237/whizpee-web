// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class SettingState {
  final bool isDarkMode;
  final String language;
  final bool inAppAlerts;

  SettingState({
    required this.isDarkMode,
    required this.language,
    required this.inAppAlerts,
  });

  @override
  String toString() {
    return 'SettingState{isDarkMode: $isDarkMode, language: $language, inAppAlerts: $inAppAlerts}';
  }

  SettingState copyWith({
    bool? isDarkMode,
    bool? inAppAlerts,
    String? language,
  }) {
    return SettingState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      inAppAlerts: inAppAlerts ?? this.inAppAlerts,
      language: language ?? this.language,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingState &&
          runtimeType == other.runtimeType &&
          isDarkMode == other.isDarkMode &&
          language == other.language &&
          inAppAlerts == other.inAppAlerts;

  @override
  int get hashCode =>
      isDarkMode.hashCode ^ language.hashCode ^ inAppAlerts.hashCode;
}
