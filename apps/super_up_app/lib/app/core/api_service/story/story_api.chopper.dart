// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$StoryApi extends StoryApi {
  _$StoryApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = StoryApi;

  @override
  Future<Response<dynamic>> createStory(
    List<PartValue<dynamic>> body,
    MultipartFile? file,
  ) {
    final Uri $url = Uri.parse('user-story/');
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
  Future<Response<dynamic>> deleteStory(String id) {
    final Uri $url = Uri.parse('user-story/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getUsersStories(Map<String, dynamic> query) {
    final Uri $url = Uri.parse('user-story/');
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
  Future<Response<dynamic>> setSeen(String id) {
    final Uri $url = Uri.parse('user-story/views/${id}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getMyStories() {
    final Uri $url = Uri.parse('user-story/me');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> addViewToStory() {
    final Uri $url = Uri.parse('user-story/views/{id}');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getStoryViews(
    String storyId,
    Map<String, dynamic> query,
  ) {
    final Uri $url = Uri.parse('user-story/views/${storyId}');
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
