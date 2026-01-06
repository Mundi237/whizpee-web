import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:v_platform/v_platform.dart';

import '../../utils/enums.dart';

class CreateStoryDto {
  final VPlatformFile? image;
  final StoryType storyType;
  final StoryFontType storyFontType;
  final String content;
  final String? backgroundColor;
  final String? caption;
  final Map<String, dynamic>? attachment;

  const CreateStoryDto({
    this.image,
    required this.storyType,
    required this.content,
    this.backgroundColor,
    this.storyFontType = StoryFontType.normal,
    this.caption,
    this.attachment,
  });

  List<PartValue> toListOfPartValue() {
    return [
      PartValue('storyType', storyType.name),
      PartValue('content', content),
      PartValue('fontType', storyFontType.name),
      PartValue('backgroundColor', backgroundColor),
      PartValue('caption', caption),
      if (attachment != null) PartValue('attachment', jsonEncode(attachment)),
    ];
  }
}
