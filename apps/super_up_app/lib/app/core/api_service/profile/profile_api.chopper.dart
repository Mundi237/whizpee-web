// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ProfileApi extends ProfileApi {
  _$ProfileApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ProfileApi;

  @override
  Future<Response<dynamic>> updateImage(MultipartFile file) {
    final Uri $url = Uri.parse('profile/image');
    final List<PartValue> $parts = <PartValue>[
      PartValueFile<MultipartFile>(
        'file',
        file,
      )
    ];
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> checkVersion(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('profile/version');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateUserName(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('profile/name');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updatePassword(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('profile/password');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateUserBio(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('profile/bio');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> setVisit() {
    final Uri $url = Uri.parse('profile/visit');
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createReport(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('profile/report');
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
  Future<Response<dynamic>> device() {
    final Uri $url = Uri.parse('profile/device');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updatePrivacy(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('profile/privacy');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> adminNotifications(Map<String, dynamic> query) {
    final Uri $url = Uri.parse('profile/admin-notifications');
    final Map<String, dynamic> $params = query;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteDevice(String id) {
    final Uri $url = Uri.parse('profile/device/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteMyAccount(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('profile/delete-my-account');
    final $body = body;
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> myBlocked(Map<String, dynamic> query) {
    final Uri $url = Uri.parse('profile/blocked');
    final Map<String, dynamic> $params = query;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> myProfile() {
    final Uri $url = Uri.parse('profile/');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> passwordCheck(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('profile/password-check');
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
  Future<Response<dynamic>> peerProfile(String id) {
    final Uri $url = Uri.parse('profile/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> appConfig() {
    final Uri $url = Uri.parse('profile/app-config');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> appUsers(Map<String, dynamic> query) {
    final Uri $url = Uri.parse('profile/users');
    final Map<String, dynamic> $params = query;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
