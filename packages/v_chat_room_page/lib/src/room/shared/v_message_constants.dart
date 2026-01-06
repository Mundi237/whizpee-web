// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

abstract class VMessageConstants {
  static String getMessageBody(VBaseMessage m, VMessageInfoTrans language) {
    if (m is VInfoMessage) {
      final infoAtt = m.data;
      switch (infoAtt.action) {
        case VMessageInfoType.updateTitle:
          return "${infoAtt.adminName} ${language.updateTitleTo} ${infoAtt.targetName}";
        case VMessageInfoType.updateImage:
          return "${infoAtt.adminName} ${language.updateImage}";
        case VMessageInfoType.addGroupMember:
          return "${infoAtt.targetName} ${language.joinedBy} ${infoAtt.adminName}";
        case VMessageInfoType.upAdmin:
          return "${infoAtt.targetName} ${language.promotedToAdminBy} ${infoAtt.adminName}";
        case VMessageInfoType.downMember:
          return "${infoAtt.targetName} ${language.dismissedToMemberBy} ${infoAtt.adminName}";
        case VMessageInfoType.leave:
          return "${infoAtt.targetName} ${language.leftTheGroup}";
        case VMessageInfoType.kick:
          if (infoAtt.isMe) {
            return "${language.you} ${language.kickedBy} ${infoAtt.adminName}";
          }
          return "${infoAtt.targetName} ${language.kickedBy} ${infoAtt.adminName}";
        case VMessageInfoType.createGroup:
          return "${language.groupCreatedBy} ${infoAtt.adminName}";

        case VMessageInfoType.addToBroadcast:
          return "${infoAtt.adminName} ${language.addedYouToNewBroadcast} ${infoAtt.targetName}";
      }
    }
    return m.contentTr ?? m.realContent;
  }

  static const String heart = "\u{2764}";
  static const String faceWithTears = "\u{1F602}";
  static const String disappointedFace = "\u{1F625}";
  static const String angryFace = "\u{1F621}";
  static const String astonishedFace = "\u{1F632}";
  static const String thumbsUp = "\u{1F44D}";

  static const thisContentIsFile = "📁";
  static const thisContentIsVoice = "🎤";
  static const thisContentIsImage = "📷";
  static const thisContentIsVideo = "🎥";
  static const thisContentIsLocation = "📍";
}
