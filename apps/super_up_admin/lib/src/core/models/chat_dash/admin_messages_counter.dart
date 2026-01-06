// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class AdminMessagesCounter {
  final int messages;
  final int textMessages;
  final int imageMessages;
  final int videoMessages;
  final int voiceMessages;
  final int fileMessages;
  final int infoMessages;
  final int callMessages;
  final int locationMessages;
  final int allDeletedMessages;

//<editor-fold desc="Data Methods">
  const AdminMessagesCounter({
    required this.messages,
    required this.textMessages,
    required this.imageMessages,
    required this.videoMessages,
    required this.voiceMessages,
    required this.fileMessages,
    required this.infoMessages,
    required this.callMessages,
    required this.locationMessages,
    required this.allDeletedMessages,
  });

  @override
  String toString() {
    return 'AdminMessagesCounter{ messages: $messages, textMessages: $textMessages, imageMessages: $imageMessages, videoMessages: $videoMessages, voiceMessages: $voiceMessages, fileMessages: $fileMessages, infoMessages: $infoMessages, callMessages: $callMessages, locationMessages: $locationMessages, allDeletedMessages: $allDeletedMessages,}';
  }

  AdminMessagesCounter.empty()
      : messages = 0,
        textMessages = 0,
        imageMessages = 0,
        videoMessages = 0,
        voiceMessages = 0,
        fileMessages = 0,
        infoMessages = 0,
        callMessages = 0,
        locationMessages = 0,
        allDeletedMessages = 0;

  Map<String, dynamic> toMap() {
    return {
      'messages': messages,
      'textMessages': textMessages,
      'imageMessages': imageMessages,
      'videoMessages': videoMessages,
      'voiceMessages': voiceMessages,
      'fileMessages': fileMessages,
      'infoMessages': infoMessages,
      'callMessages': callMessages,
      'locationMessages': locationMessages,
      'allDeletedMessages': allDeletedMessages,
    };
  }

  factory AdminMessagesCounter.fromMap(Map<String, dynamic> map) {
    return AdminMessagesCounter(
      messages: map['messages'] as int,
      textMessages: map['textMessages'] as int,
      imageMessages: map['imageMessages'] as int,
      videoMessages: map['videoMessages'] as int,
      voiceMessages: map['voiceMessages'] as int,
      fileMessages: map['fileMessages'] as int,
      infoMessages: map['infoMessages'] as int,
      callMessages: map['callMessages'] as int,
      locationMessages: map['locationMessages'] as int,
      allDeletedMessages: map['allDeletedMessages'] as int,
    );
  }

//</editor-fold>
}
