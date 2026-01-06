// // Copyright 2023, the hatemragab project author.
// // All rights reserved. Use of this source code is governed by a
// // MIT license that can be found in the LICENSE file.
//
// import 'package:flutter/material.dart';
// import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
//
// import '../lib/src/agora/pages/call/improved_call_page.dart';
//
// /// Example demonstrating how to use the improved call screens
// class ImprovedCallExample extends StatelessWidget {
//   const ImprovedCallExample({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Improved Call Screens Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () => _startVideoCall(context),
//               child: const Text('Start Video Call'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () => _startAudioCall(context),
//               child: const Text('Start Audio Call'),
//             ),
//             const SizedBox(height: 32),
//             const Text(
//               'Features of Improved Call Screens:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 32),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _FeatureItem(
//                     icon: Icons.design_services,
//                     title: 'Modern UI Design',
//                     description:
//                         'Clean gradients, smooth animations, and better visual hierarchy',
//                   ),
//                   SizedBox(height: 12),
//                   _FeatureItem(
//                     icon: Icons.responsive_layout,
//                     title: 'Responsive Layout',
//                     description:
//                         'Optimized for tablets and different screen orientations',
//                   ),
//                   SizedBox(height: 12),
//                   _FeatureItem(
//                     icon: Icons.language,
//                     title: 'Full Internationalization',
//                     description:
//                         'Support for all languages using s_translation package',
//                   ),
//                   SizedBox(height: 12),
//                   _FeatureItem(
//                     icon: Icons.error_outline,
//                     title: 'Better Error Handling',
//                     description:
//                         'Comprehensive error management with user-friendly messages',
//                   ),
//                   SizedBox(height: 12),
//                   _FeatureItem(
//                     icon: Icons.analytics,
//                     title: 'Call Quality Monitoring',
//                     description:
//                         'Visual indicators for connection quality and call statistics',
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _startVideoCall(BuildContext context) {
//     final callData = VCallDto(
//       roomId: 'example_room_${DateTime.now().millisecondsSinceEpoch}',
//       peerUser: _createExampleUser(),
//       isVideoEnable: true,
//       isCaller: true,
//     );
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ImprovedVCallPage(callData: callData),
//       ),
//     );
//   }
//
//   void _startAudioCall(BuildContext context) {
//     final callData = VCallDto(
//       roomId: 'example_room_${DateTime.now().millisecondsSinceEpoch}',
//       peerUser: _createExampleUser(),
//       isVideoEnable: false,
//       isCaller: true,
//     );
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ImprovedVCallPage(callData: callData),
//       ),
//     );
//   }
//
//   VChatUser _createExampleUser() {
//     return VChatUser(
//       id: 'example_user_id',
//       userTag: 'example_user',
//       fullName: 'John Doe',
//       userImage: 'https://via.placeholder.com/150/0000FF/FFFFFF?text=JD',
//       isOnline: true,
//       lastSeen: DateTime.now(),
//       baseUrl: '',
//       platform: VPlatform.android,
//       updatedAt: DateTime.now(),
//     );
//   }
// }
//
// class _FeatureItem extends StatelessWidget {
//   const _FeatureItem({
//     required this.icon,
//     required this.title,
//     required this.description,
//   });
//
//   final IconData icon;
//   final String title;
//   final String description;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(
//           icon,
//           color: Theme.of(context).primaryColor,
//           size: 24,
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 description,
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// /// Example of how to customize the improved call screens
// class CustomizedCallExample extends StatelessWidget {
//   const CustomizedCallExample({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Customized Call Example'),
//       ),
//       body: const Center(
//         child: Text(
//           'This example shows how the improved call screens\n'
//           'can be customized with different themes,\n'
//           'colors, and animations.',
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }
// }
//
// /// Entry point for the example app
// void main() {
//   runApp(const ImprovedCallExampleApp());
// }
//
// class ImprovedCallExampleApp extends StatelessWidget {
//   const ImprovedCallExampleApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Improved Call Screens Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         useMaterial3: true,
//       ),
//       home: const ImprovedCallExample(),
//       routes: {
//         '/customized': (context) => const CustomizedCallExample(),
//       },
//     );
//   }
// }
