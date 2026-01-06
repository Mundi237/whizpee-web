// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

// final vDefaultMessageNavigator = VMessageNavigator(
//   toMessagePage: (context, vRoom) {
//     return context.toPage(
//       VMessagePage(
//         vRoom: vRoom,
//         vMessageConfig: const VMessageConfig(),
//         localization: VMessageLocalization.fromEnglish(),
//       ),
//     );
//   },
//   toVideoPlayer: (context, source) {
//     return context.toPage(
//       VVideoPlayer(
//         platformFileSource: source,
//         downloadingLabel: "Downloading...",
//         successfullyDownloadedInLabel: "Successfully downloaded in ",
//       ),
//     );
//   },
//   toImageViewer: (context, source) {
//     return context.toPage(
//       VImageViewer(
//         platformFileSource: source,
//         downloadingLabel: "Downloading...",
//         successfullyDownloadedInLabel: "Successfully downloaded in ",
//       ),
//     );
//   },
//   toGroupChatMessageInfo: (context, message) => context.toPage(
//     VMessageGroupStatusPage(
//       message: message,
//       deliveredLabel: "Delivered",
//       messageInfoLabel: "Message Info",
//       readLabel: "Read",
//       vMessageLocalization: VMessageLocalization.fromEnglish(),
//     ),
//   ),
//   toBroadcastChatMessageInfo: (context, message) => context.toPage(
//     VMessageBroadcastStatusPage(
//       message: message,
//       deliveredLabel: "Delivered",
//       messageInfoLabel: "Message Info",
//       readLabel: "Read",
//       vMessageLocalization: VMessageLocalization.fromEnglish(),
//     ),
//   ),
//   toSingleChatMessageInfo: (context, message) => context.toPage(
//     VMessageSingleStatusPage(
//       message: message,
//       deliveredLabel: "Delivered",
//       readLabel: "Read",
//       vMessageLocalization: VMessageLocalization.fromEnglish(),
//     ),
//   ),
// );
