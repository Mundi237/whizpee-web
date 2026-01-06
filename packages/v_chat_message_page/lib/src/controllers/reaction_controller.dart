// Copyright 2025, the hatemragab project.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class ReactionController {
  /// Toggle reaction on a message using API and local optimistic updates.
  static Future<void> toggleReaction(
    VBaseMessage message,
    String emoji,
  ) async {
    try {
      // Optimistic UI update
      final oldReactionNumber = message.reactionNumber;
      final oldReactionSample = List<ReactionSample>.from(message.reactionSample);
      final oldCurrentUserEmoji = message.currentUserEmoji;

      // Call API first for server-side toggle
      final apiResponse = await VChatController.I.nativeApi.remote.message.toggleReaction(
        roomId: message.roomId,
        messageId: message.id,
        emoji: emoji,
      );

      // Extract response data - handle null safety
      
      final action = apiResponse['action'] as String?;
      if (action == null) {
        throw Exception('Action field is missing from API response');
      }
      
      final reactionData = apiResponse['reaction'] as Map<String, dynamic>?;
      final reactionEmoji = reactionData?['emoji'] as String? ?? emoji;
      
      // Update local state based on server response
      List<ReactionSample> updatedSample = List<ReactionSample>.from(message.reactionSample);
      int updatedNumber = message.reactionNumber;
      String? updatedCurrentUserEmoji = message.currentUserEmoji;

      switch (action) {
        case 'created':
          updatedNumber++;
          updatedCurrentUserEmoji = reactionEmoji;
          // Add/update emoji in sample
          final existingIndex = updatedSample.indexWhere((sample) => sample.emoji == reactionEmoji);
          if (existingIndex >= 0) {
            updatedSample[existingIndex] = updatedSample[existingIndex].copyWith(
              count: updatedSample[existingIndex].count + 1,
            );
          } else {
            updatedSample.add(ReactionSample(emoji: reactionEmoji, count: 1));
          }
          break;
          
        case 'updated':
          // Remove old emoji and add new one
          if (oldCurrentUserEmoji != null) {
            final oldIndex = updatedSample.indexWhere((sample) => sample.emoji == oldCurrentUserEmoji);
            if (oldIndex >= 0) {
              if (updatedSample[oldIndex].count > 1) {
                updatedSample[oldIndex] = updatedSample[oldIndex].copyWith(
                  count: updatedSample[oldIndex].count - 1,
                );
              } else {
                updatedSample.removeAt(oldIndex);
              }
            }
          }
          updatedCurrentUserEmoji = reactionEmoji;
          // Add new emoji
          final newIndex = updatedSample.indexWhere((sample) => sample.emoji == reactionEmoji);
          if (newIndex >= 0) {
            updatedSample[newIndex] = updatedSample[newIndex].copyWith(
              count: updatedSample[newIndex].count + 1,
            );
          } else {
            updatedSample.add(ReactionSample(emoji: reactionEmoji, count: 1));
          }
          break;
          
        case 'deleted':
          updatedNumber = updatedNumber > 0 ? updatedNumber - 1 : 0;
          updatedCurrentUserEmoji = null;
          // Remove emoji from sample
          final deleteIndex = updatedSample.indexWhere((sample) => sample.emoji == reactionEmoji);
          if (deleteIndex >= 0) {
            if (updatedSample[deleteIndex].count > 1) {
              updatedSample[deleteIndex] = updatedSample[deleteIndex].copyWith(
                count: updatedSample[deleteIndex].count - 1,
              );
            } else {
              updatedSample.removeAt(deleteIndex);
            }
          }
          
          // Delete the reaction message from local database
          await _deleteReactionMessage(message.roomId, message.id, reactionEmoji);
          break;
      }

      // Sort by count (descending) and take top 5
      updatedSample.sort((a, b) => b.count.compareTo(a.count));
      updatedSample = updatedSample.take(5).toList();

      // Update message immediately for UI responsiveness
      message.reactionNumber = updatedNumber;
      message.reactionSample = updatedSample;
      message.currentUserEmoji = updatedCurrentUserEmoji;

      // Create event and update local database
      final event = VUpdateMessageReactionsEvent(
        roomId: message.roomId,
        localId: message.localId,
        reactionNumber: updatedNumber,
        reactionSample: updatedSample,
        currentUserEmoji: updatedCurrentUserEmoji,
      );

      await VChatController.I.nativeApi.local.message.updateMessageReactions(event);
    } catch (e) {
      // Revert optimistic update on error
      debugPrint('Error toggling reaction: $e');
      // Could show a snackbar or toast here
      rethrow;
    }
  }

  /// Delete reaction message from local database
  static Future<void> _deleteReactionMessage(
    String roomId,
    String reactedToMessageId,
    String emoji,
  ) async {
    try {
      // Find all reaction messages for this room, message, and emoji from current user
      final localMessages = await VChatController.I.nativeApi.local.message.getRoomMessages(
        roomId: roomId,
        filter: VRoomMessagesDto(limit: 1000), // Get all messages to find reactions
      );

      // Filter to find the reaction message we want to delete
      final currentUserId = VAppConstants.myId;
      final reactionToDelete = localMessages.firstWhere(
        (msg) =>
            msg.messageType == VMessageType.reaction &&
            msg.senderId == currentUserId &&
            msg is VReactionMessage &&
            msg.reactedToMessageId == reactedToMessageId &&
            msg.emoji == emoji,
        orElse: () => throw Exception('Reaction message not found'),
      );

      // Delete the reaction message from local database
      await VChatController.I.nativeApi.local.message.deleteMessageByLocalId(reactionToDelete);

      if (kDebugMode) {
        print('Reaction message deleted successfully: ${reactionToDelete.localId}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting reaction message: $e');
      }
      // Don't rethrow - this is a cleanup operation and shouldn't break the main flow
    }
  }
}
