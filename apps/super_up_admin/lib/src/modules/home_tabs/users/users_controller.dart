// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_admin/src/modules/home_tabs/users/users_page.dart';
import 'package:super_up_core/super_up_core.dart';

import '../../../core/api_service/api_service.dart';
import '../../../core/models/admin.dart';
import '../../../core/utils/no_animation_page_route.dart';
import 'nested/user_profile.dart';

class UsersController extends SLoadingController<PaginateModel<DashUser>> {
  UsersController() : super(SLoadingState(PaginateModel.empty()));
  final adminApi = GetIt.I.get<SAdminApiService>();
  final paginatorController = NumberPaginatorController();
  int currentPage = 1;

  bool isSortAscending = true;
  final currentFilter = {};

  @override
  void onInit() {
    getUsers();
    paginatorController.addListener(_paginatorControllerListener);
  }

  @override
  void onClose() {
    paginatorController.removeListener(_paginatorControllerListener);
    paginatorController.dispose();
  }

  Future<PaginateModel<DashUser>?> getUsers({
    Map<String, String> filter = const {},
  }) async {
    final result = await vSafeApiCall<PaginateModel<DashUser>>(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        return adminApi.getDashUsers({
          "page": currentPage,
          "sort": isSortAscending ? "-_id" : "_id",
          ...filter
        });
      },
      onSuccess: (response) {
        value.data = response;
        setStateSuccess();
        return response;
      },
      onError: (exception) {
        print(exception);
        if (exception is Error) {
          print('StackTrace: ${exception.stackTrace}');
        }
      },
    );

    return result.when(
      success: (data) => data,
      failure: (error) => null,
    );
  }

  void _paginatorControllerListener() async {
    final number = paginatorController.currentPage + 1;
    if (number != currentPage) {
      currentPage = number;
      await getUsers();
    }
  }

  void toggleSort() {
    isSortAscending = !isSortAscending;
    getUsers();
  }

  Future<void> onCopyId(BuildContext context, String id) async {
    await Clipboard.setData(ClipboardData(text: id));
    VAppAlert.showSuccessSnackBar(
      context: context,
      message: S.of(context).copy,
    );
  }

  void onUserTap(String id) {
    UsersTabNavigation.navKey.currentState?.push(
      NoAnimationPageRoute(
        builder: (context) => UserProfile(
          id: id,
        ),
      ),
    );
  }

  void onSearch(String query) async {
    if (query.isEmpty) {
      await getUsers();
      return;
    }
    await getUsers(filter: {
      "fullName": query,
    });
  }
}
