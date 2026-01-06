// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:super_up/app/core/api_service/profile/profile_api.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../modules/home/settings_modules/my_account/views/sheet_for_update_password.dart';
import '../../../modules/peer_profile/states/peer_profile_state.dart';
import '../../dto/create_report_dto.dart';
import '../../models/user_device_model.dart';
import '../interceptors.dart';

class ProfileApiService {
  static ProfileApi? _profileApi;

  ProfileApiService._();

  Future<String> updateImage(VPlatformFile img) async {
    final res = await _profileApi!.updateImage(
      await VPlatforms.getMultipartFile(
        source: img,
      ),
    );
    throwIfNotSuccess(res);
    return res.body['data'] as String;
  }

  Future<void> updatePassword(UpdatePasswordDto dto) async {
    final res = await _profileApi!.updatePassword(dto.toMap());
    throwIfNotSuccess(res);
  }

  Future<SVersion> checkVersion(String current) async {
    final res = await _profileApi!.checkVersion({"semVer": current});
    throwIfNotSuccess(res);
    return SVersion.fromMap(extractDataFromResponse(res));
  }

  Future<bool> setVisit() async {
    final res = await _profileApi!.setVisit();
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> createReport(CreateReportDto data) async {
    final res = await _profileApi!.createReport(data.toMap());
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> deleteDevice(String id) async {
    final res = await _profileApi!.deleteDevice(
      id,
    );
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> deleteMyAccount(String password) async {
    final res = await _profileApi!.deleteMyAccount(
      {"password": password},
    );
    throwIfNotSuccess(res);
    return true;
  }

  Future<List<UserDeviceModel>> getMyDevices() async {
    final res = await _profileApi!.device();
    throwIfNotSuccess(res);
    final l = (res.body as Map<String, dynamic>)['data'] as List;
    return l.map((e) => UserDeviceModel.fromMap(e)).toList();
  }

  Future<List<SBaseUser>> getMyBlocked({
    VBaseFilter? filter,
  }) async {
    final res = await _profileApi!.myBlocked(filter?.toMap() ?? {});
    throwIfNotSuccess(res);
    final l = (res.body as Map<String, dynamic>)['data']['docs'] as List;
    return l.map((e) => SBaseUser.fromMap(e['targetId'])).toList();
  }

  Future<bool> updatePrivacy(UserPrivacy userPrivacy) async {
    final res = await _profileApi!.updatePrivacy(userPrivacy.toMap());
    throwIfNotSuccess(res);
    return true;
  }

  Future<List<AdminNotificationsModel>> getMyAdminNotifications({
    VBaseFilter? filter,
  }) async {
    final res = await _profileApi!.adminNotifications(filter?.toMap() ?? {});
    throwIfNotSuccess(res);
    final l = (res.body as Map<String, dynamic>)['data']['docs'] as List;
    return l.map((e) => AdminNotificationsModel.fromMap(e)).toList();
  }

  Future<bool> updateUserBio(String bio) async {
    final res = await _profileApi!.updateUserBio({"bio": bio});
    throwIfNotSuccess(res);

    return true;
  }

  Future<bool> updateUserName(String fullName) async {
    final res = await _profileApi!.updateUserName({"fullName": fullName});
    throwIfNotSuccess(res);

    return true;
  }

  Future<SMyProfile> getMyProfile() async {
    final res = await _profileApi!.myProfile();
    throwIfNotSuccess(res);
    return SMyProfile.fromMap(extractDataFromResponse(res));
  }

  Future<bool> passwordCheck(String password) async {
    final res = await _profileApi!.passwordCheck({"password": password});
    throwIfNotSuccess(res);
    return true;
  }

  Future<PeerProfileModel> peerProfile(String peerId) async {
    final res = await _profileApi!.peerProfile(peerId);
    throwIfNotSuccess(res);
    return PeerProfileModel.fromMap(res.body['data'] as Map<String, dynamic>);
  }

  Future<AppConfigModel> appConfig() async {
    final res = await _profileApi!.appConfig();
    throwIfNotSuccess(res);
    return AppConfigModel.fromMap(res.body['data'] as Map<String, dynamic>);
  }

  Future<List<SSearchUser>> appUsers(UserFilterDto dto) async {
    final res = await _profileApi!.appUsers(dto.toMap());
    throwIfNotSuccess(res);
    return (extractDataFromResponse(res)['docs'] as List)
        .map(
          (e) => SSearchUser.fromMap(e),
        )
        .toList();
  }

  static ProfileApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _profileApi ??= ProfileApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? SConstants.sApiBaseUrl,
    );
    return ProfileApiService._();
  }
}
