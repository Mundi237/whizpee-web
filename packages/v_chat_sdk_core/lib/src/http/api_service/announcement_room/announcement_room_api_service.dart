// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:v_chat_sdk_core/src/http/api_service/announcement_room/announcement_room_api.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/src/models/v_chat_base_exception.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VAnnouncementRoomApiService {
  static AnnouncementRoomApi? _announcementRoomApi;

  VAnnouncementRoomApiService._();

  /// Get messages in announcement room
  Future<List<VBaseMessage>> getAnnouncementRoomMessages({
    required String roomId,
    required VRoomMessagesDto dto,
  }) async {
    // print("🔍 [AnnouncementRoom] Getting messages for roomId: $roomId");
    // print("🔍 [AnnouncementRoom] DTO params: ${dto.toMap()}");

    final res = await _announcementRoomApi!.getAnnouncementRoomMessages(
      roomId,
      dto.toMap(),
    );

    // print("🔍 [AnnouncementRoom] Response status: ${res.statusCode}");
    // print("🔍 [AnnouncementRoom] Response isSuccessful: ${res.isSuccessful}");
    // print("🔍 [AnnouncementRoom] Response body type: ${res.body.runtimeType}");
    // print("🔍 [AnnouncementRoom] Response body: ${res.body}");

    // Handle the case where room has no messages yet (400 error with specific message)
    if (!res.isSuccessful && res.statusCode == 400) {
      final errorMap = res.error as Map<String, dynamic>?;
      final errorMessage = errorMap?['data']?.toString() ?? '';
      // print("🔍 [AnnouncementRoom] Error 400 - Message: $errorMessage");
      if (errorMessage.contains('dont have messages yet')) {
        // print(
        //     "🔍 [AnnouncementRoom] Room has no messages yet, returning empty list");
        return [];
      }
    }

    throwIfNotSuccess(res);

    // Handle different response formats from announcement API
    final List<dynamic> messagesList;

    if (res.body is List) {
      // Format 1: Direct list response: [...]
      // print("🔍 [AnnouncementRoom] Response is a direct List");
      messagesList = res.body as List;
      // print("🔍 [AnnouncementRoom] List has ${messagesList.length} items");
    } else if (res.body is Map<String, dynamic>) {
      // Format 2: Object response with data field
      final responseBody = res.body as Map<String, dynamic>;
      // print("🔍 [AnnouncementRoom] Response body keys: ${responseBody.keys}");

      final data = responseBody['data'];
      // print("🔍 [AnnouncementRoom] Data type: ${data.runtimeType}");
      // print("🔍 [AnnouncementRoom] Data value: $data");

      if (data is List) {
        // Format 2a: { data: [...] }
        // print("🔍 [AnnouncementRoom] Data is a List with ${data.length} items");
        messagesList = data;
      } else if (data is Map<String, dynamic> && data.containsKey('docs')) {
        // Format 2b: { data: { docs: [...] } }
        // print("🔍 [AnnouncementRoom] Data is a Map with 'docs' key");
        messagesList = data['docs'] as List;
        // print(
        //     "🔍 [AnnouncementRoom] Docs list has ${messagesList.length} items");
      } else {
        // print(
        //     "🔍 [AnnouncementRoom] Data is neither List nor Map with docs, returning empty");
        messagesList = [];
      }
    } else {
      // print("🔍 [AnnouncementRoom] Unknown response format, returning empty");
      messagesList = [];
    }

    // print("🔍 [AnnouncementRoom] Processing ${messagesList.length} messages");

    return messagesList
        .map(
          (e) => MessageFactory.createBaseMessage(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  /// Create a message in announcement room
  Future<VBaseMessage> createAnnouncementMessage(
    VMessageUploadModel messageModel,
  ) async {
    // print(
    //     "🔍 [AnnouncementRoom] Creating message in roomId: ${messageModel.roomId}");

    // Convert PartValue list to Map and extract only essential fields for announcement API
    final bodyMap = messageModel.getMapFromPartValuesUsingMap();
    // print("🔍 [AnnouncementRoom] Original body map: $bodyMap");

    // Announcement API expects JSON with content, messageType, and localId
    final requestBody = {
      'content': bodyMap['content'] ?? '',
      'messageType': bodyMap['messageType'] ?? 'text',
      'localId': bodyMap['localId'] ?? '',
    };

    // print("🔍 [AnnouncementRoom] Request body: $requestBody");

    late Response res;
    try {
      res = await _announcementRoomApi!.createAnnouncementMessage(
        messageModel.roomId,
        requestBody,
      );
    } on SocketException {
      // print("🔍 [AnnouncementRoom] SocketException occurred");
      throw VUserInternetException(exception: "SocketException");
    } on TimeoutException {
      // print("🔍 [AnnouncementRoom] TimeoutException occurred");
      throw VUserInternetException(exception: "TimeoutException");
    }

    // print("🔍 [AnnouncementRoom] Create response status: ${res.statusCode}");
    // print(
    //     "🔍 [AnnouncementRoom] Create response isSuccessful: ${res.isSuccessful}");
    // print(
    //     "🔍 [AnnouncementRoom] Create response body type: ${res.body.runtimeType}");
    // print("🔍 [AnnouncementRoom] Create response body: ${res.body}");
    // print("🔍 [AnnouncementRoom] Create response error: ${res.error}");
    // print(
    //     "🔍 [AnnouncementRoom] Create response base request URL: ${res.base.request?.url}");
    // print(
    //     "🔍 [AnnouncementRoom] Create response base request method: ${res.base.request?.method}");

    if (!res.isSuccessful) {
      // print(
      //     "🔍 [AnnouncementRoom] ❌ Request FAILED - Status ${res.statusCode}");
      // print("🔍 [AnnouncementRoom] ❌ Error details: ${res.error}");
      try {
        final errorMap = res.error as Map<String, dynamic>?;
        // print("🔍 [AnnouncementRoom] ❌ Error map: $errorMap");
        // print("🔍 [AnnouncementRoom] ❌ Error message: ${errorMap?['data']}");
      } catch (e) {
        // print("🔍 [AnnouncementRoom] ❌ Could not parse error: $e");
      }
    }

    throwIfNotSuccess(res);

    // Announcement API returns the message directly in the body, not wrapped in "data"
    final messageData = res.body as Map<String, dynamic>;
    // print("🔍 [AnnouncementRoom] Message data received: $messageData");

    return MessageFactory.createBaseMessage(messageData);
  }

  /// Get my announcement conversations
  Future<List<Map<String, dynamic>>> getMyConversations({
    int limit = 20,
    int skip = 0,
  }) async {
    final res = await _announcementRoomApi!.getMyConversations({
      'limit': limit,
      'skip': skip,
    });
    throwIfNotSuccess(res);
    final data = extractDataFromResponse(res);
    return (data['conversations'] as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  /// Get announcement room by ID
  Future<Map<String, dynamic>> getAnnouncementRoomById(String roomId) async {
    final res = await _announcementRoomApi!.getAnnouncementRoomById(roomId);
    throwIfNotSuccess(res);
    return extractDataFromResponse(res);
  }

  /// Delete announcement message
  Future<bool> deleteAnnouncementMessage(
    String roomId,
    String messageId,
  ) async {
    final res = await _announcementRoomApi!.deleteAnnouncementMessage(
      roomId,
      messageId,
    );
    throwIfNotSuccess(res);
    return true;
  }

  /// Initialize the service
  static VAnnouncementRoomApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _announcementRoomApi ??= AnnouncementRoomApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? VAppConstants.baseUri,
    );
    return VAnnouncementRoomApiService._();
  }
}
