// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.
// @dart=3.0

import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' hide Request, Response;
import 'package:http/io_client.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_platform/v_platform.dart';

part 'announcement_room_api.chopper.dart';

@ChopperApi(baseUrl: 'announcement-rooms')
abstract class AnnouncementRoomApi extends ChopperService {
  /// Create message in announcement room
  @POST(path: "/{roomId}/messages")
  Future<Response> createAnnouncementMessage(
    @Path('roomId') String roomId,
    @Body() Map<String, dynamic> body,
  );

  /// Get messages in announcement room
  @GET(path: "/{roomId}/messages")
  Future<Response> getAnnouncementRoomMessages(
    @Path("roomId") String roomId,
    @QueryMap() Map<String, dynamic> query,
  );

  /// Get my conversations
  @GET(path: "/my-conversations")
  Future<Response> getMyConversations(@QueryMap() Map<String, dynamic> query);

  /// Get announcement room by ID
  @GET(path: "/{roomId}")
  Future<Response> getAnnouncementRoomById(@Path() String roomId);

  /// Delete announcement room message
  @DELETE(path: "/{roomId}/messages/{messageId}")
  Future<Response> deleteAnnouncementMessage(
    @Path("roomId") String roomId,
    @Path("messageId") String messageId,
  );

  static AnnouncementRoomApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: VAppConstants.baseUri,
      services: [
        _$AnnouncementRoomApi(),
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
    return _$AnnouncementRoomApi(client);
  }
}
