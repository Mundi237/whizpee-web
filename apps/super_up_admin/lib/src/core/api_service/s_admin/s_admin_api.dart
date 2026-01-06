// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' hide Response, Request;
import 'package:http/io_client.dart';
import 'package:v_platform/v_platform.dart';

import '../interceptors.dart';

part 's_admin_api.chopper.dart';

@ChopperApi(baseUrl: 'admin-panel')
abstract class SAdminApi extends ChopperService {
  @GET(path: "/dashboard")
  Future<Response> dashboard();

  @GET(path: "/config")
  Future<Response> config();

  @PATCH(path: "/config")
  Future<Response> updateConfig(@Body() Map<String, dynamic> body);

  @POST(path: "/login")
  Future<Response> login();

  @GET(path: "/users")
  Future<Response> getDashUsers(
    @QueryMap() Map<String, dynamic> body,
  );

  @GET(path: "/notifications")
  Future<Response> getNotifications();

  @POST(path: '/notifications')
  @multipart
  Future<Response> createNotifications(
    @PartFile("file") MultipartFile? file,
    @PartMap() List<PartValue> body,
  );

  @PATCH(path: "/user/info/{id}")
  Future<Response> updateUserData(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @GET(path: "/user/info/{id}")
  Future<Response> getUserInfo(
    @Path("id") String id,
  );

  static SAdminApi create({
    required Uri baseUrl,
    String? accessToken,
    Map<String, String>? headers,
  }) {
    final client = ChopperClient(
      baseUrl: baseUrl,
      services: [
        _$SAdminApi(),
      ],
      converter: const JsonConverter(),
      interceptors: [
        //AuthInterceptor(headers: headers),
        SAdminHeaderKeySetterInterceptor(),
      ],
      errorConverter: ErrorInterceptor(),
      client: VPlatforms.isWeb
          ? null
          : IOClient(
              HttpClient()..connectionTimeout = const Duration(seconds: 7),
            ),
    );
    return _$SAdminApi(client);
  }
}
