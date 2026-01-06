// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../dto/reset_password_dto.dart';
import '../interceptors.dart';
import 'auth_api.dart';

class AuthApiService {
  AuthApiService._();

  static AuthApi? _authApi;

  Future<void> login(LoginDto dto) async {
    final body = dto.toMap();
    final response = await _authApi!.login(body);
    throwIfNotSuccess(response);
    await VAppPref.setHashedString(
      SStorageKeys.vAccessToken.name,
      extractDataFromResponse(response)['accessToken'].toString(),
    );
  }

  Future<String?> checkMethod({
    required RegisterMethod authType,
    required String authId,
  }) async {
    final response = await _authApi!.checkMethod({
      "authType": authType.name,
      "authId": authId,
    });
    throwIfNotSuccess(response);
    final x = (response.body as Map<String, dynamic>)['data'];
    if (x == null) return null;
    return x['fullName'];
  }

  Future sendResetPasswordEmailOtp(String email) async {
    final response = await _authApi!.sendOtpResetPassword({"email": email});
    throwIfNotSuccess(response);
  }

  Future verifyAndResetPassword(ResetPasswordDto dto) async {
    final response = await _authApi!.verifyAndResetPassword(dto.toMap());
    throwIfNotSuccess(response);
  }

  Future<String> getWebScan(String deviceId) async {
    final response = await _authApi!.getWebScan({"id": deviceId});
    throwIfNotSuccess(response);
    return extractDataFromResponse(response)['_id'] as String;
  }

  Future<void> checkWebScanLogin(String sessionId) async {
    final response = await _authApi!.checkWebScanLogin(sessionId);
    throwIfNotSuccess(response);
  }

  Future<void> verifyWebScanQr(String sessionId) async {
    final response = await _authApi!.verifyWebScanQr(sessionId);
    throwIfNotSuccess(response);
  }

  Future<void> register(RegisterDto dto) async {
    final body = dto.toListOfPartValue();
    final response = await _authApi!.register(
      body,
      dto.image == null
          ? null
          : await VPlatforms.getMultipartFile(
              source: dto.image!,
            ),
    );
    throwIfNotSuccess(response);
    await VAppPref.setHashedString(
      SStorageKeys.vAccessToken.name,
      extractDataFromResponse(response)['accessToken'].toString(),
    );
  }

  static AuthApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _authApi ??= AuthApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? SConstants.sApiBaseUrl,
    );
    return AuthApiService._();
  }

  Future<bool> logout({required bool isLogoutFromALl}) async {
    final response = await _authApi!.logout({"logoutFromAll": isLogoutFromALl});
    throwIfNotSuccess(response);
    return true;
  }
}
