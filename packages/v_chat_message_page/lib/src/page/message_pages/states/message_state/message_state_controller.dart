// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../../v_chat_message_page.dart';
import '../../providers/message_provider.dart';

class MessageStateController extends ValueNotifier<List<VBaseMessage>> with VSocketStatusStream {
  final VRoom vRoom;
  final MessageProvider messageProvider;
  final AutoScrollController scrollController;
  LoadMoreStatus _loadingStatus = LoadMoreStatus.loaded;

  MessageStateController({
    required this.vRoom,
    required this.messageProvider,
    required this.scrollController,
  }) : super(<VBaseMessage>[]) {
    initSocketStatusStream(
      VChatController.I.nativeApi.streams.socketStatusStream,
    );
    getMessagesFromLocal();
    unawaited(getMessagesFromRemote(_initFilterDto));
    scrollController.addListener(_loadMoreListener);
  }

  BuildContext get context => VChatController.I.navigationContext;

  void _initLoadMore() {
    _loadingStatus = LoadMoreStatus.loaded;
    _filterDto.lastId = null;
  }

  List<VBaseMessage> get stateMessages => value;
  final messageStateStream = StreamController<VBaseMessage>.broadcast();

  bool get isMessagesEmpty => stateMessages.isEmpty;

  String get lastMessageId => stateMessages.last.id;
  final _initFilterDto = VRoomMessagesDto(
    limit: 30,
    lastId: null,
  );
  final _filterDto = VRoomMessagesDto(
    limit: 30,
    lastId: null,
  );

  void insertAllMessages(List<VBaseMessage> messages) {
    final filteredMessages = messages.where((message) => message.messageType != VMessageType.reaction).toList();
    value = sort(filteredMessages);
  }

  void updateApiMessages(List<VBaseMessage> apiMessages) {
    if (apiMessages.isEmpty) return;

    final newList = <VBaseMessage>[];
    final stateMessages = value;

    // Filter out reaction messages from apiMessages
    final filteredApiMessages = apiMessages.where((message) => message.messageType != VMessageType.reaction).toList();

    // Combine filteredApiMessages and sending/error messages from stateMessages
    newList.addAll(filteredApiMessages);
    newList.addAll(stateMessages.where((e) => e.emitStatus.isSendingOrError));

    // Replace updated messages in newList
    for (final localDbMessage in stateMessages) {
      if (localDbMessage.contentTr != null || localDbMessage.isDownloading) {
        final index = newList.indexWhere((element) => element.id == localDbMessage.id);
        if (index != -1) {
          newList[index] = localDbMessage;
        }
      }
    }

    // Sort and update value only if context is still mounted
    if (context.mounted) {
      value = sort(newList);
    }
  }

  List<VBaseMessage> sort(List<VBaseMessage> messages) {
    messages.sort((a, b) {
      return b.id.compareTo(a.id);
    });
    return messages;
  }

  void insertMessage(VBaseMessage messageModel) {
    // Filter out reaction messages
    if (messageModel.messageType == VMessageType.reaction) {
      return;
    }
    
    if (!stateMessages.contains(messageModel)) {
      value.insert(0, messageModel);
      notifyListeners();
    } else {
      if (kDebugMode) {
        print("-------------you are try to insert message which already exist!-----------");
      }
    }
  }

  void updateMessage(VBaseMessage messageModel) {
    final msgIndex = stateMessages.indexOf(messageModel);
    if (msgIndex != -1) {
      //full update
      value[msgIndex] = messageModel;
      messageStateStream.sink.add(messageModel);
    } else {
      if (kDebugMode) {
        print("----------------you are try to update message which Not exist!--------------");
      }
    }
  }

  void close() {
    messageStateStream.close();
    dispose();
    closeSocketStatusStream();
  }

  int _indexByLocalId(String localId) => value.indexWhere((e) => e.localId == localId);

  void deleteMessage(String localId) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value[index].isDeleted = true;
      messageStateStream.add(value[index]);
    }
  }

  void updateMessageStatus(String localId, VMessageEmitStatus emitState) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value[index].emitStatus = emitState;
      messageStateStream.add(value[index]);
    }
  }

  void updateMessageStar(String localId, VUpdateMessageStarEvent event) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value[index].isStared = event.isStar;
      messageStateStream.add(value[index]);
    }
  }
  void updateContentTr(String localId, String? contentTr) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value[index].contentTr = contentTr;
      messageStateStream.add(value[index]);
    }
  }
  void updateMessageOneSeen(String localId, VUpdateMessageOneSeenEvent event) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value[index].isOneSeenByMe = true;
      messageStateStream.add(value[index]);
    }
  }

  void updateDownloadProgress(String localId, double progress) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value[index].progress = progress;
      messageStateStream.add(value[index]);
    }
  }

  void updateMessageAllDeletedAt(String localId, String? allDeletedAt) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value[index].allDeletedAt = allDeletedAt;
      messageStateStream.add(value[index]);
    }
  }

  void updateMessageReactions(String localId, VUpdateMessageReactionsEvent event) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      (value[index] as dynamic).reactionNumber = event.reactionNumber;
      (value[index] as dynamic).reactionSample = event.reactionSample;
      messageStateStream.add(value[index]);
    }
  }

  void seenAll(VSocketOnRoomSeenModel model) {
    for (int i = 0; i < stateMessages.length; i++) {
      stateMessages[i].seenAt ??= model.date;
      stateMessages[i].deliveredAt ??= model.date;
    }
    notifyListeners();
  }

  void deliverAll(VSocketOnDeliverMessagesModel model) {
    for (int i = 0; i < stateMessages.length; i++) {
      stateMessages[i].deliveredAt ??= model.date;
    }
    notifyListeners();
  }

  @override
  void onSocketConnected() {
    getMessagesFromRemote(_initFilterDto);
    messageProvider.setSeen(vRoom.id);
  }

  Future<void> getMessagesFromRemote(VRoomMessagesDto dto) async {
    await VChatController.I.nativeApi.remote.socketIo.socketCompleter.future;
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        return messageProvider.getApiMessages(
          roomId: vRoom.id,
          dto: dto,
        );
      },
      onSuccess: (response) {
        updateApiMessages(response);
        VDownloaderService.instance.checkIfCanAutoDownloadFor(response);
      },
    );
  }

  Future<void> getMessagesFromLocal() async {
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        return messageProvider.getLocalMessages(
          roomId: vRoom.id,
          filter: _initFilterDto,
        );
      },
      onSuccess: (response) {
        insertAllMessages(response);
        VDownloaderService.instance.checkIfCanAutoDownloadFor(response);
      },
    );
  }

  void emitSeenFor(String roomId) {
    messageProvider.setSeen(roomId);
  }

  bool get requireLoadMoreMessages =>
      _loadingStatus != LoadMoreStatus.loading && _loadingStatus != LoadMoreStatus.completed;

  void _loadMoreListener() async {
    final maxScrollExtent = scrollController.position.maxScrollExtent / 2;
    if (scrollController.offset > maxScrollExtent && requireLoadMoreMessages) {
      await loadMoreMessages();
    }
  }

  Future<List<VBaseMessage>?> loadMoreMessages() async {
    _loadingStatus = LoadMoreStatus.loading;
    _filterDto.lastId = value.last.id;
    final localLoadedMessages = await messageProvider.getLocalMessages(
      roomId: vRoom.id,
      filter: _filterDto,
    );
    if (localLoadedMessages.isEmpty) {
      ///if no more data ask server for it
      final result = await vSafeApiCall<List<VBaseMessage>>(
        request: () async {
          return messageProvider.getApiMessages(
            roomId: vRoom.id,
            dto: _filterDto,
          );
        },
        onSuccess: (response) {
          if (response.isEmpty) {
            _loadingStatus = LoadMoreStatus.completed;
            return null;
          }
          _loadingStatus = LoadMoreStatus.loaded;
          final filteredResponse = response.where((message) => message.messageType != VMessageType.reaction).toList();
          value.addAll(filteredResponse);
          VDownloaderService.instance.checkIfCanAutoDownloadFor(filteredResponse);
          notifyListeners();
          return filteredResponse;
        },
      );

      return result.when(
        success: (data) => data,
        failure: (error) => null,
      );
    }
    _loadingStatus = LoadMoreStatus.loaded;
    final filteredLocalMessages = localLoadedMessages.where((message) => message.messageType != VMessageType.reaction).toList();
    value.addAll(filteredLocalMessages);
    notifyListeners();
    return filteredLocalMessages;
  }

  Future<void> loadUntil(VBaseMessage message) async {
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        return messageProvider.getLocalMessages(
          roomId: vRoom.id,
          filter: VRoomMessagesDto(
            between: VMessageBetweenFilter(
              lastId: value.last.id,
              targetId: message.id,
            ),
          ),
        );
      },
      onSuccess: (response) {
        final filteredResponse = response.where((message) => message.messageType != VMessageType.reaction).toList();
        value.insertAll(0, filteredResponse);
        notifyListeners();
      },
    );
  }

  void messageSearch(String text) async {
    final searchMessages = await messageProvider.search(vRoom.id, text);
    final filteredSearchMessages = searchMessages.where((message) => message.messageType != VMessageType.reaction).toList();
    value = filteredSearchMessages;
    notifyListeners();
  }

  void resetMessages() {
    _initLoadMore();
    getMessagesFromLocal();
  }

  void updateIsDownloading(String localId, bool isDownload) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value[index].isDownloading = isDownload;
      messageStateStream.add(value[index]);
    }
  }
}
