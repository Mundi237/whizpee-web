import 'package:enum_to_string/enum_to_string.dart';

import '../../../super_up_core.dart';

class UserPrivacy {
  final UserPrivacyType startChat;
  final UserPrivacyType showStory;
  final bool publicSearch;
  final bool acceptCalls;
  final bool lastSeen;

//<editor-fold desc="Data Methods">
  const UserPrivacy({
    required this.startChat,
    required this.showStory,
    required this.publicSearch,
    required this.lastSeen,
    required this.acceptCalls,
  });

  const UserPrivacy.defaults()
      : startChat = UserPrivacyType.forReq,
        showStory = UserPrivacyType.forReq,
        publicSearch = true,
        acceptCalls = true,
        lastSeen = true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPrivacy &&
          runtimeType == other.runtimeType &&
          startChat == other.startChat &&
          showStory == other.showStory &&
          publicSearch == other.publicSearch &&
          lastSeen == other.lastSeen);

  @override
  int get hashCode =>
      startChat.hashCode ^
      showStory.hashCode ^
      publicSearch.hashCode ^
      lastSeen.hashCode;

  @override
  String toString() {
    return 'UserPrivacy{startChat: $startChat, showStory: $showStory, publicSearch: $publicSearch, acceptCalls: $acceptCalls, lastSeen: $lastSeen}';
  }

  UserPrivacy copyWith({
    UserPrivacyType? startChat,
    UserPrivacyType? showStory,
    bool? publicSearch,
    bool? lastSeen,
    bool? acceptCalls,
  }) {
    return UserPrivacy(
      startChat: startChat ?? this.startChat,
      showStory: showStory ?? this.showStory,
      publicSearch: publicSearch ?? this.publicSearch,
      acceptCalls: acceptCalls ?? this.acceptCalls,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startChat': startChat.name,
      'showStory': showStory.name,
      'acceptCalls': acceptCalls,
      'publicSearch': publicSearch,
      'lastSeen': lastSeen,
    };
  }

  factory UserPrivacy.fromMap(Map<String, dynamic> map) {
    return UserPrivacy(
      startChat: EnumToString.fromString(
              UserPrivacyType.values, map['startChat'] as String) ??
          UserPrivacyType.none,
      showStory: EnumToString.fromString(
              UserPrivacyType.values, map['showStory'] as String) ??
          UserPrivacyType.none,
      publicSearch: map['publicSearch'] as bool,
      acceptCalls: (map['acceptCalls'] as bool?) ?? true,
      lastSeen: map['lastSeen'] as bool,
    );
  }

//</editor-fold>
}
