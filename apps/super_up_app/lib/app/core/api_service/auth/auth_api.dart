// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' hide Response, Request;
import 'package:http/io_client.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

import '../interceptors.dart';

part 'auth_api.chopper.dart';

@ChopperApi(baseUrl: 'auth')
abstract class AuthApi extends ChopperService {
  @POST(path: "/login")
  Future<Response> login(@Body() Map<String, dynamic> body);

  @GET(path: "/get-web-scan-qr", optionalBody: true)
  Future<Response> getWebScan(@QueryMap() Map<String, dynamic> queryData);

  @GET(path: "/check-web-scan-login/{sessionId}", optionalBody: true)
  Future<Response> checkWebScanLogin(
    @Path("sessionId") String sessionId,
  );

  @POST(path: "/verify-web-scan-qr/{sessionId}", optionalBody: true)
  Future<Response> verifyWebScanQr(
    @Path("sessionId") String sessionId,
  );

  ///send-otp-reset-password
  @POST(path: "/send-otp-reset-password")
  Future<Response> sendOtpResetPassword(@Body() Map<String, dynamic> body);

  ///verify-and-reset-password
  @POST(path: "/verify-and-reset-password")
  Future<Response> verifyAndResetPassword(@Body() Map<String, dynamic> body);

  @POST(path: "/register")
  @multipart
  Future<Response> register(
    @PartMap() List<PartValue> body,
    @PartFile("file") MultipartFile? file,
  );

  @POST(path: "/check-method")
  Future<Response> checkMethod(@Body() Map<String, dynamic> body);

  @POST(path: "/logout")
  Future<Response> logout(@Body() Map<String, dynamic> body);

  static AuthApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: SConstants.sApiBaseUrl,
      services: [
        _$AuthApi(),
      ],
      converter: const JsonConverter(),
      interceptors: [AuthInterceptor()],
      errorConverter: ErrorInterceptor(),
      client: VPlatforms.isWeb
          ? null
          : IOClient(
              HttpClient()..connectionTimeout = const Duration(seconds: 7),
            ),
    );
    return _$AuthApi(client);
  }
}
