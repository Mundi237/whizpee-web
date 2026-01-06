import 'package:enum_to_string/enum_to_string.dart';
import 'package:super_up/app/core/utils/enums.dart';
import 'package:super_up_core/super_up_core.dart';

class StoryModel {
  final String id;
  final String userId;
  final String content;
  final String? backgroundColor;
  final String? caption;
  final Map<String, dynamic>? att;
  final String expireAt;
  final String createdAt;
  final String updatedAt;
  final StoryType storyType;
  final StoryFontType fontType;
  final bool viewedByMe;

//<editor-fold desc="Data Methods">
  const StoryModel({
    required this.id,
    required this.userId,
    required this.content,
    this.backgroundColor,
    this.caption,
    this.att,
    required this.expireAt,
    required this.createdAt,
    required this.updatedAt,
    required this.storyType,
    required this.fontType,
    required this.viewedByMe,
  });

  // Map<String, String>? get attachment => att == null ? null : jsonDecode(att!);

  int? get colorValue =>
      backgroundColor == null ? null : int.parse(backgroundColor!, radix: 16);

  @override
  String toString() {
    return 'StoryModel{ id: $id, userId: $userId, content: $content, backgroundColor: $backgroundColor, caption: $caption, att: $att, expireAt: $expireAt, createdAt: $createdAt, updatedAt: $updatedAt, storyType: $storyType, fontType: $fontType, viewedByMe: $viewedByMe,}';
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userId': userId,
      'content': content,
      'backgroundColor': backgroundColor,
      'caption': caption,
      'att': att,
      'expireAt': expireAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'storyType': storyType.name,
      'fontType': fontType.name,
      'viewedByMe': viewedByMe,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      id: map['_id'] as String,
      userId: map['userId'] as String,
      content: map['content'] as String,
      backgroundColor: map['backgroundColor'] as String?,
      caption: map['caption'] as String?,
      att: map['att'] as Map<String, dynamic>?,
      expireAt: map['expireAt'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      storyType: EnumToString.fromString(
            StoryType.values,
            map['storyType'] as String,
          ) ??
          StoryType.unknown,
      fontType: EnumToString.fromString(
            StoryFontType.values,
            map['fontType'] as String,
          ) ??
          StoryFontType.normal,
      viewedByMe: map['viewedByMe'] as bool,
    );
  }

//</editor-fold>
}

class UserStoryModel {
  final SBaseUser userData;

  final List<StoryModel> stories;

//<editor-fold desc="Data Methods">
  const UserStoryModel({
    required this.userData,
    required this.stories,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStoryModel &&
          runtimeType == other.runtimeType &&
          userData == other.userData;

  @override
  int get hashCode => userData.hashCode;

  @override
  String toString() {
    return 'UserStoryModel{ user: $userData, stories: $stories,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'userData': userData.toMap(),
      'stories': stories.map((e) => e.toMap()).toList(),
    };
  }

  factory UserStoryModel.fromMap(Map<String, dynamic> map) {
    return UserStoryModel(
      userData: SBaseUser.fromMap(map['userData']),
      stories:
          (map['stories'] as List).map((e) => StoryModel.fromMap(e)).toList(),
    );
  }

//</editor-fold>
}
