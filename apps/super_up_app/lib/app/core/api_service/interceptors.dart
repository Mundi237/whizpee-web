// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:super_up_core/super_up_core.dart';

import 'exceptions.dart';

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
  } else if (res.statusCode == 450) {
    unAuthStream450Error.add(true);
    throw VChatHttpUnAuth(
      exception: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  }
  if (!res.isSuccessful) {
    throw SuperHttpBadRequest(
      exception: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  }
}

dynamic extractDataFromResponse(Response res) {
  if (res.body == null) {
    throw Exception('Response body is null');
  }
  
  if (res.body is! Map<String, dynamic>) {
    throw Exception('Response body is not a Map<String, dynamic>: ${res.body.runtimeType}');
  }
  
  final body = res.body as Map<String, dynamic>;
  if (!body.containsKey('data')) {
    throw Exception('Response body does not contain "data" key. Available keys: ${body.keys.toList()}');
  }
  
  return body['data'];
}

class AuthInterceptor implements Interceptor {
  final String? access;

  AuthInterceptor({
    this.access,
  });

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = applyHeader(
      chain.request,
      'authorization',
      "Bearer ${access ?? VAppPref.getHashedString(key: SStorageKeys.vAccessToken.name)}",
    );
    return chain.proceed(request);
  }
}
