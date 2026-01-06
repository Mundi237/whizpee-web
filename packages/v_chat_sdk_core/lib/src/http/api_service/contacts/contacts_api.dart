// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:chopper/chopper.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';

part 'contacts_api.chopper.dart';

@ChopperApi(baseUrl: 'contact')
abstract class ContactsApi extends ChopperService {
  @Post(path: "/")
  Future<Response> createContacts(
    @Body() Map<String, dynamic> body,
  );

  @Put(path: "/")
  Future<Response> updateContacts(
    @Body() Map<String, dynamic> body,
  );

  @Delete(path: "/")
  Future<Response> deleteContacts(
    @Body() Map<String, dynamic> body,
  );

  static ContactsApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: VAppConstants.baseUri,
      services: [
        _$ContactsApi(),
      ],
      converter: const JsonConverter(),
      interceptors: [AuthInterceptor()],
      errorConverter: ErrorInterceptor(),
    );
    return _$ContactsApi(client);
  }
}
