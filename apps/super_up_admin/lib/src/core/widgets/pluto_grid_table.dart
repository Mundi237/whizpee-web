// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:pluto_grid/pluto_grid.dart';
// import 'package:super_up_admin/src/core/models/admin.dart';
// import 'package:super_up_core/super_up_core.dart';
// import 'package:v_platform/v_platform.dart';
//
// class PlutoGridTable extends StatelessWidget {
//   PlutoGridTable({
//     super.key,
//     required this.getUsers,
//     required this.loadingState,
//   });
//
//   final Future<PaginateModel<DashUser>?> Function() getUsers;
//   final VChatLoadingState loadingState;
//   late final PlutoGridStateManager stateManager;
//   final List<PlutoRow> fakeFetchedRows = [];
//
//   @override
//   Widget build(BuildContext context) {
//     if (loadingState == VChatLoadingState.loading) {
//       return const LinearProgressIndicator();
//     }
//     return PlutoGrid(
//       onLoaded: (PlutoGridOnLoadedEvent event) {
//         stateManager = event.stateManager;
//         stateManager.setShowColumnFilter(true);
//       },
//       columns: [
//         PlutoColumn(
//           field: '_id',
//           title: "ID",
//           readOnly: true,
//           type: PlutoColumnType.text(),
//         ),
//         PlutoColumn(
//           field: 'name',
//           title: "",
//           renderer: (rendererContext) {
//             return Row(
//               children: [
//                 VCircleAvatar(
//                   vFileSource: VPlatformFile.fromUrl(
//                     url: rendererContext.row.cells['name']!.value['image'],
//                   ),
//                   radius: 17,
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   rendererContext.row.cells['name']!.value['fullName']
//                       .toString(),
//                   style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.blue),
//                 ),
//               ],
//             );
//           },
//           readOnly: true,
//           enableSorting: false,
//           type: PlutoColumnType.text(),
//         ),
//         PlutoColumn(
//           field: 'email',
//           title: "Email",
//           readOnly: true,
//           type: PlutoColumnType.text(),
//         ),
//         PlutoColumn(
//           field: 'country',
//           readOnly: true,
//           title: "Country",
//           enableRowDrag: false,
//           enableFilterMenuItem: false,
//           type: PlutoColumnType.text(defaultValue: ""),
//         ),
//         PlutoColumn(
//           title: 'Status',
//           field: 'registerStatus',
//           type: PlutoColumnType.select(
//             <String>[
//               'Accepted',
//               'Pending',
//               'Refused',
//             ],
//             enableColumnFilter: true,
//           ),
//         ),
//         PlutoColumn(
//           field: 'createdAt',
//           readOnly: true,
//           title: "Join at",
//           type: PlutoColumnType.text(),
//         ),
//         PlutoColumn(
//           field: 'deletedAt',
//           title: "Deleted at",
//           type: PlutoColumnType.date(defaultValue: null),
//         ),
//         PlutoColumn(
//           field: 'banTo',
//           title: "Ban at",
//           type: PlutoColumnType.date(defaultValue: null),
//         ),
//       ],
//       rows: [],
//       configuration: const PlutoGridConfiguration(
//         enableMoveDownAfterSelecting: true,
//       ),
//       createFooter: (stateManager) {
//         return PlutoLazyPagination(
//           initialPage: 1,
//           initialFetch: true,
//           fetchWithSorting: true,
//           fetchWithFiltering: true,
//           pageSizeToMove: null,
//           fetch: fetch,
//           stateManager: stateManager,
//         );
//       },
//       onRowChecked: (event) {
//         print("onRowChecked =>     $event");
//       },
//       onChanged: (event) {
//         print("onChanged =>     $event");
//       },
//       onRowDoubleTap: (event) {
//         print("onRowDoubleTap =>     $event");
//       },
//       onRowSecondaryTap: (event) {
//         print("onRowSecondaryTap =>     $event");
//       },
//       onSorted: (event) {
//         print("onSorted =>     $event");
//       },
//       onSelected: (event) {
//         print("onSelected =>     $event");
//       },
//     );
//   }
//
//   Future<PlutoLazyPaginationResponse> fetch(
//     PlutoLazyPaginationRequest request,
//   ) async {
//     List<PlutoRow> tempList = fakeFetchedRows;
//     if (request.filterRows.isNotEmpty) {
//       final filter = FilterHelper.convertRowsToFilter(
//         request.filterRows,
//         stateManager.refColumns,
//       );
//       tempList = fakeFetchedRows.where(filter!).toList();
//       print("-------------0");
//       print(tempList);
//     }
//     final users = await getUsers();
//     if (users == null) {
//       return PlutoLazyPaginationResponse(
//         totalPage: 1,
//         rows: [],
//       );
//     }
//     return PlutoLazyPaginationResponse(
//       totalPage: users.totalPages,
//       rows: users.values.map((e) => e.toPlutoRow()).toList(),
//     );
//   }
// }
