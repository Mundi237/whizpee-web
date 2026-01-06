// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_up/app/modules/choose_members/widgets/cupertino_checkbox_list_tile.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import '../controllers/report_controller.dart';

class ReportPage extends StatefulWidget {
  final String userId;

  const ReportPage({super.key, required this.userId});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late final ReportController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).report),
          actions: [
            CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.zero,
              onPressed: !controller.isSendReady
                  ? null
                  : () => controller.onReport(context),
              child: Text(S.of(context).send),
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CupertinoCheckboxListTile(
                    title: S.of(context).spamOrScamDescription.text.maxLine(10),
                    value: controller.data.currentType == 1,
                    onChanged: (value) {
                      controller.onTypePress(value == true ? 1 : 0);
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CupertinoCheckboxListTile(
                    title: S
                        .of(context)
                        .harassmentOrBullyingDescription
                        .text
                        .maxLine(10),
                    value: controller.data.currentType == 2,
                    onChanged: (value) {
                      controller.onTypePress(value == true ? 2 : 0);
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CupertinoCheckboxListTile(
                    title: S
                        .of(context)
                        .inappropriateContentDescription
                        .text
                        .maxLine(10),
                    value: controller.data.currentType == 3,
                    onChanged: (value) {
                      controller.onTypePress(value == true ? 3 : 0);
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CupertinoCheckboxListTile(
                    title:
                        S.of(context).otherCategoryDescription.text.maxLine(10),
                    value: controller.data.currentType == 4,
                    onChanged: (value) {
                      controller.onTypePress(value == true ? 4 : 0);
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CupertinoCheckboxListTile(
                    title: S.of(context).blockUser.text.maxLine(10),
                    value: controller.data.blockThisUser,
                    onChanged: (value) {
                      controller.onBlockPress(value ?? false);
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  STextFiled(
                    maxLines: 10,
                    minLines: 5,
                    controller: controller.txtController,
                    textHint: S.of(context).explainWhatHappens,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = ReportController(widget.userId);
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }
}
