// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/core/api_service/api_service.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class AdminNotificationController
    extends SLoadingController<List<AdminNotificationsModel>> {
  AdminNotificationController() : super(SLoadingState([]));
  final _apiService = GetIt.I.get<ProfileApiService>();
  bool isFinishLoadMore = false;
  bool _isLoadMoreActive = false;
  final _filterDto = VBaseFilter(
    limit: 30,
    page: 1,
  );

  @override
  void onClose() {}

  @override
  void onInit() {
    getData();
  }

  Future<void> getData() async {
    await vSafeApiCall<List<AdminNotificationsModel>>(
      onLoading: () async {
        setStateLoading();
      },
      onError: (exception) {
        setStateError();
      },
      request: () async {
        return _apiService.getMyAdminNotifications();
      },
      onSuccess: (response) {
        value.data = response;
        setStateSuccess();
      },
      config: const VApiConfig(
        ignoreTimeoutErrors: false,
        ignoreNetworkErrors: false,
      ),
    );
  }

  Future<bool> onLoadMore() async {
    if (_isLoadMoreActive) {
      return false;
    }
    final result = await vSafeApiCall<List<AdminNotificationsModel>>(
      onLoading: () {
        _isLoadMoreActive = true;
      },
      request: () async {
        ++_filterDto.page;
        return _apiService.getMyAdminNotifications(filter: _filterDto);
      },
      onSuccess: (response) {
        if (response.isEmpty) {
          isFinishLoadMore = true;
        }
        notifyListeners();
        _isLoadMoreActive = false;
        value.data.addAll(response);
      },
      onError: (exception) {
        if (kDebugMode) {
          print(exception);
        }
        if (kDebugMode) {
          if (exception is Error) {
            print('StackTrace: ${exception.stackTrace}');
          }
        }
        _isLoadMoreActive = false;
      },
    );

    return result.when(
      success: (data) => data.isNotEmpty,
      failure: (error) => false,
    );
  }
}
