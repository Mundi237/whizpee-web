// // Copyright 2023, the hatemragab project author.
// // All rights reserved. Use of this source code is governed by a
// // MIT license that can be found in the LICENSE file.
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:v_platform/v_platform.dart';
//
// class VCircleAvatar extends StatelessWidget {
//   final int radius;
//   final VPlatformFile fullUrl;
//
//   const VCircleAvatar({
//     Key? key,
//     this.radius = 28,
//     required this.fullUrl,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return CircleAvatar(
//       backgroundColor: Colors.transparent,
//       radius: double.tryParse(radius.toString()),
//       backgroundImage: CachedNetworkImageProvider(
//         fullUrl.url!,
//       ),
//     );
//   }
// }
