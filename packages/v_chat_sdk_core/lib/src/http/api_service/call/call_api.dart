// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:chopper/chopper.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';

part 'call_api.chopper.dart';

@ChopperApi(baseUrl: 'call')
abstract class CallApi extends ChopperService {
  @GET(path: "/active", optionalBody: true)
  Future<Response> getActiveCall();

  @GET(path: "/history", optionalBody: true)
  Future<Response> getCallHistory();

  @GET(path: "/agora-access/{roomId}", optionalBody: true)
  Future<Response> getAgoraAccess(
    @Path() String roomId,
  );

  @POST(path: "/create/{roomId}")
  Future<Response> createCall(
    @Path() String roomId,
    @Body() Map<String, dynamic> body,
  );

  @POST(path: "/accept/{callId}", optionalBody: true)
  Future<Response> acceptCall(
    @Path() String callId,
    @Body() Map<String, dynamic> body,
  );

  @POST(path: "/reject/{callId}", optionalBody: true)
  Future<Response> rejectCall(
    @Path() String callId,
  );

  @POST(path: "/end/v2/{callId}", optionalBody: true)
  Future<Response> endCallV2(
    @Path() String callId,
  );

  @DELETE(path: "/history/clear", optionalBody: true)
  Future<Response> clearHistory();

  @DELETE(path: "/history/clear/{id}", optionalBody: true)
  Future<Response> deleteOneHistory(
    @Path() String id,
  );

  static CallApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: VAppConstants.baseUri,
      services: [
        _$CallApi(),
      ],
      converter: const JsonConverter(),
      interceptors: [AuthInterceptor()],
      errorConverter: ErrorInterceptor(),
    );
    return _$CallApi(client);
  }
}
