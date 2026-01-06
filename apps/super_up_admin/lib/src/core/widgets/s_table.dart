// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

// import 'package:flutter/material.dart';
// import 'package:number_paginator/number_paginator.dart';
// import 'package:responsive_table/responsive_table.dart';
// import 'package:super_up_core/super_up_core.dart';
//
// class STable extends StatelessWidget {
//   const STable({
//     Key? key,
//     required this.headers,
//     required this.source,
//     required this.loadingState,
//   }) : super(key: key);
//   final List<Map<String, dynamic>> source;
//
//   final VChatLoadingState loadingState;
//
//   final List<DatatableHeader> headers;
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           Container(
//             margin: const EdgeInsets.all(10),
//             padding: const EdgeInsets.all(0),
//             constraints: const BoxConstraints(
//               maxHeight: 700,
//               maxWidth: 2000,
//             ),
//             child: ResponsiveDatatable(
//               reponseScreenSizes: const [ScreenSize.xs],
//               headers: headers,
//               isExpandRows: false,
//               selecteds: const [],
//               footers: const [
//                 SizedBox(
//                   width: 400,
//                   child: NumberPaginator(
//                     numberPages: 50,
//                     initialPage: 0,
//                     config: NumberPaginatorUIConfig(
//                       mode: ContentDisplayMode.numbers,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       contentPadding: EdgeInsets.all(4),
//                     ),
//                   ),
//                 )
//               ],
//               title: const Text("Title"),
//               source: source,
//               expanded: source.map((e) => false).toList(),
//               onTabRow: (data) {
//                 print("onTabRow $data");
//               },
//               isLoading: loadingState == VLoadMoreStatus.loading,
//               headerDecoration: BoxDecoration(
//                 color: context.isDark ? const Color(0xff494545) : Colors.grey,
//                 border: const Border(
//                   bottom: BorderSide(color: Colors.red, width: 1),
//                 ),
//               ),
//               selectedDecoration: BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(color: Colors.green[300]!, width: 1),
//                 ),
//                 color: Colors.grey,
//               ),
//               headerTextStyle: Theme.of(context).textTheme.bodySmall,
//               rowTextStyle: const TextStyle(color: Colors.green),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
