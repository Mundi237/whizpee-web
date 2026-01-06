// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_admin/src/modules/home_tabs/users/users_controller.dart';
import 'package:super_up_admin/src/modules/home_tabs/users/widget/search_text_field.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../core/utils/no_animation_page_route.dart';
import '../../../core/widgets/s_data_table.dart';

class UsersTabNavigation extends StatelessWidget {
  const UsersTabNavigation({
    super.key,
  });

  static final navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navKey,
      initialRoute: 'IdleUsersRoute',
      onGenerateRoute: (settings) {
        return NoAnimationPageRoute(
          fullscreenDialog: false,
          builder: (context) {
            return const UsersPage();
          },
        );
      },
    );
  }
}

class UsersPage extends StatefulWidget {
  static final navKey = GlobalKey<NavigatorState>();

  const UsersPage({
    super.key,
  });

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final controller = UsersController();

  @override
  void initState() {
    super.initState();
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SearchTextField(
              onSearch: controller.onSearch,
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: controller,
              builder: (_, value, __) {
                return SDataTable(
                  paginatorController: controller.paginatorController,
                  maxPages: controller.data.totalPages == 0
                      ? 1
                      : controller.data.totalPages,
                  loadingState: value.loadingState,
                  data: controller.data.values
                      .map(
                        (e) => DataRow(
                          cells: [
                            DataCell(
                              InkWell(
                                onTap: () => controller.onCopyId(context, e.id),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.copy,
                                      color: Colors.indigo,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(child: Text(e.id)),
                                  ],
                                ),
                              ),
                            ),
                            DataCell(
                              InkWell(
                                onTap: () => controller.onUserTap(e.id),
                                child: Row(
                                  children: [
                                    VCircleAvatar(
                                        vFileSource: VPlatformFile.fromUrl(
                                          networkUrl: e.userImage,
                                        ),
                                        radius: 15),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                        child: e.fullName.text.underline
                                            .color(Colors.blue)),
                                  ],
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.country == null
                                    ? ""
                                    : "${e.country!.emoji} ${e.country!.name}",
                              ),
                            ),
                            DataCell(Text(e.email)),
                            DataCell(Text(e.registerStatus)),
                            DataCell(
                              Text(
                                format(
                                  e.createdAt,
                                  locale: Localizations.localeOf(context)
                                      .languageCode,
                                ),
                              ),
                            ),
                            DataCell(Text(
                              _getDateFromString(e.deletedAt) ??
                                  S.of(context).none,
                            )),
                            DataCell(Text(_getDateFromString(e.banTo) ??
                                S.of(context).none)),
                          ],
                        ),
                      )
                      .toList(),
                  columns: [
                    DataColumn2(
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.of(context).id),
                          const SizedBox(
                            width: 6,
                          ),
                          const Icon(Icons.sort)
                        ],
                      ),
                      fixedWidth: 200,
                      onSort: (columnIndex, ascending) {
                        controller.toggleSort();
                      },
                    ),
                    DataColumn2(
                        label: Text(S.of(context).name), fixedWidth: 110),
                    DataColumn2(
                        label: Text(S.of(context).country), fixedWidth: 110),
                    DataColumn2(
                        label: Text(S.of(context).email), fixedWidth: 110),
                    DataColumn2(
                        label: Text(S.of(context).status), fixedWidth: 80),
                    DataColumn2(label: Text(S.of(context).joinedAt)),
                    DataColumn2(label: Text(S.of(context).deletedAt)),
                    DataColumn2(label: Text(S.of(context).banAt)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String? _getDateFromString(String? str) {
    if (str == null) return null;
    return DateFormat.yMd(
      Localizations.localeOf(context).languageCode,
    ).format(DateTime.parse(str).toLocal());
  }
}
