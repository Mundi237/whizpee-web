// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:super_up_core/super_up_core.dart';

class SDataTable extends StatelessWidget {
  final List<DataRow> data;
  final List<DataColumn2> columns;
  final VChatLoadingState loadingState;
  final NumberPaginatorController? paginatorController;
  final int maxPages;

  const SDataTable({
    super.key,
    required this.data,
    required this.columns,
    required this.maxPages,
    required this.loadingState,
    this.paginatorController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: loadingState == VChatLoadingState.loading,
            child: const LinearProgressIndicator(),
          ),
          Expanded(
            child: DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 650,
              headingTextStyle: Theme.of(context).textTheme.bodyMedium!.merge(
                  const TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.green)),
              columns: columns,
              rows: data,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 350,
                child: NumberPaginator(
                  numberPages: maxPages,
                  initialPage: 0,
                  controller: paginatorController,

                  // config: const NumberPaginatorUIConfig(
                  //   mode: ContentDisplayMode.numbers,
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   contentPadding: EdgeInsets.all(4),
                  // ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
