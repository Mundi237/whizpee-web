// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:chopper/chopper.dart';
import 'package:super_up_admin/src/core/models/dash_user/peer_user_info.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../models/admin.dart';

import '../interceptors.dart';
import 's_admin_api.dart';

class SAdminApiService {
  SAdminApiService._();

  static SAdminApi? _sAdminApi;

  Future<MainDashBoardModel> getDashboard() async {
    final res = await _sAdminApi!.dashboard();
    throwIfNotSuccess(res);
    return MainDashBoardModel.fromMap(extractDataFromResponse(res));
  }

  Future<AppConfigModel> getConfig() async {
    final res = await _sAdminApi!.config();
    throwIfNotSuccess(res);
    return AppConfigModel.fromMap(extractDataFromResponse(res));
  }

  Future<bool> login() async {
    final res = await _sAdminApi!.login();
    throwIfNotSuccess(res);
    return extractDataFromResponse(res)['isViewer'] ?? true;
  }

  Future<PaginateModel<DashUser>> getDashUsers(
    Map<String, dynamic> query,
  ) async {
    final res = await _sAdminApi!.getDashUsers(query);
    throwIfNotSuccess(res);
    final obj = extractDataFromResponse(res);
    return PaginateModel.fromCustomMap(
      map: obj,
      values: (obj['docs'] as List).map((e) => DashUser.fromMap(e)).toList(),
    );
  }

  Future<List<AdminNotificationsModel>> getNotifications() async {
    final res = await _sAdminApi!.getNotifications();
    throwIfNotSuccess(res);
    final obj = res.body['data'] as List;
    return obj.map((e) => AdminNotificationsModel.fromMap(e)).toList();
  }

  Future<bool> createNotifications({
    required String title,
    required String desc,
    VPlatformFile? img,
  }) async {
    final res = await _sAdminApi!.createNotifications(
        img == null
            ? null
            : await VPlatforms.getMultipartFile(
                source: img,
              ),
        [
          PartValue("title", title),
          PartValue(
            "content",
            desc,
          ),
        ]);
    throwIfNotSuccess(res);
    return true;
  }

  Future<PeerUserInfo> getUserInfo(String id) async {
    final res = await _sAdminApi!.getUserInfo(id);
    throwIfNotSuccess(res);
    final obj = extractDataFromResponse(res);
    return PeerUserInfo.fromMap(obj);
  }

  Future<bool> updateUserData(String id, Map<String, dynamic> body) async {
    final res = await _sAdminApi!.updateUserData(id, body);
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> updateConfig(Map<String, dynamic> data) async {
    final res = await _sAdminApi!.updateConfig(data);
    throwIfNotSuccess(res);
    return true;
  }

  static SAdminApiService init({
    Uri? baseUrl,
    String? accessToken,
    Map<String, String>? headers,
  }) {
    _sAdminApi ??= SAdminApi.create(
      accessToken: accessToken,
      headers: headers,
      baseUrl: baseUrl ?? SConstants.sApiBaseUrl,
    );
    return SAdminApiService._();
  }
}
