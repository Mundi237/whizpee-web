// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

import '../dashboard_controller.dart';

class DashInfoItem extends StatelessWidget {
  final DashGridItemModel dashGridItemModel;

  const DashInfoItem({
    super.key,
    required this.dashGridItemModel,
  });

  @override
  Widget build(BuildContext context) {
    //check if media query width is mobile
    final isMobile = MediaQuery.of(context).size.width < 600;
    return GridTile(
      child: Container(
        padding: isMobile
            ? const EdgeInsets.only(left: 5)
            : const EdgeInsets.only(left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (dashGridItemModel.iconWidget != null)
              dashGridItemModel.iconWidget!
            else
              Icon(
                dashGridItemModel.iconData,
                color: Colors.green,
                size: 40,
              ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                if (isMobile)
                  Flexible(child: "${dashGridItemModel.title}: ".text)
                else
                  Flexible(child: "${dashGridItemModel.title}: ".h6),
                if (isMobile)
                  dashGridItemModel.valueFormat
                      .toString()
                      .h5
                      .color(Colors.green)
                else
                  dashGridItemModel.valueFormat
                      .toString()
                      .h4
                      .color(Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
