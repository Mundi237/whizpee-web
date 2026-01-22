// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=3.0

part of 'announcement_room_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AnnouncementRoomApi extends AnnouncementRoomApi {
  _$AnnouncementRoomApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AnnouncementRoomApi;

  @override
  Future<Response<dynamic>> createAnnouncementMessage(
    String roomId,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('announcement-rooms/${roomId}/messages');
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
  Future<Response<dynamic>> getAnnouncementRoomMessages(
    String roomId,
    Map<String, dynamic> query,
  ) {
    final Uri $url = Uri.parse('announcement-rooms/${roomId}/messages');
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
  Future<Response<dynamic>> getMyConversations(Map<String, dynamic> query) {
    final Uri $url = Uri.parse('announcement-rooms/my-conversations');
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
  Future<Response<dynamic>> getAnnouncementRoomById(String roomId) {
    final Uri $url = Uri.parse('announcement-rooms/${roomId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteAnnouncementMessage(
    String roomId,
    String messageId,
  ) {
    final Uri $url =
        Uri.parse('announcement-rooms/${roomId}/messages/${messageId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
