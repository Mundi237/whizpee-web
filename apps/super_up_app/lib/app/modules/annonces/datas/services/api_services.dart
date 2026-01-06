// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:super_up/app/modules/annonces/cores/error_handler.dart';
import 'package:super_up/app/modules/annonces/datas/utils.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

class InterceptorsWrapper extends Interceptor {
  final Dio dio;
  InterceptorsWrapper(this.dio);

  @override
  onResponse(response, handler) {
    return handler.next(response);
  }

  @override
  Future<void> onRequest(options, handler) async {
    // Utils.printer(options.data);
    Utils.printer(options.uri);
    final Map<String, dynamic> header = await getHeader();
    if (!options.headers.containsKey('registrations')) {
      options.headers.addAll(header);
    }

    return handler.next(options);
  }

  @override
  onError(DioException err, ErrorInterceptorHandler handler) async {
    Utils.logger(
      "Error ${err.message ?? err.response?.data ?? err.toString()},\n URI: ${err.requestOptions.uri}, Code: ${err.response?.statusCode}",
      level: Level.error,
    );

    if (err.response?.statusCode == 400 || err.response?.statusCode == 500) {
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: CustomException(
            message: getAuthErrorMessage(err.response),
            code: 401,
          ),
          type: DioExceptionType.badResponse,
        ),
      );
    }
    final bool isAuthError = err.response?.statusCode == 400 &&
        (err.response?.data is Map<String, dynamic> &&
            (err.response?.data as Map<String, dynamic>).containsKey("data") &&
            (err.response?.data as Map<String, dynamic>)["data"]
                .toString()
                .startsWith("JWT"));
    if (isAuthError || err.response?.statusCode == 401) {
      // Try to refresh token
      final token = await refreshToken();
      if (token != null) {
        err.requestOptions.headers['Authorization'] = "Bearer $token";
        return dio.fetch(err.requestOptions).then((value) {
          return handler.resolve(value);
        });
      }
    }
    return handler.next(err);
  }

  static Future<Map<String, dynamic>> getHeader() async {
    final data = {
      'Content-Type': 'application/json',
      "Accept": "Application/json",
    };
    try {
      String? token =
          VAppPref.getHashedString(key: SStorageKeys.vAccessToken.name)
              ?.toString();
      Utils.printLog("Token Received from storage: $token");
      data['Authorization'] = "Bearer $token";
    } catch (e) {
      Utils.printLog(e);
    }
    return data;
  }
}

String getAuthErrorMessage(Response<dynamic>? response) {
  String? reponse;

  if (response?.data is Map && (response!.data as Map).containsKey("error")) {
    reponse = (response.data as Map)['error'];
  } else {
    response?.data is Map
        ? (response!.data as Map).values.first?.toString()
        : response?.data is String
            ? response!.data?.toString()
            : null;
    if (response?.data is Map) {
      final errors = response!.data['errors'];
      if (errors is List) {
        try {
          reponse = errors.firstOrNull?['detail'];
        } catch (e) {
          reponse = errors.firstOrNull.toString();
        }
      } else {
        reponse = response.data.toString();
      }
    }
  }
  return reponse ?? "Les données envoyées sont incorrectes";
}

Future<String?> refreshToken() async {
  try {
    final deviceHelper = DeviceInfoHelper();
    final response = await Dio().post(
      "$BASE_URL/api/v1/auth/firebase-login",
      data: {
        "idToken": await FirebaseAuth.instance.currentUser?.getIdToken(),
        "platform": VPlatforms.currentPlatform,
        "deviceInfo": await deviceHelper.getDeviceMapInfo(),
        "deviceId": await deviceHelper.getId(),
        "language": VLanguageListener.I.appLocal.languageCode,
      },
    );
    final String accessToken = response.data['data']['accessToken'];
    Utils.printLog("Refreshed Token: $accessToken");
    await VAppPref.setHashedString(
      SStorageKeys.vAccessToken.name,
      accessToken..toString().trim(),
    );
    return accessToken;
  } catch (e) {
    Utils.printLog(e);
    return null;
  }
}

class API {
  final Dio dios = Dio(
    BaseOptions(
      baseUrl: "$BASE_URL/api/v1",
      sendTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  Dio get dio => dios;
  API() {
    dios.interceptors.addAll({InterceptorsWrapper(dios)});
  }
}

class APIPackages {
  final Dio dios = Dio(
    BaseOptions(
      baseUrl: BASE_URL,
      sendTimeout: const Duration(seconds: 30),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  Dio get dio => dios;
  APIPackages() {
    dios.interceptors.addAll({InterceptorsWrapper(dios)});
  }
}

class BadRequestException extends DioException {
  BadRequestException(RequestOptions r, Response<dynamic>? response)
      : super(requestOptions: r, response: response) {
    String? reponse;

    if (response?.data is Map && (response!.data as Map).containsKey("error")) {
      reponse = (response.data as Map)['error'];
    } else {
      response?.data is Map
          ? (response!.data as Map).values.first?.toString()
          : response?.data is String
              ? response!.data?.toString()
              : null;
      if (response?.data is Map) {
        final errors = response!.data['errors'];
        if (errors is List) {
          try {
            reponse = errors.firstOrNull?['detail'];
          } catch (e) {
            reponse = errors.firstOrNull.toString();
          }
        } else {
          reponse = response.data.toString();
        }
      }
    }
    throw Exception(
      reponse ?? "Les données envoyées sont incorrectes",
    );
  }
}

const BASE_URL = "https://api.whizpee.com";
