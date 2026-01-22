// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/src/exceptions/http/v_chat_http_exception.dart';

class ErrorInterceptor implements ErrorConverter {
  @override
  FutureOr<Response> convertError<BodyType, InnerType>(Response response) {
    final errorMap =
        jsonDecode(response.body.toString()) as Map<String, dynamic>;
    return response.copyWith(
      bodyError: errorMap,
      body: errorMap,
    );
  }
}

void throwIfNotSuccess(Response res) {
  if (res.isSuccessful) return;

  if (res.statusCode == 400) {
    throw VChatHttpBadRequest(
      vChatException: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  } else if (res.statusCode == 404) {
    throw VChatHttpNotFound(
      vChatException: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  } else if (res.statusCode == 403) {
    throw VChatHttpForbidden(
      vChatException: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  } else if (res.statusCode == 450) {
    unAuthStream450Error.add(true);
    throw VChatHttpUnAuth(
      vChatException: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  }
  if (!res.isSuccessful) {
    throw VChatHttpBadRequest(
      vChatException: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  }
}

Map<String, dynamic> extractDataFromResponse(Response res) {
  print("🔍 [extractDataFromResponse] Starting extraction");
  print(
      "🔍 [extractDataFromResponse] Response body type: ${res.body.runtimeType}");
  print("🔍 [extractDataFromResponse] Response body: ${res.body}");

  try {
    final body = res.body as Map<String, dynamic>;
    print("🔍 [extractDataFromResponse] Body casted to Map successfully");
    print("🔍 [extractDataFromResponse] Body keys: ${body.keys}");

    final data = body['data'];
    print("🔍 [extractDataFromResponse] Data type: ${data.runtimeType}");
    print("🔍 [extractDataFromResponse] Data value: $data");

    if (data is! Map<String, dynamic>) {
      print(
          "🔍 [extractDataFromResponse] ❌ ERROR: data is NOT a Map<String, dynamic>");
      print("🔍 [extractDataFromResponse] ❌ Actual type: ${data.runtimeType}");
      throw TypeError();
    }

    print("🔍 [extractDataFromResponse] ✅ Data casted to Map successfully");
    return data;
  } catch (e, stackTrace) {
    print("🔍 [extractDataFromResponse] ❌ EXCEPTION occurred: $e");
    print("🔍 [extractDataFromResponse] ❌ Stack trace: $stackTrace");
    rethrow;
  }
}

class AuthInterceptor implements Interceptor {
  final String? access;

  AuthInterceptor({this.access});

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = applyHeader(
      chain.request,
      'authorization',
      "Bearer ${access ?? VAppPref.getHashedString(
            key: SStorageKeys.vAccessToken.name,
          )}",
    );
    return chain.proceed(request);
  }
}
