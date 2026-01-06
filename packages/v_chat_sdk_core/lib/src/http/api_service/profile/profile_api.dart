// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/io_client.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_platform/v_platform.dart';

part 'profile_api.chopper.dart';

@ChopperApi(baseUrl: 'profile')
abstract class ProfileApi extends ChopperService {
  ///add fcm
  @POST(path: "/push")
  Future<Response> addNotificationPush(@Body() Map<String, dynamic> body);

  ///delete fcm
  @DELETE(path: "/push")
  Future<Response> deleteNotificationPush();

  @GET(path: "/users/{peerId}/last-seen", optionalBody: true)
  Future<Response> getLastSeenAt(
    @Path("peerId") String peerId,
  );

  static ProfileApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: VAppConstants.baseUri,
      services: [
        _$ProfileApi(),
      ],
      converter: const JsonConverter(),
      //, HttpLoggingInterceptor()
      interceptors: [AuthInterceptor()],
      errorConverter: ErrorInterceptor(),
      client: VPlatforms.isWeb
          ? null
          : IOClient(
              HttpClient()..connectionTimeout = const Duration(seconds: 15),
            ),
    );
    return _$ProfileApi(client);
  }
}
