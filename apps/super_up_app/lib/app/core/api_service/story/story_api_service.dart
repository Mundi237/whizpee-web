// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:super_up/app/core/api_service/story/story_api.dart';
import 'package:super_up/app/core/models/story/create_story_dto.dart';
import 'package:super_up/app/core/models/story/story_model.dart';
import 'package:super_up/app/core/models/story/story_viewer_model.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

import '../interceptors.dart';

class StoryApiService {
  static StoryApi? _storyApi;

  StoryApiService._();

  Future<void> createStory(CreateStoryDto dto) async {
    final body = dto.toListOfPartValue();
    final res = await _storyApi!.createStory(
      body,
      dto.image == null
          ? null
          : await VPlatforms.getMultipartFile(
              source: dto.image!,
            ),
    );
    throwIfNotSuccess(res);
  }

  Future<void> deleteStory(String id) async {
    final res = await _storyApi!.deleteStory(id);
    throwIfNotSuccess(res);
  }

  Future<void> setSeen(String id) async {
    final res = await _storyApi!.setSeen(id);
    throwIfNotSuccess(res);
  }

  Future<List<UserStoryModel>> getUsersStories({
    int page = 1,
    int limit = 30,
  }) async {
    final res = await _storyApi!.getUsersStories({
      "page": page,
      "limit": limit,
    });
    throwIfNotSuccess(res);
    final responseData = extractDataFromResponse(res);
    
    if (responseData is! Map<String, dynamic>) {
      throw Exception('Expected Map<String, dynamic> but got ${responseData.runtimeType}');
    }
    
    return (responseData['docs'] as List)
        .map((e) => UserStoryModel.fromMap(e))
        .toList();
  }

  Future<UserStoryModel?> getMyStories() async {
    final res = await _storyApi!.getMyStories();
    throwIfNotSuccess(res);
    final responseData = extractDataFromResponse(res);
    
    if (responseData is! Map<String, dynamic>) {
      throw Exception('Expected Map<String, dynamic> but got ${responseData.runtimeType}');
    }
    
    final l = responseData['docs'] as List;
    if (l.isEmpty) return null;
    return UserStoryModel.fromMap(l.first);
  }

  Future<List<StoryViewerModel>> getStoryViews({
    required String storyId,
    int page = 1,
    int limit = 30,
  }) async {
    final res = await _storyApi!.getStoryViews(storyId, {
      "page": page,
      "limit": limit,
    });
    throwIfNotSuccess(res);
    try {
      final responseData = extractDataFromResponse(res);

      
      List<dynamic> viewsList = [];
      
      if (responseData is List) {
        // Handle case where data is a list of story objects
        for (final storyObj in responseData) {
          if (storyObj is Map<String, dynamic> && storyObj.containsKey('views')) {
            final views = storyObj['views'] as List;
            viewsList.addAll(views);
          }
        }
      } else if (responseData is Map<String, dynamic>) {
        // Handle different possible response structures
        if (responseData.containsKey('views')) {
          viewsList = responseData['views'] as List;
        } else if (responseData.containsKey('docs')) {
          viewsList = responseData['docs'] as List;
        } else {
          print('Unexpected response structure: $responseData');
          return [];
        }
      } else {
        print('Unexpected response data type: ${responseData.runtimeType}');
        return [];
      }
      
      if (viewsList.isEmpty) return [];
      return viewsList.map((e) => StoryViewerModel.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error parsing story views response: $e');
      print('Raw response body: ${res.body}');
      return [];
    }
  }

  static StoryApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _storyApi ??= StoryApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? SConstants.sApiBaseUrl,
    );
    return StoryApiService._();
  }
}
