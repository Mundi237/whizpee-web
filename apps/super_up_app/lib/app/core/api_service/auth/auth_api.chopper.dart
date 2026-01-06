// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AuthApi extends AuthApi {
  _$AuthApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AuthApi;

  @override
  Future<Response<dynamic>> login(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('auth/login');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getWebScan(Map<String, dynamic> queryData) {
    final Uri $url = Uri.parse('auth/get-web-scan-qr');
    final Map<String, dynamic> $params = queryData;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> checkWebScanLogin(String sessionId) {
    final Uri $url = Uri.parse('auth/check-web-scan-login/${sessionId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> verifyWebScanQr(String sessionId) {
    final Uri $url = Uri.parse('auth/verify-web-scan-qr/${sessionId}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> sendOtpResetPassword(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('auth/send-otp-reset-password');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> verifyAndResetPassword(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('auth/verify-and-reset-password');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> register(
    List<PartValue<dynamic>> body,
    MultipartFile? file,
  ) {
    final Uri $url = Uri.parse('auth/register');
    final List<PartValue> $parts = <PartValue>[
      PartValueFile<MultipartFile?>(
        'file',
        file,
      )
    ];
    $parts.addAll(body);
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> checkMethod(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('auth/check-method');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> logout(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('auth/logout');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
