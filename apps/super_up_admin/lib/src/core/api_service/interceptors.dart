// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:super_up_core/super_up_core.dart';

import 'api_service.dart';

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
    throw SuperHttpBadRequest(
      exception: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  } else if (res.statusCode == 404) {
    throw SuperHttpBadRequest(
      exception: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  } else if (res.statusCode == 403) {
    throw SuperHttpBadRequest(
      exception: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  }
  if (!res.isSuccessful) {
    throw SuperHttpBadRequest(
      exception: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  }
}

Map<String, dynamic> extractDataFromResponse(Response res) {
  return (res.body as Map<String, dynamic>)['data'] as Map<String, dynamic>;
}

class SAdminHeaderKeySetterInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = applyHeader(
      chain.request,
      'admin-key',
      "${VAppPref.getHashedString(key: SStorageKeys.adminAccessPassword.name)}",
    );
    return chain.proceed(request);
  }
}
